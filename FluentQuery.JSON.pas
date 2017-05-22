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
unit FluentQuery.JSON;

interface
uses
  System.JSON,
  FluentQuery.Core.Types,
  System.SysUtils,
  FluentQuery.Strings,
  FluentQuery.Integers;

type
  IUnboundJSONPairQuery = interface;

  IBoundJSONPairQuery = interface(IBaseBoundQuery<TJSONPair>)
    function GetEnumerator: IBoundJSONPairQuery;
    // common operations
    function Map(Transformer : TFunc<TJSONPair, TJSONPair>) : IBoundJSONPairQuery;
    function Skip(Count : Integer): IBoundJSONPairQuery;
    function SkipWhile(Predicate : TPredicate<TJSONPair>) : IBoundJSONPairQuery; overload;
    function SkipWhile(UnboundQuery : IUnboundJSONPairQuery) : IBoundJSONPairQuery; overload;
    function Take(Count : Integer): IBoundJSONPairQuery;
    function TakeWhile(Predicate : TPredicate<TJSONPair>): IBoundJSONPairQuery; overload;
    function TakeWhile(UnboundQuery : IUnboundJSONPairQuery): IBoundJSONPairQuery; overload;
    function Where(Predicate : TPredicate<TJSONPair>) : IBoundJSONPairQuery;
    function WhereNot(UnboundQuery : IUnboundJSONPairQuery) : IBoundJSONPairQuery; overload;
    function WhereNot(Predicate : TPredicate<TJSONPair>) : IBoundJSONPairQuery; overload;
    // type-specific operations
    function Value(const Name : string) : IBoundJSONPairQuery;
    function StringValue : IBoundJSONPairQuery;
    function NumberValue : IBoundJSONPairQuery;
  end;

  IUnboundJSONPairQuery = interface(IBaseUnboundQuery<TJSONPair>)
    function GetEnumerator: IUnboundJSONPairQuery;
    // common operations
    function From(JSONObject : TJSONObject) : IBoundJSONPairQuery; overload;
    function Map(Transformer : TFunc<TJSONPair, TJSONPair>) : IUnboundJSONPairQuery;
    function Skip(Count : Integer): IUnboundJSONPairQuery;
    function SkipWhile(Predicate : TPredicate<TJSONPair>) : IUnboundJSONPairQuery; overload;
    function SkipWhile(UnboundQuery : IUnboundJSONPairQuery) : IUnboundJSONPairQuery; overload;
    function Take(Count : Integer): IUnboundJSONPairQuery;
    function TakeWhile(Predicate : TPredicate<TJSONPair>): IUnboundJSONPairQuery; overload;
    function TakeWhile(UnboundQuery : IUnboundJSONPairQuery): IUnboundJSONPairQuery; overload;
    function Where(Predicate : TPredicate<TJSONPair>) : IUnboundJSONPairQuery;
    function WhereNot(UnboundQuery : IUnboundJSONPairQuery) : IUnboundJSONPairQuery; overload;
    function WhereNot(Predicate : TPredicate<TJSONPair>) : IUnboundJSONPairQuery; overload;
    // type-specific operations
    function Value(const Name : string) : IUnboundJSONPairQuery;
    function StringValue : IUnboundJSONPairQuery;
    function NumberValue : IUnboundJSONPairQuery;
  end;

  function JSONPairQuery : IUnboundJSONPairQuery;


implementation
uses
  FluentQuery.Core.EnumerationStrategies, FluentQuery.Core.Enumerators,
  FluentQuery.Core.Reduce, FluentQuery.Core.MethodFactories, FluentQuery.JSON.MethodFactories,
  Generics.Collections;

type
  TJSONPairEnumeratorAdapter = class(TInterfacedObject, IMinimalEnumerator<TJSONPair>)
  protected
    FJSONPairEnumerator : TJSONPairEnumerator;
    function GetCurrent: TJSONPair;
    function MoveNext: Boolean;
    property Current: TJSONPair read GetCurrent;
  public
    constructor Create(JSONPairEnumerator : TJSONPairEnumerator); virtual;
    destructor Destroy; override;
  end;

  TJSONObjectQuery = class(TBaseQuery<TJSONPair>,
                                 IBoundJSONPairQuery,
                                 IUnboundJSONPairQuery)
  protected
    type
      TJSONObjectQueryImpl<T : IBaseQuery<TJSONPair>> = class
      private
        FQuery : TJSONObjectQuery;
      public
        constructor Create(Query : TJSONObjectQuery); virtual;
        function GetEnumerator: T;
{$IFDEF DEBUG}
        function GetOperationName : String;
        function GetOperationPath : String;
        property OperationName : String read GetOperationName;
        property OperationPath : String read GetOperationPath;
{$ENDIF}
        function From(JSONObject : TJSONObject) : IBoundJSONPairQuery; overload;
        // Primitive Operations
        function Map(Transformer : TFunc<TJSONPair, TJSONPair>) : T;
        function SkipWhile(Predicate : TPredicate<TJSONPair>) : T; overload;
        function TakeWhile(Predicate : TPredicate<TJSONPair>): T; overload;
        function Where(Predicate : TPredicate<TJSONPair>) : T;
        // Derivative Operations
        function Skip(Count : Integer): T;
        function SkipWhile(UnboundQuery : IUnboundJSONPairQuery) : T; overload;
        function Take(Count : Integer): T;
        function TakeWhile(UnboundQuery : IUnboundJSONPairQuery): T; overload;
        function WhereNot(UnboundQuery : IUnboundJSONPairQuery) : T; overload;
        function WhereNot(Predicate : TPredicate<TJSONPair>) : T; overload;
        // type-specific operations
        function Value(const Name : string) : T;
        function StringValue : T;
        function NumberValue : T;
        // Terminating Operations
        function Count : Integer;
        function Predicate : TPredicate<TJSONPair>;
        function First : TJSONPair;
      end;
  protected
    FBoundQuery : TJSONObjectQueryImpl<IBoundJSONPairQuery>;
    FUnboundQuery : TJSONObjectQueryImpl<IUnboundJSONPairQuery>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<TJSONPair>;
                       UpstreamQuery : IBaseQuery<TJSONPair> = nil;
                       SourceData : IMinimalEnumerator<TJSONPair> = nil
                       ); override;
    destructor Destroy; override;
    property BoundQuery : TJSONObjectQueryImpl<IBoundJSONPairQuery>
                                       read FBoundQuery implements IBoundJSONPairQuery;
    property UnboundQuery : TJSONObjectQueryImpl<IUnboundJSONPairQuery>
                                       read FUnboundQuery implements IUnboundJSONPairQuery;
  end;


function JSONPairQuery : IUnboundJSONPairQuery;
begin
  Result := TJSONObjectQuery.Create(TEnumerationStrategy<TJSONPair>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'JSONPairQuery';
{$ENDIF}
end;



{ TJSONObjectQuery }

constructor TJSONObjectQuery.Create(
  EnumerationStrategy: TEnumerationStrategy<TJSONPair>;
  UpstreamQuery: IBaseQuery<TJSONPair>;
  SourceData: IMinimalEnumerator<TJSONPair>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundQuery := TJSONObjectQueryImpl<IBoundJSONPairQuery>.Create(self);
  FUnboundQuery := TJSONObjectQueryImpl<IUnboundJSONPairQuery>.Create(self);
end;

destructor TJSONObjectQuery.Destroy;
begin
  FBoundQuery.Free;
  FUnboundQuery.Free;
  inherited;
end;

{ TJSONObjectQuery.TJSONObjectQueryImpl<T> }

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.Count: Integer;
begin
  Result := TReducer<TJSONPair,Integer>.Reduce( FQuery,
                                                0,
                                                function(Accumulator : Integer; NextValue : TJSONPair): Integer
                                                begin
                                                  Result := Accumulator + 1;
                                                end);
end;

constructor TJSONObjectQuery.TJSONObjectQueryImpl<T>.Create(Query: TJSONObjectQuery);
begin
  FQuery := Query;
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.First: TJSONPair;
begin
  if FQuery.MoveNext then
    Result := FQuery.GetCurrent
  else
    raise EEmptyResultSetException.Create('Can''t call First on an empty Result Set');
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.From(
  JSONObject : TJSONObject): IBoundJSONPairQuery;
var
  EnumeratorAdapter : IMinimalEnumerator<TJSONPair>;
begin
  EnumeratorAdapter := TJSONPairEnumeratorAdapter.Create(JSONObject.GetEnumerator);
  Result := TJSONObjectQuery.Create(TEnumerationStrategy<TJSONPair>.Create,
                                  IBaseQuery<TJSONPair>(FQuery),
                                  EnumeratorAdapter);
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [JSONObject.ToString]);
{$ENDIF}
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.GetEnumerator: T;
begin
  Result := FQuery;
end;


{$IFDEF DEBUG}
function TJSONObjectQuery.TJSONObjectQueryImpl<T>.GetOperationName: String;
begin
  Result := FQuery.OperationName;
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.GetOperationPath: String;
begin
  Result := FQuery.OperationPath;
end;
{$ENDIF}


function TJSONObjectQuery.TJSONObjectQueryImpl<T>.Map(
  Transformer: TFunc<TJSONPair, TJSONPair>): T;
begin
  Result := TJSONObjectQuery.Create(TIsomorphicTransformEnumerationStrategy<TJSONPair>.Create(Transformer),
                                          IBaseQuery<TJSONPair>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Map(Transformer)';
{$ENDIF}
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.NumberValue: T;
begin
  Result := Where(TJSONPairMethodFactory.ValueIs<TJSONNumber>());
//  Result := Where(TJSONPairMEthodFactory.Or(TJSONPairMethodFactory.ValueIs<Integer>(),
//                                            TJSONPairMethodFactory.ValueIs<Double>()));

{$IFDEF DEBUG}
  Result.OperationName := 'StringValue';
{$ENDIF}
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.Predicate: TPredicate<TJSONPair>;
begin
  Result := TMethodFactory<TJSONPair>.QuerySingleValue(FQuery);
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.Skip(Count: Integer): T;
begin
  Result := SkipWhile(TMethodFactory<TJSONPair>.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [Count]);
{$ENDIF}
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.SkipWhile(
  Predicate: TPredicate<TJSONPair>): T;
begin
  Result := TJSONObjectQuery.Create(TSkipWhileEnumerationStrategy<TJSONPair>.Create(Predicate),
                                          IBaseQuery<TJSONPair>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipWhile(Predicate)';
{$ENDIF}
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.SkipWhile(
  UnboundQuery: IUnboundJSONPairQuery): T;
begin
  Result := SkipWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipWhile(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.StringValue: T;
begin
  Result := Where(TJSONPairMethodFactory.ValueIs<TJSONString>());

{$IFDEF DEBUG}
  Result.OperationName := 'StringValue';
{$ENDIF}
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.Take(Count: Integer): T;
begin
  Result := TakeWhile(TMethodFactory<TJSONPair>.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Take(%d)', [Count]);
{$ENDIF}
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.TakeWhile(
  Predicate: TPredicate<TJSONPair>): T;
begin
  Result := TJSONObjectQuery.Create(TTakeWhileEnumerationStrategy<TJSONPair>.Create(Predicate),
                                          IBaseQuery<TJSONPair>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeWhile(Predicate)';
{$ENDIF}
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.TakeWhile(
  UnboundQuery: IUnboundJSONPairQuery): T;
begin
  Result := TakeWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeWhile(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;


function TJSONObjectQuery.TJSONObjectQueryImpl<T>.Value(const Name: string): T;
begin
  Result := Where(TJSONPairMethodFactory.IsNamed(Name));

{$IFDEF DEBUG}
  Result.OperationName := Format('Value(%s)', [Name]);
{$ENDIF}
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.Where(
  Predicate: TPredicate<TJSONPair>): T;
begin
  Result := TJSONObjectQuery.Create(TWhereEnumerationStrategy<TJSONPair>.Create(Predicate),
                                          IBaseQuery<TJSONPair>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Where(Predicate)';
{$ENDIF}
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.WhereNot(
  UnboundQuery: IUnboundJSONPairQuery): T;
begin
  Result := WhereNot(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('WhereNot(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.WhereNot(
  Predicate: TPredicate<TJSONPair>): T;
begin
  Result := Where(TMethodFactory<TJSONPair>.Not(Predicate));

{$IFDEF DEBUG}
  Result.OperationName := 'WhereNot(Predicate)';
{$ENDIF}
end;

{ TJSONPairEnumeratorAdapter }

constructor TJSONPairEnumeratorAdapter.Create(
  JSONPairEnumerator: TJSONPairEnumerator);
begin
  FJSONPairEnumerator := JSONPairEnumerator;
end;

destructor TJSONPairEnumeratorAdapter.Destroy;
begin
  FJSONPairEnumerator.Free;
  inherited;
end;

function TJSONPairEnumeratorAdapter.GetCurrent: TJSONPair;
begin
  Result := FJSONPairEnumerator.GetCurrent;
end;

function TJSONPairEnumeratorAdapter.MoveNext: Boolean;
begin
  Result := FJSONPairEnumerator.MoveNext;
end;

end.
