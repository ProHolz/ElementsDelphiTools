﻿namespace TestCodegen;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestArrayConsts = public class(TestParserBase)
  private
  protected
  public
    method TestSimple;
    method TestDynamic;
  end;

implementation

method TestArrayConsts.TestSimple;
begin
  var lunit := BuildUnit(tbUnitType.interface ,"

const
  cintArray = [1,2,cInt]; // Will be a Array
  SimpleIntArray : Array[0..2] of Integer = (0, 1,2);
  AllInt : array[0..1, 3..4] of integer = ((3,4), (5,6));

");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 3);


  for each matching GV : CGGlobalVariableDefinition in lunit.Globals index i  do
    begin
    var f := GV.Variable;
    Check.IsTrue(f.Constant);
    case i of
      0 : begin
        Check.AreEqual(f.Name, 'cintArray');
        Assert.IsnotNil(f.Initializer);
        Assert.IsTrue(f.Initializer is CGArrayLiteralExpression);
        Check.AreEqual(CGArrayLiteralExpression(f.Initializer).ArrayKind, CGArrayKind.Dynamic);
      end;

      1 : begin
          Check.AreEqual(f.Name, 'SimpleIntArray');
          Assert.IsnotNil(f.Initializer);
          Assert.IsTrue(f.Initializer is CGArrayLiteralExpression);
          Check.AreEqual(CGArrayLiteralExpression(f.Initializer).ArrayKind, CGArrayKind.Dynamic);
          Check.AreEqual(CGArrayLiteralExpression(f.Initializer).Elements.Count, 3);
          Assert.IsTrue(f.Type is CGArrayTypeReference);
          var lBounds := f.Type as CGArrayTypeReference;
          Check.AreEqual( lBounds.ArrayKind, CGArrayKind.Static);

      end;


    end;



  end;
end;


method TestArrayConsts.TestDynamic;
begin
  var lunit := BuildUnit(tbUnitType.interface ,"

const
  cintArray2 : Array of Integer  = [1,2,3];
");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 1);


  for each matching GV : CGGlobalVariableDefinition in lunit.Globals  do
    begin
    var f := GV.Variable;
    Check.IsTrue(f.Constant);
    Check.AreEqual(f.Name, 'cintArray2');
    Assert.IsnotNil(f.Initializer);
    Assert.IsTrue(f.Initializer is CGArrayLiteralExpression);
    Check.AreEqual(CGArrayLiteralExpression(f.Initializer).ArrayKind, CGArrayKind.Dynamic);
    Check.AreEqual(CGArrayLiteralExpression(f.Initializer).Elements.Count, 3);
    Assert.IsTrue(f.Type is CGArrayTypeReference);
    var lBounds := f.Type as CGArrayTypeReference;
    Check.AreEqual( lBounds.ArrayKind, CGArrayKind.Dynamic);

  end;
end;

end.