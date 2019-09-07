namespace ProHolz.Ast;
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


  TGetUnitSyntaxEvent = public block (Sender: Object; const FileName: String;  var SyntaxTree: TSyntaxNode; var DoParseUnit : Boolean; Var DoAbort: Boolean);

  TIncludeFileInfo = public record
  public
    Name: String;
    Path: String;
  end;

  TIncludeFiles = public class(List<TIncludeFileInfo>)
  protected
    method Initialize(IncludeCache: TIncludeCache);
  public
    constructor(); empty;
  end;



  TProjectIncludeHandler = public class(IIncludeHandler)
  private
    fIncludeCache: TIncludeCache;
    fIndexer     : TProjectIndexer;
    fProblems    : TParseProblems;
  //  FUnitFile           : String;
    fUnitFileFolder     : String;
  public
    constructor (Indexer: TProjectIndexer; IncludeCache: TIncludeCache; ProblemList: TParseProblems; const CurrentFile: String);
    method  GetIncludeFileContent(const FileName: not nullable String): not nullable String;
  end;


implementation


constructor TProjectIncludeHandler(Indexer: TProjectIndexer; IncludeCache: TIncludeCache; ProblemList: TParseProblems; const CurrentFile: String);
begin
  fIndexer := Indexer;
  fIncludeCache := IncludeCache;
  fProblems := ProblemList;
  fUnitFileFolder :=   Path.GetParentDirectory(CurrentFile);
//  FUnitFile := Path.GetFileNameWithoutExtension(currentFile);
end;

method TProjectIncludeHandler.GetIncludeFileContent(const FileName: not nullable string): not nullable string;
var
errorMsg   : String;
filePath   : String;
includeInfo: TIncludeInfo;
key        : String;
begin

  var  fName := FileName.ToLower;

  key := fName + #13 + fUnitFileFolder;
  if fIncludeCache.ContainsKey(key) then
    exit fIncludeCache[key].Content as not nullable;
    //Exit(includeInfo.Content);

  if not fIndexer.FindFile(fName, fUnitFileFolder, out   filePath) then
  begin
    fProblems.LogProblem(TParseProblemType.ptCantFindFile, fName, 'Source folder: ' + fUnitFileFolder);
    includeInfo.FileName := '';
    includeInfo.Content := '';
    fIncludeCache.Add(key, includeInfo);
    Exit('');
  end;

  if fIncludeCache.ContainsKey(filePath) then
    exit fIncludeCache[filePath].Content as not nullable;


  if not TProjectIndexer.SafeOpenFileContext(filePath, out result, out errorMsg) then
  begin
    fProblems.LogProblem(TParseProblemType.ptCantOpenFile, filePath, errorMsg);
    Result := ''
  end
  else
  begin
    includeInfo.FileName := filePath;
    includeInfo.Content := Result;
    fIncludeCache.Add(fName + #13 + fUnitFileFolder, includeInfo);
    fIncludeCache.Add(filePath, includeInfo);
  end;
end;

{ TProjectIndexer.TIncludeFiles }

method TIncludeFiles.Initialize(IncludeCache: TIncludeCache);
begin

end;

end.