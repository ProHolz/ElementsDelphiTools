namespace TestCodegen;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestRecord = public class(TestParserBase)
  private
  protected
  public
   method testSimpleRecord;
   method testRecordOperator;
   method testRecordConstructor;
   method testRecordMethod;
   method TestGuid;
  end;

implementation

method TestRecord.testSimpleRecord;
begin
  var lunit := BuildUnit(tbUnitType.interface ,"
   type
     Tsimple = record a, b : integer; end;
");

  Assert.IsNotNil(lunit);
Assert.AreEqual(lunit.Types.Count, 1);
  for each matching GV : CGStructTypeDefinition in lunit.Types do
  begin
    Check.AreEqual(GV.Members.Count, 2);
  end;
end;

method TestRecord.testRecordOperator;
begin
  var lunit := BuildUnit(tbUnitType.Body ,"
   type
     Test_record = record
      a, b : integer;
      class operator Add(a, b: Test_record): Test_record;
      end;
    implementation

    class operator Test_record.Add(a, b: Test_record): Test_record;
    begin
     result := Test_record.create(a.fData + b.Fdata);
    end;
");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Types.Count, 1);
  for each matching GV : CGStructTypeDefinition in lunit.Types do
    begin
     Check.AreEqual(GV.Members.Count, 3);
     for each m  in GV.Members index i do
       begin
         case i of
         0 : Check.AreEqual(m.Name, 'a');
         1 : Check.AreEqual(m.Name, 'b');
         2 : begin

              Check.IsTrue(m is CGCustomOperatorDefinition);
              Check.AreEqual(m.Name, 'Add');
             end;

        end;
       end;
    end;
end;

method TestRecord.testRecordConstructor;
begin
  var lunit := BuildUnit(tbUnitType.Body ,"
 type
   Test_record = record
    a, b : integer;
    class constructor Create(a, b: Test_record);
    end;
  implementation

  class constructor Test_record.Create(a, b: Test_record);
  begin

  end;
");

Assert.IsNotNil(lunit);
Assert.AreEqual(lunit.Types.Count, 1);
for each matching GV : CGStructTypeDefinition in lunit.Types do
  begin
  Check.AreEqual(GV.Members.Count, 3);
  for each m  in GV.Members index i do
    begin
    case i of
      0 : Check.AreEqual(m.Name, 'a');
      1 : Check.AreEqual(m.Name, 'b');
      2 : begin
        Check.IsTrue(m is CGConstructorDefinition);
        Check.AreEqual(m.Name, '');
        Check.IsTrue(m.Static);
      end;


    end;
  end;
end;
end;

method TestRecord.testRecordMethod;
begin
  var lunit := BuildUnit(tbUnitType.Body ,"
 type
   Test_record = record
    a, b : integer;
     class procedure test(a, b: Test_record);
     function testfunc : integer;
    end;
  implementation

 class procedure Test_record.test(a, b: Test_record);
  begin
  end;

  function Test_record.testfunc : integer;
    begin
  end;
");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Types.Count, 1);
  for each matching GV : CGStructTypeDefinition in lunit.Types do
    begin
    Check.AreEqual(GV.Members.Count, 4);
    for each m  in GV.Members index i do
      begin
      case i of
        0 : Check.AreEqual(m.Name, 'a');
        1 : Check.AreEqual(m.Name, 'b');
        2 : begin
          Check.IsTrue(m is CGMethodDefinition);
          Check.AreEqual(m.Name, 'test');
          Check.IsTrue(m.Static);
        end;
        3 : begin
            Assert.IsTrue(m is CGMethodDefinition);
            var md := m as CGMethodDefinition;
            Check.AreEqual(m.Name, 'testfunc');
            Check.IsFalse(m.Static);
            Check.IsNotNil(md.ReturnType);
          end;

      end;
    end;
  end;
end;

method TestRecord.TestGuid;
begin
  var lunit := BuildUnit(tbUnitType.interface ,"
 const
   cGuid : TGuid = '{E277B1D4-88D3-4D1B-8541-39939F683D87}';
");

Assert.IsNotNil(lunit);
Assert.AreEqual(lunit.Globals.Count, 1);
  for each matching GV : CGGlobalVariableDefinition  in lunit.Globals do
  begin
    var v := GV.Variable;
    Check.IsNotNil(v.Initializer);

  end;
end;


end.