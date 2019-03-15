namespace PlayGroundFritz;

interface
uses PascalParser;

type
  // This part is used for Statements

  CodeBuilderMethods = static partial class
  private
    method PrepareLabaledStatement(const node: TSyntaxNode): CGStatement;
    method PrepareWithStatement(const node: TSyntaxNode): CGStatement;
    method PrepareRaiseStatement(const node: TSyntaxNode): CGStatement;
    method PrepareExceptionBlocksList(const node: TSyntaxNode): List<CGCatchBlockStatement>;
    method PrepareTryStatement(const node: TSyntaxNode): CGStatement;
    method PrepareInheritedStatement(const node: TSyntaxNode): CGExpression;
    method PrepareRepeatStatement(const node: TSyntaxNode): CGStatement;
    method PrepareWhileStatement(const node: TSyntaxNode): CGStatement;
    method PrepareForStatement(const node: TSyntaxNode): CGStatement;
    method PrepareListStatement(const node: TSyntaxNode): CGStatement;
    method PrepareIfStatement(const node: TSyntaxNode): CGStatement;
    method PrepareCallStatement(const node: TSyntaxNode): CGStatement;
    method PrepareAssignMentStatement(const node: TSyntaxNode): CGStatement;
    method PrepareExpressionStatement(const node: TSyntaxNode): CGStatement;
    method resolveCaseLabels(const node: TSyntaxNode): List<CGExpression>;
    method PrepareStatementList(const node: TSyntaxNode): List<CGStatement>;
    method PrepareStatementBlockOrSingle(const node: TSyntaxNode): CGStatement;
    method PrepareCaseStatement(const node: TSyntaxNode): CGStatement;
    method PrepareStatement(const node : TSyntaxNode) : CGStatement;
    method BuildStatements(const node : TSyntaxNode; const lMethod : CGMethodLikeMemberDefinition);

  end;

implementation

method CodeBuilderMethods.PrepareExpressionStatement(const node: TSyntaxNode): CGStatement;
begin
  Var lexpr := PrepareSingleExpressionValue(node.ChildNodes[0]);
  if assigned(lexpr)  then
    exit lexpr
  else
    exit BuildCommentFromNode('ntExpression not solved', node);
end;

method CodeBuilderMethods.resolveCaseLabels(const node: TSyntaxNode): List<CGExpression>;
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

method CodeBuilderMethods.PrepareStatementList(const node: TSyntaxNode): List<CGStatement>;
begin
  var temp := new List<CGStatement>;
  if assigned(node) then
    for each child in node.ChildNodes do
      begin
      var ltemp := PrepareStatement(child);
      if assigned(ltemp) then
        temp.Add(ltemp);
    end;
  exit temp;
end;

method CodeBuilderMethods.PrepareStatementBlockOrSingle(const node: TSyntaxNode): CGStatement;
begin
  if node.Typ.isStatement then
    exit PrepareStatement(node);
  var temp := PrepareStatementList(node);
  if temp.Count = 1 then
    result := temp[0] else
    result := new CGBeginEndBlockStatement(temp);

end;

method CodeBuilderMethods.PrepareCaseStatement(const node: TSyntaxNode): CGStatement;
begin
  result := nil;
  var lCaseIdent :=  PrepareSingleExpressionValue(node.FindNode(TSyntaxNodeType.ntExpression):ChildNodes[0]);
  var lSelectors := new List<CGSwitchStatementCase>;

  for each child in node.ChildNodes.Where(Item->Item.Typ = TSyntaxNodeType.ntCaseSelector) do
    begin
    Var lLabels := resolveCaseLabels(child.FindNode(TSyntaxNodeType.ntCaseLabels));
    var lStatement := PrepareStatement(child.ChildNodes[1]);
    if assigned(lStatement) then
    begin
      if lLabels.Count = 1 then
        lSelectors.Add(new CGSwitchStatementCase(lLabels[0], lStatement as not nullable) )
      else
        lSelectors.Add(new CGSwitchStatementCase(lLabels, lStatement as not nullable));
    end
    else exit BuildCommentFromNode('====CaseLabel=====', child);
  end;

  if assigned(lCaseIdent) and (lSelectors.Count > 0) then
    exit new CGSwitchStatement(lCaseIdent, lSelectors)
  else
    exit BuildCommentFromNode('ntCase not solved', node);
end;

method CodeBuilderMethods.PrepareAssignMentStatement(const node: TSyntaxNode): CGStatement;
begin
  var lhs := PrepareSingleExpressionValue(node.FindNode(TSyntaxNodeType.ntLHS).ChildNodes[0]);
  var rhs := PrepareSingleExpressionValue(node.FindNode(TSyntaxNodeType.ntRHS).ChildNodes[0]);
  if assigned(lhs) and assigned(rhs) then
  begin
      //if lhs is CGNamedIdentifierExpression then
        //if (lhs as CGNamedIdentifierExpression).Name.ToLower = 'result' then
         //exit rhs.AsReturnStatement;
    exit new CGAssignmentStatement(lhs, rhs);
  end
  else
    exit BuildCommentFromNode('ntAssign not solved', node);
end;


method CodeBuilderMethods.PrepareCallStatement(const node: TSyntaxNode): CGStatement;
begin
  if node.ChildCount = 1 then
  begin
    exit PrepareSingleExpressionValue(node.ChildNodes[0]);
  end
  else
    exit BuildCommentFromNode('Call Statement Childcount <> 1', node, true);
end;


method CodeBuilderMethods.PrepareIfStatement(const node: TSyntaxNode): CGStatement;
begin
  var lIfLeft := PrepareSingleExpressionValue(node.FindNode(TSyntaxNodeType.ntExpression):ChildNodes[0]);
  var lIfThen := PrepareStatement(node.FindNode(TSyntaxNodeType.ntThen):ChildNodes[0]);
  var lIfElse := PrepareStatement(node.FindNode(TSyntaxNodeType.ntElse):ChildNodes[0]);
  if assigned(lIfLeft) and assigned(lIfThen) then
    exit new CGIfThenElseStatement(lIfLeft, lIfThen, lIfElse)
  else
    exit BuildCommentFromNode('ntIf not solved', node, true);

end;


method CodeBuilderMethods.PrepareListStatement(const node: TSyntaxNode): CGStatement;
begin
  var temp := PrepareStatementList(node);
  if temp.Count = 1 then
    result := temp[0] else
    result := new CGBeginEndBlockStatement(temp);
end;


method CodeBuilderMethods.PrepareForStatement(const node: TSyntaxNode): CGStatement;
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
      lStatement := PrepareStatement(child);

  end;

// Check the type of the Loop
  if (not String.IsNullOrEmpty(lFromvar)) and assigned(lFrom) and assigned(lTo) and assigned(lStatement) then
  begin
    var lTemp :=  new CGForToLoopStatement(lFromvar, nil, lFrom, lTo, lStatement);
    if Down then
      lTemp.Direction := CGLoopDirectionKind.Backward;

    exit lTemp;
  end
  else
    if (not String.IsNullOrEmpty(lFromvar)) and assigned(lin)  and assigned(lStatement) then
    begin
      exit new CGForEachLoopStatement(lFromvar,  nil , lin, lStatement);
    end;

end;


method CodeBuilderMethods.PrepareWhileStatement(const node: TSyntaxNode): CGStatement;
begin
  if node.ChildCount = 2 then
  begin

    var lWhile := PrepareSingleExpressionValue(node.FindNode(TSyntaxNodeType.ntExpression):ChildNodes[0]);
    var lStatement :=  PrepareStatement(node.ChildNodes[1]);
    if assigned(lWhile)  and assigned(lStatement) then
      exit new CGWhileDoLoopStatement(lWhile , lStatement)
    else
      exit BuildCommentFromNode('ntWhile not solved', node, true);
  end
  else
    exit BuildCommentFromNode('ntWhile ChildCount wrong', node, true);
end;


method CodeBuilderMethods.PrepareRepeatStatement(const node: TSyntaxNode): CGStatement;
begin
  if node.ChildCount = 2 then
  begin
    var lRepeat := PrepareSingleExpressionValue(node.FindNode(TSyntaxNodeType.ntExpression):ChildNodes[0]);
    var lStatement :=  PrepareStatement(node.FindNode(TSyntaxNodeType.ntStatements));
    if assigned(lRepeat)  and assigned(lStatement) then
      exit new CGDoWhileLoopStatement(lRepeat, lStatement as not nullable)
    else
      exit BuildCommentFromNode('ntRepeat not solved', node);
  end
  else
    exit BuildCommentFromNode('ntRepeat Childcount wrong', node);
end;


method CodeBuilderMethods.PrepareInheritedStatement(const node: TSyntaxNode): CGExpression;
begin
  if node.ChildCount > 0 then
  begin
    var lCall := PrepareSingleExpressionValue(node.ChildNodes[0]);
    exit new CGInheritedExpression(lCall);
  end else
    exit new CGInheritedExpression();
end;

method CodeBuilderMethods.PrepareExceptionBlocksList(const node: TSyntaxNode): List<CGCatchBlockStatement>;
begin
  result := new List<CGCatchBlockStatement>;
  for each child in node.FindNodes(TSyntaxNodeType.ntExceptionHandler) do
    begin
    var lVariable := child.FindNode(TSyntaxNodeType.ntVariable);

    var lblock := if assigned(lVariable) then
    new CGCatchBlockStatement(lVariable.FindNode(TSyntaxNodeType.ntName):AttribName,
                                             PrepareTypeRef(lVariable.FindNode(TSyntaxNodeType.ntType)))
  else new CGCatchBlockStatement();

    var lStatement := PrepareStatementList(child.FindNode(TSyntaxNodeType.ntStatements));
    lblock.Statements.Add(lStatement);

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

method CodeBuilderMethods.PrepareTryStatement(const node: TSyntaxNode): CGStatement;
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
      if  assigned(lFinally) and (lFinally.Count > 0) then
      begin
        var lTemp :=  new CGTryFinallyCatchStatement(lTryStatement);
        lTemp.FinallyStatements.Add(lFinally);
        exit lTemp;
      end
      else
        if  assigned(lExceptBlocks) and (lExceptBlocks.Count > 0) then
        begin
          var lTemp :=  new CGTryFinallyCatchStatement(lTryStatement);
          lTemp.CatchBlocks.Add(lExceptBlocks);

          exit lTemp;
        end
        else
          if  assigned(lExceptStatements) and (lExceptStatements.Count > 0) then
          begin
            var lTemp :=  new CGTryFinallyCatchStatement(lTryStatement);
            var ltempBlock := new CGCatchBlockStatement();
            ltempBlock.Statements.Add(lExceptStatements);
            lTemp.CatchBlocks.Add(ltempBlock);
            exit lTemp;
          end;
    end

  end;

  method CodeBuilderMethods.PrepareRaiseStatement(const node: TSyntaxNode): CGStatement;
  begin
    if node.HasChildren then
    begin
      var lexpression := PrepareSingleExpressionValue(node.ChildNodes[0]);
      var ltemp := new CGThrowStatement(lexpression);
      exit ltemp;//'{$Hint "Raise not Supported"}'.AsRawExpression;
    end
    else exit new CGThrowStatement();
  end;

  method CodeBuilderMethods.PrepareWithStatement(const node: TSyntaxNode): CGStatement;
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
        var lHint := ('{$Hint "With Statement to check"}').AsRawExpression;
        var lWith := new CGWithStatement(lEx,lStatement as not nullable);
        //exit lWith;
        exit new CGSimpleBlockStatement([lHint, lWith as not nullable]);

      end
    end
    else exit BuildCommentFromNode('PrepareWithStatement Childcount wrong', node);


  end;

  method CodeBuilderMethods.PrepareLabaledStatement(const node: TSyntaxNode): CGStatement;
  begin
    if node.ChildCount = 2 then
    begin
      var jumpName := node.ChildNodes[0].AttribName;
      var ltemp := PrepareStatement(node.ChildNodes[1]);
      var lHint := ('{$Hint "Labeled Statement not Supported"}').AsRawExpression;
      var lComment := (jumpName +':').AsComment;

      result := new CGSimpleBlockStatement([lHint, lComment, ltemp as not nullable]);
    end
    else exit BuildCommentFromNode('PrepareLabaledStatement Childcount wrong', node);
  end;

  method CodeBuilderMethods.PrepareStatement(const node: TSyntaxNode): CGStatement;
  begin
    result := nil;
    if not assigned(node) then exit nil;
    if node.Typ.isStatement then
    begin
      case node.Typ of
        TSyntaxNodeType.ntAssign : exit PrepareAssignMentStatement(node);
        TSyntaxNodeType.ntCall : exit PrepareCallStatement(node);
        TSyntaxNodeType.ntIf : exit PrepareIfStatement(node);
        TSyntaxNodeType.ntStatements: exit PrepareListStatement(node);
        TSyntaxNodeType.ntFor : exit PrepareForStatement(node);
        TSyntaxNodeType.ntWhile: exit PrepareWhileStatement(node);
        TSyntaxNodeType.ntRepeat: exit PrepareRepeatStatement(node);
        TSyntaxNodeType.ntCase : exit PrepareCaseStatement(node);
        TSyntaxNodeType.ntEmptyStatement: exit new CGEmptyStatement();
        TSyntaxNodeType.ntInherited: exit PrepareInheritedStatement(node);

        TSyntaxNodeType.ntAsmStatement :; // Do nothing
        TSyntaxNodeType.ntWith : exit PrepareWithStatement(node);
        TSyntaxNodeType.ntTry : exit PrepareTryStatement(node);
        TSyntaxNodeType.ntExpression : exit PrepareExpressionStatement(node);
        TSyntaxNodeType.ntRaise:  exit PrepareRaiseStatement(node);
        TSyntaxNodeType.ntLabeledStatement : exit PrepareLabaledStatement(node);
        else raise new Exception(node.Typ.ToString+  '=======Unknown type in PrepareStatement =======');

      end;
    end
    else
      if node.Typ.notSupported then
        exit BuildCommentFromNode('Unsupported', node, true)
      else
        exit new CGCodeCommentStatement(new CGRawStatement(node.Typ.ToString+  '======= Typ not in Statement Enum ======='));
  end;

  method CodeBuilderMethods.BuildStatements(const node: TSyntaxNode; const lMethod: CGMethodLikeMemberDefinition);
  begin
    for each child in node.ChildNodes do //.Where(Item->Item.Typ = TSyntaxNodeType.ntStatement) do
      begin
      var Statement := PrepareStatement(child);
      if assigned(Statement)  then
        lMethod.Statements.Add(Statement);
    end;

  end;

end.