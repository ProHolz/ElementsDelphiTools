namespace ProHolz.SourceChecker;
uses ProHolz.Ast;
type
  //tcheckProblems = reference to function(const syntaxTree: TSyntaxNode): boolean;

  IProblemChecker = interface
    method check(const syntaxTree: TSyntaxNode): Boolean;
    method FoundProblems: Boolean;
    method GetProblemsText: String;
  end;

  ISyntaxNodeSolver = interface
  // Defaults
   method getNode(aNodetype: TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNode;
   method getNodeArray(aNodetype: TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNodeList;
   method getNodeArrayAll(aNodetypes: array of TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNodeList;
   method getNodeGlobArray(aNodetype: TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNodeList;

  // Helper
    method getPublicTypes(const aNode: TSyntaxNode; const aTypename : String; const amatchname : Boolean = false):TSyntaxNodeList;
    method getImplTypes(const aNode: TSyntaxNode; const aTypename : String; const amatchname : Boolean = false): TSyntaxNodeList;

    method getPublicClass(const aNode: TSyntaxNode): TSyntaxNodeList;
    method getPublicRecord(const aNode: TSyntaxNode): TSyntaxNodeList;
    method getImplClass(const aNode: TSyntaxNode): TSyntaxNodeList;

  end;

  IProblem_Log = interface
    method Problem_At(Check : eEleCheck; Line : Integer; Pos : Integer; const Name : String = '');
  end;

  ISingleProbSolver = interface
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
    property CheckTyp : eEleCheck read;
  end;


end.