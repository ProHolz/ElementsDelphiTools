namespace ProHolz.SourceChecker;

interface
uses ProHolz.Ast;

type

 ProjectRunner = class(TProjectIndexer)
   private
     fProjectfile : String;
     fProblems : IProblemChecker;
     fDirectives : Dictionary<String,Boolean>;
     fNotFoundDirectives : StringList;

     fCheckProblems : List<eEleCheck>;

   protected
     method UnitSyntaxEvent(Sender: Object; const fileName: String;  var syntaxTree: TSyntaxNode; var doParseUnit : Boolean; Var doAbort: Boolean);
     method UnitParsedEvent(Sender: Object; const unitName: String; const fileName: String; var syntaxTree: TSyntaxNode; syntaxTreeFromParser: Boolean; var doAbort: Boolean);

     method ResolveCompilerDirective(Sender: Object; const directive: String; out res : Boolean) : Boolean;

   public
   constructor (const aCompiler : DelphiCompiler; const projectfile : String);
    method AddCheck(const value : eEleCheck);
    method Run;

    method GetAllProblemsText : String;

    property Definesfile : String;
    property SearchPathsFile : String;
    property FalseDefinesfile : String;
    property TrueDefinesfile : String;
    property NotFoundDirectivesFile : String;


 end;

implementation

constructor ProjectRunner(const aCompiler : DelphiCompiler; const projectfile: String);
begin
  inherited constructor(aCompiler);
  fCheckProblems := new List<eEleCheck>;

  fProjectfile := projectfile;
  fSearchPaths.BasePath := Path.GetParentDirectory(fProjectfile);
  OnGetUnitSyntax := @UnitSyntaxEvent;
  OnUnitParsed := @UnitParsedEvent;
  OnParseCompilerDirective := @ResolveCompilerDirective;
  fDirectives := new Dictionary<String, Boolean>;
  fNotFoundDirectives := new StringList;

end;

method ProjectRunner.Run;
begin

  fProblems := new TProblemChecker(fCheckProblems);

 // Load the Defines with false result
  if not String.IsNullOrEmpty(FalseDefinesfile) then
    if File.Exists(FalseDefinesfile) then
    begin
      var lDefines := File.ReadLines(FalseDefinesfile);
      for each define in lDefines do

          if not String.IsNullOrWhiteSpace(define) then
          fDirectives.Add(define.trim.ToUpper, false);
    end;

 // Load the Defines with true result
  if not String.IsNullOrEmpty(TrueDefinesfile) then
    if File.Exists(TrueDefinesfile) then
    begin
      var lDefines := File.ReadLines(TrueDefinesfile);
      for each define in lDefines do

          if not String.IsNullOrWhiteSpace(define) then
          fDirectives.Add(define.Trim.ToUpper, true);
    end;


 // Load the Defines for Project
  if not String.IsNullOrEmpty(Definesfile) then
   if File.Exists(Definesfile) then
     begin
       var lDefines := File.ReadLines(Definesfile);
       for each define in lDefines do

         if not String.IsNullOrWhiteSpace(define) then
         Defines.Add(define);
     end;

  if not String.IsNullOrEmpty(SearchPathsFile) then
    if File.Exists(SearchPathsFile) then
    begin
      var lSearchPaths := File.ReadLines(SearchPathsFile);
      for each path in lSearchPaths do
        if not String.IsNullOrWhiteSpace(path) then
       SearchPaths.Add(path);
    end;

  Parse(fProjectfile);

  if fNotFoundDirectives.Count > 0 then
  if not String.IsNullOrEmpty(NotFoundDirectivesFile) then
    begin
     File.WriteLines(NotFoundDirectivesFile, fNotFoundDirectives);
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
  if fNotFoundDirectives.Count > 0 then
   begin
     var sl := new StringBuilder();
     sl.AppendLine("Defines not resolved:");
    for each s in fNotFoundDirectives do
      sl.AppendLine(s);
     sl.AppendLine("========");
     sl.Append(Result);

     result := sl.ToString;
   end;
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
    if not fNotFoundDirectives.Contains(ldirective) then
    begin
      fNotFoundDirectives.add(ldirective);
     {$IF LOG}
      writeLn(ldirective);
     {$ENDIF}
    end;
  res := true;
  exit true;
end;

method ProjectRunner.AddCheck(const value: eEleCheck);
begin
 if not fCheckProblems.Contains(value) then
 fCheckProblems.Add(value);
end;

end.