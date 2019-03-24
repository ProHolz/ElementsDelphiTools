namespace TestCodegen;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestClasses = public class(TestParserBase)
  private

  protected
  public
    method testSimpleclass;
    method testSimpleClassMethods;
    method testClassConstructor;
    method testConstructor;
    method testVirtuality;
    method testAncestor;
    method testSimpleProperty;
    method testProperty;
  end;

implementation

method TestClasses.testSimpleclass;
begin
  var lunit := BuildUnit(tbUnitType.interface ,"
 type
   Tsimple = class
   private
    a : integer;
    b : integer;
   protected
     c : integer;
    public
     d : integer;
   end;
");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Types.Count, 1);
  for each matching GV : CGClassTypeDefinition in lunit.Types do
    begin
    Check.AreEqual(GV.Members.Count, 4);
    for each matching m : CGFieldDefinition in GV.Members index i do
      begin
      case i of
        0 : begin
          Check.AreEqual(m.Name, 'a');
          Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Private);
        end;
        1 : begin
          Check.AreEqual(m.Name, 'b');
          Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Private);
        end;
        2 : begin
          Check.AreEqual(m.Name, 'c');
          Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Protected);
        end;
        3 : begin
          Check.AreEqual(m.Name, 'd');
          Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Public);
        end;

      end;
    end;
  end;
end;

method TestClasses.testSimpleClassMethods;
begin
  var lunit := BuildUnit(tbUnitType.Body ,"
  type
  Tsimple = class
 private
  procedure procPrivate;
 protected
 class   procedure procProtected;
  public
  procedure procPublic; stdcall;
  end;
implementation
procedure Tsimple.procPrivate;
begin
end;
class procedure Tsimple.procProtected;
begin
end;
procedure Tsimple.procPublic;
begin
end;
end.
  ");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Types.Count, 1);
  for each matching GV : CGClassTypeDefinition in lunit.Types do
    begin
    Check.AreEqual(GV.Members.Count, 3);
    for each matching m : CGMethodDefinition in GV.Members index i do
      begin
      case i of
        0 : begin
          Check.AreEqual(m.Name, 'procPrivate');
          Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Private);
          Check.IsFalse( m.Static);
        end;
        1 : begin
          Check.AreEqual(m.Name, 'procProtected');
          Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Protected);
          Check.IsTrue( m.Static);
        end;
        2 : begin
          Check.AreEqual(m.Name, 'procPublic');
          Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Public);
          Check.IsFalse( m.Static);
          Check.AreEqual(m.CallingConvention, CGCallingConventionKind.StdCall);
        end;
      end;
    end;
  end;
end;

method TestClasses.testClassConstructor;
begin
  var lunit := BuildUnit(tbUnitType.Body ,"
type
 Tsimple = class
  public
   class constructor Create;
   class destructor Destroy;

 end;
 implementation
class constructor Tsimple.Create;
begin
end;
 class destructor Tsimple.Destroy;
begin
end;

");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Types.Count, 1);
  for each matching GV : CGClassTypeDefinition in lunit.Types do
    begin
    Check.AreEqual(GV.Members.Count, 2);
    for each matching m : CGMethodLikeMemberDefinition in GV.Members index i do
      begin
      case i of
        0 : begin
            Check.IsTrue(m is CGConstructorDefinition);
            Check.AreEqual(m.Name, '');
            Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Public);
            Check.IsTrue( m.Static);
        end;
        1 : begin
          //  Check.IsTrue(m is CGDestructorDefinition);
          Check.EndsWith('Destroy', m.Name);
          Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Public);
          Check.IsTrue( m.Static);
        end;
      end;
    end;
  end;
end;

method TestClasses.testConstructor;
begin
  var lunit := BuildUnit(tbUnitType.Body ,"
type
Tsimple = class
public
  constructor Create;
  destructor Destroy; virtual;

end;
implementation
 constructor Tsimple.Create;
begin
end;
 destructor Tsimple.Destroy;
begin
end;

");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Types.Count, 1);
  for each matching GV : CGClassTypeDefinition in lunit.Types do
    begin

    // we should have 3 Members now
    // constructor without name.....
    // class function with name and result Type
    // destructor as method

    Check.AreEqual(GV.Members.Count, 3);
    for each matching m : CGMethodLikeMemberDefinition in GV.Members index i do
      begin
      case i of
        0 : begin
          Check.IsTrue(m is CGConstructorDefinition);
          Check.AreEqual(m.Name, '');
          Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Public);
          Check.IsFalse( m.Static);
        end;
        1 : begin
          Check.IsTrue(m is CGMethodDefinition);
           Check.AreEqual(m.Name, 'Create');
           Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Public);
           Check.IsTrue( m.Static);
         end;

        2 : begin
          Check.IsFalse(m is CGDestructorDefinition);
          Check.IsTrue(m is CGMethodDefinition);
          Check.Contains('Destroy', m.Name);
          Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Public);
          Check.IsFalse( m.Static);
          Check.AreEqual( m.Virtuality, CGMemberVirtualityKind.Virtual);
          Check.AreEqual(m.Statements.Count, 1);
        end;
      end;
    end;
  end;
end;

method TestClasses.testVirtuality;
begin
  var lunit := BuildUnit(tbUnitType.Body ,"
type
Tsimple = class
public
constructor Create; override;
destructor Destroy; virtual;

procedure Test; overload;
procedure Test2; virtual; reintroduce;
procedure Test3; override; abstract;

end;
implementation
constructor Tsimple.Create;
begin
end;
destructor Tsimple.Destroy;
begin
end;

procedure Tsimple.Test;
begin
end;
procedure Tsimple.Test2;
begin
end;
procedure Tsimple.Test3;
begin
end;


");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Types.Count, 1);
  for each matching GV : CGClassTypeDefinition in lunit.Types do
    begin
    Check.AreEqual(GV.Members.Count, 6);
    for each matching m : CGMethodLikeMemberDefinition in GV.Members index i do
      begin
      case i of
        0 : begin
          Check.IsTrue(m is CGConstructorDefinition);
          Check.AreEqual(m.Name, '');
          Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Public);
          Check.IsFalse( m.Static);
          Check.AreEqual( m.Virtuality, CGMemberVirtualityKind.Override);
        end;

        1 : begin
          Check.IsTrue(m is CGMethodDefinition);
           Check.AreEqual(m.Name, 'Create');
           Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Public);
           Check.IsTrue( m.Static);
           Check.AreNotEqual( m.Virtuality, CGMemberVirtualityKind.Override);
         end;

        2 : begin
          Check.Isfalse(m is CGDestructorDefinition);
          Check.EndsWith('Destroy', m.Name );
          Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Public);
          Check.IsFalse( m.Static);
          Check.AreEqual( m.Virtuality, CGMemberVirtualityKind.Virtual);
        end;
        3 : begin

          Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Public);
          Check.IsFalse( m.Static);
          Check.AreEqual( m.Virtuality, CGMemberVirtualityKind.None);
        end;
        4 : begin
          Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Public);
          Check.IsFalse( m.Static);
          Check.AreEqual( m.Virtuality, CGMemberVirtualityKind.Virtual);
          // Will fail until we have a list for Virtuality
          Check.IsTrue( m.Reintroduced);
        end;
        5 : begin
          Check.AreEqual( m.Visibility, CGMemberVisibilityKind.Public);
          Check.IsFalse( m.Static);

          Check.AreEqual( m.Virtuality, CGMemberVirtualityKind.Abstract);
        end;
      end;
    end;
  end;
end;

method TestClasses.testAncestor;
begin
  var lunit := BuildUnit(tbUnitType.Body ,"
type
Tsimple = class(TObject, IInterface)


end;
implementation


");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Types.Count, 1);
  for each matching GV : CGClassTypeDefinition in lunit.Types do
    begin
    Check.AreEqual(GV.Members.Count, 0);
    Check.AreEqual(GV.Ancestors.Count, 2);
    for each  m  in GV.Ancestors index i do
      begin
      case i of
        0 : begin
          Assert.IsTrue(m is CGNamedTypeReference);
          Check.AreEqual( CGNamedTypeReference(m).Name, 'TObject');
        end;
        1 : begin
          Assert.IsTrue(m is CGNamedTypeReference);
          Check.AreEqual( CGNamedTypeReference(m).Name, 'IInterface');
        end;
      end;
    end;
  end;
end;

method TestClasses.testSimpleProperty;
begin
  var lunit := BuildUnit(tbUnitType.interface ,"
type
Tsimple = class
 private
   fIntProp : integer;
 public
  property intProp : Integer read fIntProp write fIntProp;
end;
");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Types.Count, 1);
  for each matching GV : CGClassTypeDefinition in lunit.Types do
    begin
    Check.AreEqual(GV.Members.Count, 2);

    for each  m  in GV.Members index i do
      begin
      case i of
        0 : begin
             Assert.IsTrue(m is CGFieldDefinition);
             Check.AreEqual(CGFieldDefinition(m).Name, 'fIntProp');
          end;
        1 : begin
            Assert.IsTrue(m is CGPropertyDefinition);
            Check.AreEqual(CGPropertyDefinition(m).Name, 'intProp');
        end;
      end;
    end;
  end;
end;

method TestClasses.testProperty;
begin
  var lunit := BuildUnit(tbUnitType.Body ,"
type
Tsimple = class
 private
   fIntProp : integer;
   function GetIntProp : integer;
   procedure SetIntProp(const value : Integer);
 public
  property intProp : Integer read GetIntProp write setIntProp;
end;

implementation
function Tsimple.GetIntProp : integer;
begin
  result := fIntProp;
end;

procedure Tsimple.SetIntProp(const value : Integer);
begin
  fIntProp := value;
end;

");

  Assert.IsNotNil(lunit);
  Assert.AreEqual(lunit.Types.Count, 1);
  for each matching GV : CGClassTypeDefinition in lunit.Types do
    begin
    Check.AreEqual(GV.Members.Count, 4);

    for each  m  in GV.Members index i do
      begin
      case i of
        0 : begin
          Assert.IsTrue(m is CGFieldDefinition);
          Check.AreEqual(CGFieldDefinition(m).Name, 'fIntProp');
        end;
        1 : begin
          Assert.IsTrue(m is CGMethodLikeMemberDefinition);
          Check.AreEqual(CGMethodLikeMemberDefinition(m).Name, 'GetIntProp');
        end;

        2 : begin
          Assert.IsTrue(m is CGMethodLikeMemberDefinition);
          Check.AreEqual(CGMethodLikeMemberDefinition(m).Name, 'SetIntProp');
         end;

        3 : begin
            Assert.IsTrue(m is CGPropertyDefinition);
            Check.AreEqual(CGPropertyDefinition(m).Name, 'intProp');
        end;
    end;
 end;
  end;
end;


end.