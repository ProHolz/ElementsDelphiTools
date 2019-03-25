namespace ProHolz.Ast;

interface
type
  TUnitParsedEvent = public block (Sender: Object; const unitName: String; const fileName: String; var syntaxTree: TSyntaxNode; syntaxTreeFromParser: Boolean; var doAbort: Boolean);


  TUnitInfo = public record
  public
    Name: not nullable String := '';
    Path: not nullable String := '';
    SyntaxTree: TSyntaxNode;
  end;


  TParsedUnits = public class(List<TUnitInfo>)
  public
    constructor; empty;
    method Initialize(parsedUnits: TParsedUnitsCache; unitPaths: TUnitPathsCache);
  end;

implementation
{ TProjectIndexer.TParsedUnits }

method TParsedUnits.Initialize(parsedUnits: TParsedUnitsCache; unitPaths: TUnitPathsCache);
var
info    : TUnitInfo;
unitPath: String;
begin
  RemoveAll;
  for kv in parsedUnits.Keys do
  begin
    if  parsedUnits[kv] = nil then
      continue; //for kv
    info.Name := kv as not nullable;
    info.SyntaxTree := parsedUnits[kv];
    if unitPaths.ContainsKey(kv+'.pas')
    then unitPath :=  unitPaths[kv+'.pas']
    else unitPath := '';
            //or unitPaths.TryGetValue(kv.Key + '.dpr', unitPath))

    info.Path := unitPath as not nullable;

    Add(info);
  end;

end;

end.