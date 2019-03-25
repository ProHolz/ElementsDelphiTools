namespace TestCodegen;

interface

uses
  RemObjects.Elements.EUnit,
  ProHolz.Ast;

type
  TestMangling = public class(TestParserBase)
  private
    method SplitDot(const value : not nullable String) : not nullable  ImmutableList<String>;
    method Solve(var methodname : not nullable String);
  protected
  public
    method TestMangling;
    method TestGlobMethod;
    method TestClassMethod;
  end;

implementation


method TestMangling.TestMangling;
begin
  var nameparts := SplitDot('TGenericClass<T>');
  Check.AreEqual(nameparts.Count, 1);
  nameparts := SplitDot('TGenericClass<T>.Test<A>');
  Check.AreEqual(nameparts.Count, 2);
 // var s := nameparts[0];
  var MethodName := 'TGenericClass<T>.Test<A>';
  Solve(var MethodName);
  Check.AreEqual(MethodName, 'TGenericClass.Test<A>');


end;

method TestMangling.SplitDot(const value: not nullable String):  not nullable  ImmutableList<String>;
begin
   result := value.Split('.');
end;

method TestMangling.Solve(var methodname: not nullable String);
begin
    if methodname.Contains('.') then
    begin
      var lparts := methodname.Split('.').ToList;
      var lname := lparts[0] as not nullable;
      lparts.RemoveAt(0);

      Var last := lname.SubstringFromLastOccurrenceOf('>').Trim;
      Var start := lname.SubstringToFirstOccurrenceOf('<').Trim;
   //   if (last <> '') and (start <> '')  then
        lname := start+last;

     methodname := lname;
     for each s in lparts do
       methodname := methodname+'.'+s;

   end;
end;

method TestMangling.TestGlobMethod;
begin
  var lunit := GetRootNode(BuildBaseUnitAll("

procedure GlobProc;
function GlobFunc :  integer;
function GlobFunc2(param1 : integer) :  integer;
procedure GlobProc2<T>;


implementation
procedure GlobProc;
begin
end;

function GlobFunc :  integer;
begin
end;

function GlobFunc2(param1 : integer) :  integer;
begin
end;

procedure GlobProc2<T>;
begin
end;

end.
"));

 Assert.isnotnil(lunit);
 var fSection := lunit.FindNode(TSyntaxNodeType.ntInterface);
  Assert.isnotnil(fSection);
  for each m in fSection.ChildNodes.where(Item->Item.Typ = TSyntaxNodeType.ntMethod) index i do
 begin
   var lname := PlayGroundFritz.CodeBuilderMethods.BuildMethodMangledName(m).ToLower;
   case i of
    0 : Check.AreEqual(lname, 'globproc__');
    1 : Check.AreEqual(lname, 'globfunc__integer');
    2 : Check.AreEqual(lname, 'globfunc2_param1_integer_integer');
    3 : Check.AreEqual(lname, 'globproc2<t>__');
   end;
 end;

  fSection := lunit.FindNode(TSyntaxNodeType.ntImplementation);
  Assert.isnotnil(fSection);
  for each m in fSection.ChildNodes.where(Item->Item.Typ = TSyntaxNodeType.ntMethod) index i do
    begin
    var lname := PlayGroundFritz.CodeBuilderMethods.BuildMethodMangledName(m).ToLower;
    case i of
      0 : Check.AreEqual(lname, 'globproc__');
      1 : Check.AreEqual(lname, 'globfunc__integer');
      2 : Check.AreEqual(lname, 'globfunc2_param1_integer_integer');
      3 : Check.AreEqual(lname, 'globproc2<t>__');
    end;
  end;
end;


method TestMangling.TestClassMethod;
begin
  var lunit := GetRootNode(BuildBaseUnitAll("

type
  Testclass<t> = class
   public

     procedure GlobProc;
     function GlobFunc :  integer;
     function GlobFunc2(param1 : integer) :  integer;
     procedure GlobProc2<T>;
    constructor Create;
    destructor Destroy;
  end;


implementation



procedure Testclass<t>.GlobProc;
begin
end;

function Testclass<t>.GlobFunc :  integer;
begin
end;

function Testclass<t>.GlobFunc2(param1 : integer) :  integer;
begin
end;

procedure Testclass<t>.GlobProc2<T>;
begin
end;

constructor Testclass<t>.Create;
begin
end;

destructor Testclass<t>.Destroy;
begin
end;

end.
"));

  Assert.isnotnil(lunit);

  var fSection := lunit.FindNode(TSyntaxNodeType.ntInterface);
  Assert.isnotnil(fSection);
  for each m in fSection.FindAllNodes( TSyntaxNodeType.ntMethod) index i do
    begin
    var lname := PlayGroundFritz.CodeBuilderMethods.BuildMethodMangledName(m).ToLower;
    case i of
      0 : Check.AreEqual(lname, 'globproc__');
      1 : Check.AreEqual(lname, 'globfunc__integer');
      2 : Check.AreEqual(lname, 'globfunc2_param1_integer_integer');
      3 : Check.AreEqual(lname, 'globproc2<t>__');
      4 : Check.AreEqual(lname, 'create__');
      5 : Check.AreEqual(lname, 'destroy__');
    end;
  end;



   fSection := lunit.FindNode(TSyntaxNodeType.ntImplementation);
  Assert.isnotnil(fSection);
  for each m in fSection.ChildNodes.where(Item->Item.Typ = TSyntaxNodeType.ntMethod) index i do
    begin
    var lname := PlayGroundFritz.CodeBuilderMethods.BuildMethodMangledName(m).ToLower;
    case i of
      0 : Check.AreEqual(lname, 'testclass<t>.globproc__');
      1 : Check.AreEqual(lname, 'testclass<t>.globfunc__integer');
      2 : Check.AreEqual(lname, 'testclass<t>.globfunc2_param1_integer_integer');
      3 : Check.AreEqual(lname, 'testclass<t>.globproc2<t>__');
      4 : Check.AreEqual(lname, 'testclass<t>.create__');
      5 : Check.AreEqual(lname, 'testclass<t>.destroy__');
    end;
  end;


end;



end.