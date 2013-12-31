unit FluentQuery.Enumerators;

interface
uses
  System.Generics.Collections,
  System.Classes,
  FluentQuery.Types,
  FluentQuery.EnumerationStrategies;

type
  TMinimalEnumerator<T> = class(TinterfacedObject, IMinimalEnumerator<T>)
  protected
    FEnumerationStrategy : TEnumerationStrategy<T>;
    FSourceData : IMinimalEnumerator<T>;
    function GetCurrent: T; overload;
    function MoveNext: Boolean;
  public
    constructor Create(SourceData : IMinimalEnumerator<T>; EnumerationStrategy : TEnumerationStrategy<T>); virtual;
    destructor Destroy; override;
    property Current: T read GetCurrent;
  end;

  TStringsEnumeratorAdapter = class(TInterfacedObject, IMinimalEnumerator<String>)
  protected
    FStringsEnumerator : TStringsEnumerator;
    function GetCurrent: String;
    function MoveNext: Boolean;
  public
    constructor Create(Strings : TStrings); virtual;
    destructor Destroy; override;
    property Current: String read GetCurrent;
  end;

  TGenericEnumeratorAdapter<T> = class(TInterfacedObject, IMinimalEnumerator<T>)
  protected
    FEnumerator : TEnumerator<T>;
    function GetCurrent: T;
  public
    constructor Create(Enumerator : TEnumerator<T>); virtual;
    destructor Destroy; override;
    function MoveNext: Boolean;
    property Current: T read GetCurrent;
  end;

  TStringEnumeratorAdapter = class(TInterfacedObject, IMinimalEnumerator<Char>)
  protected
    FStringValue : String;
    FIndex : Integer;
    function GetCurrent: Char;
    function MoveNext: Boolean;
  public
    constructor Create(StringValue : String); virtual;
    property Current: Char read GetCurrent;
  end;

implementation

{ TMinimalEnumerator<T> }

constructor TMinimalEnumerator<T>.Create(SourceData : IMinimalEnumerator<T>;
                                         EnumerationStrategy: TEnumerationStrategy<T>);
begin
  FSourceData := SourceData;
  FEnumerationStrategy := EnumerationStrategy;
end;

destructor TMinimalEnumerator<T>.Destroy;
begin
  FEnumerationStrategy.Free;
  inherited;
end;

function TMinimalEnumerator<T>.GetCurrent: T;
begin
  Result := FEnumerationStrategy.GetCurrent(FSourceData);;
end;

function TMinimalEnumerator<T>.MoveNext: Boolean;
begin
  Result := FEnumerationStrategy.MoveNext(FSourceData);
end;


{ TStringsEnumeratorWrapper }

constructor TStringsEnumeratorAdapter.Create(Strings: TStrings);
begin
  FStringsEnumerator := TStringsEnumerator.Create(Strings);
end;

destructor TStringsEnumeratorAdapter.Destroy;
begin
  FStringsEnumerator.Free;
  inherited;
end;

function TStringsEnumeratorAdapter.GetCurrent: String;
begin
  Result := FStringsEnumerator.Current;
end;

function TStringsEnumeratorAdapter.MoveNext: Boolean;
begin
  Result := FStringsEnumerator.MoveNext;;
end;


{ TGenericEnumeratorWrapper<T> }

constructor TGenericEnumeratorAdapter<T>.Create(Enumerator: TEnumerator<T>);
begin
  FEnumerator := Enumerator;
end;

destructor TGenericEnumeratorAdapter<T>.Destroy;
begin
  FEnumerator.Free;
  inherited;
end;

function TGenericEnumeratorAdapter<T>.GetCurrent: T;
begin
  Result := FEnumerator.Current;
end;

function TGenericEnumeratorAdapter<T>.MoveNext: Boolean;
begin
  Result := FEnumerator.MoveNext;
end;

{ TStringEnumeratorWrapper }

constructor TStringEnumeratorAdapter.Create(StringValue: String);
begin
  FStringValue := StringValue;
  FIndex := Low(StringValue) - 1;
end;

function TStringEnumeratorAdapter.GetCurrent: Char;
begin
  Result := FStringValue[FIndex];
end;

function TStringEnumeratorAdapter.MoveNext: Boolean;
begin
  Inc(FIndex);

  Result := FIndex <= High(FStringValue);
end;

end.
