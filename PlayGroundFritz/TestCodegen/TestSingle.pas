namespace TestCodegen;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestSingle = public class(TestParserBase)
  private
    method RangeTest;

    method TestArray;
  protected
  public
    method SeconsTest;
  end;

implementation

method TestSingle.TestArray;
begin


end;

method TestSingle.SeconsTest;
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

end.