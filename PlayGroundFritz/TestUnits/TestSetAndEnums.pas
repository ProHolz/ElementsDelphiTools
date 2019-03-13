namespace PlayGroundFritz;
const TestSetAndEnums = "
unit TestSetAndEnums;

interface


type
 // TSQLFieldBits = set of 0..MAX_SQLFIELDS-1;
  simple = (sfirst, ssecond, sthird);
  simpleset = set of simple;
  withType = set of (wtFirst, wtSecond, wtThird);

// Alias
  simpleAlias = simple;


 TSimpleByteArray = Array[simple] of byte;
 TByteArray = Array[0..0] of byte;

 TCombinedArray = Array[0..5, simple] of String;


const
  SimpleByteArray : Array[simple] of Integer = (0, 1,2);


var
  EnumArray : Array[simpleAlias] of String;


 procedure TestEnum(const aSet : simpleset; const value : simple);

 procedure TestSetOf(const aSet : withType);

implementation

  procedure TestEnum(const aSet : simpleset; const value : simple);
  Var test : boolean;
      lset : simpleset;
  begin
    if value in aSet then
    begin
      test := true;
    end;

    if value in [ssecond, sthird] then
    begin
      test := true;
    end;

    lset := [];

    Include(lset, ssecond);
    Exclude(lset, ssecond);

  end;


  procedure TestSetOf(const aSet : withType);
  Var test : boolean;
  begin
     if wtSecond in aSet then
       test := true;

  end;

procedure LoopCombined;
 var i : integer;
     j : simple;
     tl : TCombinedArray;
     test : boolean;
 begin
  for I := low(tl) to High(tl) do
  begin
  for j := low(tl[i]) to High(tl[i]) do
   if tl[I][j] then
     test := true;
  end;
end;

end.
";
end.