namespace ProHolz.SourceChecker;
uses ProHolz.Ast;

type
  Program = class
  public

    class method Main(args: array of String): Int32;
    begin
      var showNotfound : Boolean := true;
      // add your own code here
      writeLn('The magic happens here.');

      const actualCompiler =
      DelphiCompiler.dcXe7;
      //DelphiCompiler.dcRio;

      var projectname :=
      "X:\Projekte\Rtl_Delphi_Elements\rtl\BuildWinRTL.dpk";

      var projectProblems :=  Path.ChangeExtension(projectname, '.txt');
      var project := new ProjectRunner(actualCompiler, projectname);

      project.NotFoundDirectives := 'D:\Test\Defines.txt';  // Here the directives not solved are wriiten
      project.FalseDefinesfile := 'D:\Test\falseDefines.txt'; // Directives where the result is false
      project.TrueDefinesfile := 'D:\Test\trueDefines.txt'; // Directives where the result is true


      project.AddCheck(eEleCheck.eDfm); // There is a *.dfm
      project.AddCheck(eEleCheck.eWith); // with clause in source
      project.AddCheck(eEleCheck.eInitializations); // initialization found
      project.AddCheck(eEleCheck.eFinalizations); // finalization found
      project.AddCheck(eEleCheck.ePublicVars); // There are public Global Vars in initialization
      project.AddCheck(eEleCheck.eGlobalMethods); // Global Methods
      project.AddCheck(eEleCheck.eDestructors); // There is a Destructor in classes
      project.AddCheck(eEleCheck.eMultiConstructors); // There is more then on public Constructor for a class
      project.AddCheck(eEleCheck.eMoreThenOneClass); // There is more then on class in the file
      project.AddCheck(eEleCheck.eInterfaceandImplement);   // declaration of a Interface and Implementatiion of a class that use it
      project.AddCheck(eEleCheck.eVariantRecord);       // Record with Variant parts
      project.AddCheck(eEleCheck.ePublicEnums);        // Enum Types without ScopedEnums
      project.AddCheck(eEleCheck.eClassDeclImpl);      // Class defined in implementation
      project.AddCheck(eEleCheck.eConstRecord);     // Const Records with initialisation);
      project.AddCheck(eEleCheck.eHasResources);     // *.Res in File
      project.AddCheck(eEleCheck.eHasResourceStrings);  // Resourcestrings in File
      project.AddCheck(eEleCheck.eVarsWithTypes);  // Var declaration with new type


      project.Run;
      if project.Problems.Count > 0 then
      begin
        writeLn('Problems:');
        writeLn('===============');

        for problem : TParseProblemInfo in project.Problems do
        begin
          writeLn(problem.FileName);
          writeLn(String.Format('{1} {0}', [problem.Description,  problem.ProblemType.ToString]));
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
        begin
          write(found.Name);
          &write(' : ');
          writeLn(found.Path);
        end;
      end;
      File.WriteText(projectProblems, project.GetAllProblemsText);

    end;

  end;

end.