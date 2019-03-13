namespace PlayGroundFritz;

interface
uses PascalParser;

type
  CodeBuilderEnum = static class
  public
    method BuildEnum(const EnumTypeNode : TSyntaxNode; const enumName : not nullable String): CGTypeDefinition;
    method BuildSet(const EnumTypeNode : TSyntaxNode; const enumName : not nullable String): CGTypeDefinition;
  end;
implementation

method CodeBuilderEnum.BuildEnum(const EnumTypeNode: TSyntaxNode; const enumName: not nullable String): CGTypeDefinition;
begin
  result := new CGEnumTypeDefinition(enumName);
  for each FieldNode in EnumTypeNode.FindNodes(TSyntaxNodeType.ntIdentifier) do
    begin
    var FieldType := FieldNode.GetAttribute(TAttributeName.anName);
    result.Members.Add(new CGEnumValueDefinition(FieldType));
  end;

end;

method CodeBuilderEnum.BuildSet(const EnumTypeNode: TSyntaxNode; const enumName: not nullable String): CGTypeDefinition;
begin
 var ltemp := new CGEnumTypeDefinition(enumName);
  ltemp.IsSet := true;
  for each FieldNode in EnumTypeNode.FindNodes(TSyntaxNodeType.ntIdentifier) do
    begin
    var FieldType := FieldNode.GetAttribute(TAttributeName.anName);
    ltemp.Members.Add(new CGEnumValueDefinition(FieldType));
  end;
 result := ltemp;
end;

end.