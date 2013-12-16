unit Generics.Collections.Enumerators;

interface
uses
  System.Generics.Collections, Generics.Collections.Query, System.SysUtils;

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

  TTakeEnumerator<T> = class(TQueryEnumerator<T>)
  private
    FTakeCount: Integer;
    FItemCount : Integer;
  protected
    function DoMoveNext: Boolean; override;
  public
    constructor Create(Enumerator : TEnumerator<T>; TakeCount : Integer); reintroduce;
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



end.
