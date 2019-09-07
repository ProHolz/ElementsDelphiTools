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
   method AppendUnits(UsesNode: TSyntaxNode; const FilePath: String; UnitList: StringList);
   method BuildUsesList(UnitNode: TSyntaxNode; const FileName: String; IsProject: Boolean; UnitList: StringList);
   method FindType(Node: TSyntaxNode; NodeType: TSyntaxNodeType): TSyntaxNode;
   method GetUnitSyntax(const FileName: String; var SyntaxTree: TSyntaxNode; var DoParseUnit: Boolean);
   method NotifyUnitParsed(const UnitName, FileName: String; var SyntaxTree: TSyntaxNode; SyntaxTreeFromParser: Boolean);
   method ParseUnit(const UnitName: String; const FileName: String; IsProject: Boolean);
   method PrepareSearchPath;

   method RunParserOnUnit(const FileName: String; var SyntaxTree: TSyntaxNode);
   method ScanUsedUnits(const UnitName, FileName: String; IsProject: Boolean; SyntaxTree: TSyntaxNode; SyntaxTreeFromParser: Boolean);

 public // Class
   class method SafeOpenFileContext(const FileName: not nullable String; out FileContext: not nullable String; out ErrorMsg: String): Boolean;

 public
   constructor (const aCompiler : DelphiCompiler);
   method  FindFile(const FileName: String; RelativeToFolder: String; out FilePath: String): Boolean;

   method Parse(const FileName: String);

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


method TProjectIndexer.AppendUnits(UsesNode: TSyntaxNode; const FilePath: String; UnitList: StringList);
begin
  for childNode in UsesNode.ChildNodes do
    if childNode.Typ = TSyntaxNodeType.ntUnit then
    begin
      var unitName := childNode.AttribName.ToLower;
      UnitList.Add(unitName);
      if not fUnitPaths.ContainsKey(unitName) then
      begin
        var unitPath := childNode.GetAttribute(TAttributeName.anPath);
        if unitPath <> '' then begin
          fProjectPaths.Add(unitPath);
          if SearchPaths.IsRelativeWinPath(unitPath) then
            unitPath :=  Path.GetFullPath(Path.Combine( FilePath , unitPath));
          fUnitPaths.Add(unitName + '.pas', unitPath.ToLower);
        end
        else
        begin

          FindFile(unitName+ '.pas', '', out  unitPath);

          if unitPath <> '' then begin
            fProjectPaths.Add(unitPath);
            // How to Handle on MAC?
            if Environment.OS =   OperatingSystem.Windows then begin
            if SearchPaths.IsRelativeWinPath(unitPath) then
              unitPath :=  Path.GetFullPath(Path.Combine( FilePath , unitPath));
            end;
            fUnitPaths.Add(unitName + '.pas', unitPath.ToLower);
          end
      end;
      end;
    end;
end;


method TProjectIndexer.BuildUsesList(UnitNode: TSyntaxNode; const FileName: String; IsProject: Boolean; UnitList: StringList);
var
usesNode  : TSyntaxNode;
begin
var fileFolder := Path.GetParentDirectory(FileName);
if IsProject then
begin
  fProjectPaths.Add(Path.GetFileName(FileName));
  usesNode := FindType(UnitNode, TSyntaxNodeType.ntUses);
  if assigned(usesNode) then
    AppendUnits(usesNode, fileFolder, UnitList);
  usesNode := FindType(UnitNode, TSyntaxNodeType.ntContains);
  if assigned(usesNode) then
    AppendUnits(usesNode, fileFolder, UnitList);
end
else
begin
  var intfNode := FindType(UnitNode, TSyntaxNodeType.ntInterface);
  if assigned(intfNode) then
  begin
    usesNode := FindType(intfNode, TSyntaxNodeType.ntUses);
    if assigned(usesNode) then
      AppendUnits(usesNode, fileFolder, UnitList);
  end;
  var implNode := FindType(UnitNode, TSyntaxNodeType.ntImplementation);
  if assigned(implNode) then
  begin
    usesNode := FindType(implNode, TSyntaxNodeType.ntUses);
    if assigned(usesNode) then
      AppendUnits(usesNode, fileFolder, UnitList);
  end;
end;
end;


method TProjectIndexer.FindType(Node: TSyntaxNode; NodeType: TSyntaxNodeType):
TSyntaxNode;
begin
  if Node.Typ = NodeType then
    Exit Node
  else
    Result := Node.FindNode(NodeType);
end;

method TProjectIndexer.GetUnitSyntax(const FileName: string; var SyntaxTree: TSyntaxNode; var DoParseUnit: boolean);
begin
  var doAbort := false;
  DoParseUnit := true;
   SyntaxTree := nil;
   if assigned(OnGetUnitSyntax) then
   begin
     OnGetUnitSyntax(Self, FileName, var SyntaxTree, var DoParseUnit, var doAbort);
     if doAbort then
       fAborting := true;
   end;
 end;

 method TProjectIndexer.NotifyUnitParsed(const UnitName, FileName: string; var SyntaxTree: TSyntaxNode; SyntaxTreeFromParser: boolean);
 begin
   if assigned(OnUnitParsed) then
   begin
     var doAbort := false;
     OnUnitParsed(Self, UnitName, FileName,  var SyntaxTree, SyntaxTreeFromParser,  var doAbort);
     if doAbort then
       fAborting := true;
   end;
 end;


 method TProjectIndexer.ParseUnit(const UnitName: String; const FileName: String; IsProject: Boolean);
 var
 doParseUnit: Boolean;
 syntaxTree : TSyntaxNode;
 begin
   if fAborting then  Exit;
   GetUnitSyntax(FileName, var syntaxTree, var doParseUnit);
   if fAborting then Exit;

   if doParseUnit then
     RunParserOnUnit(FileName, var  syntaxTree);

   fParsedUnits.Add(UnitName.ToLower, syntaxTree);

   if (not fAborting) and assigned(syntaxTree) then
     ScanUsedUnits(UnitName, FileName, IsProject, syntaxTree, doParseUnit);
 end;

 method TProjectIndexer.PrepareSearchPath;
 begin
   for iPath in fSearchPathRel do begin
     fSearchPaths.Add(iPath as not nullable);
   end;
 end;



 method TProjectIndexer.Parse(const FileName: string);
 begin
   fAborting := false;
   fParsedUnits.RemoveAll;
   fProjectFolder :=   Path.GetParentDirectory(FileName);
   fIncludeCache := new TIncludeCache;
   fUnitPaths := new TUnitPathsCache();
   fSearchPaths.BasePath := fProjectFolder;

   fNotFoundUnits.RemoveAll;
   fProblems.RemoveAll;
   fProjectPaths.RemoveAll;
   var projectName := Path.GetFileName(FileName);
   fUnitPaths.Add(projectName, FileName);
   // Do the work
   ParseUnit(projectName, FileName, true);
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



 method TProjectIndexer.FindFile(const FileName: string; RelativeToFolder: string; out FilePath: string): boolean;

 method FilePresent(const testFile: String; const name : String; out newFolder : String): Boolean;
 begin
   Result := File.Exists(testFile);
   if Result then
   begin
      newFolder := Path.GetFullPath(testFile);
     fUnitPaths.Add(name, newFolder);
   end;
 end;

 begin
   Result := false;
   var fName :=   StrHelper.AnsiDequotedStr(FileName, Char("'")).ToLower;

   if fUnitPaths.ContainsKey(fName) then
   begin
     FilePath := fUnitPaths[fName];
     Exit true;
   end;

   if fNotFoundUnits.Contains(fName) then
     exit false;

   if RelativeToFolder <> '' then
     if FilePresent(Path.Combine(RelativeToFolder , fName), fName, out  FilePath) then
       Exit true;

   if FilePresent(Path.Combine(fProjectFolder ,fName), fName, out  FilePath) then
     Exit true;

   for lsearch in fSearchPaths.GetPaths do
     if FilePresent(Path.Combine( lsearch , fName), fName, out FilePath) then
       Exit true;

 //if SameText(ExtractFileExt(fileName), '.pas') then
   //Result := false
 //else
   //Result := FindFile(fileName + '.pas', relativeToFolder, var var filePath);

   if (not Result) and (RelativeToFolder = '') {ignore include files} then
     if not fNotFoundUnits.Contains(fName) then
       fNotFoundUnits.Add(fName);
 end;


 class method TProjectIndexer.SafeOpenFileContext(const FileName: not nullable String; out FileContext: not nullable String; out ErrorMsg: string): boolean;
 begin
   try
     var data := File.ReadBytes(FileName);
     // If we have a Utf8-Bom use the dfeault encoding else the
     // windows Encoding.....
     if (data.Count > 3) and

        ((data[0] = $EF) and (data[1] = $BB) and (data[2] = $BF)) then
       FileContext := Encoding.UTF8.GetString(data) as not nullable
       else
       FileContext := Encoding.GetEncoding('windows-1252').GetString(data) as not nullable;

     Result := true;
   except
     on E: Exception do
     begin
       result := false;
       ErrorMsg := E.Message;
       FileContext := '';
     end;
   end;
 end;


 method TProjectIndexer.RunParserOnUnit(const FileName: string; var SyntaxTree: TSyntaxNode);
 var
 errorMsg  : String;
 fileContext : String;
 begin
   if not SafeOpenFileContext(FileName, out fileContext, out errorMsg) then
     fProblems.LogProblem(TParseProblemType.ptCantOpenFile, FileName, errorMsg)
   else begin
     var builder := new TPasSyntaxTreeBuilder(Compiler);

     builder.IncludeHandler := new TProjectIncludeHandler(Self, fIncludeCache, fProblems, FileName);

     TmwSimplePasPar(builder).Lexer.OnParseCompilerDirectiveEvent := fonParseCompilerDirective;

     for define in FDefinesList do
       TmwSimplePasPar(builder).Lexer.AddDefine(define);
     try
       SyntaxTree := builder.RunWithString(File.ReadText(FileName));
     except
       on E: ESyntaxTreeException do begin
         fProblems.LogProblem(TParseProblemType.ptCantParseFile, FileName,
         String.Format('Line {0}, Column: {1} {2}', [E.Line, E.Col, E.Message]));
       end;
     end;
   end;

 end; { TProjectIndexer.RunParserOnUnit }

 method TProjectIndexer.ScanUsedUnits(const UnitName, FileName: string; IsProject: boolean; SyntaxTree: TSyntaxNode; SyntaxTreeFromParser: boolean);
 begin
   var unitNode := SyntaxTree;

   var unitList := new List<String>;
   BuildUsesList(unitNode, FileName, IsProject, unitList);
   NotifyUnitParsed(UnitName, FileName, var SyntaxTree, SyntaxTreeFromParser);

   for usesName in unitList do
     begin
     if fAborting then Exit;
     if not fParsedUnits.ContainsKey(usesName) then
     begin
       var  usesPath: String;
       if FindFile(usesName + '.pas', '', out  usesPath) then
         ParseUnit(usesName, usesPath, false)
       else
         fParsedUnits.Add(usesName, nil);
     end;
   end;

 end;


end.