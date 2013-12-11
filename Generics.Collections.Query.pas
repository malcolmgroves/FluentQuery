unit Generics.Collections.Query;

interface
uses
  System.Generics.Collections, System.SysUtils;

type
  TQueryEnumerator<T> = class(TEnumerator<T>)
  protected
    FUpstreamEnumerator : TEnumerator<T>;
    function DoGetCurrent: T; override;
    function DoMoveNext: Boolean; override;
  public
    constructor Create(Enumerator : TEnumerator<T>); virtual;
    destructor Destroy; override;
    function GetEnumerator: TQueryEnumerator<T>;
    function Take(Count : Integer): TQueryEnumerator<T>;
    function Where(Predicate : TPredicate<T>) : TQueryEnumerator<T>;
    property Current: T read DoGetCurrent;
  end;

  TTakeEnumerator<T> = class(TQueryEnumerator<T>)
  private
    FMaxPassCount: Integer;
    FPassCount : Integer;
  protected
    function DoMoveNext: Boolean; override;
  public
    constructor Create(Enumerator : TEnumerator<T>; PassCount : Integer); reintroduce;
    property MaxPassCount : Integer read FMaxPassCount write FMaxPassCount;
  end;

  TWhereEnumerator<T> = class(TQueryEnumerator<T>)
  private
    FWherePredicate : TPredicate<T>;
  protected
    function DoMoveNext: Boolean; override;
    function ShouldIncludeItem : Boolean;
  public
    constructor Create(Enumerator : TEnumerator<T>; Predicate : TPredicate<T>); reintroduce;
  end;

  Query<T> = class
    class function From(Collection : TEnumerable<T>) : TQueryEnumerator<T> ;
  end;


implementation


{ Query<T> }

class function Query<T>.From(Collection: TEnumerable<T>): TQueryEnumerator<T>;
begin
  Result := TQueryEnumerator<T>.Create(Collection.GetEnumerator);
end;

{ TQueryEnumerator<T> }

constructor TQueryEnumerator<T>.Create(Enumerator: TEnumerator<T>);
begin
  FUpstreamEnumerator := Enumerator;
end;

destructor TQueryEnumerator<T>.Destroy;
begin
  FUpstreamEnumerator.Free;
  inherited;
end;

function TQueryEnumerator<T>.DoGetCurrent: T;
begin
  Result := FUpstreamEnumerator.Current;
end;

function TQueryEnumerator<T>.DoMoveNext: Boolean;
begin
  Result := FUpstreamEnumerator.MoveNext;
end;

function TQueryEnumerator<T>.GetEnumerator: TQueryEnumerator<T>;
begin
  Result := self;
end;

function TQueryEnumerator<T>.Take(Count: Integer): TQueryEnumerator<T>;
begin
  Result := TTakeEnumerator<T>.Create(self, Count);
end;

function TQueryEnumerator<T>.Where(
  Predicate: TPredicate<T>): TQueryEnumerator<T>;
begin
  Result := TWhereEnumerator<T>.Create(self, Predicate);
end;

{ TAtMostEnumerator<T> }

constructor TTakeEnumerator<T>.Create(Enumerator: TEnumerator<T>; PassCount : Integer);
begin
  inherited Create(Enumerator);
  FPassCount := 0;
  FMaxPassCount := PassCount;
end;

function TTakeEnumerator<T>.DoMoveNext: Boolean;
begin
  Result := FPassCount < FMaxPassCount;

  if Result then
  begin
    Result := inherited DoMoveNext;
    Inc(FPassCount);
  end;
end;

{ TWhereEnumerator<T> }

constructor TWhereEnumerator<T>.Create(Enumerator: TEnumerator<T>;
  Predicate: TPredicate<T>);
begin
  inherited Create(Enumerator);
  FWherePredicate := Predicate;
end;

function TWhereEnumerator<T>.DoMoveNext: Boolean;
var
  IsDone : Boolean;
begin
  inherited DoMoveNext;

  repeat
    IsDone := ShouldIncludeItem;
  until IsDone or (not inherited DoMoveNext);

  Result := IsDone;
end;


function TWhereEnumerator<T>.ShouldIncludeItem: Boolean;
begin
    try
      if Assigned(FWherePredicate) then
        Result := FWherePredicate(Current)
      else
        Result := False;
    except
      on E : EArgumentOutOfRangeException do
        Result := False;
    end;
end;



end.
