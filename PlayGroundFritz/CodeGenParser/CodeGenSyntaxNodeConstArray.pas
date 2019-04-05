namespace ProHolz.CodeGen;
interface
uses ProHolz.Ast;

type

  // This part is used for Array Constants like
  // SimpleIntArray2 : Array[0..2] of Integer = (1 shl 2 -1, 1,2);
  CodeBuilderMethods = static partial class
  private
    method resolveBounds(const node: TSyntaxNode): List<CGEntity>;
    method PrepareConstArrayExpression(const node: TSyntaxNode): CGExpression;

  public

    method PrepareArrayVarOrConstant(const node: TSyntaxNode; const isConst: Boolean; const ispublic: Boolean): CGFieldDefinition;
    method PrepareSetVarOrConstant(const node: TSyntaxNode; const isConst: Boolean; const ispublic: Boolean): CGFieldDefinition;


  end;

implementation

method CodeBuilderMethods.PrepareArrayVarOrConstant(const node: TSyntaxNode; const isConst: Boolean; const ispublic: Boolean): CGFieldDefinition;
begin
  var constName := node.FindNode(TSyntaxNodeType.ntName).AttribName;
  var typeNode := node.FindNode(TSyntaxNodeType.ntType);

  var lArray := PrepareArrayType(typeNode);


  result := new CGFieldDefinition(constName, lArray);

  var valuenode := node.FindNode(TSyntaxNodeType.ntValue);
  if valuenode <> nil then
    result.Initializer := PrepareConstArrayExpression(valuenode.ChildNodes[0]);

  result.Constant := isConst;

  if ispublic then
    result.Visibility := CGMemberVisibilityKind.Public;

end;


method CodeBuilderMethods.PrepareConstArrayExpression(const node: TSyntaxNode): CGExpression;
begin
  result := nil;
  if node = nil then exit;
  // If there is a Expression in the First Array filed like (1 shl 1...
  // The Ast creates a ntExpression around all, this is a Bug in my Opinion but
  // must check Further....
  if node.HasChildren then
    case node.Typ of

      TSyntaxNodeType.ntExpression :
      begin
        if node.ChildCount = 1 then
          result := PrepareConstArrayExpression(node.ChildNodes[0])
        else
          raise new Exception(node.Typ.ToString+  '=======  More than one Child =======');
      end;

      TSyntaxNodeType.ntExpressions :
      begin
        var lSet := new CGArrayLiteralExpression();
        for each child in  node.ChildNodes do
          lSet.Elements.Add(PrepareSingleExpressionValue(child));
        result := lSet;

      end;

      TSyntaxNodeType.ntSet :
      begin
        var lSet := new CGArrayLiteralExpression();
        for each child in  node.ChildNodes do
          lSet.Elements.Add(PrepareSingleExpressionValue(child));
        result := lSet;

      end;

    end;
end;

method CodeBuilderMethods.resolveBounds(const node: TSyntaxNode): List<CGEntity>;
begin
  result := nil;
  var lBounds := node.FindNode(TSyntaxNodeType.ntBounds);
  if lBounds <> nil then
  begin
    var lDimensions := lBounds.FindChilds(TSyntaxNodeType.ntDimension);
    if lDimensions <> nil then
    begin
      result := new List<CGEntity>;

      for  each lDimension in lDimensions do
        begin
        var resDimensions := PrepareCallExpressions(lDimension);
        if length(resDimensions) = 2 then
        begin

            var temp := new CGArrayBounds(resDimensions[0]) &end(resDimensions[1]);
            result.Add(temp);//,  end_:= lmax));

        end
        else
          if length(resDimensions) = 1 then
          begin
            var temp := new CGArrayBounds(resDimensions[0]);
              result.Add(temp);
          end;
      end;
    end;
  end;

end;

method CodeBuilderMethods.PrepareSetVarOrConstant(const node: TSyntaxNode; const isConst: Boolean; const ispublic: Boolean): CGFieldDefinition;
begin
  var constName := node.FindNode(TSyntaxNodeType.ntName).AttribName;
  var typeNode := node.FindNode(TSyntaxNodeType.ntType):FindNode(TSyntaxNodeType.ntType);

   //PrepareArrayType(typeNode, constName);
  var lArray  := new CGSetTypeReference(typeNode.AttribName.AsTypeReference);

   result := new CGFieldDefinition(constName, lArray);

   var valuenode := node.FindNode(TSyntaxNodeType.ntValue);
   if valuenode <> nil then
     result.Initializer := PrepareConstArrayExpression(valuenode.ChildNodes[0]);

   result.Constant := isConst;

   if ispublic then
     result.Visibility := CGMemberVisibilityKind.Public;

end;




end.