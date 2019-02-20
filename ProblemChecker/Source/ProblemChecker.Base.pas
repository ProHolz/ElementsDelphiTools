namespace Problemchecker;

interface
uses PascalParser;

type
  TSyntaxNodeResolver = class(ISyntaxNodeSolver)
  private
    method internGetTypes(const aNode: TSyntaxNode; const aInterface: Boolean; const aTypename: not nullable String; const amatchname: Boolean): TSyntaxNodeList; // ISyntaxNodeSolver

  private // Interface ISyntaxNodeSolver
    method getNode(aNodetype: TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNode;
    method getNodeArray(aNodetype: TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNodeList;
    method getNodeArrayAll(aNodetypes: array of TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNodeList;

    method getPublicTypes(const aNode: TSyntaxNode; const aTypename : not nullable String; const amatchname : Boolean = false):TSyntaxNodeList;
    method getImplTypes(const aNode: TSyntaxNode; const aTypename : not nullable String; const amatchname : Boolean = false): TSyntaxNodeList;
    method getPublicClass(const aNode: TSyntaxNode): TSyntaxNodeList;
    method getPublicRecord(const aNode: TSyntaxNode): TSyntaxNodeList;
    method getImplClass(const aNode: TSyntaxNode): TSyntaxNodeList;

  end;


implementation

method TSyntaxNodeResolver.internGetTypes(const aNode: TSyntaxNode; const aInterface : Boolean; const aTypename : not nullable String; const amatchname : Boolean): TSyntaxNodeList;
begin
  result := new TSyntaxNodeList();
  var lClasses := getNodeArrayAll(if aInterface then cPublicTypesInterface else cPublicTypesImplementation, aNode);
  for lClass in lClasses do
    if String.EqualsIgnoringCaseInvariant(
    lClass.GetAttribute(if amatchname then TAttributeName.anName else TAttributeName.anType),
     aTypename) then
      result.Add(lClass);

end;

method TSyntaxNodeResolver.getPublicTypes(const aNode: TSyntaxNode; const aTypename : not nullable String; const amatchname : Boolean): TSyntaxNodeList;
begin
  result := internGetTypes(aNode, true, aTypename, amatchname);
end;


method TSyntaxNodeResolver.getImplTypes(const aNode: TSyntaxNode;  const aTypename: not nullable String; const amatchname: Boolean): TSyntaxNodeList;
begin
  result := internGetTypes(aNode, false, aTypename, amatchname);

end;

method TSyntaxNodeResolver.getNode(aNodetype: TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNode;
begin
  Result  := aNode:FindNode(aNodetype);
end;

method TSyntaxNodeResolver.getNodeArray(aNodetype: TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNodeList;
begin
  result := new TSyntaxNodeList();
  for lNode in aNode:ChildNodes do
    if lNode.Typ = aNodetype then
      result.Add(lNode);
end;

method TSyntaxNodeResolver.getNodeArrayAll(aNodetypes: array of TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNodeList;
begin
  result := new TSyntaxNodeList();
  if length(aNodetypes) = 0 then exit(nil);
  if length(aNodetypes) = 1 then
    exit getNodeArray(aNodetypes[0], aNode) else
    begin
      var temp := getNodeArray(aNodetypes[0], aNode);
      var ltemp := new List<TSyntaxNodeType>();
      for i : Integer := 1 to high(aNodetypes) do
        ltemp.Add(aNodetypes[i]);
      for each node  in temp do
        begin
        var linner := getNodeArrayAll(ltemp.ToArray, node);
        result.Add(linner.toArray);
      end;
    end;
  end;


  method TSyntaxNodeResolver.getPublicClass(const aNode: TSyntaxNode): TSyntaxNodeList;
  begin
    result := getPublicTypes(aNode, 'class');
  end;

  method TSyntaxNodeResolver.getPublicRecord(const aNode: TSyntaxNode): TSyntaxNodeList;
  begin
    result := getPublicTypes(aNode, 'record');
  end;

  method TSyntaxNodeResolver.getImplClass(const aNode: TSyntaxNode): TSyntaxNodeList;
  begin
    result := getImplTypes(aNode, 'class');
  end;

end.