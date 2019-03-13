namespace PlayGroundFritz;

var Testrecord := "
unit TestRecord;

interface
 {$DESCRIPTION 'TEST Description '}
 {$R *.res}
 {$R *.dfm}

 type

  Test_record = record
   private
     fData : integer;
    function GetData : integer;
   public
    constructor Create(aData : Integer);
    class operator Add(a, b: Test_record): Test_record;
    class operator Implicit(value: integer): Test_record;
    class operator Implicit(value: Test_record): integer;
    Procedure Test;
    property Data : integer read GetData write fData;
  end;


  procedure doTestRecord;


implementation

{ tTestrecord }

function Test_record.GetData : integer;
begin
  exit (fData);
end;

constructor Test_record.Create(aData: Integer);
begin
 fdata := aData;
end;

class operator Test_record.Add(a, b: Test_record): Test_record;
begin
   result := Test_record.create(a.fData + b.Fdata);
end;




class operator Test_record.Implicit(value: integer): Test_record;
begin
  result.fData := value;
end;

class operator Test_record.Implicit(value: Test_record): integer;
begin
   result := value.fData;
end;

procedure doTestRecord;
var a,b,c : Test_record;
begin
 a :=   Test_record.Create(10);
 b :=   20;
 c := a+b;
end;

end.

";

end.