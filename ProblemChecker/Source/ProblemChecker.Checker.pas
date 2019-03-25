namespace ProHolz.SourceChecker;
uses ProHolz.Ast;
interface
type
  TProblem_Dummy = class( ISingleProbSolver)
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean; empty;
    property CheckTyp : eEleCheck read eEleCheck.eDummy;
  end;

 // Simple checks

  TProblem_Initialization = class( ISingleProbSolver)
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
    property CheckTyp : eEleCheck read eEleCheck.eInitializations;
  end;

  TProblem_Finalization = class( ISingleProbSolver)
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;

    property CheckTyp : eEleCheck read eEleCheck.eFinalizations;
  end;

  TProblem_MoreThanOneClass = class( ISingleProbSolver)
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
      property CheckTyp : eEleCheck read eEleCheck.eMoreThenOneClass;
    end;

  TProblem_Enums = class( ISingleProbSolver)
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
    property CheckTyp : eEleCheck read eEleCheck.ePublicEnums;
  end;


  TProblem_GlobVars = class( ISingleProbSolver)
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
    property CheckTyp : eEleCheck read eEleCheck.ePublicVars;
  end;

  TProblem_GlobMethods = class( ISingleProbSolver)
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
    property CheckTyp : eEleCheck read eEleCheck.eGlobalMethods;

  end;

  TProblem_Destructors = class( ISingleProbSolver)
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
    property CheckTyp : eEleCheck read eEleCheck.eDestructors;
  end;

  TProblem_MultiContructors = class( ISingleProbSolver)
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
    property CheckTyp : eEleCheck read eEleCheck.eMultiConstructors;
  end;


  TProblem_ClassInImplementation = class( ISingleProbSolver)
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
    property CheckTyp : eEleCheck read eEleCheck.eClassDeclImpl;
  end;

  TProblem_InterFaceAndImplement = class( ISingleProbSolver)
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
    property CheckTyp : eEleCheck read eEleCheck.eInterfaceandImplement;
  end;

  TProblem_HasConstRecords = class( ISingleProbSolver)
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
    property CheckTyp : eEleCheck read eEleCheck.eConstRecord;
  end;


  TProblem_VariantRecord = class( ISingleProbSolver)
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
    property CheckTyp : eEleCheck read eEleCheck.eVariantRecord;
  end;



  TProblem_With = class( ISingleProbSolver)
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
   property CheckTyp : eEleCheck read eEleCheck.eWith;
 end;


  TProblem_DFM = class( ISingleProbSolver)
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
   property CheckTyp : eEleCheck read eEleCheck.eDfm;
 end;

  TProblem_RES = class( ISingleProbSolver)
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
    property CheckTyp : eEleCheck read eEleCheck.eHasResources;
  end;


  TProblem_ResString = class( ISingleProbSolver)
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
     property CheckTyp : eEleCheck read eEleCheck.eHasResourceStrings;
   end;

implementation


method TProblem_With.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
begin
  const cMethodTypes : array of SNT = [SNT.ntImplementation, SNT.ntMethod, SNT.ntStatements, SNT.ntWith];
  Result :=   NodeSolver.getNodeArrayAll(cMethodTypes, syntaxTree):Count > 0;
end;

method TProblem_Initialization.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
begin
  var Node  := NodeSolver.getNode(SNT.ntInitialization, syntaxTree);

  result := Node <> nil;
  if result then
    ProblemLog.Problem_At(CheckTyp, Node.Line, Node.Col);
end;

method TProblem_Finalization.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
begin
  var node := NodeSolver.getNode(SNT.ntFinalization, syntaxTree);
  result := node <> nil;
  if result then
    ProblemLog.Problem_At(CheckTyp, node.Line, node.Col);
end;

method TProblem_Enums.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
begin
  var Lenums := NodeSolver.getPublicTypes(syntaxTree,'enum', false);
   // Todo add Check for ScopedEnums
  result := Lenums.Count > 0;
  if result then
   begin
    result := false;
    for node in Lenums do
     begin
      if node.GetAttribute(TAttributeName.anVisibility) = 'scoped' then
       continue;
      result := true;
      ProblemLog.Problem_At(CheckTyp, node.Line, node.Col);
     end;
   end;
end;

method TProblem_GlobVars.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
begin
  var lBase := NodeSolver.getNode(SNT.ntInterface, syntaxTree);
  var Lenums := NodeSolver.getNodeArray(SNT.ntVariables, lBase);
  result := Lenums.Count > 0;
  if result then
    for node in Lenums do
      ProblemLog.Problem_At(CheckTyp, node.Line, node.Col);
end;

method TProblem_GlobMethods.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
begin
  var lBase := NodeSolver.getNode(SNT.ntInterface, syntaxTree);
  var Nodes := NodeSolver.getNodeArray(SNT.ntMethod, lBase);
  result := Nodes:Count > 0;
  if result then
    for Node in Nodes do
    ProblemLog.Problem_At(CheckTyp, Node.Line, Node.Col);
end;

method TProblem_Destructors.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
begin
  Result := false;
  var Lclasses := NodeSolver.getPublicClass(syntaxTree);
  for each node in Lclasses do
    begin
    //  [SNT.ntPublic, SNT.ntMethod]
    var lMethods := NodeSolver.getNodeArrayAll([SNT.ntPublic, SNT.ntMethod], node);
    for lmethod in lMethods do
      if  String.EqualsIgnoringCaseInvariant(lmethod.GetAttribute(TAttributeName.anKind) , 'destructor') then
        begin
         result := true;
         ProblemLog.Problem_At(CheckTyp, lmethod.Line, lmethod.Col);
        end;
    end;
end;

method TProblem_MultiContructors.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
begin
  const cMethodTypes = [SNT.ntPublic, SNT.ntMethod];
  var lClasses := NodeSolver.getPublicClass(syntaxTree);
  for lClass in lClasses do
    begin
    var lres := 0;
    var lMethods := NodeSolver.getNodeArrayAll(cMethodTypes, lClass);
    for lMethod in lMethods do
      if  String.EqualsIgnoringCaseInvariant( lMethod.GetAttribute(TAttributeName.anKind) , 'constructor') then
      begin
        inc(lres);
        if lres > 1 then
          exit true;
      end;
  end;
  exit false;
end;

method TProblem_MoreThanOneClass.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
begin

  var Nodes := NodeSolver.getPublicClass(syntaxTree);
  result := Nodes.Count > 0;
  if result then
    for  each node in Nodes do
      ProblemLog.Problem_At(CheckTyp, node.Line, node.Col);
end;


method TProblem_InterFaceAndImplement.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
begin
  var lInterfaces := NodeSolver.getPublicTypes(syntaxTree, 'interface');
  if lInterfaces.Count = 0 then exit  false;
  var lClasses := NodeSolver.getPublicClass(syntaxTree);
  lClasses.Add(NodeSolver.getImplClass(syntaxTree).ToArray);
  if lClasses.Count = 0 then  exit false;

  for lInterface in lInterfaces do
    begin  // Yes there are Interfaces so we will check
  // We now know the name in lInterface to check
  // Pick up the Typ Nodes from Classes so
  for lClass in lClasses do
    begin
    var lTypes := NodeSolver.getNodeArray(SNT.ntType, lClass);
    for lType in lTypes do
      if  String.EqualsIgnoringCaseInvariant( lType.GetAttribute(TAttributeName.anName) ,  lInterface.ParentNode.GetAttribute(TAttributeName.anName) )then
        exit true;

  end;
end;
  exit false;
end;



method TProblem_HasConstRecords.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver: ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
begin
  var
  cMethodTypes: Array of SNT;

  cMethodTypes := [ //
  SNT.ntInterface, //
     SNT.ntConstants,
     SNT.ntConstant,
     SNT.ntValue
     ,SNT.ntRecordConstant
     ,SNT.ntField
     ,SNT.ntExpression
     ]; //
  var lConstants := NodeSolver.getNodeArrayAll(cMethodTypes, syntaxTree);
  result := lConstants.Count > 0;
  if result then exit(true);

  cMethodTypes := [ //
  SNT.ntImplementation, //
     SNT.ntConstants,
     SNT.ntConstant,
     SNT.ntValue,
     SNT.ntRecordConstant,
     SNT.ntField,
     SNT.ntExpression]; //
  lConstants := NodeSolver.getNodeArrayAll(cMethodTypes, syntaxTree);
  result := lConstants.Count > 0;

end;

method TProblem_VariantRecord.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver: ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
begin
  result := false;
  var lRecords := NodeSolver.getPublicRecord(syntaxTree);
  for lRecord in lRecords do
    if NodeSolver.getNodeArray(SNT.ntVariantSection, lRecord).Count > 0 then exit(true);
end;

method TProblem_ClassInImplementation.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver: ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
begin
  result := NodeSolver.getImplClass(syntaxTree).Count > 0;
end;

method TProblem_DFM.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver: ISyntaxNodeSolver; ProblemLog: IProblem_Log): Boolean;
begin
  result := false;
  var Nodes := NodeSolver.getNodeGlobArray(SNT.ntCompilerDirective, syntaxTree);
  if Nodes.Count > 0 then
  begin
    for each node in Nodes do
     begin
      if node.AttribType = 'R' then
       if node.AttribKind.Trim.ToUpper.EndsWith('.DFM') then exit (true);
     end;
  end;

end;

method TProblem_RES.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver: ISyntaxNodeSolver; ProblemLog: IProblem_Log): Boolean;
begin
  result := false;

  var Nodes := NodeSolver.getNodeGlobArray(SNT.ntCompilerDirective, syntaxTree);
  if Nodes.Count > 0 then
  begin
    for each node in Nodes do
      begin
      if node.AttribType = 'R' then
      if node.AttribKind.Trim.ToUpper.EndsWith('.RES') then exit (true);
    end;
  end;

end;

method TProblem_ResString.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver: ISyntaxNodeSolver; ProblemLog: IProblem_Log): Boolean;
begin
  result := false;
  var Nodes := syntaxTree.FindAllNodes(SNT.ntResourceString);
  result := Nodes:Count > 0
end;


end.