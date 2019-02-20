namespace ProblemChecker;
interface

type
  FileProbs = public class
    public
      constructor (aLine, aPos : Integer; const aName : String = '');
      property Line : Integer;
      property Pos : Integer;
      property Name : String;
  end;


  FileProbList = public class(IProblem_Log)
  private
    method getItem(&index: eEleCheck): List<FileProbs>;
 fValues : Dictionary<eEleCheck, List<FileProbs>>;
  protected
  public
    constructor();
    method Problem_At(Check: eEleCheck; Line: Integer; Pos: Integer; const Name: String := '');
    property Probs[index : eEleCheck] : List<FileProbs> read getItem; default;
  end;

implementation

constructor FileProbs(aLine: Integer; aPos: Integer; const aName: String := '');
begin
  Line := aLine;
  Pos := aPos;
  Name := aName;
end;

constructor FileProbList;
begin
  fValues := new Dictionary<eEleCheck,List<FileProbs>>;

end;

method FileProbList.getItem(&index: eEleCheck): List<FileProbs>;
begin
  if not fValues.ContainsKey(&index) then
    fValues.Add(&index, new List<FileProbs>);
  result := fValues[&index];
end;

method FileProbList.Problem_At(Check: eEleCheck; Line: Integer; Pos: Integer; const Name: String := '');
begin
  getItem(Check).Add(new FileProbs(Line, Pos, Name));
end;




end.