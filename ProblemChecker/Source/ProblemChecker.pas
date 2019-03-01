﻿namespace ProblemChecker;

interface
uses PascalParser;
type
  // Alias shoud be in PascalParser
  SNT = TSyntaxNodeType;
  TSyntaxNodeList = List<TSyntaxNode>;

type
  TProblemChecker = sealed class( IProblemChecker, IProblem_Log)
  private
    fProbsList: tProbsList;
    fProbSolver : Dictionary<eEleCheck, ISingleProbSolver>;
    fResolver : ISyntaxNodeSolver;
  private // Interface
    method check(const syntaxTree: TSyntaxNode): Boolean;
    method checkParseit(const aFilename: String): Boolean;
    method FoundProblems: Boolean;
    method GetProblemsText: String;

    method Problem_At(aCheck : eEleCheck; Line : Integer; Pos : Integer; const Name : String := '');

  public
    constructor (aEleCheck : sequence of eEleCheck);
  end;
implementation
{ TProblemChecker }

constructor TProblemChecker(aEleCheck : sequence of eEleCheck);
begin
  inherited Create;
  fProbsList := new tProbsList();
  fProbSolver := new Dictionary<eEleCheck, ISingleProbSolver>;
  fResolver := new TSyntaxNodeResolver();
  // Prepare the solvers
  for each check  in aEleCheck  do
    begin
    case check of
      eEleCheck.eDfm                    : fProbSolver.Add(check, new TProblem_DFM);
      eEleCheck.eWith                   : fProbSolver.Add(check, new TProblem_With);
      eEleCheck.eInitializations        : fProbSolver.Add(check, new TProblem_Initialization);
      eEleCheck.eFinalizations          : fProbSolver.Add(check, new TProblem_Finalization);
      eEleCheck.ePublicVars             : fProbSolver.Add(check, new TProblem_GlobVars);
      eEleCheck.eGlobalMethods          : fProbSolver.Add(check, new TProblem_GlobMethods);
      eEleCheck.eDestructors            : fProbSolver.Add(check, new TProblem_Destructors);
      eEleCheck.eMultiConstructors      : fProbSolver.Add(check, new TProblem_MultiContructors);
      eEleCheck.eMoreThenOneClass       : fProbSolver.Add(check, new TProblem_MoreThanOneClass);
      eEleCheck.eInterfaceandImplement  : fProbSolver.Add(check, new TProblem_InterFaceAndImplement);
      eEleCheck.eVariantRecord          : fProbSolver.Add(check, new TProblem_VariantRecord);
      eEleCheck.ePublicEnums            : fProbSolver.Add(check, new TProblem_Enums);
      eEleCheck.eClassDeclImpl          : fProbSolver.Add(check, new TProblem_ClassInImplementation);
      eEleCheck.eConstRecord            : fProbSolver.Add(check, new TProblem_HasConstRecords);
    end;
  end;

end;

  method TProblemChecker.check(const syntaxTree: TSyntaxNode): boolean;
  begin
    result := false;
    if (syntaxTree <> nil) and (syntaxTree.Typ = TSyntaxNodeType.ntUnit) then
    begin
      var factual := new tPasSource();
      factual.FileName := syntaxTree.GetAttribute(TAttributeName.anName);
      for check in fProbSolver.Values do
        begin
        if check.CheckForProblem(syntaxTree, fResolver, self) then
        begin
          factual.AddProblem(check.CheckTyp);
        end;
      end;
      if (factual.Problems.Count > 0) then
      begin
        fProbsList.Add(factual.FileName, factual);
        result := true;
      end;
    end;
  end;


  method TProblemChecker.checkParseit(const aFilename: string): boolean;
  begin
    if fProbSolver.ContainsKey(eEleCheck.eDfm) then
    begin
      if File.Exists(Path.ChangeExtension(aFilename, '.dfm')) then
      begin
        var lactual := new tPasSource();
        lactual.FileName := Path.GetFileNameWithoutExtension(aFilename);
        lactual.addProblem(eEleCheck.eDfm);
        fProbsList.Add(aFilename, lactual);
        exit false;
      end
      else exit true;
    end
  else exit true;
  end;


  method TProblemChecker.FoundProblems: boolean;
  begin
    result := fProbsList.Count > 0;
  end;



  method TProblemChecker.GetProblemsText: String;
  var
  ltext: StringBuilder;


  lArray : Array of String;

  begin
    if fProbsList.Count = 0 then
      exit('');

    ltext := new StringBuilder();
    lArray := fProbsList.Keys.ToArray;

    for lname in lArray do
      begin

      for lact in fProbsList.Values do
        begin
        ltext.AppendLine(lact.FileName + '.pas');
        for lLoop in lact.Problems.Keys do
          ltext.AppendLine('   ' + cEleProbsnames[lLoop]);
        ltext.AppendLine('====').AppendLine;
      end;
    end;

      result := ltext.ToString;

    end;

method TProblemChecker.Problem_At(aCheck: eEleCheck; Line: Integer; Pos: Integer; const Name : String := '');
begin

end;



end.