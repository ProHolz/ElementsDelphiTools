namespace TestCodegen;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestGenricClass = public class(TestParserBase)
  private
  protected
  public
    method TestSimpleGenericClass;
  end;

implementation

method TestGenricClass.TestSimpleGenericClass;
begin
  var lunit := BuildUnit(tbUnitType.Body ,"
type
  TGenericClass<T> = class
  private
   fdata : Array of T;
   procedure Test;
  end;

  implementation

  procedure TGenericClass<T>.Test;beginend;

");

 Assert.IsNotNil(lunit);
 Assert.AreEqual(lunit.Types.Count, 1);
 for each matching GV : CGClassTypeDefinition in lunit.Types do
   begin

   Check.AreEqual(GV.GenericParameters.Count, 1);
   Check.AreEqual(GV.Members.Count, 2);
   for each matching f : CGFieldDefinition in GV.Members index i do
     begin
     case i of
       0 : begin
         Check.AreEqual(f.Name, 'fdata');
         Check.AreEqual( f.Visibility, CGMemberVisibilityKind.Private);
         Check.IsTrue(f.Type is CGArrayTypeReference);
       end;
     end;
   end;

   for each matching m : CGMethodDefinition in GV.Members index i do
     begin
      case i of
        1 : begin
          Check.AreEqual(m.Name, 'Test');
          Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Private);
         // Check.IsTrue(m.Type is CGArrayTypeReference);
        end;
      end;
    end;

 end;
end;



end.