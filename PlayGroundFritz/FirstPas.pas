namespace ProHolz.CodeGen;
{$GLOBALS ON}
uses
  ProHolz.Ast;

  method BuildInterfaceTest(const Source : String; const TestName : String; const hd : Boolean = false) : String;
  begin

    var  Root := TPasSyntaxTreeBuilder.RunWithString(Source, false);
    if Environment.OS = OperatingSystem.Windows then
      File.WriteText(String.Format('d:\Test\{0}.xml', TestName),   TSyntaxTreeWriter.ToXML(Root, true));
    //  CodeBuilderMethods.FileData := Source.Split(Environment.LineBreak);
    var lUnit := new CodeBuilder().BuildCGCodeUnitFomSyntaxNode(Root);
  //  CodeBuilderMethods.FileData := nil;
   // var cg2 := new CGDelphiCodeGenerator();
    var cg := new CGOxygeneCodeGenerator();
  // var cg3 := new CGCSharpCodeGenerator();
   //var cg := new CGCPlusPlusCPPCodeGenerator();
  // var cg := new CGSwiftCodeGenerator();
   //var cg := new CGGoCodeGenerator();

    result := cg.GenerateUnit(lUnit);
    if Environment.OS = OperatingSystem.Windows then
    begin
      var a := Encoding.UTF8.GetBytes(result) includeBOM(true);
      if not hd then
        File.WriteBytes($"d:\Test\{TestName}.pas" , a)
      else
        File.WriteBytes($"X:\Elements\Cairo\Classes\{TestName}.pas" , a);

    end;

  end;


  method BuildPasfromNode(full : Boolean) : String;
  begin
    Var sb := new StringBuilder();
    if full then
    begin
      Var s :=
   // Var s := "D:\sourceProHolz\Abbund170\Synopse\SynCommons.pas";
    //  Var s :=  "D:\sourceProHolz\Abbund170\DachHolz\TypConst.pas";
    //  Var s := "D:\sourceProHolz\Abbund170\Synopse\SynLz.pas";
    // "D:\sourceProHolz\Abbund170\Cairo\Cairo.Dll.pas";
    //  "D:\sourceProHolz\Abbund170\Cairo\Cairo.Types.pas";
   //   Var s := "X:\Projekte\Neslib\Neslib.Clang\Neslib.Clang.pas";
   //   "D:\sourceProHolz\Abbund170\Cairo\Cairo.Freetype.pas";


   //   "X:\Elements\ElementsDelphiTools\CtoElements\Chet\Classes\Chet.SourceWriter.pas";
   //   "X:\Elements\ElementsDelphiTools\CtoElements\Chet\Classes\Chet.Project.pas";
    //  "X:\Elements\ElementsDelphiTools\CtoElements\Chet\Classes\Chet.HeaderTranslator.pas";
    //  "X:\Elements\ElementsDelphiTools\CtoElements\Chet\Classes\Chet.CommentWriter.pas";
    //  "D:\sourceProHolz\Abbund170\bool\OCCTypes.pas";
     // "D:\sourceProHolz\Abbund170\bool\cppWrapperTypes.pas";
    //  "X:\Opencascade\OCC-Island\srcDelphi\OCCTypes.pas";

    // Cairo

    //  "X:\Elements\Cairo\Cairoimpl\Cairo.Base.pas";
     // "X:\Elements\Cairo\Cairoimpl\Cairo.Interfaces.pas";
     // "X:\Elements\Cairo\Cairoimpl\Cairo.Stream.pas";
     // "X:\Elements\Cairo\Cairoimpl\Cairo.Surface.pas";
      "X:\Elements\Cairo\Cairoimpl\Cairo.Context.pas";

      var Source : not nullable String;
      var Error : not nullable String;
      if TProjectIndexer.SafeOpenFileContext(s, out Source, out Error) then
      begin
        var fname := Path.GetFileNameWithoutExtension(s);
        sb.Append(BuildInterfaceTest(Source, fname, true));
        sb.AppendLine.Append('{Next File}').AppendLine;
      end
      else
        sb.Appendline(Error);
    end;
(*
    sb.Append(BuildInterfaceTest(TestRecordHelper, 'TestRecordHelper'));
    sb.AppendLine.Append('{Next File}').AppendLine;



    sb.Append(BuildInterfaceTest(TestMethodimplementation, 'TestMethodimplementation'));
    sb.AppendLine.Append('{Next File}').AppendLine;
    sb.Append(BuildInterfaceTest(TestDll, 'TestDll'));
    sb.AppendLine.Append('{Next File}').AppendLine;



    sb.Append(BuildInterfaceTest(TestTypes, 'TestTypes'));
    sb.AppendLine.Append('{Next File}').AppendLine;


    sb.Append(BuildInterfaceTest(TestIndentifier, 'TestIndentifier'));
    sb.AppendLine.Append('{Next File}').AppendLine;


    sb.Append(BuildInterfaceTest(TestAnonymous, 'TestAnonymous'));
    sb.AppendLine.Append('{Next File}').AppendLine;


    sb.Append(BuildInterfaceTest(TestSetAndEnums, 'TestSetAndEnums'));
    sb.AppendLine.Append('{Next File}').AppendLine;


    sb.Append(BuildInterfaceTest(TestLoops, 'TestLoops'));
    sb.AppendLine.Append('{Next File}').AppendLine;


    sb.Append(BuildInterfaceTest(TestExceptions, 'TestExceptions'));
    sb.AppendLine.Append('{Next File}').AppendLine;

    sb.Append(BuildInterfaceTest(TestConstArray, 'TestConstArray'));
    sb.AppendLine.Append('{Next File}').AppendLine;





    sb.Append(BuildInterfaceTest(TestAll, 'TestAll'));
    sb.AppendLine.Append('{Next File}').AppendLine;


    sb.Append(BuildInterfaceTest(TestMethods, 'TestMethods'));
    sb.AppendLine.Append('{Next File}').AppendLine;

    sb.Append(BuildInterfaceTest(Testrecord, 'Testrecord'));
    sb.AppendLine.Append('{Next File}').AppendLine;


    sb.Append(BuildInterfaceTest(TestGeneric, 'TestGeneric'));
    sb.AppendLine.Append('{Next File}').AppendLine;




    sb.Append(BuildInterfaceTest(TestInterfaceImpl, 'TestInterfaceImpl'));
    sb.AppendLine.Append('{Next File}').AppendLine;

    sb.Append(BuildInterfaceTest(TestAttributes, 'TestAttributes'));
    sb.AppendLine.Append('{Next File}').AppendLine;

    sb.Append(BuildInterfaceTest(TestWithClause, 'TestWithClause'));
    sb.AppendLine.Append('{Next File}').AppendLine;

    sb.Append(BuildInterfaceTest(TestUnit2, 'TestUnit2'));
    sb.AppendLine.Append('{Next File}').AppendLine;

    sb.Append(BuildInterfaceTest(cResStrings, 'TestResStrings'));
    sb.AppendLine.Append('{Next File}').AppendLine;

*)

    result := sb.ToString;
   // File.WriteText(String.Format('d:\Test\{0}.pas','AllinOne'),   result);

  end;

end.