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


  TProblem_VarTypes = class( ISingleProbSolver)
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
    property CheckTyp : eEleCheck read eEleCheck.eVarsWithTypes;
  end;

  TProblem_TypesInMethods = class( ISingleProbSolver)
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
   property CheckTyp : eEleCheck read eEleCheck.eTypesInMethods;
 end;


  TProblem_Asm = class( ISingleProbSolver)
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
   property CheckTyp : eEleCheck read eEleCheck.eAsm;
 end;

implementation


method TProblem_With.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
begin
  const cMethodTypes : array of SNT = [SNT.ntImplementation, SNT.ntMethod, SNT.ntStatements, SNT.ntWith];
  var ltemp := NodeSolver.getNodeArrayAll(cMethodTypes, syntaxTree);
  Result :=   ltemp:Count > 0;
  if result then
    for each child in ltemp do
      ProblemLog.Problem_At(CheckTyp, child.Line, child.Col);
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
      ProblemLog.Problem_At(CheckTyp, node.Line, node.Col, node.ParentNode.AttribName);
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
        ProblemLog.Problem_At(CheckTyp, lmethod.Line, lmethod.Col, $" {node.ParentNode.AttribName}.{lmethod.AttribName}");
      end;
  end;
end;

method TProblem_MultiContructors.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
begin
  result := false;
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
        begin
           ProblemLog.Problem_At(CheckTyp, lMethod.Line, lMethod.Col,  $" {lClass.ParentNode.AttribName}.{lMethod.AttribName}" );
          result := true;
        end;
      end;
  end;
end;

method TProblem_MoreThanOneClass.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
begin
 var Nodes := NodeSolver.getPublicClass(syntaxTree);
  result := Nodes.Count > 1;
  if result then
    for  each node in Nodes do
      ProblemLog.Problem_At(CheckTyp, node.Line, node.Col, node.ParentNode.AttribName);
end;


method TProblem_InterFaceAndImplement.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
begin
  result := false;
  var lInterfaces := NodeSolver.getPublicTypes(syntaxTree, 'interface');
  if lInterfaces.Count = 0 then exit  false;
  var lClasses := NodeSolver.getPublicClass(syntaxTree);
  lClasses.Add(NodeSolver.getImplClass(syntaxTree).ToArray);
  if lClasses.Count = 0 then  exit false;

  lOuterLoop:  for lInterface in lInterfaces do
    begin  // Yes there are Interfaces so we will check
  // We now know the name in lInterface to check
  // Pick up the Typ Nodes from Classes so
    for lClass in lClasses do
      begin
      var lTypes := NodeSolver.getNodeArray(SNT.ntType, lClass);
      for lType in lTypes do
        if  String.EqualsIgnoringCaseInvariant( lType.AttribName ,  lInterface.ParentNode.AttribName )then
        begin
          ProblemLog.Problem_At(CheckTyp, lType.Line, lType.Col, $" {lClass.ParentNode.AttribName}({lType.AttribName})");
          result := true;
          continue lOuterloop;
        end;
    end;
  end;
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
     ]; //
  var lConstants := NodeSolver.getNodeArrayAll(cMethodTypes, syntaxTree);
  result := lConstants.Count > 0;

  if result then
    for each child in lConstants do
      ProblemLog.Problem_At(CheckTyp, child.Line, child.Col, child.ParentNode.ParentNode.FindNode(TSyntaxNodeType.ntName):AttribName);

//  if result then exit(true);

  cMethodTypes := [ //
  SNT.ntImplementation, //
     SNT.ntConstants,
     SNT.ntConstant,
     SNT.ntValue,
     SNT.ntRecordConstant]; //,

  lConstants := NodeSolver.getNodeArrayAll(cMethodTypes, syntaxTree);
  result := result or (lConstants.Count > 0);

  if result then
    for each child in lConstants do
      ProblemLog.Problem_At(CheckTyp, child.Line, child.Col, child.ParentNode.ParentNode.FindNode(TSyntaxNodeType.ntName):AttribName);

end;

method TProblem_VariantRecord.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver: ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
begin
  result := false;
  var lRecords := NodeSolver.getPublicRecord(syntaxTree);
  for lRecord in lRecords do
    if NodeSolver.getNodeArray(SNT.ntVariantSection, lRecord).Count > 0 then
    begin
      result := true;
      ProblemLog.Problem_At(CheckTyp, lRecord.Line, lRecord.Col, lRecord.ParentNode.AttribName);
    end;
end;

method TProblem_ClassInImplementation.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver: ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
begin
  var lClasses := NodeSolver.getImplClass(syntaxTree);
  result := lClasses.Count > 0;
  if result  then
    for each child in lClasses do
      ProblemLog.Problem_At(CheckTyp, child.Line, child.Col, child.ParentNode.AttribName);

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
  result := Nodes.Count > 0;
  if result then
    for each child in Nodes do
      ProblemLog.Problem_At(CheckTyp, child.Line, child.Col);

end;

method TProblem_VarTypes.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver: ISyntaxNodeSolver; ProblemLog: IProblem_Log): Boolean;
begin
  result := false;
  var Nodes := syntaxTree.FindAllNodes(SNT.ntVariable);

  if Nodes:Count > 0 then
  begin
    for each child in Nodes do
      begin
      var lnode := child.FindNode(TSyntaxNodeType.ntType);
      if assigned (lnode) and lnode.HasChildren then
      begin
           // Allow Array Types
        if (lnode.AttribType <> '') {and (lnode.AttribType.ToLower <> 'array')} then
        begin

          case lnode.AttribType.ToLower of
            'array' : begin

              // here we  check for the finalType of a Array
              loop  begin
                var lnodetemp := lnode.FindNode(TSyntaxNodeType.ntType);
                if not assigned(lnodetemp) then break;
                lnode := lnodetemp;
                if not lnode.AttribType.ToLower.Equals('array') then
                  break;
              end;
              if lnode.HasChildren then
              begin
                var varname := child.FindNode(TSyntaxNodeType.ntName):AttribName;
                 {$IF LOG}
                writeLn;
                writeLn($" ***** {varname} *****");
                writeLn(TSyntaxTreeWriter.ToXML(lnode, true));
                writeLn;
                writeLn($" ===== End ***** {varname} *****");
                writeLn;
                {$ENDIF}
                ProblemLog.Problem_At(CheckTyp, child.Line, child.Col, varname);
                result := true;


              end;
            end;
            else
              begin
                {$IF LOG}
                writeLn(TSyntaxTreeWriter.ToXML(lnode, true));
                writeLn('==========================');
                writeLn;
                {$ENDIF}
                ProblemLog.Problem_At(CheckTyp, child.Line, child.Col, child.FindNode(TSyntaxNodeType.ntName).AttribName);
                result := true;
              end;
          end;
        end;
      end;
    end;
  end;
end;

method TProblem_TypesInMethods.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver: ISyntaxNodeSolver; ProblemLog: IProblem_Log): Boolean;
begin
  result := false;
  var Nodes :=  NodeSolver.getNodeArrayAll([TSyntaxNodeType.ntImplementation, TSyntaxNodeType.ntMethod], syntaxTree);
  for each child in Nodes do
    begin
     for each ltype in child.FindAllNodes(TSyntaxNodeType.ntTypeDecl) do
       begin
         result := true;
         ProblemLog.Problem_At(CheckTyp, ltype.Line, ltype.Col, ltype.AttribName);
       end;
    end;
end;

method TProblem_Asm.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver: ISyntaxNodeSolver; ProblemLog: IProblem_Log): Boolean;
begin
  result := false;
  var Nodes :=  NodeSolver.getNodeArrayAll([TSyntaxNodeType.ntImplementation, TSyntaxNodeType.ntMethod], syntaxTree);
  lOuter: for each child in Nodes do
    begin
    var lAsm := child.FindAllNodes(TSyntaxNodeType.ntAsmStatement);
    for each ltype in lAsm do
      begin

       {$IF LOG}
       writeLn(TSyntaxTreeWriter.ToXML(ltype, true));
       writeLn('==========================');
       writeLn;
        {$ENDIF}
      result := true;
      ProblemLog.Problem_At(CheckTyp, ltype.Line, ltype.Col, child.Findnode(TSyntaxNodeType.ntName):AttribName);
      continue louter;
    end;
  end;
end;



end.