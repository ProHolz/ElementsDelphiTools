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

      const actualCompiler =
      DelphiCompiler.dcXe7;
      //DelphiCompiler.dcRio;

      var projectname :=
    //  "D:\Komps_Xe7\dwscript\Packages\DXE7\dwsLibRuntime.dpk";

   //   "X:\Projekte\SynEdit\Packages\XE7\SynEdit_R.dpk";
     // "X:\Projekte\SynEdit\Source\SynEditMiscClasses.pas";
   //   "X:\Projekte\Rtl_Delphi_Elements\rtl\BuildWinRTL.dpk";
     // "C:\Program Files (x86)\Embarcadero\Studio\20.0\source\rtl\BuildWinRTL.dpk"; // Rio

      //"X:\Projekte\Rtl_Delphi_Elements\System.Classes.pas"; // Rio

     // "X:\Projekte\pascalscript\Source\PascalScript_Core_D21.dpk");
      "D:\sourceProHolz\Abbund170\ABBUNDXE7.dpr";
   //   "X:\Projekte\Rtl_Delphi_Elements\rtl\common\System.ObjAuto.pas";

      var projectProblems :=  Path.ChangeExtension(projectname, '.txt');
      var project := new ProjectRunner(actualCompiler, projectname);

      project.NotFoundDirectives := 'D:\Test\Defines.txt';
      project.FalseDefinesfile := 'D:\Test\falseDefines.txt';
      project.TrueDefinesfile := 'D:\Test\trueDefines.txt';


      project.Run;
      if project.Problems.Count > 0 then
      begin
        writeLn('Problems:');
        writeLn('===============');

        for problem : TParseProblemInfo in project.Problems
      //.Where((item)->(item.ProblemType <> TProblemType.ptCantFindFile))  do
        do
        begin
          writeLn(problem.FileName);

         writeLn(String.Format('{1} {0}', [problem.Description,  problem.ProblemType.ToString]));
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


      File.WriteText(projectProblems, project.GetAllProblemsText);

    end;

  end;

end.