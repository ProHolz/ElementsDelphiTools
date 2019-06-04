namespace ProHolz.CodeGen;

interface
uses ProHolz.Ast;

type
  // This part is used for ntTypes
  CodeBuilder =  partial class
  private
    method PrepareArrayType(const node: TSyntaxNode): CGTypeReference;
   method PrepareTypeRef(const node: TSyntaxNode): CGTypeReference;
 end;

implementation
method CodeBuilder.PrepareArrayType(const node: TSyntaxNode): CGTypeReference;
begin
  var typeNode := node.FindNode(TSyntaxNodeType.ntType);
  if assigned(typeNode) then
  begin
    var lBounds := resolveBounds(node);
    if lBounds <> nil then
    begin
      var lArrayBounds := new List<CGArrayBounds>;
      for each lbound in lBounds do
        if lbound is CGArrayBounds then
          lArrayBounds.Add(lbound as CGArrayBounds);


      Var lTempType := PrepareTypeRef(typeNode);
      if lArrayBounds.Count > 0 then
      begin
        result := new CGArrayTypeReference(lTempType, lArrayBounds);

        CGArrayTypeReference( result).ArrayKind := CGArrayKind.Static;
      end
      else
        result := new CGArrayTypeReference(lTempType);
    end
    else
      result := new CGArrayTypeReference(typeNode.AttribName.AsTypeReference);

  end
  else raise new Exception("Array Type Alias not solved");

end;



method CodeBuilder.PrepareTypeRef(const node: TSyntaxNode): CGTypeReference;
var lTemp : CGTypeReference;
begin
  if isDefaultType(node.AttribName) then
    lTemp := GetDefaultType(node.AttribName)
  else
  begin
     case node.AttribName.ToLower of
       'subrange' : begin
         if node.ChildNodes.Count = 2 then
         begin
           var lstart := PrepareSingleExpressionValue(node.ChildNodes[0]);
           var lEnd := PrepareSingleExpressionValue(node.ChildNodes[1]);
           exit new CGRangeTypeReference(lstart, lEnd);
         end;
       end;
     end;


     case node.AttribType.ToLower of
       'array' : begin
         var la := PrepareArrayType(node);
         exit la;

       end;
     end;


      lTemp := node.AttribName.AsTypeReference;
    end;

    // if it is a named reference check further.....
  if lTemp is CGNamedTypeReference then
  begin
    var typeArgs := node.FindNode(TSyntaxNodeType.ntTypeArgs);
    if assigned(typeArgs) then
    begin
      var largs := new List<CGTypeReference>;
      for each child in typeArgs.ChildNodes.where(Item->Item.Typ = TSyntaxNodeType.ntType) do
        largs.Add(PrepareTypeRef(child));

      if largs.Count > 0 then
        CGNamedTypeReference(lTemp).GenericArguments := largs;
    end;
  end;
exit lTemp;
end;

end.