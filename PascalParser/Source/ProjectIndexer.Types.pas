namespace PascalParser;
interface

type
  StringList = List<String>;

  TParsedUnitsCache = public class(Dictionary<String,TSyntaxNode>)
  public
    constructor ();
    begin
      inherited constructor();
    end;
  end;

  TUnitPathsCache = public class(Dictionary<String,String>)
  public
    constructor (); empty;
  end;

  TIncludeInfo = public record
  public
    FileName: String;
    Content : String;
  end;

  TIncludeCache = public class(Dictionary<String,TIncludeInfo>)
  public
    constructor ();
    begin
      inherited constructor();
    end;
  end;


  TGetUnitSyntaxEvent = public block (Sender: Object; const fileName: String;  var syntaxTree: TSyntaxNode; var doParseUnit : Boolean; Var doAbort: Boolean);

  TIncludeFileInfo = public record
  public
    Name: String;
    Path: String;
  end;

  TIncludeFiles = public class(List<TIncludeFileInfo>)
  protected
    method Initialize(includeCache: TIncludeCache);
  public
    constructor(); empty;
  end;



  TProjectIncludeHandler = public class(IIncludeHandler)
  private
    FIncludeCache: TIncludeCache;
    FIndexer     : TProjectIndexer;
    FProblems    : TParseProblems;
    FUnitFile           : String;
    FUnitFileFolder     : String;
  public
    constructor (indexer: TProjectIndexer; includeCache: TIncludeCache; problemList: TParseProblems; const currentFile: String);
    method  GetIncludeFileContent(const fileName: not nullable String): not nullable String;
  end;


implementation


constructor TProjectIncludeHandler(indexer: TProjectIndexer; includeCache: TIncludeCache; problemList: TParseProblems; const currentFile: String);
begin
  FIndexer := indexer;
  FIncludeCache := includeCache;
  FProblems := problemList;
  FUnitFileFolder :=   Path.GetParentDirectory(currentFile);
  FUnitFile := Path.GetFileNameWithoutExtension(currentFile);
end;

method TProjectIncludeHandler.GetIncludeFileContent(const fileName: not nullable string): not nullable string;
var
errorMsg   : String;
filePath   : String;
includeInfo: TIncludeInfo;
key        : String;
begin
  //fileName);

  //if fileName.StartsWith('*.') then
    //fName := FUnitFile + fileName.Remove(0 {0-based}, 1)
  //else if fileName.Contains('*') then
    //fName := fileName.Replace('*', '')
  //else
  var  fName := fileName.ToLowerInvariant;

  key := fName + #13 + FUnitFileFolder;
  if FIncludeCache.ContainsKey(key) then
    exit FIncludeCache[key].Content as not nullable;
    //Exit(includeInfo.Content);

  if not FIndexer.FindFile(fName, FUnitFileFolder, var  filePath) then
  begin
    FProblems.LogProblem(TParseProblemType.ptCantFindFile, fName, 'Source folder: ' + FUnitFileFolder);
    includeInfo.FileName := '';
    includeInfo.Content := '';
    FIncludeCache.Add(key, includeInfo);
    Exit('');
  end;

  if FIncludeCache.ContainsKey(filePath) then
    exit FIncludeCache[filePath].Content as not nullable;


  if not TProjectIndexer.SafeOpenFileContext(filePath, out result, out errorMsg) then
  begin
    FProblems.LogProblem(TParseProblemType.ptCantOpenFile, filePath, errorMsg);
    Result := ''
  end
  else
  begin
    includeInfo.FileName := filePath;
    includeInfo.Content := Result;
    FIncludeCache.Add(fName + #13 + FUnitFileFolder, includeInfo);
    FIncludeCache.Add(filePath, includeInfo);
  end;
end;

{ TProjectIndexer.TIncludeFiles }

method TIncludeFiles.Initialize(includeCache: TIncludeCache);
begin

end;

end.