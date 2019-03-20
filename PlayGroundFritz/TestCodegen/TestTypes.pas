namespace TestCodegen;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestTypes = public class(TestParserBase)
  public
    method TestTypes;
  end;

implementation

method TestTypes.TestTypes;
begin
  var lunit := BuildUnit(tbUnitType.interface ,"
type
 myString = String; // Alias
// Pointer Type
  PmyInteger = ^Integer; // Alias

 // record
 PMyRecord = ^MyRecord; // Alias

 MyRecord = record // Struct
 a : integer;
 b : Double;
 end;

 // Enum
 eCadPenStyle = (lpsDash, lpsSolid, lpsDot);

 eStyleset = set of eCadPenStyle; // Alias

const
 DefaultStyle : eStyleSet = [lpsDash, lpsSolid];
 SimpleIntArray : Array[0..2] of Integer = (0, 1,2);
 AllInt : array[0..1, 3..4] of integer = ((3,4), (5,6));

type
  tClassCollection = class of  TPersistent; // Alias

  tmyProc = procedure(value : integer); // Block Type
  tmyfunc = function(value : integer) : integer of object; // Block Type
  tmyref = reference to procedure(value : integer); // Block Type

 ");

  const cAlias = ['myString', 'PmyInteger', 'PMyRecord','MyRecord','eCadPenStyle', 'eStyleset', 'tClassCollection','tmyProc','tmyfunc','tmyref'];

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 3, 'There are 3 const defined');
  Assert.AreEqual(lunit.Types.Count, 10, 'There are 10 types defined');

  for each matching GV : CGGlobalVariableDefinition in lunit.Globals  do
    with f := GV.Variable do
    begin
      Check.IsTrue(f.Constant);
    end;

  for each matching GT: CGTypeAliasDefinition  in lunit.Types index i do
    begin
    Check.AreEqual(GT.Name, cAlias[i],  $' {GT.Name} Loop [{i}]');
  end;

  for each matching GT: CGStructTypeDefinition  in lunit.Types index i do
    begin
    Check.AreEqual(GT.Name, cAlias[i],  $' {GT.Name} Loop [{i}]');
  end;

  for each matching GT: CGEnumTypeDefinition  in lunit.Types index i do
    begin

    Check.AreEqual(GT.Name, cAlias[i],  $' {GT.Name} Loop [{i}]');
  end;

  for each matching GT: CGBlockTypeDefinition  in lunit.Types index i do
    begin
    Check.AreEqual(GT.Name, cAlias[i],  $' {GT.Name} Loop [{i}]');
  end;

end;

end.