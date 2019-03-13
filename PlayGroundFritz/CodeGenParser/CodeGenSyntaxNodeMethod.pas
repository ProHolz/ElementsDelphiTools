namespace PlayGroundFritz;

interface
uses PascalParser;

type
  // This part is used for Methods

  CodeBuilderMethods = static partial class
  private
    method PrepareLocalVarOrConstant(const constnode: TSyntaxNode; const isConst: Boolean): CGVariableDeclarationStatement;
    method BuildVariablesMethod(const node: TSyntaxNode; const lMethod: CGMethodLikeMemberDefinition);
    method BuildConstantsMethodClause(const node: TSyntaxNode; const lMethod: CGMethodLikeMemberDefinition);
    method BuildTypesMethodClause(const node : TSyntaxNode; const lMethod : CGMethodLikeMemberDefinition);

  end;
implementation

method CodeBuilderMethods.PrepareLocalVarOrConstant(const constnode: TSyntaxnode; const isConst : Boolean) : CGVariableDeclarationStatement;
begin
  Var constName := constnode.FindNode(TSyntaxNodeType.ntName).AttribName;
  Var typeNode := constnode.FindNode(TSyntaxNodeType.ntType);

  Var typeName := typeNode:AttribName;
  Var typeType := typeNode:AttribType;
  var linit : CGExpression := nil;

  //if typeType <> nil then
    //case typeType.ToLower of
    //// Special Handling of Array Constants
      //'array' :
      //exit  new CGVariableDeclarationStatement(PrepareArrayVarOrConstant(constnode, isConst, ispublic));
    //end;

  var valuenode := constnode.FindNode(TSyntaxNodeType.ntValue);
  if valuenode <> nil then
    linit := PrepareExpressionValue(valuenode);

   result :=  new CGVariableDeclarationStatement(constName, typeName:AsTypeReference, PrepareExpressionValue(valuenode));
   result.Constant := isConst;

end;



method CodeBuilderMethods.BuildVariablesMethod(const node : TSyntaxNode; const lMethod : CGMethodLikeMemberDefinition);
begin
  for each Child in node.ChildNodes.FindAll(Item -> Item.Typ = TSyntaxNodeType.ntVariable) do
    begin

    var temp := PrepareLocalVarOrConstant(Child, false);
    if temp <> nil then
    begin
     if lMethod.LocalVariables = nil then
       lMethod.LocalVariables := new List<CGVariableDeclarationStatement>;

     lMethod.LocalVariables.Add(temp);
    end;
    end;
end;


method CodeBuilderMethods.BuildConstantsMethodClause(const node : TSyntaxNode; const lMethod : CGMethodLikeMemberDefinition);
begin
  for each Child in node.ChildNodes.FindAll(Item -> Item.Typ = TSyntaxNodeType.ntConstant) do
    begin
       var temp := PrepareLocalVarOrConstant(Child, true);
       if temp <> nil then
       begin
         if lMethod.LocalVariables = nil then
           lMethod.LocalVariables := new List<CGVariableDeclarationStatement>;

         lMethod.LocalVariables.Add(temp);
       end;
     end;
end;

method CodeBuilderMethods.BuildTypesMethodClause(const node : TSyntaxNode; const lMethod : CGMethodLikeMemberDefinition);
begin
  if node = nil  then exit;
  for each child in node.ChildNodes.FindAll(Item -> Item.Typ = TSyntaxNodeType.ntTypeDecl) do
    if child.HasChildren then
    begin
      Var lTypNode := child.FindNode(TSyntaxNodeType.ntType);
      if lTypNode <> nil then
      begin
        Var lTyp := lTypNode.GetAttribute(TAttributeName.anType).ToLower;
        if lTyp = '' then
          lTyp := lTypNode.GetAttribute(TAttributeName.anName).ToLower;

        //case lTyp  of
          //'class' : lMethod.LocalVariables.Add(BuildClass(lTypNode, child.GetAttribute(TAttributeName.anName)));
          //'interface' : lMethod.LocalVariables.Add(BuildInterface(lTypNode, child.GetAttribute(TAttributeName.anName)));
          //'record' :  lMethod.LocalVariables.Add(BuildRecord(lTypNode, child.GetAttribute(TAttributeName.anName)));
          ////'pointer' : BuildPointerClause(child);
          //'enum' : lMethod.LocalVariables.Add(BuildEnum(lTypNode, child.GetAttribute(TAttributeName.anName)));
          //'set' : lMethod.LocalVariables.Add(BuildSet(lTypNode, child.GetAttribute(TAttributeName.anName)));

        //end;
      end;

    end;

end;

end.