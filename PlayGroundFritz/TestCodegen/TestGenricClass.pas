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
    method TestComplexerGenericClass;
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

  procedure TGenericClass<T>.Test;
begin

end;

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

method TestGenricClass.TestComplexerGenericClass;
begin
  var lunit := BuildUnit(tbUnitType.Body ,"
type
  TGenericClass<U,T> = class
  private
   fdata : Array of T;
   procedure Test<U>;
   procedure TestString<U, T>(const value : String);

  end;

  implementation

  procedure TGenericClass<U,T>.Test<U>;
begin

end;

  procedure TGenericClass<U,T>.TestString<U,T>(const value : String);
begin
   //TArray.Sort<Double, Integer>(value);
   TArray.Sort<U, T>(value);
end;

");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Types.Count, 1);
  for each matching GV : CGClassTypeDefinition in lunit.Types do
    begin

    Check.AreEqual(GV.GenericParameters.Count, 2);
    Check.AreEqual(GV.Members.Count, 3);
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
          Assert.IsNotNil(m.GenericParameters);
          Check.AreEqual(m.GenericParameters.Count, 1);
          for each mg in m.GenericParameters do
           begin
            Check.AreEqual(mg.Name, 'U');
           end;

        end;
        2 : begin
          Check.AreEqual(m.Name, 'TestString');
          Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Private);
          Assert.IsNotNil(m.GenericParameters);
          Check.AreEqual(m.GenericParameters.Count, 2);
          for each mg in m.GenericParameters index j do
            begin
            case j of
              0 :   Check.AreEqual(mg.Name, 'U');
              1 :   Check.AreEqual(mg.Name, 'T');
           end;
         end;
        end;
      end;
   end;

  end;
end;



end.