unit Generics.Collections.Enumerators;

interface
uses
  System.Generics.Collections, Generics.Collections.Query, System.SysUtils,
  System.Classes;

type
  TSkipEnumerator<T> = class(TQueryEnumerator<T>)
  private
    FSkipCount: Integer;
    FItemCount : Integer;
  protected
    function DoMoveNext: Boolean; override;
  public
    constructor Create(Enumerator : TEnumerator<T>; SkipCount : Integer); reintroduce;
  end;

  TSkipWhileEnumerator<T> = class(TQueryEnumerator<T>)
  private
    FSkipWhilePredicate : TPredicate<T>;
  protected
    function DoMoveNext: Boolean; override;
    function ShouldSkipItem : Boolean;
  public
    constructor Create(Enumerator : TEnumerator<T>; Predicate : TPredicate<T>); reintroduce;
  end;

  TTakeEnumerator<T> = class(TQueryEnumerator<T>)
  private
    FTakeCount: Integer;
    FItemCount : Integer;
  protected
    function DoMoveNext: Boolean; override;
  public
    constructor Create(Enumerator : TEnumerator<T>; TakeCount : Integer); reintroduce;
  end;

  TTakeWhileEnumerator<T> = class(TQueryEnumerator<T>)
  private
    FTakeWhilePredicate : TPredicate<T>;
  protected
    function DoMoveNext: Boolean; override;
    function ShouldTakeItem : Boolean;
  public
    constructor Create(Enumerator : TEnumerator<T>; Predicate : TPredicate<T>); reintroduce;
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

constructor TTakeEnumerator<T>.Create(Enumerator: TEnumerator<T>; TakeCount : Integer);
begin
  inherited Create(Enumerator);
  FItemCount := 0;
  FTakeCount := TakeCount;
end;

function TTakeEnumerator<T>.DoMoveNext: Boolean;
begin
  Result := FItemCount < FTakeCount;

  if Result then
  begin
    Result := inherited DoMoveNext;
    Inc(FItemCount);
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



{ TSkipEnumerator<T> }

constructor TSkipEnumerator<T>.Create(Enumerator: TEnumerator<T>;
  SkipCount: Integer);
begin
  inherited Create(Enumerator);
  FItemCount := 0;
  FSkipCount := SkipCount;
end;

function TSkipEnumerator<T>.DoMoveNext: Boolean;
var
  LEndOfList : Boolean;
begin
  LEndOFList := False;
  while (FItemCount < FSkipCount) do
  begin
    Inc(FItemCount);
    LEndOfList := not inherited DoMoveNext;
    if LEndOfList then
      break;
  end;

  if LEndOfList then
    Result := not LEndOfList
  else
    Result := inherited DoMoveNext;
end;



{ TSkipWhileEnumerator<T> }

constructor TSkipWhileEnumerator<T>.Create(Enumerator: TEnumerator<T>;
  Predicate: TPredicate<T>);
begin
  inherited Create(Enumerator);
  FSkipWhilePredicate := Predicate;
end;

function TSkipWhileEnumerator<T>.DoMoveNext: Boolean;
var
  LEndOfList : Boolean;
begin
  repeat
    LEndOfList := not inherited DoMoveNext;
    if LEndOfList then
      break;
  until not ShouldSkipItem;

  Result := not LEndOfList;
end;

function TSkipWhileEnumerator<T>.ShouldSkipItem: Boolean;
begin
    try
      if Assigned(FSkipWhilePredicate) then
        Result := FSkipWhilePredicate(Current)
      else
        Result := False;
    except
      on E : EArgumentOutOfRangeException do
        Result := False;
    end;
end;

{ TTakeWhileEnumerator<T> }

constructor TTakeWhileEnumerator<T>.Create(Enumerator: TEnumerator<T>;
  Predicate: TPredicate<T>);
begin
  inherited Create(Enumerator);
  FTakeWhilePredicate := Predicate;
end;

function TTakeWhileEnumerator<T>.DoMoveNext: Boolean;
var
  LAtEnd : Boolean;
begin
  LAtEnd := not inherited DoMoveNext;

  if LAtEnd then
    Exit(False);

  if ShouldTakeItem then
    Result := True
  else
  begin
    repeat
      LAtEnd := not inherited DoMoveNext;
    until LAtEnd;
    Result := False
  end;
end;

function TTakeWhileEnumerator<T>.ShouldTakeItem: Boolean;
begin
  try
    if Assigned(FTakeWhilePredicate) then
      Result := FTakeWhilePredicate(Current)
    else
      Result := False;
  except
    on E : EArgumentOutOfRangeException do
      Result := False;
  end;
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

function TStringsEnumeratorWrapper.DoGetCurrent: String;
begin
  Result := FStringsEnumerator.Current;
end;

function TStringsEnumeratorWrapper.DoMoveNext: Boolean;
begin
  Result := FStringsEnumerator.MoveNext;;
end;


end.
