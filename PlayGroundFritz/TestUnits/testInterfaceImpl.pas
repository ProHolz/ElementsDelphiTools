namespace ProHolz.CodeGen;
const TestInterfaceImpl = "

unit testInterface;

interface
  uses
   classes;
type
  ISimple<T> = Interface
  ['{E70B0D49-F2FC-432F-BB0F-E27AE25956C2}']
   procedure TestSimple;
  end;

 IBase = Interface
 ['{172278F8-24F9-41D4-96BA-865FD3E7B07A}']
   procedure TestBase;
  end;

  TSimple = class(TInterfacedObject, ISimple)
    procedure TestSimple;
  end;

   TBase = class(TInterfacedObject, IBase, ISimple)
   private
   function GetSimple : ISimple;

    procedure Allocate;

    procedure IBase.TestBase = Allocate;

   property  Simple : ISimple read getSimple implements ISimple;

  end;


implementation

{ TSimple }

procedure TSimple.TestSimple;
begin

end;

{ TBase }

function TBase.GetSimple: ISimple;
begin

end;

procedure TBase.Allocate;
begin

end;

end.

";

end.