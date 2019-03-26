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
Isimple = Interface(IBase)
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
    Check.AreEqual(GV.ImplementedInterfaces.Count, 1);
    Check.AreEqual(GV.InterfaceGuid.ToString, 'E277B1D4-88D3-4D1B-8541-39939F683D87');
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
    Check.AreEqual(GV.Attributes.Count, 2);

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
Tsimple = class(TObject, IBase, ISimple)
 procedure Allocate;
 property  Simple : ISimple read getSimple implements ISimple;
 procedure IBase.TestBase = Allocate;
end;

");

(*
  the procedure IBase.TestBase = Allocate  must be deleted and
  replaced with
  method Allocate; implements IBase.TestBase;

  so in this Test we Expect 2 Members in the class
  0 :  method Allocate; implements IBase.Test;
  1 : property Simple: ISimple read getSimple; implements ISimple;
*)

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Types.Count, 1);
  for each matching GV : CGClassTypeDefinition in lunit.Types do
    begin
     Check.AreEqual(GV.Members.Count, 2);
     Check.AreEqual(GV.Ancestors.Count, 1);
    Check.AreEqual(GV.ImplementedInterfaces.Count, 2);



    for each  m  in GV.Members index i do
      begin
      case i of
        0 : begin
          Assert.IsTrue(m is CGMethodLikeMemberDefinition);
          Check.AreEqual(CGMethodLikeMemberDefinition(m).Name, 'Allocate');
          Check.AreEqual(CGMethodLikeMemberDefinition(m).Parameters.Count , 0);
          if assigned(CGNamedTypeReference(m.ImplementsInterface)) then
          begin

          Check.AreEqual(CGNamedTypeReference(m.ImplementsInterface).Name, 'IBase');
          Check.AreEqual(m.ImplementsInterfaceMember, 'TestBase');
         end
          else Check.Fail('m.ImplementsInterface is NIL');
        end;
        1 : begin
          Assert.IsTrue(m is CGFieldOrPropertyDefinition);
          Check.AreEqual(CGFieldOrPropertyDefinition(m).Name, 'Simple');
          Assert.IsTrue(m.ImplementsInterface is CGNamedTypeReference);
          Check.AreEqual(CGNamedTypeReference(m.ImplementsInterface).Name, 'ISimple');
        end;

      end;
    end;
  end;
end;
end.