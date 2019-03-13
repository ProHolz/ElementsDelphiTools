namespace PlayGroundFritz;
const
  TestExceptions = "
  unit TestExceptions;

interface

implementation

uses
   sysutils,
   classes;

procedure SimpleTryFinally;
var
   MyClass: TComponent;
begin
   MyClass := TComponent.Create(nil);
   try
   //  if MyClass.HasParent then;
   finally
      MyClass.Free;
   end;
end;

procedure SimpleTryExcept;
begin
   try
    calltest();
   except
    calltest();
   end;
end;

procedure TryExcept;
begin
   try
    calltest();
   except
     ON E:Exception do
       begin
         calltest();
      end
      else
      begin
        raise;
      end;
   end;
end;


procedure RaiseExcept;
begin
   try
     calltest();
    except
      on Exception do;
    end;

   raise Exception.Create('Errormessage');
end;


end.

  ";

end.