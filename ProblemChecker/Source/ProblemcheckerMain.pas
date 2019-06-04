namespace ProHolz.SourceChecker;
interface

uses ProHolz.Ast;

type
  SourceChecker = class
  private
    projectname : String;
    actualCompiler := DelphiCompiler.dcDefault;
    showNotfound : Boolean := false;
    Level := 1000;

   method showintro;
   method getProjectName(args: array of String) : String;

public
    method RunMain(args: array of String): Int32;
 end;

implementation

method SourceChecker.showintro;
begin
 writeLn(
 "call ProblemChecker [project] [/Compiler:xx] [/ShowNotFound:[true, false]] [/Level:[level]]
  Project :  Full Path to a Delphi Project, this should be a *.dpr or *.dpk
  Compiler : one of the following:
             xe7, xe8, seatle, berlin, tokyo, rio
             default is xe7
 ShowNotFound : true or false, default false

 Level:  specify which Test to run
         1 : Only Critical Tests like types in methods, types in var declarations and Constants
             Variant Records, With Statements, Assembler parts

         2 : Level 1 plus Enums without scope and constant records

         3 : Level 2 plus Checks for Global members and Finalizations, Initializations
                     multible Constructors etc..

         4 : Level 3 plus resourechecks, like *dfm, *.res and Resourcestrings

         default all Tests

 ");


end;

method SourceChecker.getProjectName(args: array of String): String;
begin
 var cl := new SimpleCommandLineParser(args);
 for each s  in cl.OtherParameters do
  writeLn(s);

  for each switch  in cl.Switches do
   begin
  //  writeLn($"{switch.Key} {switch.Value}");
    case  switch.Key.ToLower of
      'compiler' : case switch.Value.ToLower of
                    'xe7' : actualCompiler := DelphiCompiler.dcXe7;
                     'xe8' : actualCompiler := DelphiCompiler.dcXe8;
                     'seatle' : actualCompiler := DelphiCompiler.dcSeatle;
                     'berlin' : actualCompiler := DelphiCompiler.dcBerlin;
                     'tokyo' : actualCompiler := DelphiCompiler.dcTokyo;
                     'rio' : actualCompiler := DelphiCompiler.dcRio;
                   end;

      'level' : case switch.Value.ToLower of
        '0' : Level := 0;
        '1' : Level := 1;
        '2' : Level := 2;
        '3' : Level := 3;
        '4' : Level := 4;

      end;


      'shownotfound': case switch.Value.ToLower of
        'false' : showNotfound := false;
      'true' : showNotfound := true;
      else begin
        writeLn($"Unknown Switch {switch.Key} {switch.Value}");
       end;
      end;
    end;
   end;



 if cl.OtherParameters.Count > 0 then
   exit cl.OtherParameters[0];

 result := '<noFile>';
end;

method SourceChecker.RunMain(args: array of String): Int32;
begin
  writeLn('======================');
  writeLn('Proholz ProblemChecker');
  writeLn('======================');


  if length(args) = 0 then
   begin
     showintro;
     exit;
   end;


  projectname := getProjectName(args);
  if not assigned(projectname) or
   (not File.Exists(projectname)) then
  begin
    showintro;
    writeLn($"Could not find {projectname}!!");
    exit;
  end;


  var projectProblems :=  Path.ChangeExtension(projectname, '.Problems.txt');
  var projectPath := Path.GetWindowsParentDirectory(projectname);
  var projectShortName := Path.GetFileNameWithoutExtension(projectname);
  var project := new ProjectRunner(actualCompiler, projectname);


  project.SearchPathsFile := Path.Combine(projectPath, projectShortName+'.SearchPath.txt');
  project.Definesfile := Path.Combine(projectPath, projectShortName+'.Defines.txt');

  project.NotFoundDirectivesFile := Path.Combine(projectPath, projectShortName+'.notFoundDefines.txt');  // Here the directives not solved are wriiten
  project.FalseDefinesfile := Path.Combine(projectPath, projectShortName+'.falseDefines.txt'); // Directives where the result is false
  project.TrueDefinesfile := Path.Combine(projectPath, projectShortName+'.trueDefines.txt'); // Directives where the result is true

  // Add now the wanted checks

  // I use here a Level Var


  // First the critical ones we should solve before move to Elements
  // These should always run
  if Level > 0 then
   begin
    project.AddCheck(eEleCheck.eVariantRecord);       // Record with Variant parts
    project.AddCheck(eEleCheck.eVarsWithTypes);  // Var declaration with new type
    project.AddCheck(eEleCheck.eTypesInMethods);  // Type declaration in Methods
    project.AddCheck(eEleCheck.eAsm);  // Asm Statements in Methods
    project.AddCheck(eEleCheck.eTypeinType);  // nested Type declaration
    project.AddCheck(eEleCheck.eWith); // with clause in source
   end;

  // now  the critical ones we can  solve after move to Elements

  if Level > 1 then
  begin
    project.AddCheck(eEleCheck.ePublicEnums);        // Enum Types without ScopedEnums
    project.AddCheck(eEleCheck.eConstRecord);     // Const Records with initialisation;
  end;

  // now  the checks for problems the CodeGenerator can solve (I Hope :-)
  if Level > 2 then
  begin
    project.AddCheck(eEleCheck.eInitializations); // initialization found
    project.AddCheck(eEleCheck.eFinalizations); // finalization found
    project.AddCheck(eEleCheck.eDestructors); // There is a Destructor in classes
    project.AddCheck(eEleCheck.eMultiConstructors); // There is more then on public Constructor for a class
  end;
  // Now the Information ones

  if Level > 3 then
  begin
    project.AddCheck(eEleCheck.ePublicVars); // There are public Global Vars in initialization
    project.AddCheck(eEleCheck.eGlobalMethods); // Global Methods

    project.AddCheck(eEleCheck.eMoreThenOneClass); // There is more then on class in the file
    project.AddCheck(eEleCheck.eInterfaceandImplement);   // declaration of a Interface and Implementatiion of a class that use it

    project.AddCheck(eEleCheck.eClassDeclImpl);      // Class defined in implementation
  end;

  // Now about Resources
  if Level > 4 then
  begin
    project.AddCheck(eEleCheck.eDfm); // There is a *.dfm
    project.AddCheck(eEleCheck.eHasResources);     // *.Res in File
    project.AddCheck(eEleCheck.eHasResourceStrings);  // Resourcestrings in File
  end;

  project.Run;
  writeLn();
  writeLn();
  if project.Problems.Count > 0 then
  begin
    writeLn('Problems:');
    writeLn('===============');

    for problem : TParseProblemInfo in project.Problems do
    begin
      writeLn(problem.FileName);
      writeLn($"{problem.Description} {problem.ProblemType.ToString}");
    end;
    writeLn;
    if System.Diagnostics.Debugger.IsAttached then
    begin
      writeLn('Debugger is running');
    end
    else
    begin
      writeLn('Press Enter to continue');
      readLn;
    end;

  end;


  if  showNotfound and ( project.NotFoundUnits.Count > 0 ) then
  begin
    writeLn('Not Found: '+project.NotFoundUnits.Count.ToString);
    writeLn('===============');
    for notfound in project.NotFoundUnits do
      writeLn(notfound);

    writeLn;
    if System.Diagnostics.Debugger.IsAttached then
    begin
      writeLn('Debugger is running');
    end
    else
    begin
      writeLn('Press Enter to continue');
      readLn;
    end;
  end;

  if project.ParsedUnits.Count > 0 then
  begin
    writeLn('Found and parsed:');
    writeLn('===============');
    writeLn(String.Format('Parsed Units {0}',[project.ParsedUnits.Count]));
    for found in project.ParsedUnits do
      writeLn($"{found.Name} : {found.Path}");

  end;
  File.WriteText(projectProblems, project.GetAllProblemsText);

end;

end.