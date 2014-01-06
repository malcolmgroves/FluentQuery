unit FluentQuery.Enumerators;

interface
uses
  System.Generics.Collections,
  System.Classes,
  FluentQuery.Types,
  FluentQuery.EnumerationStrategies;

type
  TBaseQueryEnumerator<T> = class(TInterfacedObject, IMinimalEnumerator<T>, IBaseQueryEnumerator<T>)
  protected
    FUpstreamQuery : IBaseQueryEnumerator<T>;
    FEnumerationStrategy : TEnumerationStrategy<T>;
    FSourceData : IMinimalEnumerator<T>;
    procedure SetSourceData(SourceData : IMinimalEnumerator<T>); virtual;
    function GetCurrent: T; virtual;
    function MoveNext: Boolean; virtual;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<T>;
                       UpstreamQuery : IBaseQueryEnumerator<T> = nil;
                       SourceData : IMinimalEnumerator<T> = nil); virtual;
    destructor Destroy; override;
    procedure SetUpstreamQuery(UpstreamQuery : IBaseQueryEnumerator<T>);
  end;


  TStringsEnumeratorAdapter = class(TInterfacedObject, IMinimalEnumerator<String>)
  protected
    FStringsEnumerator : TStringsEnumerator;
    function GetCurrent: String;
    function MoveNext: Boolean;
  public
    constructor Create(StringsEnumerator : TStringsEnumerator); virtual;
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

  TSingleValueAdapter<T> = class(TInterfacedObject, IMinimalEnumerator<T>)
  private
    FMoveCount: Integer;
    FValue : T;
  public
    function GetCurrent: T;
    function MoveNext: Boolean;
    constructor Create(Value : T);
  end;

  TListEnumeratorAdapter = class(TinterfacedObject, IMinimalEnumerator<Pointer>)
    FListEnumerator : TListEnumerator;
    function GetCurrent: Pointer;
    function MoveNext: Boolean;
  public
    constructor Create(ListEnumerator : TListEnumerator); virtual;
    destructor Destroy; override;
    property Current: Pointer read GetCurrent;
  end;

implementation

{ TStringsEnumeratorWrapper }

constructor TStringsEnumeratorAdapter.Create(StringsEnumerator : TStringsEnumerator);
begin
  FStringsEnumerator := StringsEnumerator;
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

{ TSingleValueAdapter<T> }

constructor TSingleValueAdapter<T>.Create(Value: T);
begin
  FValue := Value;
end;

function TSingleValueAdapter<T>.GetCurrent: T;
begin
  Result := FValue;
end;

function TSingleValueAdapter<T>.MoveNext: Boolean;
begin
  Inc(FMoveCount);
  Result := FMoveCount = 1;
end;

{ TListEnumeratorAdapter }

constructor TListEnumeratorAdapter.Create(ListEnumerator: TListEnumerator);
begin
  FListEnumerator := ListEnumerator;
end;

destructor TListEnumeratorAdapter.Destroy;
begin
  FListEnumerator.Free;
  inherited;
end;

function TListEnumeratorAdapter.GetCurrent: Pointer;
begin
  Result := FListEnumerator.Current;
end;

function TListEnumeratorAdapter.MoveNext: Boolean;
begin
  Result := FListEnumerator.MoveNext;
end;


{ TBaseQueryEnumerator<T> }


constructor TBaseQueryEnumerator<T>.Create(
  EnumerationStrategy: TEnumerationStrategy<T>;
  UpstreamQuery: IBaseQueryEnumerator<T>; SourceData: IMinimalEnumerator<T>);
begin
  SetUpstreamQuery(UpstreamQuery);
  SetSourceData(SourceData);
  FEnumerationStrategy := EnumerationStrategy;
end;

destructor TBaseQueryEnumerator<T>.Destroy;
begin
  FEnumerationStrategy.Free;
  inherited;
end;

function TBaseQueryEnumerator<T>.GetCurrent: T;
begin
  if Assigned(FUpstreamQuery) then
    Result := FEnumerationStrategy.GetCurrent(FUpstreamQuery)
  else
    Result := FEnumerationStrategy.GetCurrent(FSourceData);;
end;

function TBaseQueryEnumerator<T>.MoveNext: Boolean;
begin
  if Assigned(FUpstreamQuery) then
    Result := FEnumerationStrategy.MoveNext(FUpstreamQuery)
  else
    Result := FEnumerationStrategy.MoveNext(FSourceData);
end;

procedure TBaseQueryEnumerator<T>.SetSourceData(
  SourceData: IMinimalEnumerator<T>);
begin
  if Assigned(SourceData) then
  begin
    if Assigned(FUpstreamQuery) then
      FUpstreamQuery.SetSourceData(SourceData)
    else
      FSourceData := SourceData;
  end;
end;

procedure TBaseQueryEnumerator<T>.SetUpstreamQuery(
  UpstreamQuery: IBaseQueryEnumerator<T>);
begin
  FUpstreamQuery := UpstreamQuery;
end;

end.
