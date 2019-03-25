namespace ProHolz.SourceChecker;

interface

uses
  RemObjects.Elements.EUnit,
  ProblemChecker;

type
  TestProbListsClass = public class(Test)
  private
  protected
  public
    method FirstTest;
  end;

implementation

method TestProbListsClass.FirstTest;
begin
  var Probs := new FileProbList();
  for lcheck :eEleCheck := low(eEleCheck) to high(eEleCheck) do
   Check.AreEqual(Probs[lcheck].Count, 0);


  for lcheck :eEleCheck := low(eEleCheck) to high(eEleCheck) do
    Probs.Problem_At(lcheck, 10, 20, 'Test');


  for lcheck :eEleCheck := low(eEleCheck) to high(eEleCheck) do
    Check.AreEqual(Probs[lcheck].Count, 1);


  for lcheck :eEleCheck := low(eEleCheck) to high(eEleCheck) do
    Probs.Problem_At(lcheck, 10, 20, 'Test');


  for lcheck :eEleCheck := low(eEleCheck) to high(eEleCheck) do
    Check.AreEqual(Probs[lcheck].Count, 2);

  Check.AreEqual(Probs[eEleCheck.eInitializations].Item[1].Pos, 20);
  Check.AreEqual(Probs[eEleCheck.eInitializations].Item[1].Line, 10);
  Check.AreEqual(Probs[eEleCheck.eInitializations].Item[1].Name, 'Test');

end;

end.