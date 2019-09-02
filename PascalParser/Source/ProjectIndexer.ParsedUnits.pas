namespace ProHolz.Ast;

interface
type
  TUnitParsedEvent = public block (Sender: Object; const UnitName: String; const FileName: String; var SyntaxTree: TSyntaxNode; SyntaxTreeFromParser: Boolean; var doAbort: Boolean);

  TUnitInfo = public record
  public
    Name: not nullable String := '';
    Path: not nullable String := '';
    SyntaxTree: TSyntaxNode;
  end;

  TParsedUnits = public class(List<TUnitInfo>)
  public
    constructor; empty;
    method Initialize(ParsedUnits: TParsedUnitsCache; UnitPaths: TUnitPathsCache);
  end;

implementation
{ TProjectIndexer.TParsedUnits }

method TParsedUnits.Initialize(ParsedUnits: TParsedUnitsCache; UnitPaths: TUnitPathsCache);
begin
  RemoveAll;
  for kv in ParsedUnits.Keys do
  begin
    if  ParsedUnits[kv] = nil then
      continue; //for kv
    var  info    : TUnitInfo;
    info.Name := kv as not nullable;
    info.SyntaxTree := ParsedUnits[kv];
    var unitpath :=
    if UnitPaths.ContainsKey(kv+'.pas')
    then   UnitPaths[kv+'.pas']
    else   '';

    info.Path := String(unitpath);
    Add(info);
  end;

end;

end.