namespace ProHolz.CodeGen;
{$DEFINE USESET}
interface
uses ProHolz.Ast;

type
  CodeBuilderEnum = static class
  public
    method BuildEnum(const node : TSyntaxNode; const enumName : not nullable String): CGTypeDefinition;
    method BuildSet(const node : TSyntaxNode; const setName : not nullable String): CGTypeDefinition;
  end;
implementation

method CodeBuilderEnum.BuildEnum(const node: TSyntaxNode; const enumName: not nullable String): CGTypeDefinition;
begin
  result := new CGEnumTypeDefinition(enumName);
  for each FieldNode in node.FindChilds(TSyntaxNodeType.ntIdentifier) do
    begin
    var FieldType := FieldNode.AttribName;
    result.Members.Add(new CGEnumValueDefinition(FieldType));
  end;

end;

method CodeBuilderEnum.BuildSet(const node: TSyntaxNode; const setName: not nullable String): CGTypeDefinition;
begin
 // var l := new CGSetTypeReference(enumName.AsTypeReference).
  {$HINT WE NEED A SET TYPE}
 var ltemp := new CGEnumTypeDefinition(setName);
// ''.AsTypeReference.
ltemp.Comment := ('Should be Set of ').AsComment;
 {$IF USESET}
   ltemp.IsSet := true;
 {$ENDIF}
  for each FieldNode in node.FindNode(TSyntaxNodeType.ntType):FindChilds(TSyntaxNodeType.ntIdentifier) do
    begin
    var FieldType := FieldNode.AttribName;
    ltemp.Members.Add(new CGEnumValueDefinition(FieldType));
  end;
 result := ltemp;
end;

end.