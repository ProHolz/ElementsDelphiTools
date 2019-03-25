namespace TestCodegen;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestTryExcept = public class(TestParserBase)
  private



    method FirstTest;
    method TestEmptyTry;
    method TestEmptyFinally;
  public
    method TestExceptnoStatement;
    method TestMixedTry;
  end;

implementation

method TestTryExcept.FirstTest;
begin
  var lunit := BuildUnit(tbUnitType.implementation ,"
    procedure ProcSimple;
    begin
      try
        a:=1;
      except
      end;
    end;

");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 1);

  for each matching GV : CGGlobalFunctionDefinition in lunit.Globals index i do
    begin
    var func := GV.Function;
    case i of
      0 : begin
         Assert.AreEqual(func.Statements.Count, 1);
      end;
    end;
  end;
end;

method TestTryExcept.TestEmptyTry;
begin
  var lunit := BuildUnit(tbUnitType.implementation ,"
    procedure ProcSimple;
    begin
      try

      except
      end;
    end;

");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 1);

  for each matching GV : CGGlobalFunctionDefinition in lunit.Globals index i do
    begin
    var func := GV.Function;
    case i of
      0 : begin
        Assert.AreEqual(func.Statements.Count, 1);
      end;
    end;
  end;
end;

method TestTryExcept.TestEmptyFinally;
begin
  var lunit := BuildUnit(tbUnitType.implementation ,"
    procedure ProcSimple;
    begin
      try
        a:=1;
      finally
      end;
    end;

");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 1);

  for each matching GV : CGGlobalFunctionDefinition in lunit.Globals index i do
    begin
    var func := GV.Function;
    case i of
      0 : begin
        Assert.AreEqual(func.Statements.Count, 1);
      end;
    end;
  end;
end;



method TestTryExcept.TestExceptnoStatement;
begin
  var lunit := BuildUnit(tbUnitType.implementation ,"
   procedure RaiseExcept;
begin
  try
    calltest();
  except
    on Exception do;
  end;


end;

");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 1);

  for each matching GV : CGGlobalFunctionDefinition in lunit.Globals index i do
    begin
    var func := GV.Function;
    case i of
      0 : begin
        Assert.AreEqual(func.Statements.Count, 1);
        Assert.isTrue(func.Statements[0] is CGTryFinallyCatchStatement);
        var lCatch := func.Statements[0] as CGTryFinallyCatchStatement;
        Check.AreEqual(lCatch.CatchBlocks.Count, 1);
        Check.AreEqual(lCatch.CatchBlocks[0].Statements.Count, 1);

      end;
    end;
  end;
end;

method TestTryExcept.TestMixedTry;
begin
  var lunit := BuildUnit(tbUnitType.implementation ,"
    procedure ProcSimple;
    begin
     try
      calltest();
      except
      on e: EArgumentException do
         begin
           calltest();
         end;
      on Exception do
         begin
            calltest();
         end
      else
         begin
            calltest;
         end;
     end;
 end;

");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 1);

  for each matching GV : CGGlobalFunctionDefinition in lunit.Globals index i do
    begin
    var func := GV.Function;
    case i of
      0 : begin
        Assert.AreEqual(func.Statements.Count, 1);
      end;
    end;
  end;
end;



end.