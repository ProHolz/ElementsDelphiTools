﻿namespace TestCodegen;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestSingle = public class(TestParserBase)
  private
    method RangeTest;

    method TestArray;
    method testLocalConsts;
  protected
  public
    method SeconsTest;

  end;

implementation


method TestSingle.SeconsTest;
begin
  var lunit := BuildUnit(tbUnitType.interface ,"
   type
     TIntegerHelper = record helper for integer
       function AddHelper(const a : integer) : integer;
     end;

     TStringsHelper = class helper for Tstrings
       function AddHelper(const a : integer) : integer;
     end;

     TTest = class
      procedure Testnone;
      private
      procedure Testprivate;
      strict private
      procedure TestStrictprivate;

      protected
      procedure Testprotected;

      strict protected
      procedure TestStrictprotected;

      public
      procedure testPublic; stdcall;

      published
      procedure TestPublished;

     end;

  ");
  Assert.IsNotNil(lunit);
  Check.AreEqual(lunit.Globals.Count, 0);
  Check.AreEqual(lunit.Types.Count, 3);

  var lclass := lunit.Types.Item[2];
  if lclass is CGClassTypeDefinition then
  if lclass.Name = 'TTest' then
    begin
    for each matching m : CGMethodLikeMemberDefinition in lclass.Members index i do
      begin
       case i of
         0 : begin
           //Check.IsTrue(m is CGConstructorDefinition);
           //Check.AreEqual(m.Name, '');
           //Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Public);
           //Check.IsFalse( m.Static);
           //Check.isFalse(m.Virtuality = CGMemberVirtualityKind.Override);
         end;
         1 : begin
           //Check.IsTrue(m is CGMethodDefinition);
           //Check.AreEqual(m.Name, 'Create');
           //Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Public);
          //Check.IsTrue( m.Static);
        end;

         2 : begin
           //Check.IsFalse(m is CGDestructorDefinition);
           //Check.IsTrue(m is CGMethodDefinition);
           //Check.Contains('Destroy', m.Name);
           //Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Public);
           //Check.IsFalse( m.Static);
           //// Should not be virtual
           //Check.AreNotEqual( m.Virtuality, CGMemberVirtualityKind.Virtual);
           //Check.AreEqual(m.Statements.Count, 1);
         end;

         5 : begin
         Check.IsTrue(m is CGMethodDefinition);
           Check.AreEqual(m.Name, 'testPublic');
         Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Public);
        Check.IsFalse( m.Static);
           Check.IsTrue(m.CallingConvention = CGCallingConventionKind.StdCall);
         end;

       end;
      end;
    end;





  var cg := new CGOxygeneCodeGenerator();
  writeLn( cg.GenerateUnit(lunit));
end;

method TestSingle.TestArray;
begin
  var lunit := BuildUnit(tbUnitType.interface ,"
type
  tUtf8Rec = record
  offset, minimum: cardinal;
end;

const
  UTF8_EXTRA: array[0..6] of tUtf8Rec
 = ( // http://floodyberry.wordpress.com/2007/04/14/utf-8-conversion-tricks
(offset: $00000000;  minimum: $00010000),
(offset: $00003080;  minimum: $00000080),
(offset: $000e2080;  minimum: $00000800),
(offset: $03c82080;  minimum: $00010000),
(offset: $fa082080;  minimum: $00200000),
(offset: $82082080;  minimum: $04000000),
(offset: $00000000;  minimum: $04000000));
");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 1);

end;

method TestSingle.RangeTest;
begin
  var lunit := BuildUnit(tbUnitType.interface ,"
const
  NullVarData: TVarData = (VType: varNull);
");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 1);


  for each matching GT : CGGlobalVariableDefinition in lunit.Globals index i do
    begin
    case i of

      0 :  begin
            Check.AreEqual(GT.Variable.Name, 'NullVarData');
            Check.IsFalse(GT.Variable.Constant);
            Check.IsTrue(GT.Variable.ReadOnly);

            Check.IsNotNil(GT.Variable.Initializer);
            const  v = GT.Variable.Initializer;
            Check.IsTrue(v is CGExpression);

      //  Assert.IsTrue(GT is CGTypeAliasDefinition);
      end;
    end;
  end;


end;

method TestSingle.testLocalConsts;
begin
  var lunit := BuildUnit(tbUnitType.implementation ,"

    procedure Localproc;
    var i : Integer;
    const b = 3;
    var initD : Double = 0.03;
    begin

    end;
 ");
  Assert.IsNotNil(lunit);
 Check.AreEqual(lunit.Globals.Count, 1);
 Check.AreEqual(lunit.Types.Count, 0);
 var cg := new CGOxygeneCodeGenerator();
 writeLn( cg.GenerateUnit(lunit));
end;

end.