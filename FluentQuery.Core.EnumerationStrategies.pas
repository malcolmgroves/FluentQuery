{****************************************************}
{                                                    }
{  FluentQuery                                       }
{                                                    }
{  Copyright (C) 2013 Malcolm Groves                 }
{                                                    }
{  http://www.malcolmgroves.com                      }
{                                                    }
{****************************************************}
{                                                    }
{  This Source Code Form is subject to the terms of  }
{  the Mozilla Public License, v. 2.0. If a copy of  }
{  the MPL was not distributed with this file, You   }
{  can obtain one at                                 }
{                                                    }
{  http://mozilla.org/MPL/2.0/                       }
{                                                    }
{****************************************************}

unit FluentQuery.Core.EnumerationStrategies;

interface
uses
  System.SysUtils,
  FluentQuery.Core.Types;

type
  TEnumerationStrategy<T> = class
  public
    function MoveNext(Enumerator : IMinimalEnumerator<T>) : Boolean; virtual;
    function GetCurrent(Enumerator : IMinimalEnumerator<T>): T; virtual;
  end;

  TSkipWhileEnumerationStrategy<T> = class(TEnumerationStrategy<T>)
  private
    FSkipWhilePredicate : TPredicate<T>;
    FSkippingComplete : Boolean;
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
  protected
    FWherePredicate : TPredicate<T>;
    function ShouldIncludeItem(Enumerator : IMinimalEnumerator<T>) : Boolean; virtual;
  public
    function MoveNext(Enumerator : IMinimalEnumerator<T>): Boolean; override;
    constructor Create(Predicate : TPredicate<T>); virtual;
  end;

  TWhereNotEnumerationStrategy<T> = class(TWhereEnumerationStrategy<T>)
  protected
    function ShouldIncludeItem(Enumerator : IMinimalEnumerator<T>) : Boolean; override;
  end;

  TIsomorphicTransformEnumerationStrategy<T> = class(TEnumerationStrategy<T>)
  protected
    FTransformFunc : TFunc<T, T>;
  public
    function GetCurrent(Enumerator : IMinimalEnumerator<T>): T; override;
    constructor Create(TransformFunc : TFunc<T, T>); virtual;
  end;

  TPredicateFactory<T> = class
  public
    class function LessThanOrEqualTo(Count : Integer) : TPredicate<T>;
    class function QuerySingleValue(UnboundQuery : IBaseQueryEnumerator<T>) : TPredicate<T>;
  end;


implementation
uses
  FluentQuery.Core.Enumerators;

{ TEnumerationStrategy<T> }

function TEnumerationStrategy<T>.GetCurrent(Enumerator : IMinimalEnumerator<T>): T;
begin
  if not Assigned(Enumerator) then
    raise ENilEnumeratorException.Create('Enumerator is nil. Are you attempting to enumerate an Unbound Query?');

  Result := Enumerator.Current;
end;

function TEnumerationStrategy<T>.MoveNext(Enumerator : IMinimalEnumerator<T>): Boolean;
begin
  if not Assigned(Enumerator) then
    raise ENilEnumeratorException.Create('Enumerator is nil. Are you attempting to enumerate an Unbound Query?');

  Result := Enumerator.MoveNext;
end;

{ TSkipWhileEnumerationStrategy<T> }

constructor TSkipWhileEnumerationStrategy<T>.Create(Predicate: TPredicate<T>);
begin
  FSkipWhilePredicate := Predicate;
  FSkippingComplete := False;
end;

function TSkipWhileEnumerationStrategy<T>.MoveNext(Enumerator : IMinimalEnumerator<T>): Boolean;
var
  LAtEnd : Boolean;
begin
  if FSkippingComplete then
    Result := inherited MoveNext(Enumerator)
  else
  begin
    repeat
      LAtEnd := not Enumerator.MoveNext;
      if LAtEnd then
        exit(False);
    until not ShouldSkipItem(Enumerator);

    FSkippingComplete := True;
    Result := FSKippingComplete;
  end;
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
  IncludeItem, IsDone : Boolean;
begin
  repeat
    IsDone := not Enumerator.MoveNext;
    if not IsDone then
      IncludeItem := ShouldIncludeItem(Enumerator);
  until IsDone or IncludeItem;

  Result := not IsDone;
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

{ TEnumerationPredicates<T> }

class function TPredicateFactory<T>.LessThanOrEqualTo(
  Count: Integer): TPredicate<T>;
var
  LCount : Integer;
begin
  LCOunt := 0;
  Result := function (Value : T) : boolean
            begin
              Inc(LCount);
              Result := LCount <= Count;
            end;
end;

class function TPredicateFactory<T>.QuerySingleValue(
  UnboundQuery: IBaseQueryEnumerator<T>): TPredicate<T>;
begin
  Result := function (CurrentValue : T) : Boolean
            begin
              UnboundQuery.SetSourceData(TSingleValueAdapter<T>.Create(CurrentValue));
              Result := UnboundQuery.MoveNext;
            end;
end;

{ TWhereNotEnumerationStrategy<T> }

function TWhereNotEnumerationStrategy<T>.ShouldIncludeItem(
  Enumerator: IMinimalEnumerator<T>): Boolean;
begin
  try
    if Assigned(FWherePredicate) then
      Result := not FWherePredicate(Enumerator.Current)
    else
      Result := False;
  except
    on E : EArgumentOutOfRangeException do
      Result := False;
  end;
end;

{ TTransformEnumerationStrategy<T> }

constructor TIsomorphicTransformEnumerationStrategy<T>.Create(
  TransformFunc: TFunc<T, T>);
begin
  FTransformFunc := TransformFunc;
end;

function TIsomorphicTransformEnumerationStrategy<T>.GetCurrent(
  Enumerator: IMinimalEnumerator<T>): T;
begin
  if Assigned(FTransformFunc) then
    Result := FTransformFunc(Enumerator.Current)
  else
    Result := Enumerator.Current;
end;

end.
