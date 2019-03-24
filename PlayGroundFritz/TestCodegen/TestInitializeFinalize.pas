namespace TestCodegen;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestInitializeFinalize = public class(TestParserBase)
  private
  protected
  public
   method testInitialize;
  end;

implementation

method TestInitializeFinalize.testInitialize;
begin
  var lunit := BuildUnit(tbUnitType.implementation ,"
   initialization
   {EMPTY}
   a := b;
   finalization
   a := b;

");

  Assert.IsNotNil(lunit);
  Assert.IsNil(lunit.Initialization);
  Check.AreEqual(lunit.Globals.Count, 2);
end;


end.