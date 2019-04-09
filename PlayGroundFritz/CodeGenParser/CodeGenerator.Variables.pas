namespace ProHolz.CodeGen;

interface
uses ProHolz.Ast;

type
  CodeBuilder =  partial class
  private
    method isVarWithNewType(const node : TSyntaxNode; out preparetyp : eNewType) : Boolean;
    method resolveBounds(const node: TSyntaxNode): List<CGEntity>;
    method PrepareConstArrayExpression(const aType : CGTypeReference; const node: TSyntaxNode): CGExpression;
    method PrepareArrayVarOrConstant(const node: TSyntaxNode; const isConst: Boolean; const ispublic: Boolean): CGFieldDefinition;
    method PrepareSetVarOrConstant(const node: TSyntaxNode; const isConst: Boolean; const ispublic: Boolean): CGFieldDefinition;

    method PrepareVarOrConstant(const node: TSyntaxNode; const isConst: Boolean; const ispublic: Boolean; const newtypename : String = nil): CGGlobalVariableDefinition;

  end;

implementation


method CodeBuilder.isVarWithNewType(const node: TSyntaxnode; out preparetyp : eNewType): Boolean;
begin
  case node.FindNode(TSyntaxNodeType.ntType):AttribType.ToLower of
    'function','procedure' : begin
        preparetyp := eNewType.block;
        exit true;
    end;
    'enum' : begin
      preparetyp := eNewType.enum;
      exit true;
    end;
  end;
  exit false;
end;


method CodeBuilder.PrepareVarOrConstant(const node: TSyntaxnode; const isConst : Boolean; const ispublic : Boolean; const newtypename : string = nil) : CGGlobalVariableDefinition;
begin
  Var constName := node.FindNode(TSyntaxNodeType.ntName).AttribName;
  Var typeNode := node.FindNode(TSyntaxNodeType.ntType);

  if assigned(typeNode) then
  begin
    case typeNode.AttribName.ToLower of
    // Special Handling of Array Constants
      'array' :
      exit  new CGGlobalVariableDefinition(PrepareArrayVarOrConstant(node, isConst, ispublic));
    end;

    case typeNode.AttribType.ToLower of
   // Special Handling of Array Constants
      'array' :
      exit  new CGGlobalVariableDefinition(PrepareArrayVarOrConstant(node, isConst, ispublic));
      'set' :
      begin
          var lset := PrepareSetVarOrConstant(node, isConst, ispublic);
          exit  new CGGlobalVariableDefinition(lset);
      end;
    end;
  end;

  var typename : String := '';

  if assigned(newtypename) then
    typename := newtypename
  else
  begin
    typename := typeNode:AttribName;
    if String.IsNullOrEmpty(typename) then
      typename := typeNode:AttribType;
  end;

  var   lGlobalSet := if String.IsNullOrEmpty(typename) then  new CGFieldDefinition(constName)
else if assigned(newtypename) then
  new CGFieldDefinition(constName, newtypename.AsTypeReference)
else
  new CGFieldDefinition(constName, PrepareTypeRef( typeNode));

  lGlobalSet.Constant := isConst;

  var valuenode := node.FindNode(TSyntaxNodeType.ntValue);
  if assigned(valuenode) then
   begin
     // If there ar ntRecordConstants inside we will solve these
     var rec := valuenode.FindAllNodes(TSyntaxNodeType.ntRecordConstant);
     if rec.Length > 0 then
     begin
       lGlobalSet.Initializer := PrepareInitializer(lGlobalSet.Type,  valuenode);
       //lGlobalSet.Constant := false;
       //lGlobalSet.ReadOnly := true;
       //lGlobalSet.l
     end
    else
    lGlobalSet.Initializer := PrepareExpressionValue(valuenode);
   end;



  if ispublic then
    lGlobalSet.Visibility := CGMemberVisibilityKind.Public;
  exit new CGGlobalVariableDefinition(lGlobalSet);

end;

method CodeBuilder.PrepareArrayVarOrConstant(const node: TSyntaxNode; const isConst: Boolean; const ispublic: Boolean): CGFieldDefinition;
begin
  var constName := node.FindNode(TSyntaxNodeType.ntName).AttribName;
  var typeNode := node.FindNode(TSyntaxNodeType.ntType);

  var lArray := PrepareArrayType(typeNode);


  result := new CGFieldDefinition(constName, lArray);

  var valuenode := node.FindNode(TSyntaxNodeType.ntValue);
  if valuenode <> nil then
    result.Initializer := PrepareConstArrayExpression(CGArrayTypeReference( lArray).Type, valuenode.ChildNodes[0]);

  result.Constant := isConst;

  if ispublic then
    result.Visibility := CGMemberVisibilityKind.Public;

end;


method CodeBuilder.PrepareConstArrayExpression(const aType : CGTypeReference; const node: TSyntaxNode): CGExpression;
begin
  result := nil;
  if node = nil then exit;
  // If there is a Expression in the First Array filed like (1 shl 1...
  // The Ast creates a ntExpression around all, this is a Bug in my Opinion but
  // must check Further....
  if node.HasChildren then
    case node.Typ of

      TSyntaxNodeType.ntExpression :
      begin
        if node.ChildCount = 1 then
          result := PrepareConstArrayExpression(aType, node.ChildNodes[0])
        else
          raise new Exception(node.Typ.ToString+  '=======  More than one Child =======');
      end;

      TSyntaxNodeType.ntExpressions :
      begin
        var lSet := new CGArrayLiteralExpression();
        for each child in  node.ChildNodes do
          begin
            if child.Typ = TSyntaxNodeType.ntRecordConstant then
            begin
              lSet.Elements.Add(PrepareInitializer(aType, child));
            end
            else
            lSet.Elements.Add(PrepareSingleExpressionValue(child));
          end;
        result := lSet;

      end;

      TSyntaxNodeType.ntSet :
      begin
        var lSet := new CGArrayLiteralExpression();
        for each child in  node.ChildNodes do
          lSet.Elements.Add(PrepareSingleExpressionValue(child));
        result := lSet;

      end;

    end;
end;

method CodeBuilder.resolveBounds(const node: TSyntaxNode): List<CGEntity>;
begin
  result := nil;
  var lBounds := node.FindNode(TSyntaxNodeType.ntBounds);
  if lBounds <> nil then
  begin
    var lDimensions := lBounds.FindChilds(TSyntaxNodeType.ntDimension);
    if lDimensions <> nil then
    begin
      result := new List<CGEntity>;

      for  each lDimension in lDimensions do
        begin
        var resDimensions := PrepareCallExpressions(lDimension);
        if length(resDimensions) = 2 then
        begin

            var temp := new CGArrayBounds(resDimensions[0]) &end(resDimensions[1]);
            result.Add(temp);//,  end_:= lmax));

        end
        else
          if length(resDimensions) = 1 then
          begin
            var temp := new CGArrayBounds(resDimensions[0]);
              result.Add(temp);
          end;
      end;
    end;
  end;

end;

method CodeBuilder.PrepareSetVarOrConstant(const node: TSyntaxNode; const isConst: Boolean; const ispublic: Boolean): CGFieldDefinition;
begin
  var constName := node.FindNode(TSyntaxNodeType.ntName).AttribName;
  var typeNode := node.FindNode(TSyntaxNodeType.ntType):FindNode(TSyntaxNodeType.ntType);
  var typename := typeNode.AttribName;

   //PrepareArrayType(typeNode, constName);
  var lArray  := new CGSetTypeReference(typeNode.AttribName.AsTypeReference);

   result := new CGFieldDefinition(constName, lArray);

   var valuenode := node.FindNode(TSyntaxNodeType.ntValue);
   if valuenode <> nil then
     result.Initializer := PrepareConstArrayExpression(typename.AsTypeReference, valuenode.ChildNodes[0]);

   result.Constant := isConst;

   if ispublic then
     result.Visibility := CGMemberVisibilityKind.Public;

end;




end.