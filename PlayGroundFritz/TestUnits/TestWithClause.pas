namespace ProHolz.CodeGen;
const TestWithClause = "
unit TestMethods;

interface

implementation
 procedure test;
 begin

   with value do
     begin
       test := test+1;

     end;

 end;


end.


";
end.