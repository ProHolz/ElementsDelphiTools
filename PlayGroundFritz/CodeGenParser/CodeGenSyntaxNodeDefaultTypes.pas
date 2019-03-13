namespace PlayGroundFritz;

interface
type
  CodeBuilderDefaultTypes = static class

  public
    method GetType(const typename : String) : CGTypeReference;
  end;

implementation


method CodeBuilderDefaultTypes.GetType(const typename:  String): CGTypeReference;
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
    'extended',
    'double' : result:= CGPredefinedTypeReference.Double;
     else
       result := typename.asTypeReference;
   end;
end;

end.