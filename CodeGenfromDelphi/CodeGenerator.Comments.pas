namespace ProHolz.CodeGen;

interface
uses ProHolz.Ast;

type
  CodeBuilder =  partial class
  private
    method BuildCommentFromNode(const info: String; const node: TSyntaxNode; const isError : Boolean := false): CGStatement;
    method BuildComment(const Values: array of String): CGStatement;
  end;

implementation

method CodeBuilder.BuildCommentFromNode(const info : string; const node : Tsyntaxnode; const isError : boolean := false) : CGStatement;
begin
  if isError then
  begin
    var s:= String.Format('{0} Line: {1}  Col: {2}   {3}', [info, node.Line, node.Col, node.Typ.ToString]);
    result := new CGRawStatement(String.Format('(*$HINT "{0}" *)',[s]));
  end
  else
  result := BuildComment([info+': '+
                                      node.Typ.EnumName,
                                      String.Format('Line: {0}  Col: {1}', [node.Line, node.Col])
                                      ]);

end;



method CodeBuilder.BuildComment(const Values : Array of String) : CGStatement;
begin
  var lList := new List<String>;
  for each s in Values do lList.Add(s);
  exit new CGCommentStatement(lList);

end;


end.