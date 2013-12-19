unit Generics.Collections.Enumerators;

interface
uses
  System.Generics.Collections, System.Classes,
  Generics.Collections.Query.Interfaces;

type
  TStringsEnumeratorWrapper = class(TInterfacedObject, IMinimalEnumerator<String>)
  protected
    FStringsEnumerator : TStringsEnumerator;
    function GetCurrent: String;
    function MoveNext: Boolean;
  public
    constructor Create(Strings : TStrings); virtual;
    destructor Destroy; override;
    property Current: String read GetCurrent;
  end;

  TGenericEnumeratorWrapper<T> = class(TInterfacedObject, IMinimalEnumerator<T>)
  protected
    FEnumerator : TEnumerator<T>;
    function GetCurrent: T;
  public
    constructor Create(Enumerator : TEnumerator<T>); virtual;
    destructor Destroy; override;
    function MoveNext: Boolean;
    property Current: T read GetCurrent;
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

function TStringsEnumeratorWrapper.GetCurrent: String;
begin
  Result := FStringsEnumerator.Current;
end;

function TStringsEnumeratorWrapper.MoveNext: Boolean;
begin
  Result := FStringsEnumerator.MoveNext;;
end;


{ TGenericEnumeratorWrapper<T> }

constructor TGenericEnumeratorWrapper<T>.Create(Enumerator: TEnumerator<T>);
begin
  FEnumerator := Enumerator;
end;

destructor TGenericEnumeratorWrapper<T>.Destroy;
begin
  FEnumerator.Free;
  inherited;
end;

function TGenericEnumeratorWrapper<T>.GetCurrent: T;
begin
  Result := FEnumerator.Current;
end;

function TGenericEnumeratorWrapper<T>.MoveNext: Boolean;
begin
  Result := FEnumerator.MoveNext;
end;

end.
