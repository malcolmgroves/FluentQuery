unit Generics.Collections.EnumerationDelegates;

interface
uses
  Generics.Collections, System.SysUtils, Generics.Collections.Query.Types;

type
  TEnumerationDelegate<T> = class
  private
    FEnumerator : IMinimalEnumerator<T>;
  public
    function MoveNext: Boolean; virtual;
    function GetCurrent: T; virtual;
    constructor Create(Enumerator : IMinimalEnumerator<T>); virtual;
  end;

  TTakeEnumerationDelegate<T> = class(TEnumerationDelegate<T>)
  private
    FTakeCount: Integer;
    FItemCount : Integer;
  public
    function MoveNext: Boolean; override;
    constructor Create(Enumerator : IMinimalEnumerator<T>; TakeCount : Integer); reintroduce;
  end;

  TSkipEnumerationDelegate<T> = class(TEnumerationDelegate<T>)
  private
    FSkipCount: Integer;
    FItemCount : Integer;
  public
    function MoveNext: Boolean; override;
    constructor Create(Enumerator : IMinimalEnumerator<T>; SkipCount : Integer); reintroduce;
  end;

  TSkipWhileEnumerationDelegate<T> = class(TEnumerationDelegate<T>)
  private
    FSkipWhilePredicate : TPredicate<T>;
  protected
    function ShouldSkipItem : Boolean;
  public
    function MoveNext: Boolean; override;
    constructor Create(Enumerator : IMinimalEnumerator<T>; Predicate : TPredicate<T>); reintroduce;
  end;

  TTakeWhileEnumerationDelegate<T> = class(TEnumerationDelegate<T>)
  private
    FTakeWhilePredicate : TPredicate<T>;
  protected
    function ShouldTakeItem : Boolean;
  public
    function MoveNext: Boolean; override;
    constructor Create(Enumerator : IMinimalEnumerator<T>; Predicate : TPredicate<T>); reintroduce;
  end;

  TWhereEnumerationDelegate<T> = class(TEnumerationDelegate<T>)
  private
    FWherePredicate : TPredicate<T>;
  protected
    function ShouldIncludeItem : Boolean;
  public
    function MoveNext: Boolean; override;
    constructor Create(Enumerator : IMinimalEnumerator<T>; Predicate : TPredicate<T>); reintroduce;
  end;

implementation

{ TEnumerationDelegate<T> }

constructor TEnumerationDelegate<T>.Create(Enumerator: IMinimalEnumerator<T>);
begin
  FEnumerator := Enumerator;
end;


function TEnumerationDelegate<T>.GetCurrent: T;
begin
  Result := FEnumerator.Current;
end;

function TEnumerationDelegate<T>.MoveNext: Boolean;
begin
  Result := FEnumerator.MoveNext;
end;

{ TTakeEnumerationDelegate<T> }

constructor TTakeEnumerationDelegate<T>.Create(Enumerator: IMinimalEnumerator<T>;
  TakeCount: Integer);
begin
  inherited Create(Enumerator);
  FItemCount := 0;
  FTakeCount := TakeCount;
end;

function TTakeEnumerationDelegate<T>.MoveNext: Boolean;
begin
  Result := FItemCount < FTakeCount;

  if Result then
  begin
    Result := inherited MoveNext;
    Inc(FItemCount);
  end;
end;

{ TSkipEnumerationDelegate<T> }

constructor TSkipEnumerationDelegate<T>.Create(Enumerator: IMinimalEnumerator<T>;
  SkipCount: Integer);
begin
  inherited Create(Enumerator);
  FItemCount := 0;
  FSkipCount := SkipCount;
end;

function TSkipEnumerationDelegate<T>.MoveNext: Boolean;
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

{ TSkipWhileEnumerationDelegate<T> }

constructor TSkipWhileEnumerationDelegate<T>.Create(Enumerator: IMinimalEnumerator<T>;
  Predicate: TPredicate<T>);
begin
  inherited Create(Enumerator);
  FSkipWhilePredicate := Predicate;
end;

function TSkipWhileEnumerationDelegate<T>.MoveNext: Boolean;
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

function TSkipWhileEnumerationDelegate<T>.ShouldSkipItem: Boolean;
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

{ TTakeWhileEnumerationDelegate<T> }

constructor TTakeWhileEnumerationDelegate<T>.Create(Enumerator: IMinimalEnumerator<T>;
  Predicate: TPredicate<T>);
begin
  inherited Create(Enumerator);
  FTakeWhilePredicate := Predicate;
end;

function TTakeWhileEnumerationDelegate<T>.MoveNext: Boolean;
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

function TTakeWhileEnumerationDelegate<T>.ShouldTakeItem: Boolean;
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

{ TWhereEnumerationDelegate<T> }

constructor TWhereEnumerationDelegate<T>.Create(Enumerator: IMinimalEnumerator<T>;
  Predicate: TPredicate<T>);
begin
  inherited Create(Enumerator);
  FWherePredicate := Predicate;
end;

function TWhereEnumerationDelegate<T>.MoveNext: Boolean;
var
  IsDone : Boolean;
begin
  inherited MoveNext;

  repeat
    IsDone := ShouldIncludeItem;
  until IsDone or (not inherited MoveNext);

  Result := IsDone;
end;

function TWhereEnumerationDelegate<T>.ShouldIncludeItem: Boolean;
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
