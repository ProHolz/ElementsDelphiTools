namespace ProHolz.CodeGen;

interface
uses
  ProHolz.Ast;

type
  CodeBuilder =  partial class
  private
    method PrepareDllCallAttribute(const node: TSyntaxNode): CGAttribute;
    method PrepareCallingConventionAttribute(const value: CGCallingConventionKind): CGAttribute;
    method PrepareAttribute(const node: TSyntaxNode): CGAttribute;
  end;


implementation


method CodeBuilder.PrepareDllCallAttribute(const node : TSyntaxNode) : CGAttribute;
begin
  var lident := node.FindNode(TSyntaxNodeType.ntIdentifier);
  if not assigned(lident) then
    lident := node.FindNode(TSyntaxNodeType.ntLiteral);


  var ltype := PrepareSingleExpressionValue(lident);

  var lextnode := node.FindNode(TSyntaxNodeType.ntExternalName);
  if assigned(lextnode) then
  begin
    var lexttype := PrepareSingleExpressionValue(lextnode);
    var lentry := new CGCallParameter(lexttype, 'EntryPoint') as not nullable;
    exit new CGAttribute('DllImport'.AsTypeReference, ltype.AsCallParameter, lentry);
  end;
  exit new CGAttribute('DllImport'.AsTypeReference, ltype.AsCallParameter);
end;


method CodeBuilder.PrepareCallingConventionAttribute(const value : CGCallingConventionKind) : CGAttribute;
begin
  result :=
  case value of
    CGCallingConventionKind.CDecl : new CGAttribute('CallingConvention'.AsTypeReference, 'CallingConvention.Cdecl'.AsNamedIdentifierExpression.AsCallParameter);
    CGCallingConventionKind.StdCall : new CGAttribute('CallingConvention'.AsTypeReference, 'CallingConvention.Stdcall'.AsNamedIdentifierExpression.AsCallParameter);
    CGCallingConventionKind.SafeCall : new CGAttribute('CallingConvention'.AsTypeReference, 'CallingConvention.SafeCall'.AsNamedIdentifierExpression.AsCallParameter);
    CGCallingConventionKind.FastCall : new CGAttribute('CallingConvention'.AsTypeReference, 'CallingConvention.Fastcall'.AsNamedIdentifierExpression.AsCallParameter);

  end;
end;

method CodeBuilder.PrepareAttribute(const node: TSyntaxNode): CGAttribute;
begin
  Var lName := node.FindNode(TSyntaxNodeType.ntName):AttribName;
  if not String.IsNullOrEmpty(lName) then
  begin
    var lparameter := new List<CGCallParameter>;
    var lArguments := node.FindNode(TSyntaxNodeType.ntArguments);

    for each posarg in lArguments:ChildNodes.Where(Item->Item.Typ = TSyntaxNodeType.ntPositionalArgument) do
      begin
      var lattr := PrepareExpressionValue(posarg.FindNode(TSyntaxNodeType.ntValue));
      if assigned(lattr) then
        lparameter.Add(new CGCallParameter(lattr));
    end;
    if lparameter.Count > 0 then
      result := new CGAttribute(lName.AsTypeReference, lparameter)
    else
      result := new CGAttribute(lName.AsTypeReference);
  end;
end;


end.