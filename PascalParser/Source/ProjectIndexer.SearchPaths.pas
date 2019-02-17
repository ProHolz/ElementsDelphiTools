namespace PascalParser;

interface

type
  Searchpaths = public class
  private
    fPaths : Dictionary<String, String>;
    fBasePath : not nullable String;

    method setBasePath(const value : not nullable String);
  public
    class method IsRelativeWinPath(const Path: not nullable String): Boolean;
    constructor(const base : not nullable String);
    method Add(const value : not nullable String);
    method getPaths : sequence of  String;
    method Clear;
    method getFullpath(const value : not nullable String): not nullable String;
    property BasePath : not nullable String read fBasePath write setBasePath;
  end;

implementation

constructor Searchpaths(const base : not nullable String);
begin
  fBasePath := base;
  fPaths := new Dictionary<String, String>;
end;

method Searchpaths.Add(const value: not nullable String);
begin
  var Fullpath := getFullpath(value);
  if (Fullpath <> '')  then
  begin
    if fPaths.ContainsKey(value.ToLower) then
     fPaths[value.ToLower] := Fullpath
   else
    fPaths.Add(value.ToLower, Fullpath);
  end;
end;

method Searchpaths.getFullpath(const value: not nullable String): not nullable String;
begin
  if value.IsAbsolutePath then exit value;
  if not IsRelativeWinPath(value) then exit value;
  exit   Path.GetFullPath( Path.Combine(fBasePath, value));
end;

method Searchpaths.getPaths: sequence of String;
begin
 result := fPaths.Values;
end;

method Searchpaths.setBasePath(const value: not nullable String);
begin
 fBasePath := value;
 for s in fPaths.Keys do
   fPaths[s] := getFullpath(s as not nullable);

end;

class method Searchpaths.IsRelativeWinPath(const Path: not nullable String): Boolean;
begin
  var L := Path.Length;
  Result := ((L = 0) or ((L > 0) and (Path[0] <> '\')))
  and ( (L <= 1) or (Path[ 1] <> ':') );
end;

method Searchpaths.Clear;
begin
 fPaths.RemoveAll;
end;

end.