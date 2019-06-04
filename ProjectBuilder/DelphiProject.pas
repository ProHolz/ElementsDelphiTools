namespace ProjectBuilder;

interface
 uses
   ProHolz.Ast;

  type
    DelphiProject = class
    private
      fProjectFileName : String;
      Compiler : DelphiCompiler := DelphiCompiler.dcDefault;
      method UnitSyntaxEvent(Sender: Object; const fileName: String; var syntaxTree: TSyntaxNode; var doParseUnit: Boolean; var doAbort: Boolean);
      method GetContainingFiles : Array of String;
    public
     constructor (const value : String);
     method createElementsProject : Boolean;
    end;


implementation

constructor DelphiProject(const value: String);
begin
  inherited constructor();
  fProjectFileName := value;
end;

method DelphiProject.GetContainingFiles: array of String;
begin
 result := [];
 if File.Exists(fProjectFileName) then
  begin
   var Parser := new TProjectIndexer(Compiler);
 //  Parser.SearchPaths.Add('..\Sources');
   Parser.OnGetUnitSyntax := @UnitSyntaxEvent;
   Parser.Parse(fProjectFileName);
   exit Parser.ProjectPaths.ToArray;
  end;
end;


method DelphiProject.UnitSyntaxEvent(Sender: Object; const fileName: String; var syntaxTree: TSyntaxNode; var doParseUnit: Boolean; var doAbort: Boolean);
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
    doParseUnit := false;
    doAbort := true;
  end;
end;

method DelphiProject.createElementsProject: Boolean;
begin
  var units := GetContainingFiles;
  if units.Count > 0 then
  begin
    var lElements := new PBuilder(fProjectFileName);
    lElements.AddShared(units);
    lElements.Save;
    exit true;
  end;
  exit false;
 end;

end.