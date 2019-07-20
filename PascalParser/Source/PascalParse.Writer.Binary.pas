namespace ProHolz.Ast;

interface
type
  TNodeClass = public enum (ntSyntax, ntCompound, ntValued, ntComment);

  TBinarySerializer =public class
  private
    fStream     : BinaryStream;
    fStringList : List<not nullable String>;
    fStringTable: Dictionary<not nullable String,Integer>;
  protected
    method CheckSignature: Boolean;
    method CheckVersion: Boolean;
    method CreateNode(NodeClass: TNodeClass; NodeType: TSyntaxNodeType): TSyntaxNode;
    method ReadNode(var Node: TSyntaxNode): Boolean;
    method ReadNumber(var Num: Cardinal): Boolean;
    method ReadString(var Str: not nullable String): Boolean;
    method WriteNode(Node: TSyntaxNode): Boolean;
    method WriteNumber(Num: Cardinal): Boolean;
    method WriteString(const S: not nullable String): Boolean;
  public
    method Read(Stream: Stream; var Root: TSyntaxNode): Boolean;
    method Write(Stream: Stream; Root: TSyntaxNode): Boolean;
  end;

implementation

const
  CSignature: String = 'DAST binary file'#26;


  method TBinarySerializer.CheckSignature: Boolean;
  begin
    var sig := fStream.ReadString(CSignature.Length);
    result := sig = CSignature;
  end;

  method TBinarySerializer.CheckVersion: Boolean;
  begin
    var Version := fStream.ReadInt32;
    result := Version = $01000000;
  end;

  method TBinarySerializer.CreateNode(NodeClass: TNodeClass; NodeType: TSyntaxNodeType): TSyntaxNode;
  begin
    case NodeClass of
      TNodeClass.ntSyntax:   Result := new TSyntaxNode(NodeType);
      TNodeClass.ntCompound: Result := new TCompoundSyntaxNode(NodeType);
      TNodeClass.ntValued:   Result := new TValuedSyntaxNode(NodeType);
      TNodeClass.ntComment:  Result := new TCommentNode(NodeType);
      else raise new Exception('TBinarySerializer.CreateNode: Unexpected node class');
    end;
  end;

  method TBinarySerializer.ReadNode(var Node: TSyntaxNode): Boolean;
  var
  childNode: TSyntaxNode;
  i        : Integer;
  nodeClass: TNodeClass;
  num      : Cardinal;
  numSub: Cardinal;
  str      : not nullable String;
  begin
    Result := false;
    str := '';
    Node := nil;
    if (not ReadNumber(var num)) or (num > Cardinal(ord(high(TNodeClass)))) then
      Exit;
    nodeClass := TNodeClass(num);
    if (not ReadNumber(var   num)) or (num > ord(high(TSyntaxNodeType))) then
      Exit;
    Node := CreateNode(nodeClass, TSyntaxNodeType(num));
    try

      if (not ReadNumber(var   num)) or (num > Cardinal(high(Integer))) then
        Exit;
      Node.Col := num;
      if (not ReadNumber(var   num)) or (num > Cardinal(high(Integer))) then
        Exit;
      Node.Line := num;

      case nodeClass of
        TNodeClass.ntCompound:
        begin
          if (not ReadNumber(var   num)) or (num > Cardinal(high(Integer))) then
            Exit;
          TCompoundSyntaxNode(Node).EndCol := num;
          if (not ReadNumber(var   num)) or (num > Cardinal(high(Integer))) then
            Exit;
          TCompoundSyntaxNode(Node).EndLine := num;
        end;
        TNodeClass.ntValued:
        begin

          if not ReadString(var str) then
            Exit;
          TValuedSyntaxNode(Node).Value := str;
        end;
        TNodeClass.ntComment:
        begin
          if not ReadString(var   str) then
            Exit;
          TCommentNode(Node).Text := str;
        end;
      end;

      if not ReadNumber(var   numSub) then
        Exit;
      for i := 1 to numSub do begin
        if (not ReadNumber(var   num)) or (num > Cardinal(ord(high(TAttributeName)))) then
          Exit;
        if not ReadString(var   str) then
          Exit;
        Node.SetAttribute(TAttributeName(num), str);
      end;

      if not ReadNumber(var   numSub) then
        Exit;
      for i := 1 to numSub do begin
        if not ReadNode(var   childNode) then
          Exit;
        Node.AddChild(childNode);
      end;

      Result := true;
    finally
      if not Result then begin

        Node := nil;
      end;
    end;
  end;

  method TBinarySerializer.ReadNumber(var Num: Cardinal): Boolean;
  var
  lowPart: Byte;
  shift  : Integer;
  begin
    Result := false;

    shift := 0;
    Num := 0;
    repeat
      lowPart := fStream.ReadByte;

      Num := Num OR ((lowPart AND $7F) SHL shift);
      inc(shift, 7);
      until (lowPart AND $80) = 0;

    Result := true;
  end;

  method TBinarySerializer.ReadString(var Str: not nullable String): Boolean;
  var
  id: Integer;
  len: Cardinal;

  begin
    Result := false;

    if not ReadNumber(var len) then
      Exit;
    if (len SHR 24) = $FF then begin
      id := len AND $00FFFFFF;
      if id >= fStringList.Count then
        Exit;
      Str := fStringList[id];
    end
    else begin
      Str := fStream.ReadString(len) as not nullable String;

      if length(Str) > 4 then
        fStringList.Add(Str);
    end;

    Result := true;
  end;

  method TBinarySerializer.WriteNode(Node: TSyntaxNode): Boolean;
  var
  nodeClass: TNodeClass;
  begin
    Result := false;

    if Node is TCompoundSyntaxNode then
      nodeClass := TNodeClass.ntCompound
    else if Node is TValuedSyntaxNode then
      nodeClass := TNodeClass.ntValued
    else if Node is TCommentNode then
      nodeClass := TNodeClass.ntComment
    else
      nodeClass := TNodeClass.ntSyntax;

    if not WriteNumber(ord(nodeClass)) then Exit;
    if not WriteNumber(ord(Node.Typ)) then Exit;
    if not WriteNumber(Node.Col) then Exit;
    if not WriteNumber(Node.Line) then Exit;

    case nodeClass of
      TNodeClass.ntCompound:
      begin
        if not WriteNumber(TCompoundSyntaxNode(Node).EndCol) then Exit;
        if not WriteNumber(TCompoundSyntaxNode(Node).EndLine) then Exit;
      end;
      TNodeClass.ntValued:
      if not WriteString(TValuedSyntaxNode(Node).Value) then Exit;
      TNodeClass.ntComment:
      if not WriteString(TCommentNode(Node).Text) then Exit;
    end;

    if not WriteNumber(Node.Attributes.Count) then Exit;
    for attr in Node.Attributes do
      begin // causes dynamic array assignment, yuck
      if not WriteNumber(ord(attr.Key)) then Exit;
      if not WriteString(attr.Value) then Exit;
    end;

    if not WriteNumber(length(Node.ChildNodes)) then Exit;
    for childNode in Node.ChildNodes do // causes dynamic array assignment, yuck
      if not WriteNode(childNode) then Exit;

    Result := true;
  end;

  method TBinarySerializer.WriteNumber(Num: Cardinal): Boolean;
  var
  lowPart: Byte;
  begin
    Result := false;

    repeat
      lowPart := Num AND $7F;
      Num := Num SHR 7;
      if Num <> 0 then
        lowPart := lowPart OR $80;
      fStream.WriteByte (lowPart)

      until Num = 0;

    Result := true;
  end;

  method TBinarySerializer.WriteString(const S: not nullable String): Boolean;
  var
  i: Integer;
  id: Integer;

  begin
    Result := false;

    if (S.Length > 4) and fStringTable.ContainsKey(S) then begin
      id := fStringTable[S];
      if not WriteNumber(Cardinal(id) OR $FF000000) then
        Exit;
    end
    else begin
      if  (S.Length > 4) then
      begin
        fStringTable.Add(S, fStringTable.Count);
        if fStringTable.Count > $FFFFFF then
          raise new Exception('BinarySerializer.WriteString: Too many strings!');
      end;

      i :=   S.Length;
      if not WriteNumber(i) then
        Exit;
      if i > 0 then
        fStream.WriteString(S);
    end;

    Result := true;
  end;

  method TBinarySerializer.Read(Stream: Stream; var Root: TSyntaxNode): Boolean;
  begin
    Result := false;
    fStringList := new List<not nullable String>;

    fStream :=  new BinaryStream( Stream);
    if not CheckSignature then
      Exit;
    if not CheckVersion then
      Exit;
    var
    node: TSyntaxNode;
    if not ReadNode(var  node) then
      Exit;
    Root := node;
    Result := true;
  end;

  method TBinarySerializer.Write(Stream: Stream; Root: TSyntaxNode): Boolean;
  begin
    try
      fStringTable := new Dictionary<not nullable String,Integer>;

      fStream :=  new BinaryStream(Stream);
      fStream.WriteString(CSignature);

      var version :Integer := $01000000;
      fStream.WriteInt32(version);

      if not WriteNode(Root) then
        Exit false;
      Result := true;
    except
      result := false;
    end;
  end;
end.