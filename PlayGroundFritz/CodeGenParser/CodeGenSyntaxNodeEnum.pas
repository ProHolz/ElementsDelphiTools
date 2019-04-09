namespace ProHolz.CodeGen;
{ $DEFINE USESET}
interface
uses ProHolz.Ast;

type
  CodeBuilder =  partial class
  private
    method BuildEnum(const node : TSyntaxNode; const enumName : not nullable String): CGTypeDefinition;
    method BuildSet2(const node : TSyntaxNode; const setName : not nullable String): CGTypeDefinition;
  end;
implementation

method CodeBuilder.BuildEnum(const node: TSyntaxNode; const enumName: not nullable String): CGTypeDefinition;
begin
  result := new CGEnumTypeDefinition(enumName);
  for each FieldNode in node.FindChilds(TSyntaxNodeType.ntIdentifier) do
    begin
    var FieldType := FieldNode.AttribName;
    result.Members.Add(new CGEnumValueDefinition(FieldType));
  end;

  if settings.PublicEnums then
   result.Visibility := CGTypeVisibilityKind.Public;

end;

method CodeBuilder.BuildSet2(const node: TSyntaxNode; const setName: not nullable String): CGTypeDefinition;
begin
 result := new CGSetTypeDefinition(setName);
  for each FieldNode in node.FindNode(TSyntaxNodeType.ntType):FindChilds(TSyntaxNodeType.ntIdentifier) do
    begin
    var FieldType := FieldNode.AttribName;
    result.Members.Add(new CGEnumValueDefinition(FieldType));
  end;

  if settings.PublicEnums then
    result.Visibility := CGTypeVisibilityKind.Public;

end;

end.