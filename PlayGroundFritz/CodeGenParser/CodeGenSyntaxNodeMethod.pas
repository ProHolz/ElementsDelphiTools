namespace ProHolz.CodeGen;

interface
uses ProHolz.Ast;

type
  // This part is used for Methods

  CodeBuilder =  partial class
  private
    method GetReturnType(const node: TSyntaxNode) : CGTypeReference;
    method BuildLocalMethod(const node: TSyntaxNode; const lMethod: CGMethodLikeMemberDefinition);
    method PrepareLocalVarOrConstant(const node: TSyntaxNode; const isConst: Boolean): CGVariableDeclarationStatement;
    method BuildVariablesMethod(const node: TSyntaxNode; const lMethod: CGMethodLikeMemberDefinition);
    method BuildConstantsMethodClause(const node: TSyntaxNode; const lMethod: CGMethodLikeMemberDefinition);
    method BuildTypesMethodClause(const node : TSyntaxNode; const lMethod : CGMethodLikeMemberDefinition);

  end;
implementation

method CodeBuilder.PrepareLocalVarOrConstant(const node: TSyntaxnode; const isConst : Boolean) : CGVariableDeclarationStatement;
begin
  Var constName := node.FindNode(TSyntaxNodeType.ntName).AttribName;
  Var typeNode := node.FindNode(TSyntaxNodeType.ntType);

  Var typeName := typeNode:AttribName;
  Var typeType := typeNode:AttribType;
//  var linit : CGExpression := nil;

 if not String.IsNullOrEmpty(typeType) then
    case typeType.ToLower of
    // Special Handling of Array Constants
      'array' : begin
                  var larray := PrepareArrayVarOrConstant(node, isConst, false);
                  //CGTypeDefinition

                   exit  new CGVariableDeclarationStatement(constName, larray.Type );
                end;

      'pointer' : begin
                   typeName := typeNode.FindNode(TSyntaxNodeType.ntType):AttribName;

                   exit new CGVariableDeclarationStatement(constName, new CGPointerTypeReference(typeName:AsTypeReference));
                  end;

    end;

  var valuenode := node.FindNode(TSyntaxNodeType.ntValue);


   if assigned(typeNode) then
   result :=  new CGVariableDeclarationStatement(constName, PrepareTypeRef(typeNode), PrepareExpressionValue(valuenode))
   else
     result :=  new CGVariableDeclarationStatement(constName, ''.AsTypeReference , PrepareExpressionValue(valuenode));
   result.Constant := isConst;

end;


method CodeBuilder.BuildLocalMethod(const node : TSyntaxNode; const lMethod : CGMethodLikeMemberDefinition);
begin
  var lTemp := PrepareMethod(node, nil);
  if assigned(lTemp) and (lTemp is CGMethodDefinition) then
    begin
    if not assigned(lMethod.LocalMethods) then
      lMethod.LocalMethods := new List<CGMethodDefinition>;

    lMethod.LocalMethods.Add(CGMethodDefinition(lTemp));
    end;

end;


method CodeBuilder.BuildVariablesMethod(const node : TSyntaxNode; const lMethod : CGMethodLikeMemberDefinition);
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


method CodeBuilder.BuildConstantsMethodClause(const node : TSyntaxNode; const lMethod : CGMethodLikeMemberDefinition);
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

method CodeBuilder.BuildTypesMethodClause(const node : TSyntaxNode; const lMethod : CGMethodLikeMemberDefinition);
begin
  if node = nil  then exit;
  for each child in node.ChildNodes.FindAll(Item -> Item.Typ = TSyntaxNodeType.ntTypeDecl) do
    if child.HasChildren then
    begin
      Var lTypNode := child.FindNode(TSyntaxNodeType.ntType);
      if lTypNode <> nil then
      begin
        Var lTyp := lTypNode.AttribType.ToLower;
        if lTyp = '' then
          lTyp := lTypNode.AttribName.ToLower;

         if not assigned(lMethod.LocalTypes) then
           lMethod.LocalTypes := new List<CGTypeDefinition>;

        case lTyp  of
          'record' :  lMethod.LocalTypes.Add(BuildRecord(lTypNode, child.AttribName, nil));
        end;
      end;

    end;

end;

method CodeBuilder.GetReturnType(const node: TSyntaxNode): CGTypeReference;
begin
  if not assigned(node) then exit nil;
  assert(node.Typ = TSyntaxNodeType.ntReturnType);
  var lReturn := node.FindNode(TSyntaxNodeType.ntType);
  if assigned(lReturn) then
    exit PrepareTypeRef(lReturn)
    else
      exit nil;
end;



end.