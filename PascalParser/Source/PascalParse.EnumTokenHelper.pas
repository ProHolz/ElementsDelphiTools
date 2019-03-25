namespace ProHolz.Ast;

type
  TptTokenKindHelper = public extension class(TptTokenKind)
  public
    class method IsTokenIDJunk(const aTokenID: TptTokenKind): Boolean;
    begin
      Result := aTokenID in [
      TptTokenKind.ptAnsiComment,
        TptTokenKind.ptBorComment,
        TptTokenKind.ptCRLF,
        TptTokenKind.ptCRLFCo,
        TptTokenKind.ptSlashesComment,
        TptTokenKind.ptSpace,
        TptTokenKind.ptIfDirect,
        TptTokenKind.ptElseDirect,
        TptTokenKind.ptIfEndDirect,
        TptTokenKind.ptElseIfDirect,
        TptTokenKind.ptIfDefDirect,
        TptTokenKind.ptIfNDefDirect,
        TptTokenKind.ptEndIfDirect,
        TptTokenKind.ptIfOptDirect,
        TptTokenKind.ptDefineDirect,
        TptTokenKind.ptScopedEnumsDirect,
        TptTokenKind.ptUndefDirect];
    end;

    method isJunk : Boolean; inline;
    begin
      exit IsTokenIDJunk(self);
    end;

    method EnumName() : String;
    begin
      exit Self.ToString.Substring(2);
    end;

  end;


end.