namespace TestCodegen;

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
    method TestArrayType;
    method TestArrayOfArray;
    method TestArray;
    method SeconsTest;
    method RangeTest;

    method TestCairoArrayType;

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
          Assert.IsTrue(f.Type is CGArrayTypeReference);
          Assert.IsnotNil(f.Initializer);
          Assert.IsTrue(f.Initializer is CGArrayLiteralExpression);
          Check.AreEqual(CGArrayLiteralExpression(f.Initializer).ArrayKind, CGArrayKind.Dynamic);
          Check.AreEqual(CGArrayLiteralExpression(f.Initializer).Elements.Count, 3);
          var lBounds := f.Type as CGArrayTypeReference;
          Check.IsTrue(lBounds.Type is CGPredefinedTypeReference);
          Check.AreEqual( lBounds.ArrayKind, CGArrayKind.Static);
      end;

      2 : begin
          Check.AreEqual(f.Name, 'AllInt');
        Assert.IsnotNil(f.Initializer);
        Assert.IsTrue(f.Initializer is CGArrayLiteralExpression);
        Check.AreEqual(CGArrayLiteralExpression(f.Initializer).ArrayKind, CGArrayKind.Dynamic);
        Check.AreEqual(CGArrayLiteralExpression(f.Initializer).Elements.Count, 2);
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

method TestArrayConsts.TestArrayOfArray;
begin
  var lunit := BuildUnit(tbUnitType.interface ,"

const
  TwoDigitLookup: packed array[0..99] of array[1..2] of AnsiChar =
    ('00','01','02','03','04','05','06','07','08','09',
     '10','11','12','13','14','15','16','17','18','19',
     '20','21','22','23','24','25','26','27','28','29',
     '30','31','32','33','34','35','36','37','38','39',
     '40','41','42','43','44','45','46','47','48','49',
     '50','51','52','53','54','55','56','57','58','59',
     '60','61','62','63','64','65','66','67','68','69',
     '70','71','72','73','74','75','76','77','78','79',
     '80','81','82','83','84','85','86','87','88','89',
     '90','91','92','93','94','95','96','97','98','99');

");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 1);


  for each matching GV : CGGlobalVariableDefinition in lunit.Globals index i  do
    begin
    var f := GV.Variable;
    Check.IsTrue(f.Constant);
    case i of
      0 : begin
          Check.AreEqual(f.Name, 'TwoDigitLookup');
        Assert.IsnotNil(f.Initializer);
        Assert.IsTrue(f.Initializer is CGArrayLiteralExpression);
        Check.AreEqual(CGArrayLiteralExpression(f.Initializer).ArrayKind, CGArrayKind.Dynamic);
        Check.AreEqual(CGArrayLiteralExpression(f.Initializer).Elements.Count, 100);
        Assert.IsTrue(f.Type is CGArrayTypeReference);
        var lBounds := f.Type as CGArrayTypeReference;
        Check.AreEqual( lBounds.ArrayKind, CGArrayKind.Static);
        Check.IsTrue(lBounds.Type is CGArrayTypeReference);
        lBounds := lBounds.Type as CGArrayTypeReference;
        Check.IsTrue(lBounds.Type is CGPredefinedTypeReference);
      end;
    end;
  end;
end;

method TestArrayConsts.TestArrayType;
begin
  var lunit := BuildUnit(tbUnitType.interface ,"

type
  TwoLevelArray = packed array[0..99] of array[1..2] of Array[0..2] of AnsiChar;

var
  TwoDigitLookup : packed array[0..99] of array[1..2] of AnsiChar;



");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 1);
  Assert.AreEqual(lunit.Types.Count, 1);


  for each matching GT: CGTypeAliasDefinition  in lunit.Types index i do
    begin
    case i of
      0 :  begin
        Check.AreEqual(GT.Name, 'TwoLevelArray');
        Assert.IsTrue(GT.ActualType is CGArrayTypeReference);
        var lBounds := GT.ActualType as CGArrayTypeReference;
        Check.AreEqual( lBounds.ArrayKind, CGArrayKind.Static);
        Check.IsTrue(lBounds.Type is CGArrayTypeReference);
        lBounds := lBounds.Type as CGArrayTypeReference;
        Check.IsTrue(lBounds.Type is CGArrayTypeReference);
        lBounds := lBounds.Type as CGArrayTypeReference;
        Check.IsTrue(lBounds.Type is CGPredefinedTypeReference);
      end;
    end;
  end;


  for each matching GV : CGGlobalVariableDefinition in lunit.Globals index i  do
    begin
    var f := GV.Variable;

    case i of
      0 : begin
          Check.IsFalse(f.Constant);
          Check.AreEqual(f.Name, 'TwoDigitLookup');

        Assert.IsTrue(f.Type is CGArrayTypeReference);
        var lBounds := f.Type as CGArrayTypeReference;
        Check.AreEqual( lBounds.ArrayKind, CGArrayKind.Static);
        Check.IsTrue(lBounds.Type is CGArrayTypeReference);
        lBounds := lBounds.Type as CGArrayTypeReference;
        Check.IsTrue(lBounds.Type is CGPredefinedTypeReference);

      end;

      1 : begin
          Check.IsTrue(f.Constant);
        Check.AreEqual(f.Name, 'coeffsHigh');

         Assert.IsTrue(f.Type is CGArrayTypeReference);
         var lBounds := f.Type as CGArrayTypeReference;
         Check.AreEqual( lBounds.ArrayKind, CGArrayKind.Static);
         Check.IsTrue(lBounds.Type is CGArrayTypeReference);
         lBounds := lBounds.Type as CGArrayTypeReference;
         Check.IsTrue(lBounds.Type is CGPredefinedTypeReference);

       end;

    end;
  end;
end;

method TestArrayConsts.TestArray;
begin
  var lunit := BuildUnit(tbUnitType.Body ,"

type
  TSQLDBFieldTypeArray = array[0..MAX_SQLFIELDS] of TSQLDBFieldType;
 oneLevelArray = array[0..99] of Integer;
 TwoLevelArray = packed array[0..99] of array[1..2]  of INT64;
 ThreeLevelArray = packed array[0..99] of array[1..2] of Array[0..2] of AnsiChar;
TPtrUIntArray = array[0..MaxInt div SizeOf(PtrUInt)-1] of PtrUInt;

implementation

procedure TestArray(const cintArray : intArray = []);
var i : integer;
begin
  for I in cintArray do
   begin
    Start();
    Start2();
   end;

end;


");

  Assert.IsNotNil(lunit);

  //Var lOut := new CGOxygeneCodeGenerator();
  //writeLn(lOut.GenerateUnit(lunit));

  Assert.AreEqual(lunit.Types.Count, 5);


  for each matching GT: CGTypeAliasDefinition  in lunit.Types index i do
    begin
    case i of
      1 :  begin
        Check.AreEqual(GT.Name, 'oneLevelArray');
        Assert.IsTrue(GT.ActualType is CGArrayTypeReference);
        var lBounds := GT.ActualType as CGArrayTypeReference;
        Check.AreEqual( lBounds.ArrayKind, CGArrayKind.Static);
        Assert.IsTrue(lBounds.Type is CGPredefinedTypeReference);
        var ltemp := lBounds.Type as CGPredefinedTypeReference;
        Check.IsTrue(  ltemp.Kind = CGPredefinedTypeKind.Int32);


      end;

      2 :  begin
        Check.AreEqual(GT.Name, 'TwoLevelArray');
        Assert.IsTrue(GT.ActualType is CGArrayTypeReference);
        var lBounds := GT.ActualType as CGArrayTypeReference;
        Check.AreEqual( lBounds.ArrayKind, CGArrayKind.Static);
        Check.IsTrue(lBounds.Type is CGArrayTypeReference);

        lBounds := lBounds.Type as CGArrayTypeReference;
        Check.IsTrue(lBounds.Type is CGPredefinedTypeReference);


      end;


      3 :  begin
        Check.AreEqual(GT.Name, 'ThreeLevelArray');
        Assert.IsTrue(GT.ActualType is CGArrayTypeReference);
        var lBounds := GT.ActualType as CGArrayTypeReference;
        Check.AreEqual( lBounds.ArrayKind, CGArrayKind.Static);
        Check.IsTrue(lBounds.Type is CGArrayTypeReference);

        lBounds := lBounds.Type as CGArrayTypeReference;
        Check.IsTrue(lBounds.Type is CGArrayTypeReference);
        lBounds := lBounds.Type as CGArrayTypeReference;
        Check.IsTrue(lBounds.Type is CGPredefinedTypeReference);
      end;

      0 :  begin
        Check.AreEqual(GT.Name, 'TSQLDBFieldTypeArray');
        Assert.IsTrue(GT.ActualType is CGArrayTypeReference);
        var lBounds := GT.ActualType as CGArrayTypeReference;
        Check.AreEqual( lBounds.ArrayKind, CGArrayKind.Static);
        Check.IsTrue(lBounds.Type is CGNamedTypeReference);


      end;


    end;
  end;

end;

method TestArrayConsts.SeconsTest;
begin
  var lunit := BuildUnit(tbUnitType.interface ,"

type
 oneLevelSet = set of Byte; // alias to set of byte
 twoLevelSet = set of (one, two , three); // New set type
 Range = 0..20;

RangeSet = set of Range;
RangeArray = Array[Range] of Integer;

");

  Assert.IsNotNil(lunit);

  Assert.AreEqual(lunit.Types.Count, 5);


  for each matching GT: CGTypeDefinition  in lunit.Types index i do
    begin
    case i of
      0 :  begin
        Check.AreEqual(GT.Name, 'oneLevelSet');
        Assert.IsTrue(GT is CGTypeAliasDefinition);
        Check.IsTrue(CGTypeAliasDefinition(GT).ActualType is CGSetTypeReference);
      end;

      1 :  begin
        Check.AreEqual(GT.Name, 'twoLevelSet');
        Assert.IsTrue(GT is CGSetTypeDefinition);
      end;


      2 :  begin
        Check.AreEqual(GT.Name, 'Range');
        Assert.IsTrue(GT is CGTypeAliasDefinition);
      end;
    end;
  end;


end;

method TestArrayConsts.RangeTest;
begin
  var lunit := BuildUnit(tbUnitType.interface ,"

type
 Range = 0..20;

");

  Assert.IsNotNil(lunit);

  Assert.AreEqual(lunit.Types.Count, 1);


  for each matching GT: CGTypeDefinition  in lunit.Types index i do
    begin
    case i of

      0 :  begin
        Check.AreEqual(GT.Name, 'Range');
        Assert.IsTrue(GT is CGTypeAliasDefinition);
      end;
    end;
  end;


end;


method TestArrayConsts.TestCairoArrayType;
begin
  var lunit := BuildUnit(tbUnitType.interface ,"

type
  TCoeff = array[0..3] of Double;
  TCoeffArray = array [0 .. 1, 0 .. 3] of TCoeff;


  const
  coeffsHigh: TCoeffArray = (((0.0899116, - 19.2349, - 4.11711, 0.183362), (0.138148, - 1.45804, 1.32044, 1.38474), (0.230903, - 0.450262, 0.219963, 0.414038),
    (0.0590565, - 0.101062, 0.0430592, 0.0204699)), ((0.0164649, 9.89394, 0.0919496, 0.00760802), (0.0191603, - 0.0322058, 0.0134667, - 0.0825018),
    (0.0156192, - 0.017535, 0.00326508, - 0.228157), ( - 0.0236752, 0.0405821, - 0.0173086, 0.176187)));


");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Globals.Count, 1);
  Assert.AreEqual(lunit.Types.Count, 2);


  for each matching GT: CGTypeAliasDefinition  in lunit.Types index i do
    begin
    case i of
      0 :  begin
        Check.AreEqual(GT.Name, 'TCoeff');
        Assert.IsTrue(GT.ActualType is CGArrayTypeReference);
        var lBounds := GT.ActualType as CGArrayTypeReference;
        Check.AreEqual( lBounds.ArrayKind, CGArrayKind.Static);
        Assert.IsTrue(lBounds.Type is CGPredefinedTypeReference);
        //lBounds := lBounds.Type as CGArrayTypeReference;
        //Check.IsTrue(lBounds.Type is CGArrayTypeReference);
        //lBounds := lBounds.Type as CGArrayTypeReference;

      end;

      1 :  begin
        Check.AreEqual(GT.Name, 'TCoeffArray');
        Assert.IsTrue(GT.ActualType is CGArrayTypeReference);
        var lBounds := GT.ActualType as CGArrayTypeReference;
        Check.AreEqual( lBounds.ArrayKind, CGArrayKind.Static);
        Assert.IsTrue(lBounds.Type is CGNamedTypeReference);
        //lBounds := lBounds.Type as CGArrayTypeReference;
        //Check.IsTrue(lBounds.Type is CGArrayTypeReference);
        //lBounds := lBounds.Type as CGArrayTypeReference;

      end;


    end;
  end;


  for each matching GV : CGGlobalVariableDefinition in lunit.Globals index i  do
    begin
    var f := GV.Variable;

    case i of
      0 : begin
          Check.IsTrue(f.Constant);
         Check.AreEqual(f.Name, 'coeffsHigh');

        Assert.IsTrue(f.Type is CGNamedTypeReference);
        Assert.IsTrue(f.Initializer is CGArrayLiteralExpression);
        var lBounds := f.Initializer as CGArrayLiteralExpression;
        Check.AreEqual( lBounds.ArrayKind, CGArrayKind.Dynamic);
        Check.AreEqual( lBounds.Elements.Count, 2);


      end;

    end;
  end;
end;




end.