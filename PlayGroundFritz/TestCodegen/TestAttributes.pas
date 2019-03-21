namespace TestCodegen;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestAttributes = public class(TestParserBase )
  private
  protected
  public
   method TestAttribinClass;

    method TestAttribForClass;
  end;

implementation

method TestAttributes.TestAttribinClass;
begin
  var lunit := BuildUnit(tbUnitType.Body ,"
type
Tsimple = class
 private
   [ID (10)]
   fIntProp : integer;
   function GetIntProp : integer;
   procedure SetIntProp(const value : Integer);
 public
   [Name ('INTValue')]
  property intProp : Integer read GetIntProp write setIntProp;
end;

implementation
function Tsimple.GetIntProp : integer;
begin
  result := fIntProp;
end;

procedure Tsimple.SetIntProp(const value : Integer);
begin
  fIntProp := value;
end;

");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Types.Count, 1);
  for each matching GV : CGClassTypeDefinition in lunit.Types do
    begin
    Check.AreEqual(GV.Members.Count, 4);

    for each  m  in GV.Members index i do
      begin
      case i of
        0 : begin
          Assert.IsTrue(m is CGFieldDefinition);
          Check.AreEqual(CGFieldDefinition(m).Name, 'fIntProp');
          Check.AreEqual(m.Attributes.Count, 1);
          Check.AreEqual(m.Attributes[0]:Parameters.Count, 1);
        end;
        1 : begin
          Assert.IsTrue(m is CGMethodLikeMemberDefinition);
          Check.AreEqual(CGMethodLikeMemberDefinition(m).Name, 'GetIntProp');
        end;

        2 : begin
          Assert.IsTrue(m is CGMethodLikeMemberDefinition);
          Check.AreEqual(CGMethodLikeMemberDefinition(m).Name, 'SetIntProp');
        end;

        3 : begin
            Assert.IsTrue(m is CGPropertyDefinition);
            Check.AreEqual(CGPropertyDefinition(m).Name, 'intProp');
            Assert.AreEqual(m.Attributes.Count, 1);
            var la := m.Attributes[0];
            Check.AreEqual(la.Parameters.Count, 1);

        end;
      end;
    end;
  end;

end;

method TestAttributes.TestAttribForClass;
begin
  var lunit := BuildUnit(tbUnitType.Body ,"
type
  [Name ('INTValue')]
Tsimple = class

end;

implementation


");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Types.Count, 1);
  for each matching GV : CGClassTypeDefinition in lunit.Types do
    begin
     Check.AreEqual(GV.Members.Count, 0);
    Assert.AreEqual(GV.Attributes.Count, 1);
    end;

end;



end.