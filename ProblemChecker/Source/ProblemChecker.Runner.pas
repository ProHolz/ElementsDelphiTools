namespace Problemchecker;

interface
uses PascalParser;

type

 ProjectRunner = class(TProjectIndexer)
   private
     fProjectfile : String;
     fProblems : IProblemChecker;

   protected
     method UnitSyntaxEvent(Sender: Object; const fileName: String;  var syntaxTree: TSyntaxNode; var doParseUnit : Boolean; Var doAbort: Boolean);
     method UnitParsedEvent(Sender: Object; const unitName: String; const fileName: String; var syntaxTree: TSyntaxNode; syntaxTreeFromParser: Boolean; var doAbort: Boolean);

     method InitDefines;
   public
    constructor (const projectfile : String);

    method Run;

    method GetAllProblemsText : String;

    property Definesfile : String;
    property SearchPathsFile : String;

 end;

implementation

constructor ProjectRunner(const projectfile: String);
begin
  inherited constructor(DelphiCompiler.dcXe7);
  fProblems := new TProblemChecker([
 // eEleCheck.eDfm, // There is a *.dfm
  eEleCheck.eWith, // with clause in source
  eEleCheck.eInitializations, // initialization found
  eEleCheck.eFinalizations, // finalization found
//  eEleCheck.ePublicVars, // There are public Global Vars in initialization
//  eEleCheck.eGlobalMethods, // Global Methods
//  eEleCheck.eDestructors, // There is a Destructor in classes
//  eEleCheck.eMultiConstructors, // There is more then on public Constructor for a class
//  eEleCheck.eMoreThenOneClass, // There is more then on class in the file
//  eEleCheck.eInterfaceandImplement,   // declaration of a Interface and Implementatiion of a class that use it
  eEleCheck.eVariantRecord,       // Record with Variant parts
//  eEleCheck.ePublicEnums,        // Enum Types shuld be check ScopedEnums, not done yet
//  eEleCheck.eClassDeclImpl,      // Class defined in implementation
  eEleCheck.eConstRecord     // Const Records with initialisation, Should be extend]);
  ]);
  fProjectfile := projectfile;
  OnGetUnitSyntax := @UnitSyntaxEvent;
  OnUnitParsed := @UnitParsedEvent;
  InitDefines;
end;

method Projectrunner.initDefines;
begin
 // Setup Additional Defines here
 // Example
 //Defines.Add('TEST');
end;



method ProjectRunner.Run;
begin
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

end.