namespace TestCodegen;

interface

uses
  RemObjects.Elements.EUnit,
  ProHolz.Ast,
  ProHolz.CodeGen;



  type tbUnitType = public enum (&interface, &implementation, &Body);

  TestParserBase = public class(Test)
  private

  protected
    method GetRootNode(const value : String) : TSyntaxNode;
    method BuildBaseUnitInterface(const value : String): String;
    method BuildBaseUnitImplementation(const value : String): String;
    method BuildBaseUnitAll(const value : String): String;

    method BuildUnit(utype : tbUnitType; const value : String) : CGCodeUnit;
  public

  end;

implementation

const cBaseUnit = "
 unit Test;
 interface
  {0}
 implementation
 end.
";

const cBaseUnitImpl = "
 unit Test.Special.part;
 interface

 implementation
  {0}
 end.
";

const cBaseUnitAll = "
 unit Test;
 interface
  {0}
 end.
";



method TestParserBase.BuildBaseUnitInterface(const value: String): String;
begin
 result := String.Format(cBaseUnit, value);
end;

method TestParserBase.BuildBaseUnitImplementation(const value: String): String;
begin
  result := String.Format(cBaseUnitImpl, value);
end;

method TestParserBase.BuildBaseUnitAll(const value: String): String;
begin
  result := String.Format(cBaseUnitAll, value);
end;

method TestParserBase.BuildUnit(utype : tbUnitType; const value: String): CGCodeUnit;
begin
  var source :=
case utype  of
  tbUnitType.interface : BuildBaseUnitInterface(value);
  tbUnitType.implementation : BuildBaseUnitImplementation(value);
  else  BuildBaseUnitAll(value);
 end;
 var root := GetRootNode(source);
 result := new CodeBuilder().BuildCGCodeUnitFomSyntaxNode(root);

end;

method TestParserBase.GetRootNode(const value: String): TSyntaxNode;
begin
  result := TPasSyntaxTreeBuilder.RunWithString(value, false);
end;

end.