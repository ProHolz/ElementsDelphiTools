namespace ProHolz.Ast;
interface

type
 TProjectIndexer = public class
  private
   FDefinesList    : StringList;   // For all Directives not resolved
  public
    fAborting       : Boolean;

    fIncludeCache   : TIncludeCache;
    fIncludeFiles   : TIncludeFiles;
    fNotFoundUnits  : StringList;
    fOnGetUnitSyntax: TGetUnitSyntaxEvent;
    fOnUnitParsed   : TUnitParsedEvent;
    fonParseCompilerDirective : TParseCompilerDirectiveEvent;

    fParsedUnits    : TParsedUnitsCache;
    fParsedUnitsInfo: TParsedUnits;
    fProblems       : TParseProblems;
    fProjectFolder  : String;
    fSearchPathRel  : StringList;
    fSearchPaths    : Searchpaths;
    fUnitPaths      : TUnitPathsCache;
    fProjectPaths   : StringList;

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
    property ParsedUnits: TParsedUnits read fParsedUnitsInfo;
    property IncludeFiles: TIncludeFiles read fIncludeFiles;
    property Problems: TParseProblems read fProblems;
    property NotFoundUnits: StringList read fNotFoundUnits;
    //property UnitPaths      : TUnitPathsCache read FUnitPaths;
    property ProjectPaths   : StringList read fProjectPaths;


    property SearchPaths: Searchpaths read fSearchPaths write fSearchPaths;

    property OnGetUnitSyntax: TGetUnitSyntaxEvent read fOnGetUnitSyntax write fOnGetUnitSyntax;
    property OnUnitParsed: TUnitParsedEvent read fOnUnitParsed write fOnUnitParsed;
    property OnParseCompilerDirective : TParseCompilerDirectiveEvent read fonParseCompilerDirective write fonParseCompilerDirective;

  end;

implementation


method TProjectIndexer.AppendUnits(usesNode: TSyntaxNode; const filePath: String; unitList: StringList);
begin
  for childNode in usesNode.ChildNodes do
    if childNode.Typ = TSyntaxNodeType.ntUnit then
    begin
      var unitName := childNode.AttribName.ToLower;
      unitList.Add(unitName);
      if not fUnitPaths.ContainsKey(unitName) then
      begin
        var unitPath := childNode.GetAttribute(TAttributeName.anPath);
        if unitPath <> '' then begin
          fProjectPaths.Add(unitPath);
          if SearchPaths.IsRelativeWinPath(unitPath) then
            unitPath :=  Path.GetFullPath(Path.Combine( filePath , unitPath));
          fUnitPaths.Add(unitName + '.pas', unitPath.ToLower);
        end
        else
          begin

          FindFile(unitName+ '.pas', '', var unitPath);

          if unitPath <> '' then begin
            fProjectPaths.Add(unitPath);
            if SearchPaths.IsRelativeWinPath(unitPath) then
              unitPath :=  Path.GetFullPath(Path.Combine( filePath , unitPath));
            fUnitPaths.Add(unitName + '.pas', unitPath.ToLower);
          end
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
    fProjectPaths.Add(Path.GetWindowsFileName(fileName));
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
      fAborting := true;
  end;
end;

method TProjectIndexer.NotifyUnitParsed(const unitName, fileName: string; var syntaxTree: TSyntaxNode; syntaxTreeFromParser: boolean);
begin
  if assigned(OnUnitParsed) then
  begin
    var doAbort := false;
    OnUnitParsed(Self, unitName, fileName,  var syntaxTree, syntaxTreeFromParser,  var doAbort);
    if doAbort then
      fAborting := true;
  end;
end;


method TProjectIndexer.ParseUnit(const unitName: String; const fileName: String; isProject: Boolean);
var
doParseUnit: Boolean;
syntaxTree : TSyntaxNode;
begin
  if fAborting then  Exit;
  GetUnitSyntax(fileName, var syntaxTree, var doParseUnit);
  if fAborting then Exit;

  if doParseUnit then
    RunParserOnUnit(fileName, var  syntaxTree);

  fParsedUnits.Add(unitName.ToLower, syntaxTree);

  if (not fAborting) and assigned(syntaxTree) then
    ScanUsedUnits(unitName, fileName, isProject, syntaxTree, doParseUnit);
end;

method TProjectIndexer.PrepareSearchPath;
begin
  for iPath in fSearchPathRel do begin
    fSearchPaths.Add(iPath as not nullable);
  end;
end;



method TProjectIndexer.Parse(const fileName: string);
begin
  fAborting := false;
  fParsedUnits.RemoveAll;
  fProjectFolder :=   Path.GetParentDirectory(fileName);
  fIncludeCache := new TIncludeCache;
  fUnitPaths := new TUnitPathsCache();
  fSearchPaths.BasePath := fProjectFolder;

  fNotFoundUnits.RemoveAll;
  fProblems.RemoveAll;
  fProjectPaths.RemoveAll;
  var projectName := Path.GetFileName(fileName);
  fUnitPaths.Add(projectName, fileName);
  // Do the work
  ParseUnit(projectName, fileName, true);
  // Fill Results
  fParsedUnitsInfo.Initialize(fParsedUnits, fUnitPaths);
        //FIncludeFiles.Initialize(FIncludeCache);

end;


constructor TProjectIndexer(const aCompiler : DelphiCompiler);
begin
  inherited constructor;
  Compiler := aCompiler;
  fSearchPaths := new Searchpaths('');
  FDefinesList := new StringList;
  fParsedUnits :=  new TParsedUnitsCache;
  fParsedUnitsInfo := new TParsedUnits;
  fIncludeFiles :=new TIncludeFiles;
  fNotFoundUnits := new StringList;
  fProblems := new TParseProblems;
  fProjectPaths := new StringList;
end;



method TProjectIndexer.FindFile(const fileName: string; relativeToFolder: string; var filePath: string): boolean;

method FilePresent(const testFile: String; const name : String): Boolean;
begin
  Result := File.Exists(testFile);
  if Result then
  begin
    filePath := Path.GetFullPath(testFile);
    fUnitPaths.Add(name, filePath);
  end;
end;

begin
  Result := false;
  var fName :=   StrHelper.AnsiDequotedStr(fileName, Char("'")).ToLower;

  if fUnitPaths.ContainsKey(fName) then
  begin
    filePath := fUnitPaths[fName];
    Exit true;
  end;

  if fNotFoundUnits.Contains(fName) then
    exit false;

    if relativeToFolder <> '' then
      if FilePresent(Path.Combine(relativeToFolder , fName), fName) then
        Exit true;

    if FilePresent(Path.Combine(fProjectFolder ,fName), fName) then
      Exit true;

    for lsearch in fSearchPaths.getPaths do
      if FilePresent(Path.Combine( lsearch , fName), fName) then
        Exit true;

  //if SameText(ExtractFileExt(fileName), '.pas') then
    //Result := false
  //else
    //Result := FindFile(fileName + '.pas', relativeToFolder, var var filePath);

    if (not Result) and (relativeToFolder = '') {ignore include files} then
      if not fNotFoundUnits.Contains(fName) then
        fNotFoundUnits.Add(fName);
  end;


  class method TProjectIndexer.SafeOpenFileContext(const fileName: not nullable String; out fileContext: not nullable String; out errorMsg: string): boolean;
  begin
    try
      var data := File.ReadBytes(fileName);
      // If we have a Utf8-Bom use the dfeault encoding else the
      // windows Encoding.....
      if (data.Count > 3) and

         ((data[0] = $EF) and (data[1] = $BB) and (data[2] = $BF)) then
         fileContext := Encoding.UTF8.GetString(data) as not nullable
         else
          fileContext := Encoding.GetEncoding('windows-1252').GetString(data) as not nullable;

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
      fProblems.LogProblem(TParseProblemType.ptCantOpenFile, fileName, errorMsg)
    else begin
      builder := new TPasSyntaxTreeBuilder(Compiler);

      builder.IncludeHandler := new TProjectIncludeHandler(Self, fIncludeCache, fProblems, fileName);

      TmwSimplePasPar(builder).Lexer.OnParseCompilerDirectiveEvent := fonParseCompilerDirective;

      for define in FDefinesList do
        TmwSimplePasPar(builder).Lexer.AddDefine(define);
      try
        syntaxTree := builder.RunWithString(File.ReadText(fileName));
      except
        on E: ESyntaxTreeException do begin
          fProblems.LogProblem(TParseProblemType.ptCantParseFile, fileName,
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
      if fAborting then Exit;
      if not fParsedUnits.ContainsKey(usesName) then
      begin
        if FindFile(usesName + '.pas', '', var usesPath) then
          ParseUnit(usesName, usesPath, false)
        else
          fParsedUnits.Add(usesName, nil);
      end;
    end;

  end;


end.