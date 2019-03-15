namespace PlayGroundFritz;

interface
type
  CodeBuilderDefaultTypes = static class

  public
    method GetDefaultType(const typename : String) : CGTypeReference;
    method GetType(const typename : String) : CGTypeReference;
    method isDefaultType(const typename : String) : Boolean;
  end;

implementation

method CodeBuilderDefaultTypes.GetDefaultType(const typename: String): CGTypeReference;

begin
  case typename.ToLower of
  // 8 Bit

    'shortint',
    'int8' : result := CGPredefinedTypeReference.Int8;
    'byte' : result := CGPredefinedTypeReference.UInt8;
  // 16 BIT
    'smallint',
    'int16' : result := CGPredefinedTypeReference.Int16;
    'word' : result := CGPredefinedTypeReference.UInt16;

    // 32 BIT
    'fixedint',
    'int32',
    'integer' : result:= CGPredefinedTypeReference.Int32;
    'fixeduint',
    'uint32',
    'cardinal' : result:= CGPredefinedTypeReference.UInt32;


    // 64 BIT
    'comp',
    'int64' : result:= CGPredefinedTypeReference.Int64;
    'uint64' : result:= CGPredefinedTypeReference.UInt64;

    // Floats
    'single' : result:= CGPredefinedTypeReference.Single;
    'real',
    'real48',
    'extended',
    'double' : result:= CGPredefinedTypeReference.Double;

    'string' : result := CGPredefinedTypeReference.String;
    'char' : result := CGPredefinedTypeReference.UTF16Char;
    'ansichar' : result := CGPredefinedTypeReference.AnsiChar;


     else
       result := nil;
   end;
end;

method CodeBuilderDefaultTypes.GetType(const typename:  String): CGTypeReference;
begin
  result := GetDefaultType(typename);
  if not assigned(result) then
    result := typename.asTypeReference;
end;

method CodeBuilderDefaultTypes.isDefaultType(const typename: String): Boolean;
begin
 result := GetDefaultType(typename) <> nil;
end;

end.