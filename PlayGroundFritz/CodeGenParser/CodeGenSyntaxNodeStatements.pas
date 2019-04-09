namespace ProHolz.CodeGen;
interface
uses ProHolz.Ast;
{$DEFINE NULLABLEFOR}
type
  // This part is used for Statements
  CGStatementList = class
    protected
    property data : List<CGStatement>;
     public
       constructor (const value : CGStatement);
       begin
         data := new List<CGStatement>;
         &Add(value);
       end;

      method First : not nullable CGStatement;
      begin
        exit data.First as not nullable;
      end;

    method &Add(const value : CGStatement);
    begin
      if assigned(value) then
        data.Add(value);
    end;

    method asList: List<CGStatement>;
    begin
      exit data;
    end;

    end;

  CodeBuilder =  partial class
  private
    method PrepareLabeledStatement(const node: TSyntaxNode): CGStatementList;
    method PrepareWithStatement(const node: TSyntaxNode): CGStatementList;
    method PrepareRaiseStatement(const node: TSyntaxNode): CGStatementList;
    method PrepareExceptionBlocksList(const node: TSyntaxNode): List<CGCatchBlockStatement>;
    method PrepareTryStatement(const node: TSyntaxNode): CGStatementList;
    method PrepareInheritedStatement(const node: TSyntaxNode; const isConstructor : Boolean = false): CGStatementList;
    method PrepareRepeatStatement(const node: TSyntaxNode): CGStatementList;
    method PrepareWhileStatement(const node: TSyntaxNode): CGStatementList;
    method PrepareForStatement(const node: TSyntaxNode): CGStatementList;
    method PrepareListStatement(const node: TSyntaxNode): CGStatementList;
    method PrepareIfStatement(const node: TSyntaxNode): CGStatementList;
    method PrepareCallStatement(const node: TSyntaxNode): CGStatementList;
    method PrepareAssignMentStatement(const node: TSyntaxNode): CGStatementList;
    method PrepareExpressionStatement(const node: TSyntaxNode): CGStatementList;
    method PrepareCaseLabels(const node: TSyntaxNode): List<CGExpression>;
    method PrepareStatementList(const node: TSyntaxNode): List<CGStatement>;
    method PrepareStatementBlockOrSingle(const node: TSyntaxNode): CGStatementList;
    method PrepareCaseStatement(const node: TSyntaxNode): CGStatementList;
    method PrepareStatement(const node : TSyntaxNode; const isConstructor : Boolean = false) : CGStatementList;
  private
    method BuildStatements(const node : TSyntaxNode; const lMethod : CGMethodLikeMemberDefinition);

  end;

implementation

method CodeBuilder.PrepareExpressionStatement(const node: TSyntaxNode): CGStatementList;
begin
  Var lexpr := PrepareSingleExpressionValue(node.ChildNodes[0]);
  if assigned(lexpr)  then
  begin
    exit new  CGStatementList(lexpr);
  end
  else
    exit new  CGStatementList(BuildCommentFromNode('ntExpression not solved', node));
end;

method CodeBuilder.PrepareCaseLabels(const node: TSyntaxNode): List<CGExpression>;
begin
  result := new List<CGExpression>;
  for each child in node.ChildNodes.Where(Item->Item.Typ = TSyntaxNodeType.ntCaseLabel) do
    begin
    if child.ChildCount = 1 then
    begin
      Var lTemp := PrepareSingleExpressionValue(child.ChildNodes[0]);
      if assigned(lTemp) then
        result.Add(lTemp);
    end
    else
      if child.ChildCount = 2 then
      begin
        Var lTemp := PrepareSingleExpressionValue(child.ChildNodes[0]);
        Var lTemp2 := PrepareSingleExpressionValue(child.ChildNodes[1]);
        if assigned(lTemp) and assigned(lTemp2) then
        begin
          var lres := new CGRangeExpression(lTemp as not nullable, lTemp2 as not nullable);

          result.Add(lres);
        end;
      end

      else raise new Exception(node.Typ.ToString+  '======= Childcount not in 1,2 =======');

  end;
end;

method CodeBuilder.PrepareStatementList(const node: TSyntaxNode): List<CGStatement>;
begin
  var temp := new List<CGStatement>;
  if assigned(node) then
    for each child in node.ChildNodes do
      begin
      var ltemp := PrepareStatement(child);
      if assigned(ltemp) then
        temp.Add(ltemp.asList);
    end;
  exit temp;
end;

method CodeBuilder.PrepareStatementBlockOrSingle(const node: TSyntaxNode): CGStatementList;
begin
  if node.Typ.isStatement then
    exit new  CGStatementList(PrepareStatement(node).First);
  var temp := PrepareStatementList(node);
  if temp.Count = 1 then
    result := new  CGStatementList(temp[0]) else
    result := new   CGStatementList(new CGBeginEndBlockStatement(temp));

end;

method CodeBuilder.PrepareCaseStatement(const node: TSyntaxNode): CGStatementList;
begin
  result := nil;
  var lCaseIdent :=  PrepareSingleExpressionValue(node.FindNode(TSyntaxNodeType.ntExpression):ChildNodes[0]);
  var lSelectors := new List<CGSwitchStatementCase>;

  for each child in node.ChildNodes.Where(Item->Item.Typ = TSyntaxNodeType.ntCaseSelector) do
    begin
    Var lLabels := PrepareCaseLabels(child.FindNode(TSyntaxNodeType.ntCaseLabels));
    var lStatement := PrepareStatement(child.ChildNodes[1]);
    if assigned(lStatement) then
    begin
      if lLabels.Count = 1 then
        lSelectors.Add(new CGSwitchStatementCase(lLabels[0], lStatement.First) )
      else
        lSelectors.Add(new CGSwitchStatementCase(lLabels, lStatement.First));
    end
    else exit new  CGStatementList(BuildCommentFromNode('====CaseLabel=====', child));
  end;

  if assigned(lCaseIdent) and (lSelectors.Count > 0) then
    exit new  CGStatementList(new CGSwitchStatement(lCaseIdent, lSelectors))
  else
    exit new  CGStatementList(BuildCommentFromNode('ntCase not solved', node));
end;

method CodeBuilder.PrepareAssignMentStatement(const node: TSyntaxNode): CGStatementList;
begin
  var lhs := PrepareSingleExpressionValue(node.FindNode(TSyntaxNodeType.ntLHS).ChildNodes[0]);
  var rhs := PrepareSingleExpressionValue(node.FindNode(TSyntaxNodeType.ntRHS).ChildNodes[0]);
  if assigned(lhs) and assigned(rhs) then
  begin
    exit new  CGStatementList(new CGAssignmentStatement(lhs, rhs));
  end
  else
    exit new  CGStatementList(BuildCommentFromNode('ntAssign not solved', node));
end;


method CodeBuilder.PrepareCallStatement(const node: TSyntaxNode): CGStatementList;
begin
  if node.ChildCount = 1 then
    begin
     var lexpression := PrepareSingleExpressionValue(node.ChildNodes[0]);


      var lres := new  CGStatementList(lexpression);
    if lexpression is CGNamedIdentifierExpression then
       begin
      if CGNamedIdentifierExpression(lexpression).Name.ToLower = 'exit'
        then
          lres := new CGStatementList(''.AsNamedIdentifierExpression.AsReturnStatement);
       end;
    if lexpression is CGMethodCallExpression then
    begin
      if CGMethodCallExpression(lexpression).CallSite is CGNamedIdentifierExpression then
        if CGNamedIdentifierExpression(CGMethodCallExpression(lexpression).CallSite).Name.ToLower = 'exit'
        then
         begin
          //var lexit := new CGReturnStatement(lexpression);
          //lres := new CGStatementList(lexit);
         end;
      end;

      exit lres;
    end
  else
    exit new  CGStatementList(BuildCommentFromNode('Call Statement Childcount <> 1', node, true));
end;


method CodeBuilder.PrepareIfStatement(const node: TSyntaxNode): CGStatementList;
begin
  var lIfLeft := PrepareSingleExpressionValue(node.FindNode(TSyntaxNodeType.ntExpression):ChildNodes[0]);
  var lIfThen := PrepareStatement(node.FindNode(TSyntaxNodeType.ntThen):ChildNodes[0]);
  var lIfElse := PrepareStatement(node.FindNode(TSyntaxNodeType.ntElse):ChildNodes[0]);
  if assigned(lIfLeft) and assigned(lIfThen) then
    exit new  CGStatementList(new CGIfThenElseStatement(lIfLeft, lIfThen.First, lIfElse:First))
  else
    exit new  CGStatementList(BuildCommentFromNode('ntIf not solved', node, true));

end;


method CodeBuilder.PrepareListStatement(const node: TSyntaxNode): CGStatementList;
begin
  var temp := PrepareStatementList(node);
  if temp.Count = 1 then
    result := new  CGStatementList(temp[0]) else
    result := new  CGStatementList(new CGBeginEndBlockStatement(temp));
end;


method CodeBuilder.PrepareForStatement(const node: TSyntaxNode): CGStatementList;
begin
  var Down : Boolean := false;
  var lFromvar : String;
  var lFrom : CGExpression;
  var lTo : CGExpression;
  var lin : CGExpression;
  var lStatement : CGStatement;

  // Resolve childs
  // normal forloop needs
  // ntIdentifier
  // ntFrom
  // ntTo
  // and a Statement
  for each child in node.ChildNodes do
    begin

    case child.Typ of
      TSyntaxNodeType.ntIdentifier : lFromvar := child.AttribName;
      TSyntaxNodeType.ntFrom : lFrom := PrepareSingleExpressionValue(child.ChildNodes[0]);
      TSyntaxNodeType.ntTo : lTo := PrepareSingleExpressionValue(child.ChildNodes[0]);
      TSyntaxNodeType.ntDownTo : begin
        lTo := PrepareSingleExpressionValue(child.ChildNodes[0]);
        Down := true;
      end;
      TSyntaxNodeType.ntIn : lin := PrepareSingleExpressionValue(child.ChildNodes[0]);
    end;
     // The lastone will win
    if child.Typ.isStatement then
      lStatement := PrepareStatement(child).First;

  end;

// Check the type of the Loop
  if (not String.IsNullOrEmpty(lFromvar)) and assigned(lFrom) and assigned(lTo) and assigned(lStatement) then
  begin
    {$IF NULLABLEFOR}
    var lTemp :=  new CGForToLoopStatement(lFromvar, nil, lFrom, lTo, lStatement);
    {$ELSE}
    var lTemp :=  new CGForToLoopStatement(lFromvar, ''.AsTypeReference, lFrom, lTo, lStatement);
    {$ENDIF}
    if Down then
      lTemp.Direction := CGLoopDirectionKind.Backward;

    exit new  CGStatementList(lTemp);
  end
  else
    if (not String.IsNullOrEmpty(lFromvar)) and assigned(lin)  and assigned(lStatement) then
    begin
      exit new  CGStatementList(new CGForEachLoopStatement(lFromvar,  nil , lin, lStatement));
    end;

end;


method CodeBuilder.PrepareWhileStatement(const node: TSyntaxNode): CGStatementList;
begin
  if node.ChildCount = 2 then
  begin

    var lWhile := PrepareSingleExpressionValue(node.FindNode(TSyntaxNodeType.ntExpression):ChildNodes[0]);
    var lStatement :=  PrepareStatement(node.ChildNodes[1]);
    if assigned(lWhile)  and assigned(lStatement) then
      exit new  CGStatementList(new CGWhileDoLoopStatement(lWhile , lStatement.First))
    else
      exit new  CGStatementList(BuildCommentFromNode('ntWhile not solved', node, true));
  end
  else
    exit new  CGStatementList(BuildCommentFromNode('ntWhile ChildCount wrong', node, true));
end;


method CodeBuilder.PrepareRepeatStatement(const node: TSyntaxNode): CGStatementList;
begin
  if node.ChildCount = 2 then
  begin
    var lRepeat := PrepareSingleExpressionValue(node.FindNode(TSyntaxNodeType.ntExpression):ChildNodes[0]);
    var lStatement :=  PrepareStatement(node.FindNode(TSyntaxNodeType.ntStatements));
    if assigned(lRepeat)  and assigned(lStatement) then
      exit new  CGStatementList(new CGDoWhileLoopStatement(CGUnaryOperatorExpression.NotExpression(lRepeat), lStatement.First))
    else
      exit new  CGStatementList(BuildCommentFromNode('ntRepeat not solved', node));
  end
  else
    exit new  CGStatementList(BuildCommentFromNode('ntRepeat Childcount wrong', node));
end;


method CodeBuilder.PrepareInheritedStatement(const node: TSyntaxNode; const isConstructor : boolean = false): CGStatementList;
begin
  if node.ChildCount > 0 then
  begin
    var lCall := PrepareSingleExpressionValue(node.ChildNodes[0]);
    if lCall is CGMethodCallExpression  then
     begin
      if isConstructor then
      begin
        var lTemp := new CGConstructorCallStatement(new CGInheritedExpression(), CGMethodCallExpression(lCall).Parameters);
        exit new  CGStatementList(lTemp);
      end
      else
      CGMethodCallExpression(lCall).CallSite := new CGInheritedExpression();
      exit new  CGStatementList(lCall);
     end
    else
      if lCall is CGNamedIdentifierExpression  then
        if isConstructor then
          exit new  CGStatementList( new CGConstructorCallStatement(new CGInheritedExpression()))
          else
          exit new  CGStatementList(new CGMethodCallExpression(new CGInheritedExpression(), CGNamedIdentifierExpression(lCall).Name));

    raise new Exception($"Inherited Statement not solved for Line {node.Line}");
  end else
    if isConstructor then
      exit new  CGStatementList(new CGConstructorCallStatement(new CGInheritedExpression()));
  exit new  CGStatementList(new CGInheritedExpression());
end;

method CodeBuilder.PrepareExceptionBlocksList(const node: TSyntaxNode): List<CGCatchBlockStatement>;
begin
  result := new List<CGCatchBlockStatement>;
  for each child in node.FindChilds(TSyntaxNodeType.ntExceptionHandler) do
    begin
    var lVariable := child.FindNode(TSyntaxNodeType.ntVariable);
    var lTyp := child.FindNode(TSyntaxNodeType.ntType);

    var lblock := if assigned(lVariable) then
    new CGCatchBlockStatement(lVariable.FindNode(TSyntaxNodeType.ntName):AttribName,
                                             PrepareTypeRef(lVariable.FindNode(TSyntaxNodeType.ntType)))
  else
    if assigned(lTyp) then
    // I add a Variable should not make a problem
    new CGCatchBlockStatement('E_Added_Variable', lTyp.AttribName.AsTypeReference)

  else new CGCatchBlockStatement();

    var lStatement := PrepareStatementList(child.FindNode(TSyntaxNodeType.ntStatements));
    lblock.Statements.Add(lStatement);

    if (lStatement.Count = 0) and (assigned(lVariable) or assigned(lTyp)) then
    begin
      lblock.Statements.Add(new CGRawStatement($"{{$HINT 'Empty Except BLock ?'}}"));
    end;

    result.Add(lblock);
  end;
  var lElse := node.FindNode(TSyntaxNodeType.ntExceptElse);
  if assigned(lElse) then
  begin
    var lExceptElse := PrepareStatementList(lElse.ChildNodes[0]);
    if lExceptElse.Count > 0 then
    begin

      var ltempBlock := new CGCatchBlockStatement('ELSE', 'Exception'.AsTypeReference);
      ltempBlock.Statements.Add('{$Hint "ELSEPART inserted as Exceptblock (Needs check)"}'.AsRawExpression);
      ltempBlock.Statements.Add(lExceptElse);
      result.Add(ltempBlock);
    end;
  end;


end;

method CodeBuilder.PrepareTryStatement(const node: TSyntaxNode): CGStatementList;
begin
  var lFinally : List<CGStatement>;
  var lExceptStatements : List<CGStatement>;

  var lExceptBlocks : List<CGCatchBlockStatement>;
  var lTryStatement : List<CGStatement>;


  for each child in node.ChildNodes do
    case child.Typ of
      TSyntaxNodeType.ntExcept : begin
          lExceptBlocks := PrepareExceptionBlocksList(child);
          if lExceptBlocks.Count = 0 then
            lExceptStatements := PrepareStatementList(child.ChildNodes[0]);

      end;

      TSyntaxNodeType.ntFinally : lFinally := PrepareStatementList(child.ChildNodes[0]);
      TSyntaxNodeType.ntStatements : lTryStatement := PrepareStatementList(child);
    end;

  if  assigned(lTryStatement)  then
  begin

// Check the type of the Loop is the FinallyStatement when the Count > 0
    if  assigned(lFinally) then
    begin
      var lTemp :=  new CGTryFinallyCatchStatement(lTryStatement);
      if  (lFinally.Count > 0) then
        lTemp.FinallyStatements.Add(lFinally)
      else
          lTemp.FinallyStatements.Add(new CGRawStatement('{$HINT "Empty Finally ?"}'));
      exit new  CGStatementList(lTemp);
    end
    else
      if  assigned(lExceptBlocks) and (lExceptBlocks.Count > 0) then
      begin
        var lTemp :=  new CGTryFinallyCatchStatement(lTryStatement);
        lTemp.CatchBlocks.Add(lExceptBlocks);

        exit new  CGStatementList(lTemp);
      end
      else
          //if  assigned(lExceptStatements) and (lExceptStatements.Count > 0) then
        if  assigned(lExceptStatements)  then
        begin
          var lTemp :=  new CGTryFinallyCatchStatement(lTryStatement);
          var ltempBlock := new CGCatchBlockStatement();
          if lExceptStatements.Count > 0 then
            ltempBlock.Statements.Add(lExceptStatements)
          else ltempBlock.Statements.add(new CGRawStatement('{$HINT "Empty Except ?"}'));
            lTemp.CatchBlocks.Add(ltempBlock);
          exit new  CGStatementList(lTemp);
          end;
    end

end;

method CodeBuilder.PrepareRaiseStatement(const node: TSyntaxNode): CGStatementList;
begin
  if node.HasChildren then
  begin
    var lexpression := PrepareSingleExpressionValue(node.ChildNodes[0]);
    var ltemp := new CGThrowStatement(lexpression);
    exit new  CGStatementList(ltemp);//'{$Hint "Raise not Supported"}'.AsRawExpression;
  end
  else exit new  CGStatementList(new CGThrowStatement());
end;

method CodeBuilder.PrepareWithStatement(const node: TSyntaxNode): CGStatementList;
begin
  if node.ChildCount = 2 then
  begin
    var lExpressions := node.ChildNodes[0];
    var lEx := new List<CGExpression>;
    for each child in lExpressions.ChildNodes do
      lEx.Add(PrepareSingleExpressionValue(child));

    var lStatement := PrepareStatement(node.ChildNodes[1]);

    if assigned(lExpressions) and assigned(lStatement) then
    begin
     var ltempWith := new CGWithStatement(lEx, lStatement.First);
     var lres := new CGStatementList(ltempWith);
     exit lres;

    end
  end
  else exit  new  CGStatementList(BuildCommentFromNode('PrepareWithStatement Childcount wrong', node));


end;

method CodeBuilder.PrepareLabeledStatement(const node: TSyntaxNode): CGStatementList;
begin
  if node.ChildCount = 2 then
  begin
    var jumpName := node.ChildNodes[0].AttribName;
    var ltemp := PrepareStatement(node.ChildNodes[1]);
    var lHint := ('{$Hint "Labeled Statement not Supported"}').AsRawExpression;
    var lComment := (jumpName +':').AsComment;
    var lres := new CGBeginEndBlockStatement([lHint, lComment, ltemp.First]);

    result := new  CGStatementList(lres);
  end
  else exit new  CGStatementList(BuildCommentFromNode('PrepareLabeledStatement Childcount wrong', node));
end;

method CodeBuilder.PrepareStatement(const node: TSyntaxNode; const isConstructor : Boolean = false): CGStatementList;
begin
  result := nil;
  if not assigned(node) then exit nil;
  if node.Typ.isStatement then
  begin
    try
      case node.Typ of
        TSyntaxNodeType.ntAssign : exit PrepareAssignMentStatement(node);
        TSyntaxNodeType.ntCall : exit PrepareCallStatement(node);
        TSyntaxNodeType.ntIf : exit PrepareIfStatement(node);
        TSyntaxNodeType.ntStatements: exit PrepareListStatement(node);
        TSyntaxNodeType.ntFor : exit PrepareForStatement(node);
        TSyntaxNodeType.ntWhile: exit PrepareWhileStatement(node);
        TSyntaxNodeType.ntRepeat: exit PrepareRepeatStatement(node);
        TSyntaxNodeType.ntCase : exit PrepareCaseStatement(node);
        TSyntaxNodeType.ntEmptyStatement: exit new  CGStatementList( new CGEmptyStatement());
        TSyntaxNodeType.ntInherited: exit PrepareInheritedStatement(node, isConstructor);

        TSyntaxNodeType.ntAsmStatement :; // Do nothing
        TSyntaxNodeType.ntWith : exit PrepareWithStatement(node);
        TSyntaxNodeType.ntTry : exit PrepareTryStatement(node);
        TSyntaxNodeType.ntExpression : exit PrepareExpressionStatement(node);
        TSyntaxNodeType.ntRaise:  exit PrepareRaiseStatement(node);
        TSyntaxNodeType.ntLabeledStatement : exit PrepareLabeledStatement(node);
        else raise new Exception($"=======Unknown type [{node.Typ.ToString}] in PrepareStatement =======");

      end;
     finally
       if result:First is CGNamedIdentifierExpression then
       begin
         var lres := result.First as CGNamedIdentifierExpression;
         case lres.Name.ToLower of
           'break' : result := new  CGStatementList( new CGBreakStatement());
           'continue' : result := new  CGStatementList(new CGContinueStatement());
         end;
       end;
     end;
    end
    else
      if node.Typ.notSupported then
        exit new  CGStatementList(BuildCommentFromNode('Unsupported', node, true))
      else
        exit new  CGStatementList(new CGCodeCommentStatement(new CGRawStatement(node.Typ.ToString+  '======= Typ not in Statement Enum =======')));
  end;

  method CodeBuilder.BuildStatements(const node: TSyntaxNode; const lMethod: CGMethodLikeMemberDefinition);
  begin
    for each child in node.ChildNodes do //.Where(Item->Item.Typ = TSyntaxNodeType.ntStatement) do
      begin
      var Statement := PrepareStatement(child, (lMethod is CGConstructorDefinition));
      if assigned(Statement)  then
       begin
        lMethod.Statements.Add(Statement.asList);
       end;
    end;

  end;

end.