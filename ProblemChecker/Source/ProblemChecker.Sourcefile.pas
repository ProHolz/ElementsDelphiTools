namespace ProHolz.SourceChecker;

   // Shortstrings check String[12] and Shortstring?
type

  tProblempos = record
   private
    Line : Integer;
    Pos  : Integer;
    Name : String;
    public
    constructor (aLine, aPos : Integer; aName : String);
    begin
      Line := aLine;
      Pos := aPos;
      Name := aName;
    end;

    method GetProbEntry : String;
    begin
      exit $"{Name:Trim} [{Line}, {Pos}]".Trim;
    end;

  end;

  tPropPosList = List<tProblempos>;
  tPropsFile = Dictionary<eEleCheck, tPropPosList>;

//  setEleCheck = Dictionary<eEleCheck, String>;

  tPasSource = class(IProblem_Log)
   private
     fData : tPropsFile;

   public
    constructor();
    begin
      inherited;
      fData := new tPropsFile();
    end;

    constructor (const aFilename : String; aFilePath : String);
    begin
      constructor ();
      FileName := aFilename:ToLower;
      FilePath := aFilePath:ToLower;
    end;

    method AddProblem(Prob : eEleCheck; Line : Integer; Pos : Integer);
    begin
      AddProblem(Prob);
      var ltemp := new tProblempos(Line, Pos, nil);
      fData[Prob].Add(ltemp);



      //var msg := String.Format('Line: {0} Pos{1} , {2} ', [Line, Pos, cEleProbsnames[Prob]]);
      //Problems.Add(Prob, msg);
    end;

    method AddProblem(Prob : eEleCheck);
    begin
     // var msg := cEleProbsnames[Prob];
      if not fData.ContainsKey(Prob) then
        fData.Add(Prob, new tPropPosList());
    end;

    method Problem_At(aCheck : eEleCheck; Line : Integer; Pos : Integer; const Name : String := '');
    begin
      AddProblem(aCheck);
      var ltemp := new tProblempos(Line, Pos, Name);
      fData[aCheck].Add(ltemp);
    end;

    method GetProblemsPos(aCheck : eEleCheck) : String;
    begin
      result := nil;
      if fData.ContainsKey(aCheck) then
       begin
         var ls := new StringBuilder;
         ls.Append('  ');
         ls.Append(cEleProbsnames[aCheck]);
         ls.Append($" ({fData[aCheck].Count})");
         var comma := '   ';
         for each pos in fData[aCheck] do
          begin
             ls.Append( comma);
             ls.Append(pos.GetProbEntry);
            comma := ' ,';
          end;
        exit ls.ToString;
       end;

    end;



    property FileName: String ;
    property FilePath: String ;
    property Problems: tPropsFile read fData;
  end;

  tProbsList = Dictionary<String, tPasSource>;

end.