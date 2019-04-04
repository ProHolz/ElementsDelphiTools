namespace TestCodegen;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestMethodDef = public class(TestParserBase)
  private

  protected
  public
    method SimpleMethod;
    method MethodDefaultParam;
    method MethodParamValues;
    method MethodCallingConventions;
    method MethodArray;
  end;

implementation

method TestMethodDef.SimpleMethod;
begin
  var lunit := BuildUnit(tbUnitType.Body ,"
     procedure ProcSimple;
     function funcSimple : boolean;
     procedure ProcSimpleP1(const value : boolean);
     function funcSimpleP2(const value : boolean; out test : integer) : boolean;
     implementation
     procedure ProcSimple;
     begin
     end;
     function funcSimple : boolean;
     begin
       result := false;
     end;
     procedure ProcSimpleP1(const value : boolean);
     begin
     end;

     function funcSimpleP2(const value : boolean; out test : integer) : boolean;
     begin
     end;

 ");

  Assert.IsNotNil(lunit);
  Check.AreEqual(lunit.Globals.Count, 4);
  for each matching GV : CGGlobalFunctionDefinition in lunit.Globals index i do
    begin
    var func := GV.Function;
    case i of
      0 : Check.IsNil(func.ReturnType);
      1 : Check.IsNotNil(func.ReturnType);
      2 : Check.AreEqual(func.Parameters.Count, 1);
      3 : Check.AreEqual(func.Parameters.Count, 2);
    end;
      //Check.IsTrue(f.Constant);
  end;
end;

method TestMethodDef.MethodDefaultParam;
begin
  var lunit := BuildUnit(tbUnitType.Body ,"
     procedure ProcSimpleP1(const value : boolean = true);
     function funcSimpleP2(const value : boolean; out test : integer; show : integer = 1) : boolean;
     // Default String Params
     function TestFuncString6(i : integer; const value: string = 'Test'): string;
     function TestFuncString7(value: string = 'Test'): string;
      function TestFuncInt7(value: integer = 3+5): string;
     implementation
    procedure ProcSimpleP1(const value : boolean = true);
     begin
     end;
    function funcSimpleP2(const value : boolean; out test : integer; show : integer = 1) : boolean;
     begin
     end;
     function TestFuncString6(i : integer; const value: string = 'Test'): string;
     begin
     end;
     function TestFuncString7(value: string = 'Test'): string;
     begin
     end;
      function TestFuncInt7(value: integer = 3+5): string;
     begin
     end;
  ");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 5);
  for each matching GV : CGGlobalFunctionDefinition in lunit.Globals index i do
    begin
    var func := GV.Function;
    case i of
      0 : begin
        Check.AreEqual(func.Parameters.Count, 1);
        Check.AreEqual(func.Parameters[0].Modifier, CGParameterModifierKind.Const);
      end;
      1 : begin
        Assert.AreEqual(func.Parameters.Count, 3);
        Check.AreEqual(func.Parameters[0].Modifier, CGParameterModifierKind.Const);
        Check.AreEqual(func.Parameters[1].Modifier, CGParameterModifierKind.Out);
        Check.AreEqual(func.Parameters[2].Modifier, CGParameterModifierKind.In);
        var p := func.Parameters[2];
        Assert.IsnotNil(p.DefaultValue);
        Assert.IsTrue(p.DefaultValue is CGIntegerLiteralExpression);

      end;

      2 : begin
        Assert.AreEqual(func.Parameters.Count, 2);
        Check.AreEqual(func.Parameters[0].Modifier, CGParameterModifierKind.In);
        Check.AreEqual(func.Parameters[1].Modifier, CGParameterModifierKind.Const);

        var p := func.Parameters[1];
        Assert.IsnotNil(p.DefaultValue);
        Assert.IsTrue(p.DefaultValue is CGStringLiteralExpression);

      end;
      3 : begin
        Assert.AreEqual(func.Parameters.Count, 1);
          Check.AreEqual(func.Parameters[0].Modifier, CGParameterModifierKind.In);
          var p := func.Parameters[0];
          Assert.IsnotNil(p.DefaultValue);
          Assert.IsTrue(p.DefaultValue is CGStringLiteralExpression);
      end;
      4 : begin
        Assert.AreEqual(func.Parameters.Count, 1);
          Check.AreEqual(func.Parameters[0].Modifier, CGParameterModifierKind.In);
          var p := func.Parameters[0];
          Assert.IsnotNil(p.DefaultValue);
          Assert.IsTrue(p.DefaultValue is CGBinaryOperatorExpression);
      end;
    end;

  end;
end;

method TestMethodDef.MethodParamValues;
begin
  var lunit := BuildUnit(tbUnitType.Body ,"
     function funcSimpleP2(const value : boolean; out test : integer; show : integer = 1) : boolean;
     implementation
    function funcSimpleP2(const value : boolean; out test : integer; show : integer = 1) : boolean;
     begin
     end;
 ");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 1);
  for each matching GV : CGGlobalFunctionDefinition in lunit.Globals do
    begin
    var func := GV.Function;
    Assert.AreEqual(func.Parameters.Count, 3);
    Check.AreEqual(func.Parameters[0].Modifier, CGParameterModifierKind.Const);
    Check.AreEqual(func.Parameters[1].Modifier, CGParameterModifierKind.Out);
    Check.AreEqual(func.Parameters[2].Modifier, CGParameterModifierKind.In);
  end;
      //Check.IsTrue(f.Constant);
end;

method TestMethodDef.MethodCallingConventions;
begin
  var lunit := BuildUnit(tbUnitType.Body ,"

    function TestFuncString: string; cdecl;
    function TestFuncString2(value: string): string; stdcall;
    function TestFuncString3(const value: string): string;  register;  // This is the default in Delphi
    function TestFuncString4(var value: string): string;  pascal;
    function TestFuncString5(out value: string): string;  safecall;
   implementation

    function TestFuncString: string; cdecl;
    begin
    end;
    function TestFuncString2(value: string): string; stdcall;
    begin
    end;
    function TestFuncString3(const value: string): string;  register;  // This is the default in Delphi
    begin
    end;
    function TestFuncString4(var value: string): string;  pascal;
    begin
    end;
    function TestFuncString5(out value: string): string;  safecall;
    begin
    end;

");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 5);
  for each matching GV : CGGlobalFunctionDefinition in lunit.Globals index i do
    begin
    var func := GV.Function;
    case i of
      0 :  Check.AreEqual(func.CallingConvention, CGCallingConventionKind.CDecl);
      1 :  Check.AreEqual(func.CallingConvention, CGCallingConventionKind.StdCall);
      2 :  Check.AreEqual(func.CallingConvention, CGCallingConventionKind.Register);
      3 :  Check.AreEqual(func.CallingConvention, CGCallingConventionKind.Pascal);
      4 :  Check.AreEqual(func.CallingConvention, CGCallingConventionKind.SafeCall);
    end;

  end;
    //Check.IsTrue(f.Constant);
end;

method TestMethodDef.MethodArray;
begin
  var lunit := BuildUnit(tbUnitType.Body ,"
  type
    intarray = Array of integer;

implementation
  procedure TestArray(const cintArray : intArray = []);
  begin
  end;
  procedure TestArray2(const cintArray : intArray = [1,2]);
  begin
  end;

");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 2);
  for each matching GV : CGGlobalFunctionDefinition in lunit.Globals index i do
    begin
    var func := GV.Function;
    case i of
      0 : begin
        Assert.AreEqual(func.Parameters.Count, 1);
        Check.AreEqual(func.Parameters[0].Modifier, CGParameterModifierKind.Const);
        var p := func.Parameters[0];
        Assert.IsnotNil(p.DefaultValue);
        Assert.IsTrue(p.DefaultValue is CGArrayLiteralExpression);
        Assert.AreEqual((p.DefaultValue as CGArrayLiteralExpression).Elements.Count, 0);
      end;
      1 : begin
        Assert.AreEqual(func.Parameters.Count, 1);
        Check.AreEqual(func.Parameters[0].Modifier, CGParameterModifierKind.Const);
        var p := func.Parameters[0];
        Assert.IsnotNil(p.DefaultValue);
        Assert.IsTrue(p.DefaultValue is CGArrayLiteralExpression);
        Assert.AreEqual((p.DefaultValue as CGArrayLiteralExpression).Elements.Count, 2);
      end;
    end;

  end;
end;
end.