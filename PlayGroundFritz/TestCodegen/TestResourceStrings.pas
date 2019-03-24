namespace TestCodegen;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestResourceStrings = public class(TestParserBase)
  private
  protected
  public
    method TestResourceStrings;
  end;

implementation

method TestResourceStrings.TestResourceStrings;
begin
  var lunit := BuildUnit(tbUnitType.Body ,"
  resourceString
   r1 = 'Hello';
   r2 = 'Hello2';

  implementation
 resourceString
   r3 = 'Hello';
   r4 = 'Hello2';
");

  Assert.IsNotNil(lunit);
  Check.AreEqual(lunit.Globals.Count, 4);

end;


end.