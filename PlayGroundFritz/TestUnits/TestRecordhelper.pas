namespace ProHolz.CodeGen;
var TestRecordHelper := "
unit TestRecord;

interface
type
  { Extends TCursorKind }
  TCursorKindHelper = record helper for TCursorKind
  private
    {$REGION 'Internal Declarations'}
    function GetSpelling: String; inline;
    {$ENDREGION 'Internal Declarations'}
  public

    { Text version of the cursor kind. }
    property Spelling: String read GetSpelling;
  end;

implementation

function TCursorKindHelper.GetSpelling: String;
begin
  result := 'test';
end;


end.
";
end.