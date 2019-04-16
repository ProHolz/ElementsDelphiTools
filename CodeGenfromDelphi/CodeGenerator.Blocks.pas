namespace ProHolz.CodeGen;

interface
uses ProHolz.Ast;

type
  // This part is used for ntAnonym* Types
  CodeBuilder =  partial class
  private
    method PrepareAnonymousMethod(const node: TSyntaxNode): CGExpression;
    method BuildAnonymousBlockType(const node: TSyntaxNode; const name: not nullable String): CGTypeDefinition;
    method BuildBlockType(const node: TSyntaxNode; const name: not nullable String): CGTypeDefinition;
  end;

implementation

method CodeBuilder.PrepareAnonymousMethod(const node: TSyntaxNode): CGExpression;
begin
  var lParamList := new List<CGParameterDefinition>;
  var lLocalvars := new List<CGVariableDeclarationStatement>;
  var lStatements := node.FindNode(TSyntaxNodeType.ntStatements);
  var lStatementList := PrepareStatementList(lStatements);

  var lParams := node.FindNode(TSyntaxNodeType.ntParameters);
  if assigned(lParams)  then
    for each &Param in lParams.ChildNodes do
      lParamList.Add(PrepareParam(&Param));


  var lVars := node.FindNode(TSyntaxNodeType.ntVariables);
  if assigned(lVars) then
   for each lvar in lVars.ChildNodes do
     begin
       lLocalvars.add(PrepareLocalVarOrConstant(lvar, false));
     end;

  lVars := node.FindNode(TSyntaxNodeType.ntConstants);
  if assigned(lVars) then
    for each lvar in lVars.ChildNodes do
      begin
      lLocalvars.add(PrepareLocalVarOrConstant(lvar, true));
    end;


  var lMethod   := if (lParamList.Count > 0) then
    new CGAnonymousMethodExpression(lParamList,  lStatementList)
else
  new CGAnonymousMethodExpression(lStatementList);
//legacy pascal should be false here
  lMethod.Lambda := false;

 if lLocalvars.Count > 0 then
   lMethod.LocalVariables := lLocalvars;


  var lReturn :=  GetReturnType(node.FindNode(TSyntaxNodeType.ntReturnType));
  if assigned(lReturn) then
    lMethod.ReturnType := lReturn;

  exit lMethod;
end;

method CodeBuilder.BuildAnonymousBlockType(const node: TSyntaxNode; const name: not nullable String): CGTypeDefinition;
begin
  Var typenode := node.FindNode(TSyntaxNodeType.ntAnonymousMethodType);
  if assigned(typenode) then
  begin
    var ltemp := new CGBlockTypeDefinition(name);
    Var ReturnType := GetReturnType(typenode.FindNode(TSyntaxNodeType.ntReturnType));
    If assigned(ReturnType) then
      ltemp.ReturnType :=  ReturnType;
    for each &Param in typenode.FindNode(TSyntaxNodeType.ntParameters):FindChilds(TSyntaxNodeType.ntParameter) do
      ltemp.Parameters.Add(PrepareParam(&Param));

    if String.IsNullOrEmpty(typenode.AttribKind) then
      ltemp.IsPlainFunctionPointer := true;

    ltemp.Visibility := CGTypeVisibilityKind.Public;


    exit ltemp;
  end
  else raise new Exception("BuildBlockType not solved");
end;

method CodeBuilder.BuildBlockType(const node: TSyntaxNode; const name: not nullable String): CGTypeDefinition;
begin
  Var typenode := node.FindNode(TSyntaxNodeType.ntType);
  if assigned(typenode) then
  begin

    var ltemp := new CGBlockTypeDefinition(name);
    Var ReturnType :=   GetReturnType(typenode.FindNode(TSyntaxNodeType.ntReturnType));
    If assigned(ReturnType) then
      ltemp.ReturnType := ReturnType;

    for each &Param in typenode.FindNode(TSyntaxNodeType.ntParameters):FindChilds(TSyntaxNodeType.ntParameter) do
      ltemp.Parameters.Add(PrepareParam(&Param));

    if String.IsNullOrEmpty(typenode.AttribKind) then
      ltemp.IsPlainFunctionPointer := true;
    if settings.PublicBlocks then
      ltemp.Visibility := CGTypeVisibilityKind.Public;

    exit ltemp;
  end
  else raise new Exception("BuildBlockType not solved");
end;

end.