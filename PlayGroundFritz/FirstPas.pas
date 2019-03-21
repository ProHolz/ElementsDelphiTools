namespace PlayGroundFritz;

uses
  PascalParser;
  //RemObjects.CodeGen4;



method BuildInterfaceTest(const Source : String; const TestName : String) : String;
begin
  var  Root := TPasSyntaxTreeBuilder.RunWithString(Source, false);
  if Environment.OS = OperatingSystem.Windows then
  File.WriteText(String.Format('d:\Test\{0}.xml', TestName),   TSyntaxTreeWriter.ToXML(Root, true));
  var lUnit := new CodeBuilder().BuildCGCodeUnitFomSyntaxNode(Root);
 //  var cg := new CGDelphiCodeGenerator();
   var cg := new CGOxygeneCodeGenerator();
  //var cg := new CGCSharpCodeGenerator();
  //var cg := new CGCPlusPlusCPPCodeGenerator();
  //var cg := new CGSwiftCodeGenerator();
  //var cg := new CGGoCodeGenerator();

  result := cg.GenerateUnit(lUnit);
  if Environment.OS = OperatingSystem.Windows then
  File.WriteText(String.Format('d:\Test\{0}.pas',TestName),   result);
 // File.WriteText(String.Format('d:\Test\{0}.cs',TestName),   cg2.GenerateUnit(lUnit));

end;


method BuildPasfromNode(full : Boolean) : String;
begin
  Var sb := new StringBuilder();
  if full then
  begin
  Var s := File.ReadText("D:\sourceProHolz\Abbund170\Synopse\SynCommons.pas");
  sb.Append(BuildInterfaceTest(s, 'SynCommons'));
  sb.AppendLine.Append('{Next File}').AppendLine;
  end;


  //sb.Append(BuildInterfaceTest(TestTypes, 'TestTypes'));
  //sb.AppendLine.Append('{Next File}').AppendLine;



  //sb.Append(BuildInterfaceTest(TestAnonymous, 'TestAnonymous'));
  //sb.AppendLine.Append('{Next File}').AppendLine;


   //sb.Append(BuildInterfaceTest(TestSetAndEnums, 'TestSetAndEnums'));
   //sb.AppendLine.Append('{Next File}').AppendLine;


  //sb.Append(BuildInterfaceTest(TestLoops, 'TestLoops'));
  //sb.AppendLine.Append('{Next File}').AppendLine;


  //sb.Append(BuildInterfaceTest(TestExceptions, 'TestExceptions'));
  //sb.AppendLine.Append('{Next File}').AppendLine;

  //sb.Append(BuildInterfaceTest(TestConstArray, 'TestConstArray'));
  //sb.AppendLine.Append('{Next File}').AppendLine;



 //sb.Append(BuildInterfaceTest(TestMethodimplementation, 'TestMethodimplementation'));
 //sb.AppendLine.Append('{Next File}').AppendLine;

  //sb.Append(BuildInterfaceTest(TestAll, 'TestAll'));
  //sb.AppendLine.Append('{Next File}').AppendLine;


  //sb.Append(BuildInterfaceTest(TestMethods, 'TestMethods'));
  //sb.AppendLine.Append('{Next File}').AppendLine;

  sb.Append(BuildInterfaceTest(Testrecord, 'Testrecord'));
  sb.AppendLine.Append('{Next File}').AppendLine;


  //sb.Append(BuildInterfaceTest(TestGeneric, 'TestGeneric'));
  //sb.AppendLine.Append('{Next File}').AppendLine;


// sb.Append(BuildInterfaceTest(TestUnit2, 'TestUnit2'));
  //sb.AppendLine.Append('{Next File}').AppendLine;

 sb.Append(BuildInterfaceTest(TestInterfaceImpl, 'TestInterfaceImpl'));
  sb.AppendLine.Append('{Next File}').AppendLine;

  sb.Append(BuildInterfaceTest(TestAttributes, 'TestAttributes'));
   //sb.AppendLine.Append('{Next File}').AppendLine;



  result := sb.ToString;
 // File.WriteText(String.Format('d:\Test\{0}.pas','AllinOne'),   result);

end;

end.