namespace ProHolz.CodeGen;


interface
uses ProHolz.Ast;

type
  // This part is used for ntTypes
  CodeBuilderMethods = static partial class
  public
    method PrepareTypeRef(const node: TSyntaxNode): CGTypeReference;
  end;

implementation

method CodeBuilderMethods.PrepareTypeRef(const node: TSyntaxNode): CGTypeReference;
require
  (node <> nil) implies (node.Typ = TSyntaxNodeType.ntType);
begin
  var lTemp : CGTypeReference;
  if CodeBuilderDefaultTypes.isDefaultType(node.AttribName) then
   lTemp := CodeBuilderDefaultTypes.GetDefaultType(node.AttribName)
else
  begin
    case node.AttribName.ToLower of
      'subrange' : begin
          if node.ChildNodes.Count = 2 then
           begin
             var lstart := PrepareSingleExpressionValue(node.ChildNodes[0]);
             var lEnd := PrepareSingleExpressionValue(node.ChildNodes[1]);
             exit new CGSubRangeTypeReference(lstart, lEnd);
           end;
        end;
    end;
     lTemp := node.AttribName.AsTypeReference;
  end;

  // if it is a named reference check further.....
  if lTemp is CGNamedTypeReference then
  begin
    var typeArgs := node.FindNode(TSyntaxNodeType.ntTypeArgs);
    if assigned(typeArgs) then
    begin
      var largs := new List<CGTypeReference>;
      for each child in typeArgs.ChildNodes.where(Item->Item.Typ = TSyntaxNodeType.ntType) do
        largs.Add(PrepareTypeRef(child));

      if largs.Count > 0 then
        CGNamedTypeReference(lTemp).GenericArguments := largs;
    end;
  end;
  exit lTemp;
end;

end.