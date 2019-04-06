unit TestAll;

interface
 uses
   Windows,
   Sysutils,
   Classes;


  type
    varRecord = record
      case boolean of
       false : (b : Boolean);
       true : (c : Integer);

    end;


    testRecord = record
       x,y : integer;
    end;

   const T : testrecord = (X:1; y:2);

implementation
 uses
  System.Math;



end.
