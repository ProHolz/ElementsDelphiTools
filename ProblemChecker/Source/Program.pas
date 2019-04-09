namespace ProHolz.SourceChecker;
uses ProHolz.Ast;

type
  Program = class
  public

    class method Main(args: array of String): Int32;
    begin
      var showNotfound : Boolean := false;
      // add your own code here
      writeLn('The magic happens here.');

      const actualCompiler =  DelphiCompiler.dcXe7;


      var projectname :=
      "X:\Projekte\pascalscript\Source\PascalScript_Core_D21.dpk";

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
      Var Level := 1;

      // First the critical ones we should solve before move to Elements
      // These should always run
        project.AddCheck(eEleCheck.eVariantRecord);       // Record with Variant parts
        project.AddCheck(eEleCheck.eVarsWithTypes);  // Var declaration with new type
        project.AddCheck(eEleCheck.eTypesInMethods);  // Type declaration in Methods
        project.AddCheck(eEleCheck.eAsm);  // Asm Statements in Methods
        project.AddCheck(eEleCheck.eTypeinType);  // nested Type declaration
         project.AddCheck(eEleCheck.eWith); // with clause in source

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

  end;

end.