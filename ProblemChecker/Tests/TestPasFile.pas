namespace ProblemChecker;

interface

uses
  RemObjects.Elements.EUnit,
  PascalParser;

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
  PasFile.Problems.Add(eEleCheck.eDfm, cEleProbsnames[eEleCheck.eDfm]);
  Check.AreEqual(PasFile.Problems.Count, 1);

  PasFile.Problems.Add(eEleCheck.eWith, cEleProbsnames[eEleCheck.eDfm]);
  Check.AreEqual(PasFile.Problems.Count, 2);

  PasFile.AddProblem(eEleCheck.eInitializations, 10, 88);
  Check.AreEqual(PasFile.Problems.Count, 3);

end;

end.