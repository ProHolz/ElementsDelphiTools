namespace PascalParser;
interface

type
 TProjectIndexer = public class
  public
    FAborting       : Boolean;
    FDefinesList    : StringList;
    FIncludeCache   : TIncludeCache;
    FIncludeFiles   : TIncludeFiles;
    FNotFoundUnits  : StringList;
    FOnGetUnitSyntax: TGetUnitSyntaxEvent;
    FOnUnitParsed   : TUnitParsedEvent;
    FParsedUnits    : TParsedUnitsCache;
    FParsedUnitsInfo: TParsedUnits;
    FProblems       : TParseProblems;
    FProjectFolder  : String;
    FSearchPathRel  : StringList;
    FSearchPaths    : Searchpaths;
    FUnitPaths      : TUnitPathsCache;

  protected
    method AppendUnits(usesNode: TSyntaxNode; const filePath: String; unitList: StringList);
    method BuildUsesList(unitNode: TSyntaxNode; const fileName: String; isProject: Boolean; unitList: StringList);
    method FindType(node: TSyntaxNode; nodeType: TSyntaxNodeType): TSyntaxNode;
    method GetUnitSyntax(const fileName: String; var syntaxTree: TSyntaxNode; var doParseUnit: Boolean);
    method NotifyUnitParsed(const unitName, fileName: String; var syntaxTree: TSyntaxNode; syntaxTreeFromParser: Boolean);
    method ParseUnit(const unitName: String; const fileName: String; isProject: Boolean);
    method PrepareSearchPath;

    method RunParserOnUnit(const fileName: String; var syntaxTree: TSyntaxNode);
    method ScanUsedUnits(const unitName, fileName: String; isProject: Boolean; syntaxTree: TSyntaxNode; syntaxTreeFromParser: Boolean);

  public // Class
   class method SafeOpenFileContext(const fileName: not nullable String; out fileContext: not nullable String; out errorMsg: String): Boolean;

  public
    constructor (const aCompiler : DelphiCompiler);
    method  FindFile(const fileName: String; relativeToFolder: String; var filePath: String): Boolean;

    method Parse(const fileName: String);

    property Compiler : DelphiCompiler read protected write;
    property Defines: StringList read FDefinesList write FDefinesList;
    property ParsedUnits: TParsedUnits read FParsedUnitsInfo;
    property IncludeFiles: TIncludeFiles read FIncludeFiles;
    property Problems: TParseProblems read FProblems;
    property NotFoundUnits: StringList read FNotFoundUnits;
    property SearchPath: StringList read FSearchPathRel write FSearchPathRel;
    property OnGetUnitSyntax: TGetUnitSyntaxEvent read FOnGetUnitSyntax write FOnGetUnitSyntax;
    property OnUnitParsed: TUnitParsedEvent read FOnUnitParsed write FOnUnitParsed;


  end;

implementation




method TProjectIndexer.AppendUnits(usesNode: TSyntaxNode; const filePath: String; unitList: StringList);
begin
  for childNode in usesNode.ChildNodes do
    if childNode.Typ = TSyntaxNodeType.ntUnit then
    begin
      var unitName := childNode.GetAttribute(TAttributeName.anName).ToLower;
      unitList.Add(unitName);
      if not FUnitPaths.ContainsKey(unitName) then
      begin
        var unitPath := childNode.GetAttribute(TAttributeName.anPath);
        if unitPath <> '' then begin
          if Searchpaths.IsRelativeWinPath(unitPath) then
            unitPath :=  Path.GetFullPath(Path.Combine( filePath , unitPath));
          FUnitPaths.Add(unitName + '.pas', unitPath);
        end;
      end;
    end;
end;


method TProjectIndexer.BuildUsesList(unitNode: TSyntaxNode; const fileName: String; isProject: Boolean; unitList: StringList);
var
  usesNode  : TSyntaxNode;
begin
 var fileFolder := Path.GetParentDirectory(fileName);
  if isProject then
  begin
    usesNode := FindType(unitNode, TSyntaxNodeType.ntUses);
    if assigned(usesNode) then
      AppendUnits(usesNode, fileFolder, unitList);
    usesNode := FindType(unitNode, TSyntaxNodeType.ntContains);
    if assigned(usesNode) then
      AppendUnits(usesNode, fileFolder, unitList);
  end
  else
  begin
   var intfNode := FindType(unitNode, TSyntaxNodeType.ntInterface);
    if assigned(intfNode) then
    begin
      usesNode := FindType(intfNode, TSyntaxNodeType.ntUses);
      if assigned(usesNode) then
        AppendUnits(usesNode, fileFolder, unitList);
    end;
    var implNode := FindType(unitNode, TSyntaxNodeType.ntImplementation);
    if assigned(implNode) then
    begin
      usesNode := FindType(implNode, TSyntaxNodeType.ntUses);
      if assigned(usesNode) then
        AppendUnits(usesNode, fileFolder, unitList);
    end;
  end;
end;


method TProjectIndexer.FindType(node: TSyntaxNode; nodeType: TSyntaxNodeType):
TSyntaxNode;
begin
  if node.Typ = nodeType then
    Exit node
  else
    Result := node.FindNode(nodeType);
end;

method TProjectIndexer.GetUnitSyntax(const fileName: string; var syntaxTree: TSyntaxNode; var doParseUnit: boolean);
begin
 var doAbort := false;
  doParseUnit := true;
  syntaxTree := nil;
  if assigned(OnGetUnitSyntax) then
  begin
    OnGetUnitSyntax(Self, fileName, var syntaxTree, var doParseUnit, var doAbort);
    if doAbort then
      FAborting := true;
  end;
end;

method TProjectIndexer.NotifyUnitParsed(const unitName, fileName: string; var syntaxTree: TSyntaxNode; syntaxTreeFromParser: boolean);
begin
  if assigned(OnUnitParsed) then
  begin
    var doAbort := false;
    OnUnitParsed(Self, unitName, fileName,  var syntaxTree, syntaxTreeFromParser,  var doAbort);
    if doAbort then
      FAborting := true;
  end;
end;


method TProjectIndexer.ParseUnit(const unitName: String; const fileName: String; isProject: Boolean);
var
doParseUnit: Boolean;
syntaxTree : TSyntaxNode;
begin
  if FAborting then  Exit;
  GetUnitSyntax(fileName, var syntaxTree, var doParseUnit);
  if FAborting then Exit;

  if doParseUnit then
    RunParserOnUnit(fileName, var  syntaxTree);

  FParsedUnits.Add(unitName, syntaxTree);

  if (not FAborting) and assigned(syntaxTree) then
    ScanUsedUnits(unitName, fileName, isProject, syntaxTree, doParseUnit);
end;

method TProjectIndexer.PrepareSearchPath;
begin
  for iPath in FSearchPathRel do begin
    FSearchPaths.Add(iPath as not nullable);
  end;
end;



method TProjectIndexer.Parse(const fileName: string);
begin
  FAborting := false;
  FParsedUnits.RemoveAll;
  FProjectFolder :=   Path.GetParentDirectory(fileName);
  FIncludeCache := new TIncludeCache;
  FUnitPaths := new TUnitPathsCache();
  FSearchPaths.Clear;
  FSearchPaths.BasePath := FProjectFolder;
 // PrepareDefines;
  PrepareSearchPath;
  FNotFoundUnits.RemoveAll;
  FProblems.RemoveAll;
  //var filePath := FProjectFolder;
  var projectName := Path.GetFileName(fileName);
  FUnitPaths.Add(projectName, fileName);
  // Do the work
  ParseUnit(projectName, fileName, true);
  // Fill Results

  FParsedUnitsInfo.Initialize(FParsedUnits, FUnitPaths);
        //FIncludeFiles.Initialize(FIncludeCache);

end;


constructor TProjectIndexer(const aCompiler : DelphiCompiler);
begin
  inherited constructor;
  Compiler := aCompiler;
  FSearchPaths := new Searchpaths('');
  FDefinesList := new StringList;
  FParsedUnits :=  new TParsedUnitsCache;
  FParsedUnitsInfo := new TParsedUnits;
  FIncludeFiles :=new TIncludeFiles;
  FNotFoundUnits := new StringList;
  FProblems := new TParseProblems;
end;



method TProjectIndexer.FindFile(const fileName: string; relativeToFolder: string; var filePath: string): boolean;

method FilePresent(const testFile: String; const name : String): Boolean;
begin
  Result := File.Exists(testFile);
  if Result then
  begin
    filePath := Path.GetFullPath(testFile);
    FUnitPaths.Add(name, filePath);
  end;
end;

begin
  Result := false;
  var fName :=   StrHelper.AnsiDequotedStr(fileName, Char("'"));

  if FUnitPaths.ContainsKey(fName) then
  begin
    filePath := FUnitPaths[fName];
    Exit true;
  end;

  if FNotFoundUnits.Contains(fName) then
    exit false;

    if relativeToFolder <> '' then
      if FilePresent(Path.Combine(relativeToFolder , fName), fName) then
        Exit true;

    if FilePresent(Path.Combine(FProjectFolder ,fName), fName) then
      Exit true;

    for lsearch in FSearchPaths.getPaths do
      if FilePresent(Path.Combine( lsearch , fName), fName) then
        Exit true;

  //if SameText(ExtractFileExt(fileName), '.pas') then
    //Result := false
  //else
    //Result := FindFile(fileName + '.pas', relativeToFolder, var var filePath);

    if (not Result) and (relativeToFolder = '') {ignore include files} then
      if not FNotFoundUnits.Contains(fName) then
        FNotFoundUnits.Add(fName);
  end;


  class method TProjectIndexer.SafeOpenFileContext(const fileName: not nullable String; out fileContext: not nullable String; out errorMsg: string): boolean;

  begin
    try
      fileContext := File.ReadText(fileName) as not nullable;
      Result := true;
    except
      on E: Exception do
      begin
        result := false;
        errorMsg := E.Message;
        fileContext := '';
      end;
    end;
  end;


  method TProjectIndexer.RunParserOnUnit(const fileName: string; var syntaxTree: TSyntaxNode);
  var
  builder   : TPasSyntaxTreeBuilder;
  errorMsg  : String;
  fileContext : String;
  begin
    if not SafeOpenFileContext(fileName, out fileContext, out errorMsg) then
      FProblems.LogProblem(TParseProblemType.ptCantOpenFile, fileName, errorMsg)
    else begin
      builder := new TPasSyntaxTreeBuilder(Compiler);

      builder.IncludeHandler := new TProjectIncludeHandler(Self, FIncludeCache, FProblems, fileName);

      for define in FDefinesList do
        TmwSimplePasPar(builder).Lexer.AddDefine(define);
      try
        syntaxTree := builder.RunWithString(File.ReadText(fileName));
      except
        on E: ESyntaxTreeException do begin
          FProblems.LogProblem(TParseProblemType.ptCantParseFile, fileName,
          String.Format('Line {0}, Column: {1} {2}', [E.Line, E.Col, E.Message]));
        end;
      end;
    end;

  end; { TProjectIndexer.RunParserOnUnit }

  method TProjectIndexer.ScanUsedUnits(const unitName, fileName: string; isProject: boolean; syntaxTree: TSyntaxNode; syntaxTreeFromParser: boolean);
  var
  unitList: List<String>;
  unitNode: TSyntaxNode;
  usesPath: String;
  begin
    //unitNode := FindType(syntaxTree, TSyntaxNodeType.ntUnit);
    //if not assigned(unitNode) then
      //Exit;
    unitNode := syntaxTree;

    unitList := new List<String>;
    BuildUsesList(unitNode, fileName, isProject, unitList);
    NotifyUnitParsed(unitName, fileName, var syntaxTree, syntaxTreeFromParser);

    for usesName in unitList do
      begin
      if FAborting then Exit;
      if not FParsedUnits.ContainsKey(usesName) then
      begin
        if FindFile(usesName + '.pas', '', var usesPath) then
          ParseUnit(usesName, usesPath, false)
        else
          FParsedUnits.Add(usesName, nil);
      end;
    end;

  end;


end.