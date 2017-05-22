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
  IUnboundIntegerQuery = interface;

  IBoundIntegerQuery = interface(IBaseBoundQuery<Integer>)
    function GetEnumerator: IBoundIntegerQuery;
    // query operations
    function Equals(const Value : Integer) : IBoundIntegerQuery;
    function Even : IBoundIntegerQuery;
    function GreaterThan(const Value : Integer) : IBoundIntegerQuery;
    function GreaterThanOrEquals(const Value : Integer) : IBoundIntegerQuery;
    function LessThan(const Value : Integer) : IBoundIntegerQuery;
    function LessThanOrEquals(const Value : Integer) : IBoundIntegerQuery;
    function Map(Transformer : TFunc<Integer, Integer>) : IBoundIntegerQuery;
    function Negative : IBoundIntegerQuery;
    function NonZero : IBoundIntegerQuery;
    function NotEquals(const Value : Integer) : IBoundIntegerQuery;
    function Odd : IBoundIntegerQuery;
    function Positive : IBoundIntegerQuery;
    function Skip(Count : Integer): IBoundIntegerQuery;
    function SkipUntil(const Value : Integer): IBoundIntegerQuery; overload;
    function SkipUntil(Predicate : TPredicate<Integer>): IBoundIntegerQuery; overload;
    function SkipUntil(UnboundQuery : IUnboundIntegerQuery): IBoundIntegerQuery; overload;
    function SkipWhile(Predicate : TPredicate<Integer>) : IBoundIntegerQuery; overload;
    function SkipWhile(UnboundQuery : IUnboundIntegerQuery) : IBoundIntegerQuery; overload;
    function Take(Count : Integer): IBoundIntegerQuery;
    function TakeBetween(StartPredicate, EndPredicate : TPredicate<Integer>) : IBoundIntegerQuery; overload;
    function TakeBetween(StartQuery, EndQuery : IUnboundIntegerQuery) : IBoundIntegerQuery; overload;
    function TakeBetween(const StartValue, EndValue : Integer) : IBoundIntegerQuery; overload;
    function TakeUntil(const Value : Integer) : IBoundIntegerQuery; overload;
    function TakeUntil(Predicate : TPredicate<Integer>) : IBoundIntegerQuery; overload;
    function TakeUntil(UnboundQuery : IUnboundIntegerQuery) : IBoundIntegerQuery; overload;
    function TakeWhile(Predicate : TPredicate<Integer>): IBoundIntegerQuery; overload;
    function TakeWhile(UnboundQuery : IUnboundIntegerQuery): IBoundIntegerQuery; overload;
    function Where(Predicate : TPredicate<Integer>) : IBoundIntegerQuery;
    function WhereNot(UnboundQuery : IUnboundIntegerQuery) : IBoundIntegerQuery; overload;
    function WhereNot(Predicate : TPredicate<Integer>) : IBoundIntegerQuery; overload;
    function Zero : IBoundIntegerQuery;
    // terminating operations
    function AsTList : TList<Integer>;
    function Sum : Integer;
    function Average : Double;
    function Max : Integer;
    function Min : Integer;
  end;

  IUnboundIntegerQuery = interface(IBaseUnboundQuery<Integer>)
    function GetEnumerator: IUnboundIntegerQuery;
    function From(Container : TEnumerable<Integer>) : IBoundIntegerQuery; overload;
    // query operations
    function Equals(const Value : Integer) : IUnboundIntegerQuery;
    function Even : IUnboundIntegerQuery;
    function GreaterThan(const Value : Integer) : IUnboundIntegerQuery;
    function GreaterThanOrEquals(const Value : Integer) : IUnboundIntegerQuery;
    function LessThan(const Value : Integer) : IUnboundIntegerQuery;
    function LessThanOrEquals(const Value : Integer) : IUnboundIntegerQuery;
    function Map(Transformer : TFunc<Integer, Integer>) : IUnboundIntegerQuery;
    function Negative : IUnboundIntegerQuery;
    function NonZero : IUnboundIntegerQuery;
    function NotEquals(const Value : Integer) : IUnboundIntegerQuery;
    function Odd : IUnboundIntegerQuery;
    function Positive : IUnboundIntegerQuery;
    function Skip(Count : Integer): IUnboundIntegerQuery;
    function SkipUntil(const Value : Integer): IUnboundIntegerQuery; overload;
    function SkipUntil(Predicate : TPredicate<Integer>): IUnboundIntegerQuery; overload;
    function SkipUntil(UnboundQuery : IUnboundIntegerQuery): IUnboundIntegerQuery; overload;
    function SkipWhile(Predicate : TPredicate<Integer>) : IUnboundIntegerQuery; overload;
    function SkipWhile(UnboundQuery : IUnboundIntegerQuery) : IUnboundIntegerQuery; overload;
    function Take(Count : Integer): IUnboundIntegerQuery;
    function TakeBetween(StartPredicate, EndPredicate : TPredicate<Integer>) : IUnboundIntegerQuery; overload;
    function TakeBetween(StartQuery, EndQuery : IUnboundIntegerQuery) : IUnboundIntegerQuery; overload;
    function TakeBetween(const StartValue, EndValue : Integer) : IUnboundIntegerQuery; overload;
    function TakeUntil(const Value : Integer) : IUnboundIntegerQuery; overload;
    function TakeUntil(Predicate : TPredicate<Integer>) : IUnboundIntegerQuery; overload;
    function TakeUntil(UnboundQuery : IUnboundIntegerQuery) : IUnboundIntegerQuery; overload;
    function TakeWhile(Predicate : TPredicate<Integer>): IUnboundIntegerQuery; overload;
    function TakeWhile(UnboundQuery : IUnboundIntegerQuery): IUnboundIntegerQuery; overload;
    function Where(Predicate : TPredicate<Integer>) : IUnboundIntegerQuery;
    function WhereNot(UnboundQuery : IUnboundIntegerQuery) : IUnboundIntegerQuery; overload;
    function WhereNot(Predicate : TPredicate<Integer>) : IUnboundIntegerQuery; overload;
    function Zero : IUnboundIntegerQuery;
  end;

  function IntegerQuery : IUnboundIntegerQuery;

  function Range(Start : Integer = 0; Finish : Integer = MaxInt) : IBoundIntegerQuery;

implementation

uses FluentQuery.Integers.MethodFactories, FluentQuery.Core.Reduce, System.Math;

type
  TIntegerQuery = class(TBaseQuery<Integer>,
                                 IBoundIntegerQuery,
                                 IUnboundIntegerQuery)
  protected
    type
      TIntegerQueryImpl<T : IBaseQuery<Integer>> = class
      protected
        FQuery : TIntegerQuery;
      public
        constructor Create(Query : TIntegerQuery); virtual;
        function GetEnumerator: T;
{$IFDEF DEBUG}
        function GetOperationName : String;
        function GetOperationPath : String;
        property OperationName : string read GetOperationName;
        property OperationPath : string read GetOperationPath;
{$ENDIF}
        function From(Container : TEnumerable<Integer>) : IBoundIntegerQuery; overload;
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
        function SkipUntil(UnboundQuery : IUnboundIntegerQuery): T; overload;
        function SkipWhile(UnboundQuery : IUnboundIntegerQuery) : T; overload;
        function Take(Count : Integer): T;
        function TakeBetween(StartPredicate, EndPredicate : TPredicate<Integer>) : T; overload;
        function TakeBetween(StartQuery, EndQuery : IUnboundIntegerQuery) : T; overload;
        function TakeBetween(const StartValue, EndValue : Integer) : T; overload;
        function TakeUntil(const Value : Integer) : T; overload;
        function TakeUntil(Predicate : TPredicate<Integer>) : T; overload;
        function TakeUntil(UnboundQuery : IUnboundIntegerQuery) : T; overload;
        function TakeWhile(UnboundQuery : IUnboundIntegerQuery): T; overload;
        function WhereNot(Predicate : TPredicate<Integer>) : T; overload;
        function WhereNot(UnboundQuery : IUnboundIntegerQuery) : T; overload;
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
        function AsTList : TList<Integer>;
        function Predicate : TPredicate<Integer>;
        function Sum : Integer;
        function Average : Double;
        function Max : Integer;
        function Min : Integer;
        function First : Integer;
        function Count : Integer;
      end;
  protected
    FBoundQuery : TIntegerQueryImpl<IBoundIntegerQuery>;
    FUnboundQuery : TIntegerQueryImpl<IUnboundIntegerQuery>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<Integer>;
                       UpstreamQuery : IBaseQuery<Integer> = nil;
                       SourceData : IMinimalEnumerator<Integer> = nil
                       ); override;
    destructor Destroy; override;
    property BoundQuery : TIntegerQueryImpl<IBoundIntegerQuery>
                                       read FBoundQuery implements IBoundIntegerQuery;
    property UnboundQuery : TIntegerQueryImpl<IUnboundIntegerQuery>
                                       read FUnboundQuery implements IUnboundIntegerQuery;
  end;

function IntegerQuery : IUnboundIntegerQuery;
begin
  Result := TIntegerQuery.Create(TEnumerationStrategy<Integer>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'IntegerQuery';
{$ENDIF}
end;


function Range(Start : Integer = 0; Finish : Integer = MaxInt) : IBoundIntegerQuery;
var
  RangeEnumerator : IMinimalEnumerator<Integer>;
begin
  if Start < Finish then
    RangeEnumerator := TIntegerRangeEnumerator.Create(Start, Finish)
  else if Start > Finish then
    RangeEnumerator := TIntegerRangeReverseEnumerator.Create(Start, Finish)
  else
    RangeEnumerator := TSingleValueAdapter<Integer>.Create(Start);

  Result := TIntegerQuery.Create(TEnumerationStrategy<Integer>.Create,
                                           nil,
                                           RangeEnumerator);


{$IFDEF DEBUG}
  Result.OperationName := 'Range';
{$ENDIF}
end;

{ TIntegerQueryEnumerator }

constructor TIntegerQuery.Create(
  EnumerationStrategy: TEnumerationStrategy<Integer>;
  UpstreamQuery: IBaseQuery<Integer>;
  SourceData: IMinimalEnumerator<Integer>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundQuery := TIntegerQueryImpl<IBoundIntegerQuery>.Create(self);
  FUnboundQuery := TIntegerQueryImpl<IUnboundIntegerQuery>.Create(self);
end;


destructor TIntegerQuery.Destroy;
begin
  FBoundQuery.Free;
  FUnboundQuery.Free;
  inherited;
end;


function TIntegerQuery.TIntegerQueryImpl<T>.Average: Double;
var
  LTotal, LCount : Integer;
begin
  LCount := 0;

  LTotal := TReducer<Integer, Integer>.Reduce(FQuery,
                                              0,
                                              function(Accumulator : Integer; NextValue : Integer) : Integer
                                              begin
                                                Result := Accumulator + NextValue;
                                                Inc(LCount);
                                              end);

  if LCount = 0 then
    raise EEmptyResultSetException.Create('Cannot take Average of an empty ResultSet')
  else
    Result := LTotal/LCount;
end;

function TIntegerQuery.TIntegerQueryImpl<T>.Count: Integer;
begin
  Result := TReducer<Integer,Integer>.Reduce(FQuery,
                                             0,
                                             function(Accumulator : Integer; NextValue : Integer): Integer
                                             begin
                                               Result := Accumulator + 1;
                                             end);
end;

constructor TIntegerQuery.TIntegerQueryImpl<T>.Create(Query: TIntegerQuery);
begin
  FQuery := Query;
end;

function TIntegerQuery.TIntegerQueryImpl<T>.Equals(
  const Value: Integer): T;
begin
  Result := Where(TIntegerMethodFactory.Equals(Value));
{$IFDEF DEBUG}
  Result.OperationName := Format('Equals(%d)', [Value]);
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.First: Integer;
begin
  if FQuery.MoveNext then
    Result := FQuery.GetCurrent
  else
    raise EEmptyResultSetException.Create('Can''t call First on an empty Result Set');
end;

function TIntegerQuery.TIntegerQueryImpl<T>.From(Container: TEnumerable<Integer>): IBoundIntegerQuery;
var
  EnumeratorAdapter : IMinimalEnumerator<Integer>;
begin
  EnumeratorAdapter := TGenericEnumeratorAdapter<Integer>.Create(Container.GetEnumerator) as IMinimalEnumerator<Integer>;
  Result := TIntegerQuery.Create(TEnumerationStrategy<Integer>.Create,
                                          IBaseQuery<Integer>(FQuery),
                                          EnumeratorAdapter);
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Container.ToString]);
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.GetEnumerator: T;
begin
  Result := FQuery;
end;

{$IFDEF DEBUG}
function TIntegerQuery.TIntegerQueryImpl<T>.GetOperationName: String;
begin
  Result := FQuery.OperationName;
end;

function TIntegerQuery.TIntegerQueryImpl<T>.GetOperationPath: String;
begin
  Result := FQuery.OperationPath;
end;
{$ENDIF}

function TIntegerQuery.TIntegerQueryImpl<T>.GreaterThan(
  const Value: Integer): T;
begin
  Result := WhereNot(TIntegerMethodFactory.LessThanOrEquals(Value));
{$IFDEF DEBUG}
  Result.OperationName := Format('GreaterThan(%d)', [Value]);
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.GreaterThanOrEquals(
  const Value: Integer): T;
begin
  Result := Where(TIntegerMethodFactory.GreaterThanOrEquals(Value));
{$IFDEF DEBUG}
  Result.OperationName := Format('GreaterThanOrEquals(%d)', [Value]);
{$ENDIF}
end;



function TIntegerQuery.TIntegerQueryImpl<T>.Even: T;
begin
  Result := Where(TIntegerMethodFactory.Even());
{$IFDEF DEBUG}
  Result.OperationName := 'Even';
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.Negative: T;
begin
  Result := LessThan(0);
{$IFDEF DEBUG}
  Result.OperationName := 'Negative';
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.NonZero: T;
begin
  Result := NotEquals(0);
{$IFDEF DEBUG}
  Result.OperationName := 'NonZero';
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.NotEquals(
  const Value: Integer): T;
begin
  Result := WhereNot(TIntegerMethodFactory.Equals(Value));
{$IFDEF DEBUG}
  Result.OperationName := Format('NotEquals(%d)', [Value]);
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.Odd: T;
begin
  Result := WhereNot(TIntegerMethodFactory.Even());
{$IFDEF DEBUG}
  Result.OperationName := 'Odd';
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.Positive: T;
begin
  Result := GreaterThanOrEquals(1);
{$IFDEF DEBUG}
  Result.OperationName := 'Positive';
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.Zero: T;
begin
  Result := Equals(0);
{$IFDEF DEBUG}
  Result.OperationName := 'Zero';
{$ENDIF}
end;


function TIntegerQuery.TIntegerQueryImpl<T>.LessThan(
  const Value: Integer): T;
begin
  Result := WhereNot(TIntegerMethodFactory.GreaterThanOrEquals(Value));
{$IFDEF DEBUG}
  Result.OperationName := Format('LessThan(%d)', [Value]);
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.LessThanOrEquals(
  const Value: Integer): T;
begin
  Result := Where(TIntegerMethodFactory.LessThanOrEquals(Value));
{$IFDEF DEBUG}
  Result.OperationName := Format('LessThanOrEquals(%d)', [Value]);
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.Map(
  Transformer: TFunc<Integer, Integer>): T;
begin
  Result := TIntegerQuery.Create(TIsomorphicTransformEnumerationStrategy<Integer>.Create(Transformer),
                                          IBaseQuery<Integer>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Map(Transformer)';
{$ENDIF}
end;


function TIntegerQuery.TIntegerQueryImpl<T>.Max: Integer;
begin
  Result := TReducer<Integer, Integer>.Reduce(FQuery,
                                              -MaxInt,
                                              function(Accumulator : Integer; NextValue : Integer) : Integer
                                              begin
                                                Result := System.Math.Max(Accumulator, NextValue);
                                              end);
end;

function TIntegerQuery.TIntegerQueryImpl<T>.Min: Integer;
begin
  Result := TReducer<Integer, Integer>.Reduce(FQuery,
                                              MaxInt,
                                              function(Accumulator : Integer; NextValue : Integer) : Integer
                                              begin
                                                Result := System.Math.Min(Accumulator, NextValue);
                                              end);
end;

function TIntegerQuery.TIntegerQueryImpl<T>.Predicate: TPredicate<Integer>;
begin
  Result := TIntegerMethodFactory.QuerySingleValue(FQuery);
end;

function TIntegerQuery.TIntegerQueryImpl<T>.Skip(Count: Integer): T;
begin
  Result := SkipWhile(TIntegerMethodFactory.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [Count]);
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.SkipUntil(
  Predicate: TPredicate<Integer>): T;
begin
  Result := SkipWhile(TIntegerMethodFactory.Not(Predicate));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipUntil(Predicate)';
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.SkipUntil(
  UnboundQuery: IUnboundIntegerQuery): T;
begin
  Result := SkipWhile(TIntegerMethodFactory.Not(UnboundQuery.Predicate));
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipUntil(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.SkipUntil(
  const Value: Integer): T;
begin
  Result := SkipWhile(IntegerQuery.NotEquals(Value).Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipUntil(%d)', [Value]);
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.SkipWhile(
  UnboundQuery: IUnboundIntegerQuery): T;
begin
  Result := SkipWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipWhile(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.Sum: Integer;
begin
  Result := TReducer<Integer, Integer>.Reduce(FQuery,
                                              0,
                                              function(Accumulator : Integer; NextValue : Integer) : Integer
                                              begin
                                                Result := Accumulator + NextValue;
                                              end);
end;

function TIntegerQuery.TIntegerQueryImpl<T>.SkipWhile(
  Predicate: TPredicate<Integer>): T;
begin
  Result := TIntegerQuery.Create(TSkipWhileEnumerationStrategy<Integer>.Create(Predicate),
                                          IBaseQuery<Integer>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipWhile(Predicate)';
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.Take(Count: Integer): T;
begin
  Result := TakeWhile(TIntegerMethodFactory.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Take(%d)', [Count]);
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.TakeBetween(
  StartQuery, EndQuery: IUnboundIntegerQuery): T;
begin
  Result := TakeBetween(StartQuery.Predicate, EndQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := 'TakeBetween(StartQuery, EndQuery)';
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.TakeBetween(
  const StartValue, EndValue: Integer): T;
begin
  Result := TakeBetween(IntegerQuery.Equals(StartValue).Predicate, IntegerQuery.Equals(EndValue).Predicate);
{$IFDEF DEBUG}
  Result.OperationName := 'TakeBetween(StartQuery, EndQuery)';
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.TakeBetween(
  StartPredicate, EndPredicate: TPredicate<Integer>): T;
begin
  Result := TIntegerQuery.Create(
              TTakeWhileEnumerationStrategy<Integer>.Create(
                TIntegerMethodFactory.Not(EndPredicate)),
              TIntegerQuery.Create(
                TSkipWhileEnumerationStrategy<Integer>.Create(
                  TIntegerMethodFactory.Not(StartPredicate)),
                IBaseQuery<Integer>(FQuery)));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeBetween(StartPredicate, EndPredicate)';
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.TakeUntil(
  Predicate: TPredicate<Integer>): T;
begin
  Result := TakeWhile(TIntegerMethodFactory.Not(Predicate));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeUntil(Predicate)';
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.TakeUntil(
  UnboundQuery: IUnboundIntegerQuery): T;
begin
  Result := TakeWhile(TIntegerMethodFactory.Not(UnboundQuery.Predicate));
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeUntil(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.TakeUntil(
  const Value: Integer): T;
begin
  Result := TakeWhile(IntegerQuery.NotEquals(Value).Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeUntil(%d)', [Value]);
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.TakeWhile(
  UnboundQuery: IUnboundIntegerQuery): T;
begin
  Result := TakeWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeWhile(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.AsTList: TList<Integer>;
begin
  Result := TReducer<Integer,TList<Integer>>.Reduce(FQuery,
                                              TList<Integer>.Create,
                                              function(Accumulator : TList<Integer>; NextValue : Integer): TList<Integer>
                                              begin
                                                Accumulator.Add(NextValue);
                                                Result := Accumulator;
                                              end);
end;

function TIntegerQuery.TIntegerQueryImpl<T>.TakeWhile(Predicate: TPredicate<Integer>): T;
begin
  Result := TIntegerQuery.Create(TTakeWhileEnumerationStrategy<Integer>.Create(Predicate),
                                          IBaseQuery<Integer>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeWhile(Predicate)';
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.Where(
  Predicate: TPredicate<Integer>): T;
begin
  Result := TIntegerQuery.Create(TWhereEnumerationStrategy<Integer>.Create(Predicate),
                                          IBaseQuery<Integer>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Where(Predicate)';
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.WhereNot(
  UnboundQuery: IUnboundIntegerQuery): T;
begin
  Result := WhereNot(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('WhereNot(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TIntegerQuery.TIntegerQueryImpl<T>.WhereNot(
  Predicate: TPredicate<Integer>): T;
begin
  Result := Where(TIntegerMethodFactory.Not(Predicate));
{$IFDEF DEBUG}
  Result.OperationName := 'WhereNot(Predicate)';
{$ENDIF}
end;

end.
