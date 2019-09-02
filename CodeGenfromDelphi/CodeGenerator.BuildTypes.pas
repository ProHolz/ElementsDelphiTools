namespace ProHolz.CodeGen;

interface
uses ProHolz.Ast;

type
  eNewType = (&block, &enum);

  CodeBuilder =  partial class
  private
    method AddMembers(const res : CGClassOrStructTypeDefinition; const node: TSyntaxNode; const visibility :CGMemberVisibilityKind; const name: not nullable String;
    const methodBodys: Dictionary<String,TSyntaxNode>);

    method PrepareGenericParameterName(const node: TSyntaxNode): String;
    method PrepareGenericParameterDefinition(const node: TSyntaxNode): List<CGGenericParameterDefinition>;

    method AddAncestors(const value : CGClassOrStructTypeDefinition; const node : TSyntaxNode);


    method PrepareProperty(node: TSyntaxNode): CGPropertyDefinition;

    method BuildInterface(const node : TSyntaxNode; const name : not nullable String): CGInterfaceTypeDefinition;
    method BuildClass(const node: TSyntaxNode; const name: not nullable String; const methodBodys : Dictionary<String,TSyntaxNode>): CGClassOrStructTypeDefinition;
    method BuildRecord(const node : TSyntaxNode; const name : not nullable String; const methodBodys : Dictionary<String,TSyntaxNode>): CGClassOrStructTypeDefinition;
    method BuildGlobMethod(const node : TSyntaxNode; const ispublic : Boolean) : CGGlobalFunctionDefinition;

    method BuildSet(const node: TSyntaxNode; const className: not nullable String): CGTypeDefinition;

    method BuildArray(const node: TSyntaxNode; const className: not nullable String): CGTypeDefinition;
    method BuildAlias(const node: TSyntaxNode; const name: not nullable String): CGTypeDefinition;
    method BuildClassOf(const node: TSyntaxNode; const className: not nullable String): CGTypeDefinition;


  end;

implementation


method CodeBuilder.PrepareProperty(node : TSyntaxNode) : CGPropertyDefinition;
begin
  Var Propname := node.AttribName;
  Var PropType := node.FindNode(TSyntaxNodeType.ntType);
  Var PropKind := node:AttribName;
  if String.IsNullOrEmpty(PropKind) then
    result := new CGPropertyDefinition(Propname)
  else
    result := new CGPropertyDefinition(Propname,  PrepareTypeRef(PropType));
  result.Visibility :=  mapVisibility(node.ParentNode.Typ);

  // Check for Parameters

  var lParams := node.findnode(TSyntaxNodeType.ntParameters);
  if lParams <> nil then
  begin
    for each &param in lParams.FindChilds(TSyntaxNodeType.ntParameter) do
      begin
      result.Parameters.Add(PrepareParam(&param));
    end;

    if node.findnode(TSyntaxNodeType.ntDefault) <> nil then
      result.Default := true;

  end;


  var lImpl := node.FindNode(TSyntaxNodeType.ntImplements);
  if assigned(lImpl) then
  begin
    var lType :=  PrepareTypeRef(lImpl.FindNode(TSyntaxNodeType.ntType));
    if assigned(lType) then
      result.ImplementsInterface := lType;
  end;



  Var lRead := node.FindNode(TSyntaxNodeType.ntRead):FindNode(TSyntaxNodeType.ntIdentifier);
  if assigned(lRead) then
    result.GetExpression := new CGPropertyAccessExpression(nil, lRead.AttribName);

  Var lWrite := node.FindNode(TSyntaxNodeType.ntWrite):FindNode(TSyntaxNodeType.ntIdentifier);
  if assigned(lWrite) then
    result.SetExpression := new CGPropertyAccessExpression(nil, lWrite.AttribName);

end;

method CodeBuilder.AddAncestors(const value: CGClassOrStructTypeDefinition;  const node : TSyntaxNode);
begin
  // Interface
  if value is CGInterfaceTypeDefinition then
  begin
    for each child in node.ChildNodes.FindAll(Item -> Item.Typ =  TSyntaxNodeType.ntType)  do
      value.ImplementedInterfaces.Add(PrepareTypeRef(child));

  end
  else
  // Class
    for each child in node.ChildNodes.FindAll(Item -> Item.Typ =  TSyntaxNodeType.ntType) index i do
      begin
    // In Delphi for a class the first is the anestor all others are interfaces
      if i= 0 then
        value.Ancestors.Add(PrepareTypeRef(child))
      else
        value.ImplementedInterfaces.Add(PrepareTypeRef(child));
    end;
end;


method CodeBuilder.BuildInterface(const node: TSyntaxNode; const name: not nullable String): CGInterfaceTypeDefinition;
begin
  result := new CGInterfaceTypeDefinition(name);
  result.GenericParameters.Add(PrepareGenericParameterDefinition(node.ParentNode).ToArray);
  Var NodeGuid := node.FindNode(TSyntaxNodeType.ntGuid);
  Var NodeValue := NodeGuid:FindNode(TSyntaxNodeType.ntLiteral);
  If assigned(NodeValue) then
  begin
    Var StringGuid := (NodeValue as TValuedSyntaxNode).Value;
    If StringGuid <> '' then begin
      result.InterfaceGuid := new Guid(StringGuid);
      if settings.InterfaceGuids then
      begin
        if settings.ComInterfaces then
          result.Attributes.Add(new CGAttribute('COM'.AsTypeReference));

        result.Attributes.Add(new CGAttribute('Guid'.AsTypeReference, new CGCallParameter(StringGuid.AsLiteralExpression)));
       //  result.InterfaceGuid := InterfaceGuid
        end;
    end;
  end;

  AddAncestors(result, node);
  AddMembers(result, node, CGMemberVisibilityKind.Unspecified,   name, nil);
  if settings.PublicInterfaces then
    result.Visibility := CGTypeVisibilityKind.Public;


end;


method CodeBuilder.PrepareGenericParameterDefinition(const node: TSyntaxNode) : List<CGGenericParameterDefinition>;
begin
  result := new List<CGGenericParameterDefinition>;
  var TypParams := node.FindNode(TSyntaxNodeType.ntTypeParams);
  if assigned(TypParams) then
  begin
    for each child in TypParams.FindChilds(TSyntaxNodeType.ntTypeParam) do
      begin
      result.Add(new CGGenericParameterDefinition(child.FindNode(TSyntaxNodeType.ntType).AttribName));
    end;
  end;

end;

method CodeBuilder.PrepareGenericParameterName(const node: TSyntaxNode): String;
begin
  result := nil;
  if assigned(node) then
  begin
    var largs := new List<String>;
    for each child in node.ChildNodes.where(Item->Item.Typ = TSyntaxNodeType.ntTypeParam) do
      largs.Add(child.FindNode(TSyntaxNodeType.ntType).AttribName);

    if largs.Count > 0 then
    begin
      var dot := '';
      result := '<';
      for each s in largs  do
        begin
        result := result+dot+s;
        dot := ',';
      end;
      result := result+'>';
    end;
  end;

end;

method CodeBuilder.AddMembers(const res : CGClassOrStructTypeDefinition; const node: TSyntaxNode;
const visibility :CGMemberVisibilityKind; const name: not nullable String; const methodBodys : Dictionary<String,TSyntaxNode>);
begin
  if assigned(node) then
  begin
    var lAttributes := new List<CGAttribute>;
    for each child in node.ChildNodes do
      begin
      case child.Typ of
        TSyntaxNodeType.ntField : begin
          Var lFieldName := child.FindNode(TSyntaxNodeType.ntName).AttribName;
          Var lFieldType := child.FindNode(TSyntaxNodeType.ntType);
          var lCgType : CGTypeReference;
          case lFieldType.AttribType.ToLower of
            'array' : begin
              lCgType := PrepareArrayType(lFieldType);
            end;
            else
              lCgType := PrepareTypeRef(lFieldType);
          end;


          var lField := new CGFieldDefinition(lFieldName, lCgType);
          lField.Visibility :=  visibility;
          res.Members.Add(lField);
          if lAttributes.Count > 0  then
          begin
            lField.Attributes.add(lAttributes);
            lAttributes.RemoveAll;
          end;


        end;

        TSyntaxNodeType.ntMethod :
        begin
          var Search := (name+'.'+BuildMethodMangledName(child)).ToLower;
          var lMethod :=
          if (assigned(methodBodys) and methodBodys.ContainsKey(Search)) then
            PrepareMethod(child, methodBodys[Search])
        else
          PrepareMethod(child, nil);

          if assigned(lMethod)  then
          begin
            if lAttributes.Count > 0  then
            begin
              lMethod.Attributes.add(lAttributes);
              lAttributes.RemoveAll;
            end;

            res.Members.Add(lMethod);

            if (lMethod is CGConstructorDefinition) and (not lMethod.Static) then
            begin
              lMethod.Comment := 'Nameless Constructor added'.AsBuilderComment;
              var lClassMethod := PrepareClassCreateMethod(child, name);
              lClassMethod.ReturnType := name.AsTypeReference;
              lClassMethod.Comment := 'Static Factory method added'.AsBuilderComment;
              res.Members.Add(lClassMethod);
            end;
          end
          // If we receive nil it could be a
          // Implements Method so we check it
          else
          begin
            lMethod := isImplementsMethod(child);
            if assigned(lMethod) and (not String.IsNullOrEmpty(lMethod.ImplementsInterfaceMember)) and assigned(lMethod.ImplementsInterface) then
            begin
                // Search for the Method in Owner
              var lActual := res.Members.Find(Item->Item.Name.ToLower = lMethod.ImplementsInterfaceMember.ToLower);
              if assigned(lActual) and (lActual is CGMethodLikeMemberDefinition ) then
              begin
                var lData :=  CGNamedTypeReference(lMethod.ImplementsInterface).Name.Split('.', true);
                if lData.Count = 2 then
                begin
                  CGMethodLikeMemberDefinition(lActual).ImplementsInterface := lData[0].AsTypeReference;
                  CGMethodLikeMemberDefinition(lActual).ImplementsInterfaceMember := lData[1];
                end;
                lMethod := nil;
              end;
            end;
          end;
        end;

        TSyntaxNodeType.ntProperty : begin
          var lProp := PrepareProperty(child);
          if lAttributes.Count > 0  then
          begin
            lProp.Attributes.add(lAttributes);
            lAttributes.RemoveAll;
          end;

          res.Members.Add(lProp);
        end;

        TSyntaxNodeType.ntAttributes : begin
          for each lNodeAttr in child.ChildNodes.Where(Item->Item.Typ = TSyntaxNodeType.ntAttribute) do
            begin
            var lattr := PrepareAttribute(lNodeAttr);
            if assigned(lattr) then
              lAttributes.Add(lattr);
          end;
        end;


        // Visibilitys
        TSyntaxNodeType.ntPrivate : AddMembers(res, child, CGMemberVisibilityKind.Private, name, methodBodys);
        TSyntaxNodeType.ntStrictPrivate :  AddMembers(res, child, CGMemberVisibilityKind.Private, name, methodBodys);
        TSyntaxNodeType.ntStrictProtected : AddMembers(res, child, CGMemberVisibilityKind.Protected, name, methodBodys);
        TSyntaxNodeType.ntProtected : AddMembers(res, child, CGMemberVisibilityKind.Protected, name, methodBodys);
        TSyntaxNodeType.ntPublic : AddMembers(res, child, CGMemberVisibilityKind.Public, name, methodBodys);
        TSyntaxNodeType.ntPublished : AddMembers(res, child, CGMemberVisibilityKind.Published, name, methodBodys);

      end;
    end;
  end;
end;


method CodeBuilder.BuildClass(const node: TSyntaxNode; const name: not nullable String; const methodBodys : Dictionary<String,TSyntaxNode>): CGClassOrStructTypeDefinition;
begin
  {$IF LOG}
  writeLn(TSyntaxTreeWriter.ToXML(node, true ) );
 {$ENDIF}
  var Helper := node.FindNode(TSyntaxNodeType.ntHelper);

  if assigned(Helper) then
  begin
    result :=  new CGExtensionTypeDefinition(name);
    AddAncestors( result, Helper);

  end
  else

    result := new CGClassTypeDefinition(name);
  var lGenerics := PrepareGenericParameterDefinition(node.ParentNode).ToArray;
  result.GenericParameters.Add(lGenerics);

  var lTypeParams := node.ParentNode.FindNode(TSyntaxNodeType.ntTypeParams);
  var lname : String := '';
  if assigned(lTypeParams) then
    lname := PrepareGenericParameterName(lTypeParams);

    // Descenting from
  AddAncestors(result, node);
  AddMembers(result, node, CGMemberVisibilityKind.Unspecified,   name+lname, methodBodys);

   if settings.PublicClasses then
     result.Visibility := CGTypeVisibilityKind.Public;

 end;

 method CodeBuilder.BuildSet(const node: TSyntaxNode; const className: not nullable String): CGTypeDefinition;
 begin
   var typenode := node.Findnode(TSyntaxNodeType.ntType);
   var typename := typenode:AttribName;
   if not String.IsNullOrEmpty(typename) then
     exit new CGTypeAliasDefinition(className,  new CGSetTypeReference( typename.AsTypeReference));

   typename := typenode:AttribType;

   case typename:ToLower of
     'enum' : exit BuildSet2(node,className);

   end; // Case

   {..$HINT "ADD SUPPORT FOR OTHER SET TYPES"}

   if node.ChildNodes.Count = 2 then
   begin
     var lstart := PrepareSingleExpressionValue(node.ChildNodes[0]);
     var lEnd := PrepareSingleExpressionValue(node.ChildNodes[1]);

     exit new CGTypeAliasDefinition(className, new CGRangeTypeReference(lstart, lEnd));
   end;


   var lres := new CGTypeAliasDefinition(className, ('****UnknownSET').AsTypeReference);
   lres.Comment :=  $" UnknownSet on Line {node.ParentNode.Line}".AsComment;

   if settings.PublicEnums then
     lres.Visibility := CGTypeVisibilityKind.Public;


   exit lres;

   //raise new Exception("Could not create set or enum");
 end;

 method CodeBuilder.BuildGlobMethod(const node: TSyntaxNode; const ispublic : Boolean): CGGlobalFunctionDefinition;
 begin
   Var res := PrepareMethod(node, nil);
   if res is CGMethodDefinition then
   begin
     result := (res as CGMethodDefinition).AsGlobal;
     result.Function.Visibility := if ispublic then CGMemberVisibilityKind.Public else CGMemberVisibilityKind.Private;
   end
   else exit nil;
 end;

 method CodeBuilder.BuildRecord(const node: TSyntaxNode; const name: not nullable String;const methodBodys : Dictionary<String,TSyntaxNode>) : CGClassOrStructTypeDefinition;
 begin
 {$IF LOG}
 writeLn(TSyntaxTreeWriter.ToXML(node, true ) );
{$ENDIF}
   var Helper := node.FindNode(TSyntaxNodeType.ntHelper);

   if assigned(Helper) then
   begin
    result :=  new CGExtensionTypeDefinition(name);
    AddAncestors( result, Helper);

  end
  else
    result :=  new CGStructTypeDefinition(name);
  var lGenerics := PrepareGenericParameterDefinition(node.ParentNode).ToArray;
  result.GenericParameters.Add(lGenerics);

   var lTypeParams := node.ParentNode.FindNode(TSyntaxNodeType.ntTypeParams);
   var lname : String := '';
   if assigned(lTypeParams) then
     lname := PrepareGenericParameterName(lTypeParams);

   AddMembers(result, node, CGMemberVisibilityKind.Unspecified,   name+lname, methodBodys);

   if settings.PublicRecords then
     result.Visibility := CGTypeVisibilityKind.Public;
 end;



 method CodeBuilder.BuildArray(const node: TSyntaxNode; const className: not nullable String): CGTypeDefinition;
 begin
   var lArray := PrepareArrayType(node);
   if assigned(lArray) then
     exit new CGTypeAliasDefinition(className, lArray)
   else raise new Exception("Array Type Alias not solved");
 end;

 method CodeBuilder.BuildAlias(const node: TSyntaxNode; const name: not nullable String): CGTypeDefinition;
 require
   (node <> nil) implies (node.Typ = TSyntaxNodeType.ntType);
 begin
   Var typeName := node.AttribName;
   if not String.IsNullOrEmpty(typeName)  then
   begin
     var lref := PrepareTypeRef(node);
     exit new CGTypeAliasDefinition(name, lref);
   end
   else raise new Exception("BuildAlias not solved");
 end;

 method CodeBuilder.BuildClassOf(const node: TSyntaxNode; const className: not nullable String): CGTypeDefinition;
 begin
   Var typeName := node.AttribName;
   if not String.IsNullOrEmpty(typeName)  then
     exit new CGTypeAliasDefinition(className, ('Class of '+typeName).AsTypeReference)
   else raise new Exception("Type ClassOf not solved");
 end;






end.