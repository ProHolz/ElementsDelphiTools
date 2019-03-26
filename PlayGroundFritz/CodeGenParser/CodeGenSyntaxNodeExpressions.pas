namespace PlayGroundFritz;


interface
uses ProHolz.Ast;

type
  CodeBuilderMethods = static partial class
  private
    method PrepareIdentifierExpression(const node: TSyntaxNode): CGExpression;
    method PrepareFieldExpression(const node: TSyntaxNode): CGExpression;
    method PrepareGenricExpression(const node: TSyntaxNode): CGExpression;

    method PrepareTypeExpression(const node: TSyntaxNode): CGExpression;
    method PrepareListExpression(const node: TSyntaxNode): CGExpression;
    method PrepareSetExpression(const node: TSyntaxNode): CGExpression;
    method PrepareAsExpression(const node: TSyntaxNode): CGExpression;
    method PrepareDeRefExpression(const node: TSyntaxNode): CGExpression;
    method PrepareIndexedExpression(const node: TSyntaxNode): CGExpression;

    method PrepareDotValue(const node: TSyntaxNode): CGExpression;

    method PrepareUnaryOp(const node: TSyntaxNode): CGExpression;
    method PrepareBinaryOp(const left: TSyntaxNode; const right: TSyntaxNode; aType: TSyntaxNodeType): CGExpression;
    method PrepareLiteralExpression(const literalnode: TSyntaxNode): CGExpression;
    method PrepareCallExpression(node : TSyntaxNode) : CGExpression;
    method PrepareCallExpressions(expressions: TSyntaxNode): Array of CGExpression;
    method PrepareExpressionValue(const valuenode: TSyntaxNode): CGExpression;

    method PrepareSingleExpressionValue(const node: TSyntaxNode): CGExpression;

  end;

implementation


method CodeBuilderMethods.PrepareUnaryOp(const node: TSyntaxNode): CGExpression;
begin
  case node.Typ of
    TSyntaxNodeType.ntAddr : exit new  CGUnaryOperatorExpression(PrepareSingleExpressionValue(node.ChildNodes[0]), CGUnaryOperatorKind.AddressOf);
    TSyntaxNodeType.ntUnaryMinus : exit new  CGUnaryOperatorExpression(PrepareSingleExpressionValue(node.ChildNodes[0]), CGUnaryOperatorKind.Minus);
    TSyntaxNodeType.ntNot : exit new  CGUnaryOperatorExpression(PrepareSingleExpressionValue(node.ChildNodes[0]), CGUnaryOperatorKind.Not);
  end;
end;

method CodeBuilderMethods.PrepareBinaryOp(const left, right: TSyntaxNode; aType : TsyntaxnodeType): CGExpression;
require
  aType.isBinaryOperator;
begin
  var lOperator : CGBinaryOperatorKind := mapSyntaxnodeToOperatorKind(aType);

  var leftEx := PrepareSingleExpressionValue(left);
  var rightEx := PrepareSingleExpressionValue(right);

  if assigned(leftEx) and assigned(rightEx) then
    exit new CGBinaryOperatorExpression(
    leftEx,
    rightEx,
    lOperator
    )
  else
  begin
    raise new Exception("PrepareBinaryOp not Solved");
  end;

end;

method CodeBuilderMethods.PrepareLiteralExpression(const literalnode: TSyntaxNode): CGExpression;
begin
  result := nil;
  if (literalnode is TValuedSyntaxNode)  then
  begin
    var lValueStr := (literalnode as TValuedSyntaxNode).Value;
    case literalnode.AttribType.ToLower of
      'numeric' : begin
          if lValueStr.StartsWith('$') then
          begin
            Var lValue :=Convert.TryHexStringToUInt64(lValueStr.Substring(1));
            if lValue <> nil then
            begin
              result := new CGIntegerLiteralExpression(lValue, Base:=16);
            // result.Comment
              exit;
            end;
          end;


          Var lValue :=Convert.TryToInt64(lValueStr);
          if lValue <> nil then
            exit new CGIntegerLiteralExpression(lValue)
          else
          begin
            exit new CGFloatLiteralExpression(Convert.tryToDouble(lValueStr, Locale.Invariant));
          end;

      end;
      'string'  :
       begin

         exit new CGStringLiteralExpression(lValueStr);
       end;
      'nil'  : exit new CGNilExpression();
    end;
  end;
end;

method CodeBuilderMethods.PrepareCallExpression(node: TSyntaxNode): CGExpression;
begin
  result := nil;

  var lCall := PrepareSingleExpressionValue(node.ChildNodes[0]);
  var expressions := node.FindNode(TSyntaxNodeType.ntExpressions);
  if assigned(expressions) then
  begin
    result := new CGMethodCallExpression(lCall, '');
      for each lexpression in PrepareCallExpressions(expressions) do
        (result as CGMethodCallExpression).Parameters.Add(lexpression.AsCallParameter);
  end
  else
    exit lCall;

end;

method CodeBuilderMethods.PrepareCallExpressions(expressions: TSyntaxNode): Array of CGExpression;
begin
  result := nil;
  if  expressions.HasChildren then
  begin
    var lTemp := new List<CGExpression>;
    for each expression in expressions.ChildNodes
     //.Where(Item -> Item.Typ = TSyntaxNodeType.ntExpression)
      do
      if expression.HasChildren then
        lTemp.add(PrepareSingleExpressionValue(expression.ChildNodes[0]))
      else
        if expression.Typ = TSyntaxNodeType.ntType then
        lTemp.add(new CGNamedIdentifierExpression(expression.AttribName));

    result := lTemp.ToArray;
  end;
end;


method CodeBuilderMethods.PrepareExpressionValue(const valuenode: TSyntaxNode): CGExpression;
begin
  result := nil;
  if valuenode = nil then exit;

  if valuenode.HasChildren then
    exit  PrepareSingleExpressionValue(valuenode.ChildNodes[0]);

  //var ExpressionNode := valuenode.FindNode(TSyntaxNodeType.ntExpression);
  //if assigned(ExpressionNode) and ExpressionNode.HasChildren then
  //begin
    //var literalnode := ExpressionNode.ChildNodes[0];
    //result := PrepareSingleExpressionValue(literalnode);
  //end;

end;



method CodeBuilderMethods.PrepareDotValue(const node: TSyntaxNode): CGExpression;
begin
  if node.ChildCount=2 then
  begin
    var lLeft := PrepareSingleExpressionValue(node.ChildNodes[0]);
    var lRight := PrepareSingleExpressionValue(node.ChildNodes[1]);
    if assigned(lLeft) and assigned(lRight) then
     exit new CGDotNameExpression(lLeft, lRight)
    else
    raise new Exception("DOT Expression not solved");

  end
  else
    raise new Exception("DOT Expression not solved");

  //  exit  new CGNamedIdentifierExpression('======PrepareDotValue=======');
end;


method CodeBuilderMethods.PrepareIndexedExpression(const node : Tsyntaxnode) : CGExpression;
begin
  var lIdentfier : CGExpression;
 var lexpr := new List<CGExpression>;

 for each child in node.ChildNodes.Where(Item->Item.Typ = TSyntaxNodeType.ntExpression) do
   lexpr.add(PrepareSingleExpressionValue(child.ChildNodes[0]));

  for each child in node.ChildNodes.Where(Item->Item.Typ <> TSyntaxNodeType.ntExpression) do
   begin
    lIdentfier := PrepareSingleExpressionValue(child);
    break;
   end;


//  var lIdentfier := PrepareSingleExpressionValue(node.FindNode(TSyntaxNodeType.ntIdentifier));
  if (lexpr.Count > 0) and assigned(lIdentfier) then
  exit new CGArrayElementAccessExpression(lIdentfier, lexpr)
  else
    exit new CGNamedIdentifierExpression('======ntIndexed=======');

end;

method CodeBuilderMethods.PrepareDeRefExpression(const node : Tsyntaxnode) : CGExpression;
begin
 var lIdent :=  PrepareSingleExpressionValue(  node.ChildNodes[0]);
 if assigned(lIdent) then
 exit new CGPointerDereferenceExpression(lIdent)
 else
 exit new CGNamedIdentifierExpression('======Deref=======');
end;

method CodeBuilderMethods.PrepareAsExpression(const node : Tsyntaxnode) : CGExpression;
begin
  if node.ChildCount = 2 then
  begin
    Var lBase := PrepareSingleExpressionValue(node.ChildNodes[0]);
    Var lCast := node.ChildNodes[1].AttribName;
    if assigned(lBase) and not String.IsNullOrEmpty(lCast) then
      exit  new CGTypeCastExpression(lBase, lCast.AsTypeReference, true)
    else
      exit  new CGNamedIdentifierExpression('======ntAS not solved =======');
  end
  else
    exit  new CGNamedIdentifierExpression('======ntAS Childcount <> 2');
end;

method CodeBuilderMethods.PrepareSetExpression(const node : Tsyntaxnode) : CGExpression;
begin
  var lSet := new CGArrayLiteralExpression();
  for each child in node.ChildNodes.FindAll(Item->Item.Typ= TSyntaxNodeType.ntElement)  do
    lSet.Elements.Add(PrepareExpressionValue(child));
  exit lSet;
end;

method CodeBuilderMethods.PrepareListExpression(const node : Tsyntaxnode) : CGExpression;
begin
  var lTemp := PrepareCallExpressions(node);
  if lTemp <> nil then
  begin
    if length(lTemp) = 1 then
      exit new  CGParenthesesExpression(lTemp[0]);
    exit new CGArrayLiteralExpression(lTemp);
  end;
end;


method CodeBuilderMethods.PrepareTypeExpression(const node : Tsyntaxnode) : CGExpression;
begin
  exit new CGNamedIdentifierExpression(node.AttribName);
end;


method CodeBuilderMethods.PrepareGenricExpression(const node : Tsyntaxnode) : CGExpression;
begin
  var lIdent := PrepareSingleExpressionValue(node.FindNode(TSyntaxNodeType.ntIdentifier));

  // if it is a named reference check further.....
  if lIdent is CGNamedIdentifierExpression then
  begin
    var lTypename := node.FindNode(TSyntaxNodeType.ntIdentifier).AttribName;
    var typeArgs := node.FindNode(TSyntaxNodeType.ntTypeArgs);
    if assigned(typeArgs) then
    begin
      var largs := new List<CGTypeReference>;
      for each child in typeArgs.ChildNodes.where(Item->Item.Typ = TSyntaxNodeType.ntType) do
        largs.Add(PrepareTypeRef(child));

        if largs.Count > 0 then
        begin
          var ls := '';
          var dot := '';
          ls := '<';
          for each s in largs  do
            begin
            ls := ls+dot+s;
            dot := ',';
          end;
          ls := ls+'>';
         exit new CGNamedIdentifierExpression(lTypename+ls);
     end;
    end;
  end;

  exit lIdent;
end;


method CodeBuilderMethods.PrepareFieldExpression(const node : TSyntaxNode) : CGExpression;
begin
  raise new  Exception(node.Typ.ToString+  '=======Unknown Paramtype in PrepareFieldExpression =======');
end;


method CodeBuilderMethods.PrepareIdentifierExpression(const node : TSyntaxNode) : CGExpression;
begin
  case node.AttribName.ToLower of
    'result' : exit  CGResultExpression.Result;
    'nil' : exit  CGNilExpression.Nil;
    'self': exit  CGSelfExpression.Self;

  end;

  exit new CGNamedIdentifierExpression(node.AttribName);

end;


method CodeBuilderMethods.PrepareSingleExpressionValue(const node: TSyntaxNode): CGExpression;
begin
  if node = nil then exit nil;
  // Operators
  if node.Typ.isOperator then
  begin
    if node.Typ.isBinaryOperator then
    begin
      if node.ChildNodes.Count = 2 then
        exit PrepareBinaryOp(node.ChildNodes[0], node.ChildNodes[1], node.Typ)

      else raise new Exception(node.Typ.ToString+  ' Binary Operator WITH CHILDNOTES <> 2 NOT SUPPORTED');
    end
    else
      if node.Typ.isUnaryOperator then
        exit PrepareUnaryOp(node);

  end
  else
   if node.Typ.isExpression then
   begin
    case node.Typ of
      TSyntaxNodeType.ntCall : exit PrepareCallExpression(node);
      TSyntaxNodeType.ntAs :exit PrepareAsExpression(node);
      TSyntaxNodeType.ntLiteral : exit PrepareLiteralExpression(node);
      TSyntaxNodeType.ntIdentifier : exit PrepareIdentifierExpression(node);//new CGNamedIdentifierExpression(node.AttribName);
      TSyntaxNodeType.ntSet : exit PrepareSetExpression(node);
      TSyntaxNodeType.ntExpressions : exit PrepareListExpression(node);
      TSyntaxNodeType.ntExpression :
        if node.HasChildren then
          exit PrepareSingleExpressionValue(node.ChildNodes[0]);
      TSyntaxNodeType.ntDot :  exit PrepareDotValue(node);
      TSyntaxNodeType.ntIndexed : exit  PrepareIndexedExpression(node);
      TSyntaxNodeType.ntDeref : exit  PrepareDeRefExpression(node);

      TSyntaxNodeType.ntType : exit PrepareTypeExpression(node);// new CGNamedIdentifierExpression('======ntType=======');
   //   TSyntaxNodeType.ntIn : exit  new CGNamedIdentifierExpression('======ntIn=======');
      TSyntaxNodeType.ntInherited : exit  PrepareInheritedStatement(node);
      TSyntaxNodeType.ntGoto: exit new CGRawExpression('{$HINT "Goto '+node.ChildNodes[0].AttribName+' not Supported"}');

      TSyntaxNodeType.ntRecordConstant : exit  new CGNamedIdentifierExpression('======RecordConstant=======');
      TSyntaxNodeType.ntAnonymousMethod : exit  PrepareAnonymousMethod(node);
      TSyntaxNodeType.ntGeneric : exit PrepareGenricExpression(node);
      TSyntaxNodeType.ntField : exit PrepareFieldExpression(node);
      TSyntaxNodeType.ntElement : exit PrepareSingleExpressionValue(node.ChildNodes[0]);


      else raise new Exception(node.Typ.ToString+  '=======Unknown Paramtype in PrepareSingleExpressionValue =======');

    end;
    end // isExpression
  else raise new Exception(node.Typ.ToString+  '=======Paramtype not in Expressions Enum =======');

end;




end.