unit FluentQuery.EnumerationStrategies;

interface
uses
  Generics.Collections,
  System.SysUtils,
  FluentQuery.Types;

type
  TEnumerationStrategy<T> = class
  public
    function MoveNext(Enumerator : IMinimalEnumerator<T>) : Boolean; virtual;
    function GetCurrent(Enumerator : IMinimalEnumerator<T>): T; virtual;
  end;

  TTakeEnumerationStrategy<T> = class(TEnumerationStrategy<T>)
  private
    FTakeCount: Integer;
    FItemCount : Integer;
  public
    function MoveNext(Enumerator : IMinimalEnumerator<T>): Boolean; override;
    constructor Create(TakeCount : Integer); virtual;
  end;

  TSkipEnumerationStrategy<T> = class(TEnumerationStrategy<T>)
  private
    FSkipCount: Integer;
    FItemCount : Integer;
  public
    function MoveNext(Enumerator : IMinimalEnumerator<T>): Boolean; override;
    constructor Create(SkipCount : Integer); virtual;
  end;

  TSkipWhileEnumerationStrategy<T> = class(TEnumerationStrategy<T>)
  private
    FSkipWhilePredicate : TPredicate<T>;
  protected
    function ShouldSkipItem(Enumerator : IMinimalEnumerator<T>) : Boolean;
  public
    function MoveNext(Enumerator : IMinimalEnumerator<T>): Boolean; override;
    constructor Create(Predicate : TPredicate<T>); virtual;
  end;

  TTakeWhileEnumerationStrategy<T> = class(TEnumerationStrategy<T>)
  private
    FTakeWhilePredicate : TPredicate<T>;
  protected
    function ShouldTakeItem(Enumerator : IMinimalEnumerator<T>) : Boolean;
  public
    function MoveNext(Enumerator : IMinimalEnumerator<T>): Boolean; override;
    constructor Create(Predicate : TPredicate<T>); virtual;
  end;

  TWhereEnumerationStrategy<T> = class(TEnumerationStrategy<T>)
  private
    FWherePredicate : TPredicate<T>;
  protected
    function ShouldIncludeItem(Enumerator : IMinimalEnumerator<T>) : Boolean;
  public
    function MoveNext(Enumerator : IMinimalEnumerator<T>): Boolean; override;
    constructor Create(Predicate : TPredicate<T>); virtual;
  end;

implementation

{ TEnumerationStrategy<T> }



function TEnumerationStrategy<T>.GetCurrent(Enumerator : IMinimalEnumerator<T>): T;
begin
  Result := Enumerator.Current;
end;

function TEnumerationStrategy<T>.MoveNext(Enumerator : IMinimalEnumerator<T>): Boolean;
begin
  Result := Enumerator.MoveNext;
end;

{ TTakeEnumerationStrategy<T> }

constructor TTakeEnumerationStrategy<T>.Create(TakeCount: Integer);
begin
  FItemCount := 0;
  FTakeCount := TakeCount;
end;

function TTakeEnumerationStrategy<T>.MoveNext(Enumerator : IMinimalEnumerator<T>): Boolean;
begin
  Result := FItemCount < FTakeCount;

  if Result then
  begin
    Result := Enumerator.MoveNext;
    Inc(FItemCount);
  end;
end;

{ TSkipEnumerationStrategy<T> }

constructor TSkipEnumerationStrategy<T>.Create(SkipCount: Integer);
begin
  FItemCount := 0;
  FSkipCount := SkipCount;
end;

function TSkipEnumerationStrategy<T>.MoveNext(Enumerator : IMinimalEnumerator<T>): Boolean;
var
  LEndOfList : Boolean;
begin
  LEndOFList := False;
  while (FItemCount < FSkipCount) do
  begin
    Inc(FItemCount);
    LEndOfList := not Enumerator.MoveNext;
    if LEndOfList then
      break;
  end;

  if LEndOfList then
    Result := not LEndOfList
  else
    Result := Enumerator.MoveNext;
end;

{ TSkipWhileEnumerationStrategy<T> }

constructor TSkipWhileEnumerationStrategy<T>.Create(Predicate: TPredicate<T>);
begin
  FSkipWhilePredicate := Predicate;
end;

function TSkipWhileEnumerationStrategy<T>.MoveNext(Enumerator : IMinimalEnumerator<T>): Boolean;
var
  LEndOfList : Boolean;
begin
  repeat
    LEndOfList := not Enumerator.MoveNext;
    if LEndOfList then
      break;
  until not ShouldSkipItem(Enumerator);

  Result := not LEndOfList;
end;

function TSkipWhileEnumerationStrategy<T>.ShouldSkipItem(Enumerator : IMinimalEnumerator<T>): Boolean;
begin
  try
    if Assigned(FSkipWhilePredicate) then
      Result := FSkipWhilePredicate(Enumerator.Current)
    else
      Result := False;
  except
    on E : EArgumentOutOfRangeException do
      Result := False;
  end;
end;

{ TTakeWhileEnumerationStrategy<T> }

constructor TTakeWhileEnumerationStrategy<T>.Create(Predicate: TPredicate<T>);
begin
  FTakeWhilePredicate := Predicate;
end;

function TTakeWhileEnumerationStrategy<T>.MoveNext(Enumerator : IMinimalEnumerator<T>): Boolean;
var
  LAtEnd : Boolean;
begin
  LAtEnd := not Enumerator.MoveNext;

  if LAtEnd then
    Exit(False);

  if ShouldTakeItem(Enumerator) then
    Result := True
  else
  begin
    repeat
      LAtEnd := not Enumerator.MoveNext;
    until LAtEnd;
    Result := False
  end;
end;

function TTakeWhileEnumerationStrategy<T>.ShouldTakeItem(Enumerator : IMinimalEnumerator<T>): Boolean;
begin
  try
    if Assigned(FTakeWhilePredicate) then
      Result := FTakeWhilePredicate(Enumerator.Current)
    else
      Result := False;
  except
    on E : EArgumentOutOfRangeException do
      Result := False;
  end;
end;

{ TWhereEnumerationStrategy<T> }

constructor TWhereEnumerationStrategy<T>.Create(Predicate: TPredicate<T>);
begin
  FWherePredicate := Predicate;
end;

function TWhereEnumerationStrategy<T>.MoveNext(Enumerator : IMinimalEnumerator<T>): Boolean;
var
  IsDone : Boolean;
begin
  Enumerator.MoveNext;

  repeat
    IsDone := ShouldIncludeItem(Enumerator);
  until IsDone or (not Enumerator.MoveNext);

  Result := IsDone;
end;

function TWhereEnumerationStrategy<T>.ShouldIncludeItem(Enumerator : IMinimalEnumerator<T>): Boolean;
begin
  try
    if Assigned(FWherePredicate) then
      Result := FWherePredicate(Enumerator.Current)
    else
      Result := False;
  except
    on E : EArgumentOutOfRangeException do
      Result := False;
  end;
end;

end.
