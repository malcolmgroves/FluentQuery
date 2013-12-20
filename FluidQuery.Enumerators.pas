unit FluidQuery.Enumerators;

interface
uses
  System.Generics.Collections, System.Classes,
  FluidQuery.Types, FluidQuery.EnumerationDelegates;

type
  TMinimalEnumerator<T> = class(TinterfacedObject, IMinimalEnumerator<T>)
  protected
    FEnumerationDelegate : TEnumerationDelegate<T>;
    function GetCurrent: T; overload;
    function MoveNext: Boolean;
  public
    constructor Create(EnumerationDelegate : TEnumerationDelegate<T>); virtual;
    destructor Destroy; override;
    property Current: T read GetCurrent;
  end;

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

{ TMinimalEnumerator<T> }

constructor TMinimalEnumerator<T>.Create(
  EnumerationDelegate: TEnumerationDelegate<T>);
begin
  FEnumerationDelegate := EnumerationDelegate;
end;

destructor TMinimalEnumerator<T>.Destroy;
begin
  FEnumerationDelegate.Free;
  inherited;
end;

function TMinimalEnumerator<T>.GetCurrent: T;
begin
  Result := FEnumerationDelegate.GetCurrent;
end;

function TMinimalEnumerator<T>.MoveNext: Boolean;
begin
  Result := FEnumerationDelegate.MoveNext;
end;


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
