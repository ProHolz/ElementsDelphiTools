namespace ProHolz.Ast;

type
  TParseProblemType = public enum(ptCantFindFile, ptCantOpenFile, ptCantParseFile);

  TParseProblemInfo = public record
  public
    constructor();
    begin

    end;

    constructor (aProblemType: TParseProblemType; aFilename : String; aDescription : String);
    begin
      constructor ();
      ProblemType := aProblemType;
      FileName := aFilename;
      Description := aDescription;
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

    method LogProblem(ProblemType: TParseProblemType; FileName: String; Description : String);
    begin
      Add(new TParseProblemInfo(ProblemType, FileName, Description));
    end;

  end;


end.