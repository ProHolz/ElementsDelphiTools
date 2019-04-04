namespace ProHolz.SourceChecker;

interface

uses
  RemObjects.Elements.EUnit,
  ProHolz.Ast;

type
  TestPasFile = public class(Test)
  private
  protected
  public
    method FirstTest;
  end;

implementation

method TestPasFile.FirstTest;
begin
 Var PasFile := new tPasSource('Test', 'D:\Test');
 Check.AreEqual(PasFile.Problems.Count, 0 );
  PasFile.AddProblem(eEleCheck.eDfm);
  Check.AreEqual(PasFile.Problems.Count, 1);

  PasFile.AddProblem(eEleCheck.eWith);
  Check.AreEqual(PasFile.Problems.Count, 2);

  PasFile.AddProblem(eEleCheck.eInitializations, 10, 88);
  Check.AreEqual(PasFile.Problems.Count, 3);

end;

end.