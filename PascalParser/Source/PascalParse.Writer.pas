namespace ProHolz.Ast;

interface
type
  TSyntaxTreeWriter = public class
  private
    class method NodeToXML(const Builder: StringBuilder; const Node: TSyntaxNode; Formatted: Boolean);
  public
    class method ToXML(const Root: TSyntaxNode;  Formatted: Boolean = False): not nullable String;
    class function ToBinary(const Root: TSyntaxNode; Stream: Stream): Boolean;
  end;
implementation

class method TSyntaxTreeWriter.NodeToXML(const Builder: StringBuilder; const Node: TSyntaxNode; Formatted: Boolean);


method XMLEncode(const Data: not nullable String): not nullable String;
var
i, n: Integer;
res : Array of Char;

method Encode(const s: not nullable String);
begin
  for i : Integer := 0 to s.Length-1 do
  res[n+i] := s[i];
  inc(n, s.Length);
end;

begin
if Data = nil  then exit '';

  res := new Char[ Data.Length * 6];
  n := 0;
  for i := 0 to Data.Length-1 do
    case Data[i] of
      '<': Encode('&lt;');
      '>': Encode('&gt;');
      '&': Encode('&amp;');
      '"': Encode('&quot;');
      '''': Encode('&apos;');
      else
        res[n] := Data[i];
        inc(n);
    end;
  Result := new String(res, 0, n) as not nullable;

end;


  method NodeToXMLInternal(const Node: TSyntaxNode; const Indent: not nullable  String);
  var
  HasChildren: Boolean;
  NewIndent: not nullable String := '';

  begin

    HasChildren := Node.HasChildren;
    if Formatted then
    begin
      NewIndent := Indent + '  ';
      Builder.Append(Indent);
    end;
    Builder.Append('<' + Node.Typ.EnumName.ToUpper);

    if Node is TCompoundSyntaxNode then
    begin
      Builder.Append(' begin_line="' + TCompoundSyntaxNode(Node).Line.ToString + '"');
      Builder.Append(' begin_col="' + TCompoundSyntaxNode(Node).Col.ToString + '"');
      Builder.Append(' end_line="' + TCompoundSyntaxNode(Node).EndLine.ToString + '"');
      Builder.Append(' end_col="' + TCompoundSyntaxNode(Node).EndCol.ToString + '"');
    end else
    begin
      Builder.Append(' line="' + Node.Line.ToString + '"');
      Builder.Append(' col="' + Node.Col.ToString + '"');
    end;

    if not String.IsNullOrEmpty(Node.FileName)  then
      Builder.Append('  file="' + XMLEncode(Node.FileName) + '"');

    if Node is TValuedSyntaxNode then
      Builder.Append(' value="' + XMLEncode(TValuedSyntaxNode(Node).Value) + '"');

    if Node is TCommentNode then
      Builder.Append(' text="' + XMLEncode(TCommentNode(Node).Text) + '"');

    for Attr in Node.Attributes do
      Builder.Append(' ' + Attr.Key.ToString + '="' + XMLEncode(Attr.Value) + '"');
    if HasChildren then
      Builder.Append('>')
    else
      Builder.Append('/>');
    if Formatted then
      Builder.AppendLine;
    for ChildNode in Node.ChildNodes do
      NodeToXMLInternal(ChildNode, NewIndent);
    if HasChildren then
    begin
      if Formatted then
        Builder.Append(Indent);
      Builder.Append('</' + Node.Typ.EnumName.ToUpper + '>');
      if Formatted then
        Builder.AppendLine;
    end;
  end;

begin
  NodeToXMLInternal(Node, '');
end;


class method TSyntaxTreeWriter.ToXML(const Root: TSyntaxNode;  Formatted: Boolean = False): not nullable String;
var
Builder: StringBuilder;
begin
Builder := new StringBuilder;
  NodeToXML(Builder, Root, Formatted);
  Result := '<?xml version="1.0"?>' +   Environment.LineBreak + Builder.ToString;

end;

class method TSyntaxTreeWriter.ToBinary(const Root: TSyntaxNode; Stream: Stream): Boolean;
begin
  Var Binary := new TBinarySerializer();
  result := Binary.Write(Stream, Root);
end;
end.