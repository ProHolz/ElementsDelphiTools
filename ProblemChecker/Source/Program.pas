namespace Problemchecker;
uses PascalParser;

type
  Program = class
  public

    class method Main(args: array of String): Int32;
    begin
      var showNotfound : Boolean := true;
      // add your own code here
      writeLn('The magic happens here.');
      var project := new ProjectRunner("X:\Projekte\SynEdit\Packages\XE7\SynEdit_R.dpk");
     // var project := new ProjectRunner("X:\Projekte\SynEdit\Source\SynEditMiscClasses.pas");

      project.Run;
      if project.Problems.Count > 0 then
      begin
        writeLn('Problems:');
        writeLn('===============');

        for problem : TParseProblemInfo in project.Problems
      //.Where((item)->(item.ProblemType <> TProblemType.ptCantFindFile))  do
        do
        begin
         writeLn(String.Format('{2} {1} {0}', [problem.Description, problem.FileName, problem.ProblemType.ToString]));
        //writeLn(String.Format('{0}', [problem.Description]));
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

      File.WriteText("X:\Projekte\SynEdit\Packages\XE7\SynEdit_R.txt", project.GetAllProblemsText);


    end;

  end;

end.