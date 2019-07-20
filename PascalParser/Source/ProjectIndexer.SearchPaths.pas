namespace ProHolz.Ast;

interface

type
  Searchpaths = public class
  private
    fPaths : Dictionary<String, String>;
    fBasePath : not nullable String;

    method SetBasePath(const Value : not nullable String);
  public
    class method IsRelativeWinPath(const Value: not nullable String): Boolean;
    constructor(const aBasePath : not nullable String);
    method Add(const Value : not nullable String);
    method GetPaths : sequence of  String;
    method Clear;
    method GetFullpath(const Value : not nullable String): not nullable String;
    property BasePath : not nullable String read fBasePath write SetBasePath;
  end;

implementation

constructor Searchpaths(const aBasePath : not nullable String);
begin
  fBasePath := aBasePath;
  fPaths := new Dictionary<String, String>;
end;

method Searchpaths.Add(const Value: not nullable String);
begin
  var Fullpath := GetFullpath(Value);
  if (Fullpath <> '')  then
  begin
    if fPaths.ContainsKey(Value.ToLower) then
     fPaths[Value.ToLower] := Fullpath
   else
    fPaths.Add(Value.ToLower, Fullpath);
  end;
end;

method Searchpaths.GetFullpath(const Value: not nullable String): not nullable String;
begin
  if Value.IsAbsolutePath then exit Value;
  if not IsRelativeWinPath(Value) then exit Value;
  exit   Path.GetFullPath( Path.Combine(fBasePath, Value));
end;

method Searchpaths.GetPaths: sequence of String;
begin
 result := fPaths.Values;
end;

method Searchpaths.SetBasePath(const Value: not nullable String);
begin
 fBasePath := Value;
 for s in fPaths.Keys do
   fPaths[s] := GetFullpath(s as not nullable);

end;

class method Searchpaths.IsRelativeWinPath(const Value: not nullable String): Boolean;
begin
  var L := Value.Length;
  Result := ((L = 0) or ((L > 0) and (Value[0] <> '\')))
  and ( (L <= 1) or (Value[ 1] <> ':') );
end;

method Searchpaths.Clear;
begin
 fPaths.RemoveAll;
end;

end.