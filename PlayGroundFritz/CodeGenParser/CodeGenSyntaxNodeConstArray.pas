namespace PlayGroundFritz;
interface
uses PascalParser;

type

  // This part is used for Array Constants like
  // SimpleIntArray2 : Array[0..2] of Integer = (1 shl 2 -1, 1,2);
  CodeBuilderMethods = static partial class
  private
    method resolveBounds(const value: TSyntaxNode): List<CGEntity>;
    method PrepareConstArrayExpression(const ExpressionNode: TSyntaxNode): CGExpression;

  public

    method PrepareArrayVarOrConstant(const constnode: TSyntaxNode; const isConst: Boolean; const ispublic: Boolean): CGFieldDefinition;

  end;

implementation

method CodeBuilderMethods.PrepareArrayVarOrConstant(const constnode: TSyntaxNode; const isConst: Boolean; const ispublic: Boolean): CGFieldDefinition;
begin
  var constName := constnode.FindNode(TSyntaxNodeType.ntName).AttribName;
  var typeNode := constnode.FindNode(TSyntaxNodeType.ntType);

  var lArray := PrepareArrayType(typeNode, constName);


  result := new CGFieldDefinition(constName, lArray);

  var valuenode := constnode.FindNode(TSyntaxNodeType.ntValue);
  if valuenode <> nil then
    result.Initializer := PrepareConstArrayExpression(valuenode.ChildNodes[0]);

  result.Constant := isConst;

  if ispublic then
    result.Visibility := CGMemberVisibilityKind.Public;

end;


method CodeBuilderMethods.PrepareConstArrayExpression(const ExpressionNode: TSyntaxNode): CGExpression;
begin
  result := nil;
  if ExpressionNode = nil then exit;
  // If there is a Expression in the First Array filed like (1 shl 1...
  // The Ast creates a ntExpression around all, this is a Bug in my Opinion but
  // must check Further....
  if ExpressionNode.HasChildren then
    case ExpressionNode.Typ of

      TSyntaxNodeType.ntExpression :
      begin
        if ExpressionNode.ChildCount = 1 then
          result := PrepareConstArrayExpression(ExpressionNode.ChildNodes[0])
        else
          raise new Exception(ExpressionNode.Typ.ToString+  '=======  More than one Child =======');
      end;

      TSyntaxNodeType.ntExpressions :
      begin
        var lSet := new CGArrayLiteralExpression();
        for each child in  ExpressionNode.ChildNodes do
          lSet.Elements.Add(PrepareSingleExpressionValue(child));
        result := lSet;

      end;
    end;
end;

method CodeBuilderMethods.resolveBounds(const value: TSyntaxNode): List<CGEntity>;
begin
  result := nil;
  var lBounds := value.FindNode(TSyntaxNodeType.ntBounds);
  if lBounds <> nil then
  begin
    var lDimensions := lBounds.FindNodes(TSyntaxNodeType.ntDimension);
    if lDimensions <> nil then
    begin
      result := new List<CGEntity>;

      for  each lDimension in lDimensions do
        begin
        var resDimensions := PrepareCallExpressions(lDimension);
        if length(resDimensions) = 2 then
        begin
          if (resDimensions[0] is CGIntegerLiteralExpression) and (resDimensions[1] is CGIntegerLiteralExpression) then
          begin
            var lmin : Integer  := CGIntegerLiteralExpression(resDimensions[0]).Value;
            var lmax : Integer := CGIntegerLiteralExpression(resDimensions[1]).Value;
            var temp := new CGArrayBounds();
            temp.Start := lmin;
            temp.End := lmax;
            result.Add(temp);//,  end_:= lmax));
          end;
        end
        else
          if length(resDimensions) = 1 then
          begin
            if resDimensions[0] is CGNamedIdentifierExpression then
              result.Add((resDimensions[0] as CGNamedIdentifierExpression).Name.AsTypeReference);
          end;
      end;
    end;
  end;

end;




end.