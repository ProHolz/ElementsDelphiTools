namespace ProHolz.SourceChecker;

interface

uses
  RemObjects.Elements.EUnit,
  ProHolz.Ast;

type
  TestCheckers = public class(Test, IProblem_Log)
  private


    method prepareUnitWithType: TSyntaxNode;
    method prepareUnitWithInitFinal: TSyntaxNode;
    method Problem_At(Check : eEleCheck; Line : Integer; Pos : Integer; const Name : String = '');
    FSolver : ISyntaxNodeSolver;
    FGlobProbs : Integer;
  protected
  // method
  public
    method Setup; override;
    method SetupTest; override;
    method TestMoreThanOneClass;
    method TestInitialization;
    method TestFinalization;
    method TestEnums;
    method TestPublicGlobVars;
    method TestPublicGlobMethods;
    method TestMultiConstructors;
    method TestMultiDestructors;
    method TestClassInImplementation;
    method TestClassInterfacandImplementation;
    method TestConstRecord;
    method TestVariantRecord;
    method TestWithUse;
    method TestDFM;
    method TestResource;
    method TestVarTypes;
    method TestTypesMethods;
    method TestASM;
    method TestTypeTypes;

  end;

implementation

uses
  ProHolz.Ast;


  method TestCheckers.Problem_At(Check: eEleCheck; Line: Integer; Pos: Integer; const Name : String = '');
  begin
    inc(FGlobProbs);
    writeLn($" Typ: {Check.ToString}  Line {Line}/{Pos} {Name}");
  end;



  method TestCheckers.SetupTest;
  begin
    FSolver := new TSyntaxNodeResolver();
  end;

  method TestCheckers.Setup;
  begin
 // Check.IsTrue(false);
  FGlobProbs := 0;
end;

method TestCheckers.prepareUnitWithType: TSyntaxNode;
begin
  result := TPasSyntaxTreeBuilder.RunWithString(cTest1, false);
end;


method TestCheckers.prepareUnitWithInitFinal: TSyntaxNode;
begin
  result := TPasSyntaxTreeBuilder.RunWithString(cUnitInitFinal, false);
end;


method TestCheckers.TestMoreThanOneClass;
begin
  var lchecker := new TProblem_MoreThanOneClass() as ISingleProbSolver;
  Check.IsTrue( lchecker.CheckForProblem(prepareUnitWithType, FSolver, self));
  Check.AreEqual(FGlobProbs, 2);
end;

method TestCheckers.TestInitialization;
begin
  var lchecker := new TProblem_Initialization() as ISingleProbSolver;
  Check.IsFalse( lchecker.CheckForProblem(prepareUnitWithType, FSolver, self));
  Check.IsTrue( lchecker.CheckForProblem(prepareUnitWithInitFinal, FSolver, self));

end;

method TestCheckers.TestFinalization;
begin
  var lchecker := new TProblem_Finalization() as ISingleProbSolver;
  Check.IsFalse( lchecker.CheckForProblem(prepareUnitWithType, FSolver, self));
  Check.IsTrue( lchecker.CheckForProblem(prepareUnitWithInitFinal, FSolver, self));
end;

method TestCheckers.TestEnums;
begin
  var lchecker := new TProblem_Enums() as ISingleProbSolver;
  Check.IsFalse( lchecker.CheckForProblem(prepareUnitWithType, FSolver, self));
  Check.IsTrue( lchecker.CheckForProblem(prepareUnitWithInitFinal, FSolver, self));
end;

method TestCheckers.TestPublicGlobVars;
begin
  var lchecker := new TProblem_GlobVars() as ISingleProbSolver;
  Check.IsFalse( lchecker.CheckForProblem(prepareUnitWithType, FSolver, self));
  Check.IsTrue( lchecker.CheckForProblem(prepareUnitWithInitFinal, FSolver, self));
end;

method TestCheckers.TestPublicGlobMethods;
begin
  var lchecker := new TProblem_GlobMethods() as ISingleProbSolver;
  Check.IsFalse( lchecker.CheckForProblem(prepareUnitWithType, FSolver, self));
  Check.IsTrue( lchecker.CheckForProblem(prepareUnitWithInitFinal, FSolver, self));
end;

method TestCheckers.TestMultiConstructors;
begin
  var lchecker := new TProblem_MultiContructors() as ISingleProbSolver;

  var  lClassCount := FSolver.getPublicClass(prepareUnitWithType).Count;
  Check.AreEqual(lClassCount, 2);

  Check.IsTrue( lchecker.CheckForProblem(prepareUnitWithType, FSolver, self));
  Check.IsFalse( lchecker.CheckForProblem(prepareUnitWithInitFinal, FSolver, self));
end;

method TestCheckers.TestMultiDestructors;
begin
  var lchecker := new TProblem_Destructors() as ISingleProbSolver;
  Check.IsTrue( lchecker.CheckForProblem(prepareUnitWithType, FSolver, self));
  Check.IsFalse( lchecker.CheckForProblem(prepareUnitWithInitFinal, FSolver, self));
  Check.AreEqual(FGlobProbs, 1);
end;

method TestCheckers.TestClassInImplementation;
begin
  var lchecker := new TProblem_ClassInImplementation() as ISingleProbSolver;
  Check.IsTrue( lchecker.CheckForProblem(prepareUnitWithType, FSolver, self));
end;

method TestCheckers.TestClassInterfacandImplementation;
begin
  var lchecker := new TProblem_InterFaceAndImplement() as ISingleProbSolver;
  Check.IsTrue( lchecker.CheckForProblem(prepareUnitWithType, FSolver, self));
end;

method TestCheckers.TestConstRecord;
begin
  var lchecker := new TProblem_HasConstRecords() as ISingleProbSolver;
  Check.IsTrue( lchecker.CheckForProblem(prepareUnitWithType, FSolver, self));
end;

method TestCheckers.TestVariantRecord;
begin
  var lchecker := new TProblem_VariantRecord() as ISingleProbSolver;
  Check.IsFalse( lchecker.CheckForProblem(prepareUnitWithType, FSolver, self));
  Check.IsTrue( lchecker.CheckForProblem(TPasSyntaxTreeBuilder.RunWithString(cConstVarRec, false), FSolver, self));
end;

method TestCheckers.TestWithUse;
begin
  var lchecker := new TProblem_With() as ISingleProbSolver;
  Check.IsTrue( lchecker.CheckForProblem(prepareUnitWithType, FSolver, self));
end;


method TestCheckers.TestDFM;
begin
  var toCheck := TPasSyntaxTreeBuilder.RunWithString(cUnitWithResDFM, false);
  var lchecker := new TProblem_DFM() as ISingleProbSolver;
  Check.IsTrue( lchecker.CheckForProblem(toCheck, FSolver, self));
end;

method TestCheckers.TestResource;
begin
  var toCheck := TPasSyntaxTreeBuilder.RunWithString(cUnitWithResDFM, false);
  var lchecker := new TProblem_RES() as ISingleProbSolver;
  Check.IsTrue( lchecker.CheckForProblem(toCheck, FSolver, self));
end;

method TestCheckers.TestVarTypes;
begin
  var toCheck := TPasSyntaxTreeBuilder.RunWithString(cTestVarTypes, false);
  var lchecker := new TProblem_VarTypes() as ISingleProbSolver;
  Check.IsTrue( lchecker.CheckForProblem(toCheck, FSolver, self));

  // There ar 4 possible Problems in the Source
  Check.AreEqual(FGlobProbs, 4);
end;

method TestCheckers.TestTypesMethods;
begin
  var toCheck := TPasSyntaxTreeBuilder.RunWithString(cTestTypeMethods, false);
  var lchecker := new TProblem_TypesInMethods() as ISingleProbSolver;
  Check.IsTrue( lchecker.CheckForProblem(toCheck, FSolver, self));

  // There are 3 possible Problems in the Source
  Check.AreEqual(FGlobProbs, 3);
end;

method TestCheckers.TestASM;
begin
  var toCheck := TPasSyntaxTreeBuilder.RunWithString(cTestASMMethods, false);
  var lchecker := new TProblem_Asm() as ISingleProbSolver;
  Check.IsTrue( lchecker.CheckForProblem(toCheck, FSolver, self));

  // There are 1 possible Problems in the Source
  Check.AreEqual(FGlobProbs, 1);
end;

method TestCheckers.TestTypeTypes;
begin
  var toCheck := TPasSyntaxTreeBuilder.RunWithString(cTestTypeinType, false);
  var lchecker := new TProblem_TypeInTypes() as ISingleProbSolver;
  Check.IsTrue( lchecker.CheckForProblem(toCheck, FSolver, self));

  // There ar 4 possible Problems in the Source
  Check.AreEqual(FGlobProbs, 3);
end;


end.