namespace PascalParser;

interface

uses
  RemObjects.Elements.EUnit;

implementation

begin
  var lTests := Discovery.DiscoverTests();
  var TestListener := Runner.DefaultListener;
  Runner.RunTests(lTests) withListener(TestListener);

end.