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

unit FluentQuery.Integers;

interface
uses
  FluentQuery.Core.Types,
  System.SysUtils,
  FluentQuery.Core.EnumerationStrategies,
  FluentQuery.Core.Enumerators,
  System.Generics.Collections,
  System.Classes;

type
  IUnboundIntegerQueryEnumerator = interface;

  IBoundIntegerQueryEnumerator = interface(IBaseQueryEnumerator<Integer>)
    function GetEnumerator: IBoundIntegerQueryEnumerator;
    // query operations
    function Equals(const Value : Integer) : IBoundIntegerQueryEnumerator;
    function Even : IBoundIntegerQueryEnumerator;
    function GreaterThan(const Value : Integer) : IBoundIntegerQueryEnumerator;
    function GreaterThanOrEquals(const Value : Integer) : IBoundIntegerQueryEnumerator;
    function LessThan(const Value : Integer) : IBoundIntegerQueryEnumerator;
    function LessThanOrEquals(const Value : Integer) : IBoundIntegerQueryEnumerator;
    function Map(Transformer : TFunc<Integer, Integer>) : IBoundIntegerQueryEnumerator;
    function Negative : IBoundIntegerQueryEnumerator;
    function NonZero : IBoundIntegerQueryEnumerator;
    function NotEquals(const Value : Integer) : IBoundIntegerQueryEnumerator;
    function Odd : IBoundIntegerQueryEnumerator;
    function Positive : IBoundIntegerQueryEnumerator;
    function Skip(Count : Integer): IBoundIntegerQueryEnumerator;
    function SkipUntil(const Value : Integer): IBoundIntegerQueryEnumerator; overload;
    function SkipUntil(Predicate : TPredicate<Integer>): IBoundIntegerQueryEnumerator; overload;
    function SkipUntil(UnboundQuery : IUnboundIntegerQueryEnumerator): IBoundIntegerQueryEnumerator; overload;
    function SkipWhile(Predicate : TPredicate<Integer>) : IBoundIntegerQueryEnumerator; overload;
    function SkipWhile(UnboundQuery : IUnboundIntegerQueryEnumerator) : IBoundIntegerQueryEnumerator; overload;
    function Take(Count : Integer): IBoundIntegerQueryEnumerator;
    function TakeBetween(StartPredicate, EndPredicate : TPredicate<Integer>) : IBoundIntegerQueryEnumerator; overload;
    function TakeBetween(StartQuery, EndQuery : IUnboundIntegerQueryEnumerator) : IBoundIntegerQueryEnumerator; overload;
    function TakeBetween(const StartValue, EndValue : Integer) : IBoundIntegerQueryEnumerator; overload;
    function TakeUntil(const Value : Integer) : IBoundIntegerQueryEnumerator; overload;
    function TakeUntil(Predicate : TPredicate<Integer>) : IBoundIntegerQueryEnumerator; overload;
    function TakeUntil(UnboundQuery : IUnboundIntegerQueryEnumerator) : IBoundIntegerQueryEnumerator; overload;
    function TakeWhile(Predicate : TPredicate<Integer>): IBoundIntegerQueryEnumerator; overload;
    function TakeWhile(UnboundQuery : IUnboundIntegerQueryEnumerator): IBoundIntegerQueryEnumerator; overload;
    function Where(Predicate : TPredicate<Integer>) : IBoundIntegerQueryEnumerator;
    function WhereNot(UnboundQuery : IUnboundIntegerQueryEnumerator) : IBoundIntegerQueryEnumerator; overload;
    function WhereNot(Predicate : TPredicate<Integer>) : IBoundIntegerQueryEnumerator; overload;
    function Zero : IBoundIntegerQueryEnumerator;
    // terminating operations
    function ToTList : TList<Integer>;
    function Sum : Integer;
    function Average : Double;
    function Max : Integer;
    function Min : Integer;
    function First : Integer;
  end;

  IUnboundIntegerQueryEnumerator = interface(IBaseQueryEnumerator<Integer>)
    function GetEnumerator: IUnboundIntegerQueryEnumerator;
    function From(Container : TEnumerable<Integer>) : IBoundIntegerQueryEnumerator; overload;
    // query operations
    function Equals(const Value : Integer) : IUnboundIntegerQueryEnumerator;
    function Even : IUnboundIntegerQueryEnumerator;
    function GreaterThan(const Value : Integer) : IUnboundIntegerQueryEnumerator;
    function GreaterThanOrEquals(const Value : Integer) : IUnboundIntegerQueryEnumerator;
    function LessThan(const Value : Integer) : IUnboundIntegerQueryEnumerator;
    function LessThanOrEquals(const Value : Integer) : IUnboundIntegerQueryEnumerator;
    function Map(Transformer : TFunc<Integer, Integer>) : IUnboundIntegerQueryEnumerator;
    function Negative : IUnboundIntegerQueryEnumerator;
    function NonZero : IUnboundIntegerQueryEnumerator;
    function NotEquals(const Value : Integer) : IUnboundIntegerQueryEnumerator;
    function Odd : IUnboundIntegerQueryEnumerator;
    function Positive : IUnboundIntegerQueryEnumerator;
    function Skip(Count : Integer): IUnboundIntegerQueryEnumerator;
    function SkipUntil(const Value : Integer): IUnboundIntegerQueryEnumerator; overload;
    function SkipUntil(Predicate : TPredicate<Integer>): IUnboundIntegerQueryEnumerator; overload;
    function SkipUntil(UnboundQuery : IUnboundIntegerQueryEnumerator): IUnboundIntegerQueryEnumerator; overload;
    function SkipWhile(Predicate : TPredicate<Integer>) : IUnboundIntegerQueryEnumerator; overload;
    function SkipWhile(UnboundQuery : IUnboundIntegerQueryEnumerator) : IUnboundIntegerQueryEnumerator; overload;
    function Take(Count : Integer): IUnboundIntegerQueryEnumerator;
    function TakeBetween(StartPredicate, EndPredicate : TPredicate<Integer>) : IUnboundIntegerQueryEnumerator; overload;
    function TakeBetween(StartQuery, EndQuery : IUnboundIntegerQueryEnumerator) : IUnboundIntegerQueryEnumerator; overload;
    function TakeBetween(const StartValue, EndValue : Integer) : IUnboundIntegerQueryEnumerator; overload;
    function TakeUntil(const Value : Integer) : IUnboundIntegerQueryEnumerator; overload;
    function TakeUntil(Predicate : TPredicate<Integer>) : IUnboundIntegerQueryEnumerator; overload;
    function TakeUntil(UnboundQuery : IUnboundIntegerQueryEnumerator) : IUnboundIntegerQueryEnumerator; overload;
    function TakeWhile(Predicate : TPredicate<Integer>): IUnboundIntegerQueryEnumerator; overload;
    function TakeWhile(UnboundQuery : IUnboundIntegerQueryEnumerator): IUnboundIntegerQueryEnumerator; overload;
    function Where(Predicate : TPredicate<Integer>) : IUnboundIntegerQueryEnumerator;
    function WhereNot(UnboundQuery : IUnboundIntegerQueryEnumerator) : IUnboundIntegerQueryEnumerator; overload;
    function WhereNot(Predicate : TPredicate<Integer>) : IUnboundIntegerQueryEnumerator; overload;
    function Zero : IUnboundIntegerQueryEnumerator;
    // terminating operations
    function Predicate : TPredicate<Integer>;
  end;

  function Query : IUnboundIntegerQueryEnumerator;
  function IntegerQuery : IUnboundIntegerQueryEnumerator;

  function Range(Start : Integer = 0; Finish : Integer = MaxInt) : IBoundIntegerQueryEnumerator;

implementation

uses FluentQuery.Integers.MethodFactories;

type
  TIntegerQueryEnumerator = class(TBaseQueryEnumerator<Integer>,
                                 IBoundIntegerQueryEnumerator,
                                 IUnboundIntegerQueryEnumerator)
  protected
    type
      TIntegerQueryEnumeratorImpl<T : IBaseQueryEnumerator<Integer>> = class
      protected
        FQuery : TIntegerQueryEnumerator;
      public
        constructor Create(Query : TIntegerQueryEnumerator); virtual;
        function GetEnumerator: T;
{$IFDEF DEBUG}
        function GetOperationName : String;
        function GetOperationPath : String;
        property OperationName : string read GetOperationName;
        property OperationPath : string read GetOperationPath;
{$ENDIF}
        function From(Container : TEnumerable<Integer>) : IBoundIntegerQueryEnumerator; overload;
        // Primitive Operations
        function Map(Transformer : TFunc<Integer, Integer>) : T;
        function SkipWhile(Predicate : TPredicate<Integer>) : T; overload;
        function TakeWhile(Predicate : TPredicate<Integer>): T; overload;
        function Where(Predicate : TPredicate<Integer>) : T;
        // Derivative Operations
        function Equals(const Value : Integer) : T; reintroduce;
        function NotEquals(const Value : Integer) : T;
        function Skip(Count : Integer): T;
        function SkipUntil(const Value : Integer): T; overload;
        function SkipUntil(Predicate : TPredicate<Integer>): T; overload;
        function SkipUntil(UnboundQuery : IUnboundIntegerQueryEnumerator): T; overload;
        function SkipWhile(UnboundQuery : IUnboundIntegerQueryEnumerator) : T; overload;
        function Take(Count : Integer): T;
        function TakeBetween(StartPredicate, EndPredicate : TPredicate<Integer>) : T; overload;
        function TakeBetween(StartQuery, EndQuery : IUnboundIntegerQueryEnumerator) : T; overload;
        function TakeBetween(const StartValue, EndValue : Integer) : T; overload;
        function TakeUntil(const Value : Integer) : T; overload;
        function TakeUntil(Predicate : TPredicate<Integer>) : T; overload;
        function TakeUntil(UnboundQuery : IUnboundIntegerQueryEnumerator) : T; overload;
        function TakeWhile(UnboundQuery : IUnboundIntegerQueryEnumerator): T; overload;
        function WhereNot(Predicate : TPredicate<Integer>) : T; overload;
        function WhereNot(UnboundQuery : IUnboundIntegerQueryEnumerator) : T; overload;
        function Positive : T;
        function Negative : T;
        function Odd : T;
        function Even : T;
        function Zero : T;
        function NonZero : T;
        function LessThan(const Value : Integer) : T;
        function GreaterThan(const Value : Integer) : T;
        function LessThanOrEquals(const Value : Integer) : T;
        function GreaterThanOrEquals(const Value : Integer) : T;
        // Terminating Operations
        function ToTList : TList<Integer>;
        function Predicate : TPredicate<Integer>;
        function Sum : Integer;
        function Average : Double;
        function Max : Integer;
        function Min : Integer;
        function First : Integer;
      end;
  protected
    FBoundIntegerQueryEnumerator : TIntegerQueryEnumeratorImpl<IBoundIntegerQueryEnumerator>;
    FUnboundIntegerQueryEnumerator : TIntegerQueryEnumeratorImpl<IUnboundIntegerQueryEnumerator>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<Integer>;
                       UpstreamQuery : IBaseQueryEnumerator<Integer> = nil;
                       SourceData : IMinimalEnumerator<Integer> = nil
                       ); override;
    destructor Destroy; override;
    property BoundIntegerQueryEnumerator : TIntegerQueryEnumeratorImpl<IBoundIntegerQueryEnumerator>
                                       read FBoundIntegerQueryEnumerator implements IBoundIntegerQueryEnumerator;
    property UnboundIntegerQueryEnumerator : TIntegerQueryEnumeratorImpl<IUnboundIntegerQueryEnumerator>
                                       read FUnboundIntegerQueryEnumerator implements IUnboundIntegerQueryEnumerator;
  end;

function IntegerQuery : IUnboundIntegerQueryEnumerator;
begin
  Result := Query;
{$IFDEF DEBUG}
  Result.OperationName := 'IntegerQuery';
{$ENDIF}
end;

function Query : IUnboundIntegerQueryEnumerator;
begin
  Result := TIntegerQueryEnumerator.Create(TEnumerationStrategy<Integer>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'Query';
{$ENDIF}
end;

function Range(Start : Integer = 0; Finish : Integer = MaxInt) : IBoundIntegerQueryEnumerator;
var
  RangeEnumerator : IMinimalEnumerator<Integer>;
begin
  if Start < Finish then
    RangeEnumerator := TIntegerRangeEnumerator.Create(Start, Finish)
  else if Start > Finish then
    RangeEnumerator := TIntegerRangeReverseEnumerator.Create(Start, Finish)
  else
    RangeEnumerator := TSingleValueAdapter<Integer>.Create(Start);

  Result := TIntegerQueryEnumerator.Create(TEnumerationStrategy<Integer>.Create,
                                           nil,
                                           RangeEnumerator);


{$IFDEF DEBUG}
  Result.OperationName := 'Range';
{$ENDIF}
end;

{ TIntegerQueryEnumerator }

constructor TIntegerQueryEnumerator.Create(
  EnumerationStrategy: TEnumerationStrategy<Integer>;
  UpstreamQuery: IBaseQueryEnumerator<Integer>;
  SourceData: IMinimalEnumerator<Integer>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundIntegerQueryEnumerator := TIntegerQueryEnumeratorImpl<IBoundIntegerQueryEnumerator>.Create(self);
  FUnboundIntegerQueryEnumerator := TIntegerQueryEnumeratorImpl<IUnboundIntegerQueryEnumerator>.Create(self);
end;


destructor TIntegerQueryEnumerator.Destroy;
begin
  FBoundIntegerQueryEnumerator.Free;
  FUnboundIntegerQueryEnumerator.Free;
  inherited;
end;


function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.Average: Double;
var
  LTotal, LCount : Integer;
begin
  LTotal := 0;
  LCount := 0;
  while FQuery.MoveNext do
  begin
    LTotal := LTotal + FQuery.GetCurrent;
    Inc(LCount)
  end;

  if LCount = 0 then
    raise EEmptyResultSetException.Create('Cannot take Average of an empty ResultSet')
  else
    Result := LTotal/LCount;
end;

constructor TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.Create(Query: TIntegerQueryEnumerator);
begin
  FQuery := Query;
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.Equals(
  const Value: Integer): T;
begin
  Result := Where(TIntegerMethodFactory.Equals(Value));
{$IFDEF DEBUG}
  Result.OperationName := Format('Equals(%d)', [Value]);
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.First: Integer;
begin
  if FQuery.MoveNext then
    Result := FQuery.GetCurrent
  else
    raise EEmptyResultSetException.Create('Can''t call First on an empty Result Set');
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.From(Container: TEnumerable<Integer>): IBoundIntegerQueryEnumerator;
var
  EnumeratorAdapter : IMinimalEnumerator<Integer>;
begin
  EnumeratorAdapter := TGenericEnumeratorAdapter<Integer>.Create(Container.GetEnumerator) as IMinimalEnumerator<Integer>;
  Result := TIntegerQueryEnumerator.Create(TEnumerationStrategy<Integer>.Create,
                                          IBaseQueryEnumerator<Integer>(FQuery),
                                          EnumeratorAdapter);
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Container.ToString]);
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.GetEnumerator: T;
begin
  Result := FQuery;
end;

{$IFDEF DEBUG}
function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.GetOperationName: String;
begin
  Result := FQuery.OperationName;
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.GetOperationPath: String;
begin
  Result := FQuery.OperationPath;
end;
{$ENDIF}

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.GreaterThan(
  const Value: Integer): T;
begin
  Result := WhereNot(TIntegerMethodFactory.LessThanOrEquals(Value));
{$IFDEF DEBUG}
  Result.OperationName := Format('GreaterThan(%d)', [Value]);
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.GreaterThanOrEquals(
  const Value: Integer): T;
begin
  Result := Where(TIntegerMethodFactory.GreaterThanOrEquals(Value));
{$IFDEF DEBUG}
  Result.OperationName := Format('GreaterThanOrEquals(%d)', [Value]);
{$ENDIF}
end;



function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.Even: T;
begin
  Result := Where(TIntegerMethodFactory.Even());
{$IFDEF DEBUG}
  Result.OperationName := 'Even';
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.Negative: T;
begin
  Result := LessThan(0);
{$IFDEF DEBUG}
  Result.OperationName := 'Negative';
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.NonZero: T;
begin
  Result := NotEquals(0);
{$IFDEF DEBUG}
  Result.OperationName := 'NonZero';
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.NotEquals(
  const Value: Integer): T;
begin
  Result := WhereNot(TIntegerMethodFactory.Equals(Value));
{$IFDEF DEBUG}
  Result.OperationName := Format('NotEquals(%d)', [Value]);
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.Odd: T;
begin
  Result := WhereNot(TIntegerMethodFactory.Even());
{$IFDEF DEBUG}
  Result.OperationName := 'Odd';
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.Positive: T;
begin
  Result := GreaterThanOrEquals(1);
{$IFDEF DEBUG}
  Result.OperationName := 'Positive';
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.Zero: T;
begin
  Result := Equals(0);
{$IFDEF DEBUG}
  Result.OperationName := 'Zero';
{$ENDIF}
end;


function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.LessThan(
  const Value: Integer): T;
begin
  Result := WhereNot(TIntegerMethodFactory.GreaterThanOrEquals(Value));
{$IFDEF DEBUG}
  Result.OperationName := Format('LessThan(%d)', [Value]);
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.LessThanOrEquals(
  const Value: Integer): T;
begin
  Result := Where(TIntegerMethodFactory.LessThanOrEquals(Value));
{$IFDEF DEBUG}
  Result.OperationName := Format('LessThanOrEquals(%d)', [Value]);
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.Map(
  Transformer: TFunc<Integer, Integer>): T;
begin
  Result := TIntegerQueryEnumerator.Create(TIsomorphicTransformEnumerationStrategy<Integer>.Create(Transformer),
                                          IBaseQueryEnumerator<Integer>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Map(Transformer)';
{$ENDIF}
end;


function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.Max: Integer;
var
  LMax, LCurrent : Integer;
begin
  LMax := -MaxInt;
  while FQuery.MoveNext do
  begin
    LCurrent := FQuery.GetCurrent;
    if LCurrent > LMax then
      LMax := LCurrent;
  end;

  Result := LMax;
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.Min: Integer;
var
  LMin, LCurrent : Integer;
begin
  LMin := MaxInt;
  while FQuery.MoveNext do
  begin
    LCurrent := FQuery.GetCurrent;
    if LCurrent < LMin then
      LMin := LCurrent;
  end;

  Result := LMin;
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.Predicate: TPredicate<Integer>;
begin
  Result := TIntegerMethodFactory.QuerySingleValue(FQuery);
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.Skip(Count: Integer): T;
begin
  Result := SkipWhile(TIntegerMethodFactory.LessThanOrEqualTo(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [Count]);
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.SkipUntil(
  Predicate: TPredicate<Integer>): T;
begin
  Result := SkipWhile(TIntegerMethodFactory.InvertPredicate(Predicate));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipUntil(Predicate)';
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.SkipUntil(
  UnboundQuery: IUnboundIntegerQueryEnumerator): T;
begin
  Result := SkipWhile(TIntegerMethodFactory.InvertPredicate(UnboundQuery.Predicate));
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipUntil(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.SkipUntil(
  const Value: Integer): T;
begin
  Result := SkipWhile(Query.NotEquals(Value).Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipUntil(%d)', [Value]);
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.SkipWhile(
  UnboundQuery: IUnboundIntegerQueryEnumerator): T;
begin
  Result := SkipWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipWhile(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.Sum: Integer;
var
  LTotal : Integer;
begin
  LTotal := 0;
  while FQuery.MoveNext do
    LTotal := LTotal + FQuery.GetCurrent;

  Result := LTotal;
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.SkipWhile(
  Predicate: TPredicate<Integer>): T;
begin
  Result := TIntegerQueryEnumerator.Create(TSkipWhileEnumerationStrategy<Integer>.Create(Predicate),
                                          IBaseQueryEnumerator<Integer>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipWhile(Predicate)';
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.Take(Count: Integer): T;
begin
  Result := TakeWhile(TIntegerMethodFactory.LessThanOrEqualTo(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Take(%d)', [Count]);
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.TakeBetween(
  StartQuery, EndQuery: IUnboundIntegerQueryEnumerator): T;
begin
  Result := TakeBetween(StartQuery.Predicate, EndQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := 'TakeBetween(StartQuery, EndQuery)';
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.TakeBetween(
  const StartValue, EndValue: Integer): T;
begin
  Result := TakeBetween(Query.Equals(StartValue).Predicate, Query.Equals(EndValue).Predicate);
{$IFDEF DEBUG}
  Result.OperationName := 'TakeBetween(StartQuery, EndQuery)';
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.TakeBetween(
  StartPredicate, EndPredicate: TPredicate<Integer>): T;
begin
  Result := TIntegerQueryEnumerator.Create(
              TTakeWhileEnumerationStrategy<Integer>.Create(
                TIntegerMethodFactory.InvertPredicate(EndPredicate)),
              TIntegerQueryEnumerator.Create(
                TSkipWhileEnumerationStrategy<Integer>.Create(
                  TIntegerMethodFactory.InvertPredicate(StartPredicate)),
                IBaseQueryEnumerator<Integer>(FQuery)));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeBetween(StartPredicate, EndPredicate)';
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.TakeUntil(
  Predicate: TPredicate<Integer>): T;
begin
  Result := TakeWhile(TIntegerMethodFactory.InvertPredicate(Predicate));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeUntil(Predicate)';
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.TakeUntil(
  UnboundQuery: IUnboundIntegerQueryEnumerator): T;
begin
  Result := TakeWhile(TIntegerMethodFactory.InvertPredicate(UnboundQuery.Predicate));
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeUntil(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.TakeUntil(
  const Value: Integer): T;
begin
  Result := TakeWhile(Query.NotEquals(Value).Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeUntil(%d)', [Value]);
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.TakeWhile(
  UnboundQuery: IUnboundIntegerQueryEnumerator): T;
begin
  Result := TakeWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeWhile(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.ToTList: TList<Integer>;
var
  LList : TList<Integer>;
  Item : Integer;
begin
  LList := TList<Integer>.Create;

  while FQuery.MoveNext do
    LList.Add(FQuery.GetCurrent);

  Result := LList;
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.TakeWhile(Predicate: TPredicate<Integer>): T;
begin
  Result := TIntegerQueryEnumerator.Create(TTakeWhileEnumerationStrategy<Integer>.Create(Predicate),
                                          IBaseQueryEnumerator<Integer>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeWhile(Predicate)';
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.Where(
  Predicate: TPredicate<Integer>): T;
begin
  Result := TIntegerQueryEnumerator.Create(TWhereEnumerationStrategy<Integer>.Create(Predicate),
                                          IBaseQueryEnumerator<Integer>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Where(Predicate)';
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.WhereNot(
  UnboundQuery: IUnboundIntegerQueryEnumerator): T;
begin
  Result := WhereNot(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('WhereNot(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TIntegerQueryEnumerator.TIntegerQueryEnumeratorImpl<T>.WhereNot(
  Predicate: TPredicate<Integer>): T;
begin
  Result := Where(TIntegerMethodFactory.InvertPredicate(Predicate));
{$IFDEF DEBUG}
  Result.OperationName := 'WhereNot(Predicate)';
{$ENDIF}
end;

end.
