namespace TestCodegen;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestTryExcept = public class(TestParserBase)
  private

  public

    method FirstTest;
    method TestEmptyTry;
    method TestEmptyFinally;

    method TestExceptnoStatement;
    method TestMixedTry;
    method TestFinally;
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

method TestTryExcept.TestFinally;
begin
  var lunit := BuildUnit(tbUnitType.implementation ,"
    procedure ProcSimple;
    begin
     try
      calltest();
       { Done }
    AddStatus('');

    asm jmp @1; db 0,'Inno Setup Compiler, Copyright (C) 1997-2019 Jordan Russell, '
                  db 'Portions Copyright (C) 2000-2019 Martijn Laan',0; @1:
                  end;
    { Note: Removing or modifying the copyright text is a violation of the
      Inno Setup license agreement; see LICENSE.TXT. }
      finally
      CallPreprocessorCleanupProc;


    if (WizardSmallImages <> nil) then begin
      for I := WizardSmallImages.Count-1 downto 0 do
        TStream(WizardSmallImages[I]).Free;
      WizardSmallImages.Free;
    end;
    if WizardImages <> nil then begin
      for I := WizardImages.Count-1 downto 0 do
        TStream(WizardImages[I]).Free;
      WizardImages.Free;
    end;

    FreeAndNil(InternalCompressProps);
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