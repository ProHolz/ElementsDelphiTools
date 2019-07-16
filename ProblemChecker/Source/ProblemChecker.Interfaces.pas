namespace ProHolz.SourceChecker;
uses ProHolz.Ast;
type
  //tcheckProblems = reference to function(const syntaxTree: TSyntaxNode): boolean;

  IProblemChecker = interface
    method Check(const syntaxTree: TSyntaxNode): Boolean;
    method FoundProblems: Boolean;
    method GetProblemsText: String;
  end;

  ISyntaxNodeSolver = interface
  // Defaults
   method GetNode(aNodetype: TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNode;
   method GetNodeArray(aNodetype: TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNodeList;
   method GetNodeArrayAll(aNodetypes: array of TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNodeList;
   method GetNodeGlobArray(aNodetype: TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNodeList;

  // Helper
    method GetPublicTypes(const aNode: TSyntaxNode; const aTypename : String; const amatchname : Boolean = false):TSyntaxNodeList;
    method GetImplTypes(const aNode: TSyntaxNode; const aTypename : String; const amatchname : Boolean = false): TSyntaxNodeList;

    method GetPublicClass(const aNode: TSyntaxNode): TSyntaxNodeList;
    method GetPublicRecord(const aNode: TSyntaxNode): TSyntaxNodeList;
    method GetImplClass(const aNode: TSyntaxNode): TSyntaxNodeList;

  end;

  IProblem_Log = interface
    method Problem_At(Check : eEleCheck; Line : Integer; Pos : Integer; const Name : String = '');
  end;

  ISingleProbSolver = interface
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean;
    property CheckTyp : eEleCheck read;
  end;


end.