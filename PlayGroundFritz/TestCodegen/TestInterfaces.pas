namespace TestCodegen;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestInterfaces = public class(TestParserBase)
  private

  public
    method TestInterface;
    method TestInterfaceIndexProp;

    method TestImplementsMethod;
  end;

implementation

method TestInterfaces.TestInterface;
begin
  var lunit := BuildUnit(tbUnitType.interface ,"
type
Isimple = Interface
 ['{E277B1D4-88D3-4D1B-8541-39939F683D87}']
   function GetIntProp : integer;
   procedure SetIntProp(const value : Integer);
  property intProp : Integer read GetIntProp write setIntProp;
end;

");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Types.Count, 1);
  for each matching GV : CGInterfaceTypeDefinition in lunit.Types do
    begin
    Check.AreEqual(GV.Members.Count, 3);

    for each  m  in GV.Members index i do
      begin
      case i of
        0 : begin
            Assert.IsTrue(m is CGMethodLikeMemberDefinition);
            Check.AreEqual(CGMethodLikeMemberDefinition(m).Name, 'GetIntProp');
        end;

        1 : begin
            Assert.IsTrue(m is CGMethodLikeMemberDefinition);
            Check.AreEqual(CGMethodLikeMemberDefinition(m).Name, 'SetIntProp');
          end;

        2 : begin
            Assert.IsTrue(m is CGPropertyDefinition);
            Check.AreEqual(CGPropertyDefinition(m).Name, 'intProp');
          end;
    end;
  end;
  end;
end;

method TestInterfaces.TestInterfaceIndexProp;
begin
  var lunit := BuildUnit(tbUnitType.interface ,"
type
Isimple<T> = Interface
['{E277B1D4-88D3-4D1B-8541-39939F683D87}']
 function GetIntProp(Index: Integer): Integer;
 procedure SetIntProp(Index: Integer; const Value: Integer);
property intProp[index : integer] : Integer read GetIntProp write setIntProp;
end;

");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Types.Count, 1);
  for each matching GV : CGInterfaceTypeDefinition in lunit.Types do
    begin

    Check.AreEqual(GV.Name, 'Isimple');
    Check.AreEqual(GV.GenericParameters.Count, 1);
    Check.AreEqual(GV.Members.Count, 3);
    Check.IsNotNil(GV.InterfaceGuid);
    for each  m  in GV.Members index i do
      begin
      case i of
        0 : begin
          Assert.IsTrue(m is CGMethodLikeMemberDefinition);
          Check.AreEqual(CGMethodLikeMemberDefinition(m).Name, 'GetIntProp');
          Check.AreEqual(CGMethodLikeMemberDefinition(m).Parameters.Count , 1);
        end;

        1 : begin
          Assert.IsTrue(m is CGMethodLikeMemberDefinition);
          Check.AreEqual(CGMethodLikeMemberDefinition(m).Name, 'SetIntProp');
          Check.AreEqual(CGMethodLikeMemberDefinition(m).Parameters.Count , 2);
        end;

        2 : begin
          Assert.IsTrue(m is CGPropertyDefinition);
          Check.AreEqual(CGPropertyDefinition(m).Name, 'intProp');
          Check.AreEqual(CGPropertyDefinition(m).Parameters.Count , 1);

        end;
      end;
    end;
  end;
end;

method TestInterfaces.TestImplementsMethod;
begin
  var lunit := BuildUnit(tbUnitType.interface ,"
type
Tsimple = class
 procedure IBase.TestBase = Allocate;
end;

");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Types.Count, 1);
  for each matching GV : CGClassTypeDefinition in lunit.Types do
    begin
    Check.AreEqual(GV.Members.Count, 1);

    for each  m  in GV.Members index i do
      begin
      case i of
        0 : begin
          Assert.IsTrue(m is CGMethodLikeMemberDefinition);
          Check.AreEqual(CGMethodLikeMemberDefinition(m).Name, 'IBase.TestBase');
          Check.AreEqual(CGMethodLikeMemberDefinition(m).Parameters.Count , 0);
          Check.AreEqual(m.ImplementsInterfaceMember, 'Allocate');
        end;


      end;
    end;
  end;
end;
end.