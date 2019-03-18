namespace TestCodegen;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestLiteral = public class(TestParserBase)
  private


  protected
  public
    method TestInts;
    method TestFloats;
    method TestStrings;
  end;

implementation



method TestLiteral.TestInts;

begin
  var lunit := BuildUnit(tbUnitType.interface ,"
   const
     cint : integer = 42;
     cint2 = $FF;
     cint3 = $FFFF;
     cint4 = -1000;
  ");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 4);
  Assert.IsTrue(lunit.Globals[0] is CGGlobalVariableDefinition);

  with f := (lunit.Globals[0] as CGGlobalVariableDefinition).Variable do
  begin
    Check.IsTrue(f.Constant);
    Check.IsNotNil(f.Initializer);
    Check.IsNotNil(f.Type);
    Check.IsTrue( f.Initializer is CGIntegerLiteralExpression);
    Check.AreEqual((f.Initializer as CGIntegerLiteralExpression).Value, 42);
  end;

  Assert.IsTrue(lunit.Globals[1] is CGGlobalVariableDefinition);

  with f := (lunit.Globals[1] as CGGlobalVariableDefinition).Variable do
  begin
    Check.IsTrue(f.Constant);
    Check.IsNotNil(f.Initializer);
    Check.IsNil(f.Type);
    Check.IsTrue( f.Initializer is CGIntegerLiteralExpression);
    Check.AreEqual((f.Initializer as CGIntegerLiteralExpression).Value, 255);
  end;

  with f := (lunit.Globals[2] as CGGlobalVariableDefinition).Variable do
  begin
    Check.IsTrue(f.Constant);
    Check.IsNotNil(f.Initializer);
    Check.IsNil(f.Type);
    Check.IsTrue( f.Initializer is CGIntegerLiteralExpression);
    Check.AreEqual((f.Initializer as CGIntegerLiteralExpression).Value, $FFFF);
  end;

  with f := (lunit.Globals[3] as CGGlobalVariableDefinition).Variable do
  begin
    Check.IsTrue(f.Constant);
    Check.IsNotNil(f.Initializer);
    Check.IsNil(f.Type);
    Check.IsTrue( f.Initializer is CGUnaryOperatorExpression);
    var v := ((f.Initializer as CGUnaryOperatorExpression).Value as CGIntegerLiteralExpression );
    if assigned(v.SignedValue) then
      Check.AreEqual(v.SignedValue, 1000)
    else
      Check.AreEqual(v.UnsignedValue, 1000);
  end;

end;


method TestLiteral.TestFloats;
begin
  var lunit := BuildUnit(tbUnitType.interface ,"
 const
   cfloat = 42.0;
   cfloat2 = 42.0123456789;
   cFloat3 = 1E0;
   cFloat4 = 1.0E10;
   cFloat5 = -1.0E10;

");

  const cRes = [42.0, 42.0123456789,1E0, 1.0E10,-1.0E10];

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, length(cRes));
  for each matching GV : CGGlobalVariableDefinition in lunit.Globals index i do
    with f := GV.Variable do
    begin
      Check.IsTrue(f.Constant);
      Check.IsNotNil(f.Initializer);
      Check.IsNil(f.Type);
      if ( f.Initializer is CGFloatLiteralExpression) then
      begin
        var v := (f.Initializer as CGFloatLiteralExpression);
        Check.AreEqual(v.DoubleValue, cRes[i]);
      end
      else
        if ( f.Initializer is CGUnaryOperatorExpression) then
        begin
          var v := ((f.Initializer as CGUnaryOperatorExpression).Value as CGFloatLiteralExpression );
          Check.AreEqual(-v.DoubleValue, cRes[i]);
        end
        else
          Check.Fail($'Type of initializer [{i}] = {f.Initializer.ToString}');

    end;

end;

method TestLiteral.TestStrings;
begin
  var lunit := BuildUnit(tbUnitType.interface ,"
const
 cString = 'Hello';
 cString2 = 'Elements';
 cString3 = ' ';
 cString4 = cString+cString3+cString2;

");

  const cString = 'Hello';
  const  cString2 = 'Elements';
  const  cString3 = ' ';
  const  cString4 = cString+cString3+cString2;

  const cRes = [cString, cString2, cString3, cString+cString3+cString2];
  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, length(cRes));
  for each matching GV : CGGlobalVariableDefinition in lunit.Globals index i do
    with f := GV.Variable do
    begin
      Check.IsTrue(f.Constant);
      Check.IsNotNil(f.Initializer);
      Check.IsNil(f.Type);
      if ( f.Initializer is CGStringLiteralExpression) then
      begin
        var v := (f.Initializer as CGStringLiteralExpression);
        Check.AreEqual(v.Value, cRes[i]);
      end
      else
        if ( f.Initializer is CGBinaryOperatorExpression) and (i=3) then
        begin
          ; //
        end
      else
        Check.Fail($'Type of initializer [{i}] = {f.Initializer.ToString}');
    end;
end;

end.