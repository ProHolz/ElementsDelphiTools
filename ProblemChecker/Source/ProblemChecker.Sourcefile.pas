namespace ProHolz.SourceChecker;

   // Shortstrings check String[12] and Shortstring?
type
  setEleCheck = Dictionary<eEleCheck, String>;

  //const
    //cEleAll = [low(eEleCheck).. high(eEleCheck)];
    //cEleAllNoDfm = [ewith .. high(eEleCheck)];


  tPasSource = class
   public
    constructor(); empty;

    constructor (const aFilename : String; aFilePath : String);
    begin
      FileName := aFilename:ToLower;
      FilePath := aFilePath:ToLower;
    end;

    method AddProblem(Prob : eEleCheck; Line : Integer; Pos : Integer);
    begin
      var msg := String.Format('Line: {0} Pos{1} , {2} ', [Line, Pos, cEleProbsnames[Prob]]);
      Problems.Add(Prob, msg);
    end;

    method AddProblem(Prob : eEleCheck);
    begin
      var msg := cEleProbsnames[Prob];
      Problems.Add(Prob, msg);
    end;


    property FileName: String ;
    property FilePath: String ;
    property Problems: setEleCheck :=  new setEleCheck(); lazy;
  end;

  tProbsList = Dictionary<String, tPasSource>;

end.