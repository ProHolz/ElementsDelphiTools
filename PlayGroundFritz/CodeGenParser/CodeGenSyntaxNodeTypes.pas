namespace PlayGroundFritz;


interface
uses PascalParser;

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
  var lTemp :=
  if CodeBuilderDefaultTypes.isDefaultType(node.AttribName) then
  CodeBuilderDefaultTypes.GetDefaultType(node.AttribName)
else
  node.AttribName.AsTypeReference;

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