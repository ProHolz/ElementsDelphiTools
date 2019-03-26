namespace TestCodegen;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestSimpleStatements = public class(TestParserBase)
  private
  public
    method TestSimpleAssign;
    method TestFor;

    method testBreakContinue;
  end;

implementation

method TestSimpleStatements.TestSimpleAssign;
begin
  var lunit := BuildUnit(tbUnitType.implementation ,"

procedure TestAssign;
var a : integer;
begin
  a := 10;
  a := a+10;
  a := a-10;
  a := a*10;
  a := a/10; // Will not work in delphi.....
  a := a mod 10;
  a := a shl  2;
  a := a shr  2;
  a := a xor  2;
  a := a and  2;
  a := a or  2;
  a := a div  2;

end;


");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 1);
  for each matching GV : CGGlobalFunctionDefinition in lunit.Globals  do
    begin
    var func := GV.Function;
    for each s  in  func.Statements index i do
      begin
      Assert.IsTrue(s is CGAssignmentStatement);
      var se := (s as CGAssignmentStatement);
      case i of
        0 :  begin
          Assert.IsTrue(se.Target is CGNamedIdentifierExpression);
          Check.AreEqual((se.Target as CGNamedIdentifierExpression).Name, 'a');
          Assert.IsTrue(se.Value is CGIntegerLiteralExpression);
          Check.AreEqual((se.Value as CGIntegerLiteralExpression).StringRepresentation, '10');
        end;

        1 :  begin
          Assert.IsTrue(se.Target is CGNamedIdentifierExpression);
          Check.AreEqual((se.Target as CGNamedIdentifierExpression).Name, 'a');
          Assert.IsTrue(se.Value is CGBinaryOperatorExpression);
          Check.AreEqual((se.Value as CGBinaryOperatorExpression).Operator, CGBinaryOperatorKind.Addition);
        end;
        2 :  begin
          Check.AreEqual((se.Value as CGBinaryOperatorExpression).Operator, CGBinaryOperatorKind.Subtraction);
        end;
        3 :  begin
          Check.AreEqual((se.Value as CGBinaryOperatorExpression).Operator, CGBinaryOperatorKind.Multiplication);
          end;
        4 :  begin
          Check.AreEqual((se.Value as CGBinaryOperatorExpression).Operator, CGBinaryOperatorKind.Division);
         end;
        5 :  begin
          Check.AreEqual((se.Value as CGBinaryOperatorExpression).Operator, CGBinaryOperatorKind.Modulus);
        end;
        6 :  begin
          Check.AreEqual((se.Value as CGBinaryOperatorExpression).Operator, CGBinaryOperatorKind.Shl);
         end;
        7 :  begin
          Check.AreEqual((se.Value as CGBinaryOperatorExpression).Operator, CGBinaryOperatorKind.Shr);
        end;
        8 :  begin
          Check.AreEqual((se.Value as CGBinaryOperatorExpression).Operator, CGBinaryOperatorKind.LogicalXor);
        end;
        9 :  begin
          Check.AreEqual((se.Value as CGBinaryOperatorExpression).Operator, CGBinaryOperatorKind.LogicalAnd);
         end;
        10 :  begin
          Check.AreEqual((se.Value as CGBinaryOperatorExpression).Operator, CGBinaryOperatorKind.LogicalOr);
         end;
        11 :  begin
          Check.AreEqual((se.Value as CGBinaryOperatorExpression).Operator, CGBinaryOperatorKind.LegacyPascalDivision);
        end;
       end;

    end;
  end;
end;

method TestSimpleStatements.testFor;
begin
  var lunit := BuildUnit(tbUnitType.implementation ,"

procedure TestLoops;
var i : integer;
begin
  for i := 0 to 2 do;
  for j in check do;
   while false do;
   repeat until false;
end;


");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 1);
  for each matching GV : CGGlobalFunctionDefinition in lunit.Globals  do
    begin
    var func := GV.Function;
    Check.AreEqual(func.Statements.Count, 4);
    for each s  in  func.Statements index i do
      begin
        case i of
          0 : begin
              Check.IsTrue(s is CGForToLoopStatement);
            end;
          1 : begin
              Check.IsTrue(s is CGForEachLoopStatement);
          end;
          2 : begin
              Check.IsTrue(s is CGWhileDoLoopStatement);
           end;
          3 : begin
              Check.IsTrue(s is CGDoWhileLoopStatement);
           end;
        end;
      end;
    end;
end;


method TestSimpleStatements.testBreakContinue;
begin
  var lunit := BuildUnit(tbUnitType.implementation ,"

procedure TestLoops;
var i : integer;
begin
  for i := 0 to 2 do begin
    if i = 2 then break else continue;
  end;
  for j in check do;
   while false do;
   repeat until false;
end;


");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 1);
  for each matching GV : CGGlobalFunctionDefinition in lunit.Globals  do
    begin
    var func := GV.Function;
    Check.AreEqual(func.Statements.Count, 4);
    for each s  in  func.Statements index i do
      begin
      case i of
        0 : begin
              Assert.IsTrue(s is CGForToLoopStatement);
          var f := s as CGForToLoopStatement;
           Assert.IsTrue(f.NestedStatement is CGIfThenElseStatement);
          var n := f.NestedStatement as CGIfThenElseStatement;
          Check.IsTrue(n.ElseStatement is CGContinueStatement);
          Check.IsTrue(n.IfStatement is CGBreakStatement);

        end;
        1 : begin
          Check.IsTrue(s is CGForEachLoopStatement);
        end;
        2 : begin
          Check.IsTrue(s is CGWhileDoLoopStatement);
        end;
        3 : begin
          Check.IsTrue(s is CGDoWhileLoopStatement);
        end;
      end;
    end;
  end;
end;


end.