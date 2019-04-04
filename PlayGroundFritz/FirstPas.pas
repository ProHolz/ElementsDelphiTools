namespace ProHolz.CodeGen;
{$GLOBALS ON}
uses
  ProHolz.Ast;

method BuildInterfaceTest(const Source : String; const TestName : String) : String;
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
  //var cg2 := new CGSwiftCodeGenerator();
  //var cg := new CGGoCodeGenerator();

  result := cg.GenerateUnit(lUnit);
  if Environment.OS = OperatingSystem.Windows then
  begin
    {$DEFINE USEUTF8}
    {$IF USEUTF8}
    File.WriteText(String.Format('d:\Test\{0}.pas',TestName), result);

   {$ELSE}
    //var cp1252 := Encoding.GetEncoding('windows-1252');
    var cp1252 := System.Text.Encoding.GetEncoding('windows-1252');
    var a := cp1252.GetBytes(result);// includeBOM(true);

    var lPreamble := new Binary(cp1252.GetPreamble());
    lPreamble.Write(a);
    a  := lPreamble.ToArray();

    File.WriteBytes(String.Format('d:\Test\{0}.pas',TestName),   a);
   {$ENDIF}

  end;

end;


method BuildPasfromNode(full : Boolean) : String;
begin
  Var sb := new StringBuilder();
  if full then
  begin

    //var cp1252 := Encoding.GetEncoding('windows-1252');
    //var data := File.ReadBytes("D:\sourceProHolz\Abbund170\DachHolz\TypConst.pas");


 // Var s := File.ReadText("D:\sourceProHolz\Abbund170\Synopse\SynCommons.pas");
    Var s :=  File.ReadText( "D:\sourceProHolz\Abbund170\DachHolz\TypConst.pas");
 //   Var s := File.ReadText("D:\sourceProHolz\Abbund170\Synopse\SynLz.pas");
  //Var s := File.ReadText("D:\sourceProHolz\Abbund170\Cairo\Cairo.Dll.pas");
  //  Var s := File.ReadText("D:\sourceProHolz\Abbund170\Cairo\Cairo.Types.pas");
  //  Var s := File.ReadText("D:\sourceProHolz\Abbund170\Cairo\Cairo.Freetype.pas");
    sb.Append(BuildInterfaceTest(s, 'TypConst'));
  sb.AppendLine.Append('{Next File}').AppendLine;
  end;

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

  result := sb.ToString;
 // File.WriteText(String.Format('d:\Test\{0}.pas','AllinOne'),   result);

end;

end.