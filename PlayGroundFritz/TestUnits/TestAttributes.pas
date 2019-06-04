namespace ProHolz.CodeGen;

const TestAttributes = "
unit TestAttributes;

interface
 uses
  classes;

  type
    NameAttribute = class(TCustomAttribute)

       constructor Create(const AName : string);
    end;

  [Name ('Class')]
  TuseAttrib = class

    [Name ('Test')]
    fdata : integer;

    [Index (40, 'Test')]
    [Name ('Test2')]
    fid : Integer;
    [Name ('Test3')]
    procedure Test; stdcall;

  end;

implementation

{ TNameAttribute }

constructor NameAttribute.Create(const AName: string);
begin

end;

procedure TuseAttrib.Test;
begin
end;

end.

";
end.