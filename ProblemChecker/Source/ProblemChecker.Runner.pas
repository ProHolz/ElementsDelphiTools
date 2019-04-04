namespace ProHolz.SourceChecker;

interface
uses ProHolz.Ast;

type

 ProjectRunner = class(TProjectIndexer)
   private
     fProjectfile : String;
     fProblems : IProblemChecker;
     fDirectives : Dictionary<String,Boolean>;
    // fNotFoundDirectives : List<String>;

   protected
     method UnitSyntaxEvent(Sender: Object; const fileName: String;  var syntaxTree: TSyntaxNode; var doParseUnit : Boolean; Var doAbort: Boolean);
     method UnitParsedEvent(Sender: Object; const unitName: String; const fileName: String; var syntaxTree: TSyntaxNode; syntaxTreeFromParser: Boolean; var doAbort: Boolean);

     method ResolveCompilerDirective(Sender: Object; const directive: String; out res : Boolean) : Boolean;

     method InitDefines;
   public
   constructor (const aCompiler : DelphiCompiler; const projectfile : String);

    method Run;

    method GetAllProblemsText : String;

    property Definesfile : String;
    property SearchPathsFile : String;
    property FalseDefinesfile : String;
    property TrueDefinesfile : String;
    property NotFoundDirectives : String;


 end;

implementation

constructor ProjectRunner(const aCompiler : DelphiCompiler; const projectfile: String);
begin
  inherited constructor(aCompiler);
  fProblems := new TProblemChecker([
//  eEleCheck.eDfm, // There is a *.dfm
//  eEleCheck.eWith, // with clause in source
//  eEleCheck.eInitializations, // initialization found
//  eEleCheck.eFinalizations, // finalization found
//  eEleCheck.ePublicVars, // There are public Global Vars in initialization
//  eEleCheck.eGlobalMethods, // Global Methods
//  eEleCheck.eDestructors, // There is a Destructor in classes
//  eEleCheck.eMultiConstructors, // There is more then on public Constructor for a class
//  eEleCheck.eMoreThenOneClass, // There is more then on class in the file
//  eEleCheck.eInterfaceandImplement,   // declaration of a Interface and Implementatiion of a class that use it
  eEleCheck.eVariantRecord,       // Record with Variant parts
  eEleCheck.ePublicEnums,        // Enum Types shuld be check ScopedEnums, not done yet
//  eEleCheck.eClassDeclImpl,      // Class defined in implementation
  eEleCheck.eConstRecord     // Const Records with initialisation, Should be extend]);
//  ,eEleCheck.eHasResources     // *.Res in File
//  ,eEleCheck.eHasResourceStrings
 ,eEleCheck.eVarsWithTypes
  ]);
  fProjectfile := projectfile;
  OnGetUnitSyntax := @UnitSyntaxEvent;
  OnUnitParsed := @UnitParsedEvent;
  OnParseCompilerDirective := @ResolveCompilerDirective;
  InitDefines;
  fDirectives := new Dictionary<String, Boolean>;
 // NotFoundDirectives := new List<String>;
end;

method Projectrunner.initDefines;
begin
 // Setup Additional Defines here
 // Example
 //Defines.Add('TEST');
end;



method ProjectRunner.Run;
begin
  if not String.IsNullOrEmpty(FalseDefinesfile) then
    if File.Exists(FalseDefinesfile) then
    begin
      var lDefines := File.ReadLines(FalseDefinesfile);
      for each define in lDefines do
        if define <> nil then
          fDirectives.Add(define.trim.ToUpper, false);
    end;


  if not String.IsNullOrEmpty(TrueDefinesfile) then
    if File.Exists(TrueDefinesfile) then
    begin
      var lDefines := File.ReadLines(TrueDefinesfile);
      for each define in lDefines do
        if define <> nil then
          fDirectives.Add(define.Trim.ToUpper, true);
    end;



  if not String.IsNullOrEmpty(Definesfile) then
   if File.Exists(Definesfile) then
     begin
       var lDefines := File.ReadLines(Definesfile);
       for each define in lDefines do
         if define <> nil then
         Defines.Add(define);
     end;

  if not String.IsNullOrEmpty(SearchPathsFile) then
    if File.Exists(SearchPathsFile) then
    begin
      var lSearchPaths := File.ReadLines(SearchPathsFile);
    end;
  Parse(fProjectfile);

  if FDefinesList.Count > 0 then
  if not String.IsNullOrEmpty(NotFoundDirectives) then
    begin
     File.WriteLines(NotFoundDirectives, FDefinesList);
    end;


end;

method ProjectRunner.UnitSyntaxEvent(Sender: Object; const fileName: String; var syntaxTree: TSyntaxNode; var doParseUnit: Boolean; var doAbort: Boolean);
begin
  if  String.EqualsIgnoringCase( Path.GetExtension(fileName), '.dpk')
  or
  String.EqualsIgnoringCase( Path.GetExtension(fileName), '.dpr')

  then
    begin
      doParseUnit := false;
      var context := File.ReadText(fileName);
     syntaxTree := TPasSyntaxTreeBuilder.RunWithString(context, false, Compiler);
     doAbort := (syntaxTree = nil);
    end
   else
     begin
       doParseUnit := true;
     end;
end;

method ProjectRunner.UnitParsedEvent(Sender: Object; const unitName: String; const fileName: String; var syntaxTree: TSyntaxNode; syntaxTreeFromParser: Boolean; var doAbort: Boolean);
begin
 write(unitName+' ');
 fProblems.check(syntaxTree);
end;

method ProjectRunner.GetAllProblemsText: String;
begin
 result := fProblems.GetProblemsText;
end;

method ProjectRunner.ResolveCompilerDirective(Sender: Object; const directive: String; out res : boolean): Boolean;
begin
  var ldirective := directive.Trim.ToUpper;

  if fDirectives.ContainsKey(ldirective) then
   begin
    res := fDirectives[ldirective];
    exit true
   end
   else
    if not FDefinesList.Contains(ldirective) then
    begin
      FDefinesList.add(ldirective);
      writeLn(ldirective);
    end;
  res := true;
  exit true;
end;

end.