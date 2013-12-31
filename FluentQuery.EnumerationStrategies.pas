unit FluentQuery.EnumerationStrategies;

interface
uses
  Generics.Collections,
  System.SysUtils,
  FluentQuery.Types;

type
  TEnumerationStrategy<T> = class
  private
    FEnumerator : IMinimalEnumerator<T>;
  public
    function MoveNext: Boolean; virtual;
    function GetCurrent: T; virtual;
    constructor Create(Enumerator : IMinimalEnumerator<T>); virtual;
  end;

  TTakeEnumerationStrategy<T> = class(TEnumerationStrategy<T>)
  private
    FTakeCount: Integer;
    FItemCount : Integer;
  public
    function MoveNext: Boolean; override;
    constructor Create(Enumerator : IMinimalEnumerator<T>; TakeCount : Integer); reintroduce;
  end;

  TSkipEnumerationStrategy<T> = class(TEnumerationStrategy<T>)
  private
    FSkipCount: Integer;
    FItemCount : Integer;
  public
    function MoveNext: Boolean; override;
    constructor Create(Enumerator : IMinimalEnumerator<T>; SkipCount : Integer); reintroduce;
  end;

  TSkipWhileEnumerationStrategy<T> = class(TEnumerationStrategy<T>)
  private
    FSkipWhilePredicate : TPredicate<T>;
  protected
    function ShouldSkipItem : Boolean;
  public
    function MoveNext: Boolean; override;
    constructor Create(Enumerator : IMinimalEnumerator<T>; Predicate : TPredicate<T>); reintroduce;
  end;

  TTakeWhileEnumerationStrategy<T> = class(TEnumerationStrategy<T>)
  private
    FTakeWhilePredicate : TPredicate<T>;
  protected
    function ShouldTakeItem : Boolean;
  public
    function MoveNext: Boolean; override;
    constructor Create(Enumerator : IMinimalEnumerator<T>; Predicate : TPredicate<T>); reintroduce;
  end;

  TWhereEnumerationStrategy<T> = class(TEnumerationStrategy<T>)
  private
    FWherePredicate : TPredicate<T>;
  protected
    function ShouldIncludeItem : Boolean;
  public
    function MoveNext: Boolean; override;
    constructor Create(Enumerator : IMinimalEnumerator<T>; Predicate : TPredicate<T>); reintroduce;
  end;

implementation

{ TEnumerationStrategy<T> }

constructor TEnumerationStrategy<T>.Create(Enumerator: IMinimalEnumerator<T>);
begin
  FEnumerator := Enumerator;
end;


function TEnumerationStrategy<T>.GetCurrent: T;
begin
  Result := FEnumerator.Current;
end;

function TEnumerationStrategy<T>.MoveNext: Boolean;
begin
  Result := FEnumerator.MoveNext;
end;

{ TTakeEnumerationStrategy<T> }

constructor TTakeEnumerationStrategy<T>.Create(Enumerator: IMinimalEnumerator<T>;
  TakeCount: Integer);
begin
  inherited Create(Enumerator);
  FItemCount := 0;
  FTakeCount := TakeCount;
end;

function TTakeEnumerationStrategy<T>.MoveNext: Boolean;
begin
  Result := FItemCount < FTakeCount;

  if Result then
  begin
    Result := inherited MoveNext;
    Inc(FItemCount);
  end;
end;

{ TSkipEnumerationStrategy<T> }

constructor TSkipEnumerationStrategy<T>.Create(Enumerator: IMinimalEnumerator<T>;
  SkipCount: Integer);
begin
  inherited Create(Enumerator);
  FItemCount := 0;
  FSkipCount := SkipCount;
end;

function TSkipEnumerationStrategy<T>.MoveNext: Boolean;
var
  LEndOfList : Boolean;
begin
  LEndOFList := False;
  while (FItemCount < FSkipCount) do
  begin
    Inc(FItemCount);
    LEndOfList := not inherited MoveNext;
    if LEndOfList then
      break;
  end;

  if LEndOfList then
    Result := not LEndOfList
  else
    Result := inherited MoveNext;
end;

{ TSkipWhileEnumerationStrategy<T> }

constructor TSkipWhileEnumerationStrategy<T>.Create(Enumerator: IMinimalEnumerator<T>;
  Predicate: TPredicate<T>);
begin
  inherited Create(Enumerator);
  FSkipWhilePredicate := Predicate;
end;

function TSkipWhileEnumerationStrategy<T>.MoveNext: Boolean;
var
  LEndOfList : Boolean;
begin
  repeat
    LEndOfList := not inherited MoveNext;
    if LEndOfList then
      break;
  until not ShouldSkipItem;

  Result := not LEndOfList;
end;

function TSkipWhileEnumerationStrategy<T>.ShouldSkipItem: Boolean;
begin
  try
    if Assigned(FSkipWhilePredicate) then
      Result := FSkipWhilePredicate(GetCurrent)
    else
      Result := False;
  except
    on E : EArgumentOutOfRangeException do
      Result := False;
  end;
end;

{ TTakeWhileEnumerationStrategy<T> }

constructor TTakeWhileEnumerationStrategy<T>.Create(Enumerator: IMinimalEnumerator<T>;
  Predicate: TPredicate<T>);
begin
  inherited Create(Enumerator);
  FTakeWhilePredicate := Predicate;
end;

function TTakeWhileEnumerationStrategy<T>.MoveNext: Boolean;
var
  LAtEnd : Boolean;
begin
  LAtEnd := not inherited MoveNext;

  if LAtEnd then
    Exit(False);

  if ShouldTakeItem then
    Result := True
  else
  begin
    repeat
      LAtEnd := not inherited MoveNext;
    until LAtEnd;
    Result := False
  end;
end;

function TTakeWhileEnumerationStrategy<T>.ShouldTakeItem: Boolean;
begin
  try
    if Assigned(FTakeWhilePredicate) then
      Result := FTakeWhilePredicate(GetCurrent)
    else
      Result := False;
  except
    on E : EArgumentOutOfRangeException do
      Result := False;
  end;
end;

{ TWhereEnumerationStrategy<T> }

constructor TWhereEnumerationStrategy<T>.Create(Enumerator: IMinimalEnumerator<T>;
  Predicate: TPredicate<T>);
begin
  inherited Create(Enumerator);
  FWherePredicate := Predicate;
end;

function TWhereEnumerationStrategy<T>.MoveNext: Boolean;
var
  IsDone : Boolean;
begin
  inherited MoveNext;

  repeat
    IsDone := ShouldIncludeItem;
  until IsDone or (not inherited MoveNext);

  Result := IsDone;
end;

function TWhereEnumerationStrategy<T>.ShouldIncludeItem: Boolean;
begin
  try
    if Assigned(FWherePredicate) then
      Result := FWherePredicate(GetCurrent)
    else
      Result := False;
  except
    on E : EArgumentOutOfRangeException do
      Result := False;
  end;
end;

end.
