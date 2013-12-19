unit Generics.Collections.Enumerators;

interface
uses
  System.Generics.Collections, System.Classes;

type
  TStringsEnumeratorWrapper = class(TEnumerator<String>)
  protected
    FStringsEnumerator : TStringsEnumerator;
    function DoGetCurrent: String; override;
    function DoMoveNext: Boolean; override;
  public
    constructor Create(Strings : TStrings);
    destructor Destroy; override;
  end;


implementation

{ TStringsEnumeratorWrapper }

constructor TStringsEnumeratorWrapper.Create(Strings: TStrings);
begin
  FStringsEnumerator := TStringsEnumerator.Create(Strings);
end;

destructor TStringsEnumeratorWrapper.Destroy;
begin
  FStringsEnumerator.Free;
  inherited;
end;

function TStringsEnumeratorWrapper.DoGetCurrent: String;
begin
  Result := FStringsEnumerator.Current;
end;

function TStringsEnumeratorWrapper.DoMoveNext: Boolean;
begin
  Result := FStringsEnumerator.MoveNext;;
end;


end.
