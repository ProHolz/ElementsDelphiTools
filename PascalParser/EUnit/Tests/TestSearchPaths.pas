namespace ProHolz.Ast;

interface
uses
 RemObjects.Elements.EUnit;

type
  TestSearchPath = class(Test)
  public
    procedure Test1;
  end;

implementation

method TestSearchPath.Test1;
begin
  if Environment.OS = OperatingSystem.Windows then
  begin
  var lPath := new Searchpaths('X:\Source_fritz\RoofCad');
  lPath.Add('cad'); //0
  lPath.Add('\cairo'); //1
  lPath.Add('..\cairo'); //2
  lPath.Add('.\cairo'); //3
  for each ls in lPath.GetPaths index i do
    begin
      case i of
        0 : Check.AreEqual(ls, 'X:\Source_fritz\RoofCad\cad');
        1 : Check.AreEqual(ls, '\cairo');
        2 : Check.AreEqual(ls, 'X:\Source_fritz\cairo');
        3 : Check.AreEqual(ls, 'X:\Source_fritz\RoofCad\cairo');
      end;
    end;

  lPath.BasePath := 'D:\Source_fritz\';
  for each ls in lPath.GetPaths index i do
    begin
        case i of
          0 : Check.AreEqual(ls, 'D:\Source_fritz\cad');
          1 : Check.AreEqual(ls, '\cairo');
          2 : Check.AreEqual(ls, 'D:\cairo');
          3 : Check.AreEqual(ls, 'D:\Source_fritz\cairo');
        end;
      end;
  end;
end;

end.