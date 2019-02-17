namespace PascalParser;

type
  IIncludeHandler = public interface
    function GetIncludeFileContent(const FileName: not nullable String): not nullable String;
  end;

end.