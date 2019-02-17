namespace PascalParser;

interface
type
  TNodeClass = public enum (ntSyntax, ntCompound, ntValued, ntComment);

  TBinarySerializer =public class
  private
    FStream     : BinaryStream;
    FStringList : List<not nullable String>;
    FStringTable: Dictionary<not nullable String,Integer>;
  protected
    method CheckSignature: Boolean;
    method CheckVersion: Boolean;
    method CreateNode(nodeClass: TNodeClass; nodeType: TSyntaxNodeType): TSyntaxNode;
    method ReadNode(var node: TSyntaxNode): Boolean;
    method ReadNumber(var num: Cardinal): Boolean;
    method ReadString(var str: not nullable String): Boolean;
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
    var sig := FStream.ReadString(CSignature.Length);
    result := sig = CSignature;
  end;

  method TBinarySerializer.CheckVersion: Boolean;
  begin
    var Version := FStream.ReadInt32;
    result := Version = $01000000;
  end;

  method TBinarySerializer.CreateNode(nodeClass: TNodeClass; nodeType: TSyntaxNodeType): TSyntaxNode;
  begin
    case nodeClass of
      TNodeClass.ntSyntax:   Result := new TSyntaxNode(nodeType);
      TNodeClass.ntCompound: Result := new TCompoundSyntaxNode(nodeType);
      TNodeClass.ntValued:   Result := new TValuedSyntaxNode(nodeType);
      TNodeClass.ntComment:  Result := new TCommentNode(nodeType);
      else raise new Exception('TBinarySerializer.CreateNode: Unexpected node class');
    end;
  end;

  method TBinarySerializer.ReadNode(var node: TSyntaxNode): Boolean;
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
    node := nil;
    if (not ReadNumber(var num)) or (num > Cardinal(ord(high(TNodeClass)))) then
      Exit;
    nodeClass := TNodeClass(num);
    if (not ReadNumber(var   num)) or (num > ord(high(TSyntaxNodeType))) then
      Exit;
    node := CreateNode(nodeClass, TSyntaxNodeType(num));
    try

      if (not ReadNumber(var   num)) or (num > Cardinal(high(Integer))) then
        Exit;
      node.Col := num;
      if (not ReadNumber(var   num)) or (num > Cardinal(high(Integer))) then
        Exit;
      node.Line := num;

      case nodeClass of
        TNodeClass.ntCompound:
        begin
          if (not ReadNumber(var   num)) or (num > Cardinal(high(Integer))) then
            Exit;
          TCompoundSyntaxNode(node).EndCol := num;
          if (not ReadNumber(var   num)) or (num > Cardinal(high(Integer))) then
            Exit;
          TCompoundSyntaxNode(node).EndLine := num;
        end;
        TNodeClass.ntValued:
        begin

          if not ReadString(var str) then
            Exit;
          TValuedSyntaxNode(node).Value := str;
        end;
        TNodeClass.ntComment:
        begin
          if not ReadString(var   str) then
            Exit;
          TCommentNode(node).Text := str;
        end;
      end;

      if not ReadNumber(var   numSub) then
        Exit;
      for i := 1 to numSub do begin
        if (not ReadNumber(var   num)) or (num > Cardinal(ord(high(TAttributeName)))) then
          Exit;
        if not ReadString(var   str) then
          Exit;
        node.SetAttribute(TAttributeName(num), str);
      end;

      if not ReadNumber(var   numSub) then
        Exit;
      for i := 1 to numSub do begin
        if not ReadNode(var   childNode) then
          Exit;
        node.AddChild(childNode);
      end;

      Result := true;
    finally
      if not Result then begin

        node := nil;
      end;
    end;
  end;

  method TBinarySerializer.ReadNumber(var num: Cardinal): Boolean;
  var
  lowPart: Byte;
  shift  : Integer;
  begin
    Result := false;

    shift := 0;
    num := 0;
    repeat
      lowPart := FStream.ReadByte;

      num := num OR ((lowPart AND $7F) SHL shift);
      inc(shift, 7);
      until (lowPart AND $80) = 0;

    Result := true;
  end;

  method TBinarySerializer.ReadString(var str: not nullable String): Boolean;
  var
  id: Integer;
  len: Cardinal;

  begin
    Result := false;

    if not ReadNumber(var len) then
      Exit;
    if (len SHR 24) = $FF then begin
      id := len AND $00FFFFFF;
      if id >= FStringList.Count then
        Exit;
      str := FStringList[id];
    end
    else begin
      str := FStream.ReadString(len) as not nullable String;

      if length(str) > 4 then
        FStringList.Add(str);
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
      FStream.WriteByte (lowPart)

      until Num = 0;

    Result := true;
  end;

  method TBinarySerializer.WriteString(const S: not nullable String): Boolean;
  var
  i: Integer;
  id: Integer;

  begin
    Result := false;

    if (S.Length > 4) and FStringTable.ContainsKey(S) then begin
      id := FStringTable[S];
      if not WriteNumber(Cardinal(id) OR $FF000000) then
        Exit;
    end
    else begin
      if  (S.Length > 4) then
      begin
        FStringTable.Add(S, FStringTable.Count);
        if FStringTable.Count > $FFFFFF then
          raise new Exception('BinarySerializer.WriteString: Too many strings!');
      end;

      i :=   S.Length;
      if not WriteNumber(i) then
        Exit;
      if i > 0 then
        FStream.WriteString(S);
    end;

    Result := true;
  end;

  method TBinarySerializer.Read(Stream: Stream; var Root: TSyntaxNode): Boolean;
  begin
    Result := false;
    FStringList := new List<not nullable String>;

    FStream :=  new BinaryStream( Stream);
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
      FStringTable := new Dictionary<not nullable String,Integer>;

      FStream :=  new BinaryStream(Stream);
      FStream.WriteString(CSignature);

      var version :Integer := $01000000;
      FStream.WriteInt32(version);

      if not WriteNode(Root) then
        Exit false;
      Result := true;
    except
      result := false;
    end;
  end;
end.