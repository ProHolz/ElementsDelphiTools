namespace ProHolz.Ast;

type
  TParseProblemType = public enum(ptCantFindFile, ptCantOpenFile, ptCantParseFile);

  TParseProblemInfo = public record
  public
    constructor();
    begin

    end;

    class  method Create(aProblemType: TParseProblemType; aFilename : String; aDescription : String) : TParseProblemInfo;
    begin
      result := new TParseProblemInfo();
      result.ProblemType := aProblemType;
      result.FileName := aFilename;
      result.Description := aDescription;
    end;

    property  ProblemType: TParseProblemType read private write;
    property FileName   : String read private write;
    property Description: String read private write;

  end;

  TParseProblems = public class(List<TParseProblemInfo>)
  public
    constructor();
    begin
      inherited constructor();
    end;

    method LogProblem(problemType: TParseProblemType; const fileName, description: String);
    begin
      Add(TParseProblemInfo.Create(problemType, fileName, description));
    end;

  end;


end.