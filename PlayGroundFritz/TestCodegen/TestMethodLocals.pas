namespace TestCodegen;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestMethodLocals = public class(TestParserBase)
  private
  protected
  public
    method testLocalVars;
    method testLocalTypes;
    method testLocalMethod;
  end;

implementation

method TestMethodLocals.testLocalVars;
begin
  var lunit := BuildUnit(tbUnitType.implementation ,"
    procedure ProcSimple;
    Var i : integer;
    const c = 42;
    begin
    end;

");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 1);
  for each matching GV : CGGlobalFunctionDefinition in lunit.Globals do
    begin
    var func := GV.Function;
    Check.AreEqual(func.Name, 'ProcSimple');
   Check.AreEqual(func.LocalVariables.Count, 2);

   for each v in func.LocalVariables index i do
     begin
      case i of
        0 : begin
          Check.IsFalse(v.Constant);
          Check.AreEqual(v.Name, 'i');
          Check.IsNil(v.Value);
        end;
        1 : begin
          Check.IsTrue(v.Constant);
          Check.AreEqual(v.Name, 'c');
          Check.IsNotnil(v.Value);
        end;
      end;
    end;
 end;
end;

method TestMethodLocals.testLocalTypes;
begin
  var lunit := BuildUnit(tbUnitType.implementation ,"
   procedure ProcSimple;
   type testrec = record a, b : integer; end;

   begin
   end;

");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 1);
  for each matching GV : CGGlobalFunctionDefinition in lunit.Globals do
    begin
    var func := GV.Function;
    Check.AreEqual(func.Name, 'ProcSimple');
    Check.AreEqual(func.LocalTypes.Count, 1);

    for each v in func.LocalTypes  do
      begin
       Check.AreEqual(v.Name, 'testrec');
       Check.IsTrue(v is CGStructTypeDefinition);
       Check.AreEqual(CGStructTypeDefinition(v).Members.Count, 2);
      end;
   end;

 end;

method TestMethodLocals.testLocalMethod;
begin
  var lunit := BuildUnit(tbUnitType.implementation ,"
 procedure ProcSimple;

 procedure TestLocal;
 var i : integer;
 begin
   i := 2;
 end;

 begin
 end;

");

Assert.IsNotNil(lunit);
Assert.AreEqual(lunit.Globals.Count, 1);
for each matching GV : CGGlobalFunctionDefinition in lunit.Globals do
  begin
  var func := GV.Function;
  Check.AreEqual(func.Name, 'ProcSimple');
  Check.AreEqual(func.LocalMethods.Count, 1);

  for each v in func.LocalMethods  do
    begin
    Check.AreEqual(v.Name, 'TestLocal');
    Check.AreEqual(v.LocalVariables.Count, 1);
    Check.AreEqual(v.Statements.Count, 1);
  end;
end;

end;



end.