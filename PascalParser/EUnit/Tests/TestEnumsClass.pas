namespace PascalParser;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestEnumsClass = public class(Test)
  private
  protected
  public
    method FirstTest;
  end;

implementation

method TestEnumsClass.FirstTest;
begin
  Assert.IsTrue(true);
end;

end.