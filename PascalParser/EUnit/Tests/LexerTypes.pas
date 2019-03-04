namespace PascalParser;

interface
uses
 RemObjects.Elements.EUnit;

type
  TMyTestObject = class(Test)
  public
    procedure Test1;
    procedure Test2;
    procedure Test3;
    procedure Test5;

  end;

implementation


procedure TMyTestObject.Test1;
begin
  Check.AreEqual(TptTokenKind.ptAbort.EnumName, 'Abort');
  Check.AreEqual(TptTokenKind.ptXor.EnumName, 'Xor');
  Check.IsTrue(TptTokenKind.ptAnsiComment.isJunk);
  Check.IsTrue(TptTokenKind.ptUndefDirect.isJunk);

end;


procedure TMyTestObject.Test2;
begin
  Check.AreEqual(TmwParseError.vchInvalidIncludeFile.ToString, 'vchInvalidIncludeFile');
end;


procedure TMyTestObject.Test3;
begin
  Check.AreEqual(TAttributeName.anReintroduce.ToString, 'anReintroduce');
end;



procedure TMyTestObject.Test5;
begin
  Check.AreEqual(TSyntaxNodeType.ntAnonymousMethod.EnumName, 'AnonymousMethod');
  Check.AreEqual(TSyntaxNodeType.ntClassConstraint.EnumName, 'ClassConstraint');
end;


end.