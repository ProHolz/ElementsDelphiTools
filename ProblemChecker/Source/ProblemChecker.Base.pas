namespace ProHolz.SourceChecker;

interface
uses ProHolz.Ast;

type
  TSyntaxNodeResolver = class(ISyntaxNodeSolver)
  private

    method InternGetTypes(const aNode: TSyntaxNode; const aInterface: Boolean; const aTypename: not nullable String; const amatchname: Boolean): TSyntaxNodeList; // ISyntaxNodeSolver

  private // Interface ISyntaxNodeSolver
    method GetNode(aNodetype: TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNode;
    method GetNodeArray(aNodetype: TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNodeList;
    method GetNodeArrayAll(aNodetypes: array of TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNodeList;
    method GetNodeGlobArray(aNodetype: TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNodeList;

    method GetPublicTypes(const aNode: TSyntaxNode; const aTypename : not nullable String; const amatchname : Boolean = false):TSyntaxNodeList;
    method GetImplTypes(const aNode: TSyntaxNode; const aTypename : not nullable String; const amatchname : Boolean = false): TSyntaxNodeList;
    method GetPublicClass(const aNode: TSyntaxNode): TSyntaxNodeList;
    method GetPublicRecord(const aNode: TSyntaxNode): TSyntaxNodeList;
    method GetImplClass(const aNode: TSyntaxNode): TSyntaxNodeList;

  end;


implementation

method TSyntaxNodeResolver.InternGetTypes(const aNode: TSyntaxNode; const aInterface : Boolean; const aTypename : not nullable String; const amatchname : Boolean): TSyntaxNodeList;
begin
  result := new TSyntaxNodeList();
  var lClasses := GetNodeArrayAll(if aInterface then cPublicTypesInterface else cPublicTypesImplementation, aNode);
  for lClass in lClasses do
    begin
    if String.EqualsIgnoringCase(
    lClass.GetAttribute(if amatchname then TAttributeName.anName else TAttributeName.anType),
     aTypename) then
      result.Add(lClass);

    if String.EqualsIgnoringCase(
    lClass.FindNode(TSyntaxNodeType.ntName):GetAttribute(if amatchname then TAttributeName.anName else TAttributeName.anType),
    aTypename) then
      result.Add(lClass);


    end;
  ensure
    result <> nil;
end;

method TSyntaxNodeResolver.GetPublicTypes(const aNode: TSyntaxNode; const aTypename : not nullable String; const amatchname : Boolean): TSyntaxNodeList;
begin
  result := InternGetTypes(aNode, true, aTypename, amatchname);
  ensure
    result <> nil;
end;


method TSyntaxNodeResolver.GetImplTypes(const aNode: TSyntaxNode;  const aTypename: not nullable String; const amatchname: Boolean): TSyntaxNodeList;
begin
  result := InternGetTypes(aNode, false, aTypename, amatchname);
  ensure
    result <> nil;
end;

method TSyntaxNodeResolver.GetNode(aNodetype: TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNode;
begin
  Result  := aNode:FindNode(aNodetype);
end;

method TSyntaxNodeResolver.GetNodeArray(aNodetype: TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNodeList;
begin
  result := new TSyntaxNodeList();
  for lNode in aNode:ChildNodes do
    if lNode.Typ = aNodetype then
      result.Add(lNode);
 ensure
  result <> nil;

end;

method TSyntaxNodeResolver.GetNodeGlobArray(aNodetype: TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNodeList;
begin
  result := new TSyntaxNodeList();
  for lNode in aNode:ChildNodes do
    begin
    if lNode.Typ = aNodetype then
      result.Add(lNode);

        for each  ltemp in GetNodeGlobArray(aNodetype, lNode) do
          result.Add(ltemp);

    end;
  ensure
    result <> nil;
end;


method TSyntaxNodeResolver.GetNodeArrayAll(aNodetypes: array of TSyntaxNodeType; const aNode: TSyntaxNode): TSyntaxNodeList;
begin
  result := new TSyntaxNodeList();
  if length(aNodetypes) = 0 then exit(nil);
  if length(aNodetypes) = 1 then
    exit GetNodeArray(aNodetypes[0], aNode) else
    begin
      var temp := GetNodeArray(aNodetypes[0], aNode);
      var ltemp := new List<TSyntaxNodeType>();
      for i : Integer := 1 to high(aNodetypes) do
        ltemp.Add(aNodetypes[i]);
      for each node  in temp do
        begin
        var linner := GetNodeArrayAll(ltemp.ToArray, node);
        result.Add(linner.toArray);
      end;
    end;
  ensure
    result <> nil;
  end;


  method TSyntaxNodeResolver.GetPublicClass(const aNode: TSyntaxNode): TSyntaxNodeList;
  begin
    result := GetPublicTypes(aNode, 'class');
    ensure
      result <> nil;
  end;

  method TSyntaxNodeResolver.GetPublicRecord(const aNode: TSyntaxNode): TSyntaxNodeList;
  begin
    result := GetPublicTypes(aNode, 'record');
    ensure
      result <> nil;
  end;

  method TSyntaxNodeResolver.GetImplClass(const aNode: TSyntaxNode): TSyntaxNodeList;
  begin
    result := GetImplTypes(aNode, 'class');
    ensure
      result <> nil;
  end;

end.