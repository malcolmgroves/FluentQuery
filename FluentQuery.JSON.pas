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
{ TODO : Should the items that return all items of type be pluralised? ie. JSONStrings, JSONObjects,
 while items that "select" a specific one be singular, ie. JSONObject('fred').
 Alternatively, maybe the former should be TakeJSONStrings or IsJSONString, while the latter remains as they are.
 Question becomes important when you think about nested Objects/Arrays. If JSONArray "descends"
 into an array, and then you want to "descend" into a subarray (which is not named), it could become confusing }
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
    function Named(const Name : string) : IBoundJSONPairQuery;
    function JSONString : IBoundJSONPairQuery; overload;
    function JSONString(const Name : string) : IBoundJSONPairQuery; overload;
    function JSONNumber : IBoundJSONPairQuery; overload;
    function JSONNumber(const Name : string) : IBoundJSONPairQuery; overload;
    function JSONBool : IBoundJSONPairQuery; overload;
    function JSONBool(const Name : string) : IBoundJSONPairQuery; overload;
    function JSONNull : IBoundJSONPairQuery; overload;
    function JSONNull(const Name : string) : IBoundJSONPairQuery; overload;
    function JSONObject : IBoundJSONPairQuery; overload;
    function JSONObject(const Name : string) : IBoundJSONPairQuery; overload;
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
    function Named(const Name : string) : IUnboundJSONPairQuery;
    function JSONString : IUnboundJSONPairQuery; overload;
    function JSONString(const Name : string) : IUnboundJSONPairQuery; overload;
    function JSONNumber : IUnboundJSONPairQuery; overload;
    function JSONNumber(const Name : string) : IUnboundJSONPairQuery; overload;
    function JSONBool : IUnboundJSONPairQuery; overload;
    function JSONBool(const Name : string) : IUnboundJSONPairQuery; overload;
    function JSONNull : IUnboundJSONPairQuery; overload;
    function JSONNull(const Name : string) : IUnboundJSONPairQuery; overload;
    function JSONObject : IUnboundJSONPairQuery; overload;
    function JSONObject(const Name : string) : IUnboundJSONPairQuery; overload;
  end;

  IUnboundJSONValueQuery = interface;

  IBoundJSONValueQuery = interface(IBaseBoundQuery<TJSONValue>)
    function GetEnumerator: IBoundJSONValueQuery;
    // common operations
    function Map(Transformer : TFunc<TJSONValue, TJSONValue>) : IBoundJSONValueQuery;
    function Skip(Count : Integer): IBoundJSONValueQuery;
    function SkipWhile(Predicate : TPredicate<TJSONValue>) : IBoundJSONValueQuery; overload;
    function SkipWhile(UnboundQuery : IUnboundJSONValueQuery) : IBoundJSONValueQuery; overload;
    function Take(Count : Integer): IBoundJSONValueQuery;
    function TakeWhile(Predicate : TPredicate<TJSONValue>): IBoundJSONValueQuery; overload;
    function TakeWhile(UnboundQuery : IUnboundJSONValueQuery): IBoundJSONValueQuery; overload;
    function Where(Predicate : TPredicate<TJSONValue>) : IBoundJSONValueQuery;
    function WhereNot(UnboundQuery : IUnboundJSONValueQuery) : IBoundJSONValueQuery; overload;
    function WhereNot(Predicate : TPredicate<TJSONValue>) : IBoundJSONValueQuery; overload;
    // type-specific operations
    function JSONString : IBoundJSONValueQuery;
    function JSONNumber : IBoundJSONValueQuery;
    function JSONNull : IBoundJSONValueQuery;
    function JSONBool : IBoundJSONValueQuery;
    function JSONObject : IBoundJSONValueQuery;
    function JSONArray : IBoundJSONValueQuery;
    // terminating operations
    function GetItem(Index : Integer) : TJSONValue;
    property Item[Index : Integer] : TJSONValue read GetItem; default;
  end;

  IUnboundJSONValueQuery = interface(IBaseUnboundQuery<TJSONValue>)
    function GetEnumerator: IUnboundJSONValueQuery;
    // common operations
    function From(JSONArray : TJSONArray) : IBoundJSONValueQuery; overload;
    function Map(Transformer : TFunc<TJSONValue, TJSONValue>) : IUnboundJSONValueQuery;
    function Skip(Count : Integer): IUnboundJSONValueQuery;
    function SkipWhile(Predicate : TPredicate<TJSONValue>) : IUnboundJSONValueQuery; overload;
    function SkipWhile(UnboundQuery : IUnboundJSONValueQuery) : IUnboundJSONValueQuery; overload;
    function Take(Count : Integer): IUnboundJSONValueQuery;
    function TakeWhile(Predicate : TPredicate<TJSONValue>): IUnboundJSONValueQuery; overload;
    function TakeWhile(UnboundQuery : IUnboundJSONValueQuery): IUnboundJSONValueQuery; overload;
    function Where(Predicate : TPredicate<TJSONValue>) : IUnboundJSONValueQuery;
    function WhereNot(UnboundQuery : IUnboundJSONValueQuery) : IUnboundJSONValueQuery; overload;
    function WhereNot(Predicate : TPredicate<TJSONValue>) : IUnboundJSONValueQuery; overload;
    // type-specific operations
    function JSONString : IUnboundJSONValueQuery;
    function JSONNumber : IUnboundJSONValueQuery;
    function JSONNull : IUnboundJSONValueQuery;
    function JSONBool : IUnboundJSONValueQuery;
    function JSONObject : IUnboundJSONValueQuery;
    function JSONArray : IUnboundJSONValueQuery;
  end;

  function JSONQuery : IUnboundJSONPairQuery;

  // temp access
  function JSONArrayQuery : IUnboundJSONValueQuery;


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

  TJSONValueEnumeratorAdapter = class(TInterfacedObject, IMinimalEnumerator<TJSONValue>)
  protected
    FJSONArrayEnumerator : TJSONArrayEnumerator;
    function GetCurrent: TJSONValue;
    function MoveNext: Boolean;
    property Current: TJSONValue read GetCurrent;
  public
    constructor Create(JSONArrayEnumerator : TJSONArrayEnumerator); virtual;
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
        function Named(const Name : string) : T;
        function JSONString : T; overload;
        function JSONString(const Name : string) : T; overload;
        function JSONNumber : T; overload;
        function JSONNumber(const Name : string) : T; overload;
        function JSONBool : T; overload;
        function JSONBool(const Name : string) : T; overload;
        function JSONNull : T; overload;
        function JSONNull(const Name : string) : T; overload;
        function JSONObject : T; overload;
        function JSONObject(const Name : string) : T; overload;
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

  TJSONArrayQuery = class(TBaseQuery<TJSONValue>,
                                 IBoundJSONValueQuery,
                                 IUnboundJSONValueQuery)
  protected
    type
      TJSONArrayQueryImpl<T : IBaseQuery<TJSONValue>> = class
      private
        FQuery : TJSONArrayQuery;
      public
        constructor Create(Query : TJSONArrayQuery); virtual;
        function GetEnumerator: T;
{$IFDEF DEBUG}
        function GetOperationName : String;
        function GetOperationPath : String;
        property OperationName : String read GetOperationName;
        property OperationPath : String read GetOperationPath;
{$ENDIF}
        function From(JSONArray : TJSONArray) : IBoundJSONValueQuery; overload;
        // Primitive Operations
        function Map(Transformer : TFunc<TJSONValue, TJSONValue>) : T;
        function SkipWhile(Predicate : TPredicate<TJSONValue>) : T; overload;
        function TakeWhile(Predicate : TPredicate<TJSONValue>): T; overload;
        function Where(Predicate : TPredicate<TJSONValue>) : T;
        // Derivative Operations
        function Skip(Count : Integer): T;
        function SkipWhile(UnboundQuery : IUnboundJSONValueQuery) : T; overload;
        function Take(Count : Integer): T;
        function TakeWhile(UnboundQuery : IUnboundJSONValueQuery): T; overload;
        function WhereNot(UnboundQuery : IUnboundJSONValueQuery) : T; overload;
        function WhereNot(Predicate : TPredicate<TJSONValue>) : T; overload;
        // type-specific operations
        function JSONString : T;
        function JSONNumber : T;
        function JSONNull : T;
        function JSONBool : T;
        function JSONObject : T;
        function JSONArray : T;
        // Terminating Operations
        function Count : Integer;
        function Predicate : TPredicate<TJSONValue>;
        function First : TJSONValue;
        function GetItem(Index : Integer) : TJSONValue;
        property Item[Index : Integer] : TJSONValue read GetItem; default;
      end;
  protected
    FBoundQuery : TJSONArrayQueryImpl<IBoundJSONValueQuery>;
    FUnboundQuery : TJSONArrayQueryImpl<IUnboundJSONValueQuery>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<TJSONValue>;
                       UpstreamQuery : IBaseQuery<TJSONValue> = nil;
                       SourceData : IMinimalEnumerator<TJSONValue> = nil
                       ); override;
    destructor Destroy; override;
    property BoundQuery : TJSONArrayQueryImpl<IBoundJSONValueQuery>
                                       read FBoundQuery implements IBoundJSONValueQuery;
    property UnboundQuery : TJSONArrayQueryImpl<IUnboundJSONValueQuery>
                                       read FUnboundQuery implements IUnboundJSONValueQuery;
  end;


function JSONQuery : IUnboundJSONPairQuery;
begin
  Result := TJSONObjectQuery.Create(TEnumerationStrategy<TJSONPair>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'JSONPairQuery';
{$ENDIF}
end;

function JSONArrayQuery : IUnboundJSONValueQuery;
begin
  Result := TJSONArrayQuery.Create(TEnumerationStrategy<TJSONValue>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'JSONArrayQuery';
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

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.JSONBool: T;
begin
  Result := Where(TJSONPairMethodFactory.ValueIs<TJSONBool>());
{$IFDEF DEBUG}
  Result.OperationName := 'JSONBool';
{$ENDIF}
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.JSONBool(
  const Name: string): T;
begin
  Result := Where(TJSONPairMEthodFactory.And(TJSONPairMethodFactory.IsNamed(Name),
                                             TJSONPairMethodFactory.ValueIs<TJSONBool>()));

{$IFDEF DEBUG}
  Result.OperationName := Format('JSONBool(%s)', [Name]);
{$ENDIF}
end;

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

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.JSONNull: T;
begin
  Result := Where(TJSONPairMethodFactory.ValueIs<TJSONNull>());
{$IFDEF DEBUG}
  Result.OperationName := 'JSONNull';
{$ENDIF}

end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.JSONNumber: T;
begin
  Result := Where(TJSONPairMethodFactory.ValueIs<TJSONNumber>());
{$IFDEF DEBUG}
  Result.OperationName := 'JSONNumber';
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

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.JSONString(
  const Name: string): T;
begin
  Result := Where(TJSONPairMEthodFactory.And(TJSONPairMethodFactory.IsNamed(Name),
                                             TJSONPairMethodFactory.ValueIs<TJSONString>()));

{$IFDEF DEBUG}
  Result.OperationName := Format('JSONString(%s)', [Name]);
{$ENDIF}
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.JSONString: T;
begin
  Result := Where(TJSONPairMethodFactory.ValueIs<TJSONString>());

{$IFDEF DEBUG}
  Result.OperationName := 'JSONString';
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


function TJSONObjectQuery.TJSONObjectQueryImpl<T>.Named(const Name: string): T;
begin
  Result := Where(TJSONPairMethodFactory.IsNamed(Name));

{$IFDEF DEBUG}
  Result.OperationName := Format('Named(%s)', [Name]);
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

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.JSONNull(
  const Name: string): T;
begin
  Result := Where(TJSONPairMEthodFactory.And(TJSONPairMethodFactory.IsNamed(Name),
                                             TJSONPairMethodFactory.ValueIs<TJSONNull>()));

{$IFDEF DEBUG}
  Result.OperationName := Format('JSONNull(%s)', [Name]);
{$ENDIF}
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.JSONNumber(
  const Name: string): T;
begin
  Result := Where(TJSONPairMEthodFactory.And(TJSONPairMethodFactory.IsNamed(Name),
                                             TJSONPairMethodFactory.ValueIs<TJSONNumber>()));

{$IFDEF DEBUG}
  Result.OperationName := Format('JSONNumber(%s)', [Name]);
{$ENDIF}
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.JSONObject(
  const Name: string): T;
var
  LQuery : T;
  LObject : TJSONObject;
  EnumeratorAdapter : IMinimalEnumerator<TJSONPair>;
begin
  LQuery := Where(TJSONPairMEthodFactory.And(TJSONPairMethodFactory.IsNamed(Name),
                                              TJSONPairMethodFactory.ValueIs<TJSONObject>()));
  if LQuery.MoveNext then
  begin
    EnumeratorAdapter := TJSONPairEnumeratorAdapter.Create(TJSONObject(LQuery.GetCurrent.JsonValue).GetEnumerator);
    Result := TJSONObjectQuery.Create(TEnumerationStrategy<TJSONPair>.Create,
                                      IBaseQuery<TJSONPair>(FQuery),
                                      EnumeratorAdapter);
  end;
  // what happens in else block? For unboundQueries?
{$IFDEF DEBUG}
  Result.OperationName := Format('JSONObject(%s)', [Name]);
{$ENDIF}
end;

function TJSONObjectQuery.TJSONObjectQueryImpl<T>.JSONObject: T;
begin
  Result := Where(TJSONPairMethodFactory.ValueIs<TJSONObject>());
{$IFDEF DEBUG}
  Result.OperationName := 'JSONObject';
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

{ TJSONValueEnumeratorAdapter }

constructor TJSONValueEnumeratorAdapter.Create(
  JSONArrayEnumerator: TJSONArrayEnumerator);
begin
  FJSONArrayEnumerator := JSONArrayEnumerator;

end;

destructor TJSONValueEnumeratorAdapter.Destroy;
begin
  FJSONArrayEnumerator.Free;
  inherited;
end;

function TJSONValueEnumeratorAdapter.GetCurrent: TJSONValue;
begin
  Result := FJSONArrayEnumerator.GetCurrent;
end;

function TJSONValueEnumeratorAdapter.MoveNext: Boolean;
begin
  Result := FJSONArrayEnumerator.MoveNext;
end;

{ TJSONArrayQuery.TJSONArrayQueryImpl<T> }

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.Count: Integer;
begin
  Result := TReducer<TJSONValue,Integer>.Reduce( FQuery,
                                                0,
                                                function(Accumulator : Integer; NextValue : TJSONValue): Integer
                                                begin
                                                  Result := Accumulator + 1;
                                                end);
end;

constructor TJSONArrayQuery.TJSONArrayQueryImpl<T>.Create(
  Query: TJSONArrayQuery);
begin
  FQuery := Query;
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.First: TJSONValue;
begin
  if FQuery.MoveNext then
    Result := FQuery.GetCurrent
  else
    raise EEmptyResultSetException.Create('Can''t call First on an empty Result Set');
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.From(
  JSONArray: TJSONArray): IBoundJSONValueQuery;
var
  EnumeratorAdapter : IMinimalEnumerator<TJSONValue>;
begin
  EnumeratorAdapter := TJSONValueEnumeratorAdapter.Create(JSONArray.GetEnumerator);
  Result := TJSONArrayQuery.Create(TEnumerationStrategy<TJSONValue>.Create,
                                  IBaseQuery<TJSONValue>(FQuery),
                                  EnumeratorAdapter);
{$IFDEF DEBUG}
  Result.OperationName := 'From(JSONArray)';
{$ENDIF}
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.GetEnumerator: T;
begin
  Result := FQuery;
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.GetItem(
  Index: Integer): TJSONValue;
begin
  Result := IBoundJSONValueQuery(Skip(Index)).First;
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.GetOperationName: String;
begin
  Result := FQuery.OperationName;
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.GetOperationPath: String;
begin
  Result := FQuery.OperationPath;
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.JSONArray: T;
var
  LQuery : T;
  LObject : TJSONObject;
  EnumeratorAdapter : IMinimalEnumerator<TJSONValue>;
begin
  LQuery := Where(TJSONValueMethodFactory.ValueIs<TJSONArray>());
  if LQuery.MoveNext then
  begin
    EnumeratorAdapter := TJSONValueEnumeratorAdapter.Create(TJSONArray(LQuery.GetCurrent).GetEnumerator);
    Result := TJSONArrayQuery.Create(TEnumerationStrategy<TJSONValue>.Create,
                                      IBaseQuery<TJSONValue>(FQuery),
                                      EnumeratorAdapter);
  end;
  // what happens in else block? For unboundQueries?
{$IFDEF DEBUG}
  Result.OperationName := 'JSONArray';
{$ENDIF}
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.JSONBool: T;
begin
  Result := Where(TJSONValueMethodFactory.ValueIs<TJSONBool>());

{$IFDEF DEBUG}
  Result.OperationName := 'JSONBool';
{$ENDIF}
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.JSONNull: T;
begin
  Result := Where(TJSONValueMethodFactory.ValueIs<TJSONNull>());

{$IFDEF DEBUG}
  Result.OperationName := 'JSONNull';
{$ENDIF}
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.JSONNumber: T;
begin
  Result := Where(TJSONValueMethodFactory.ValueIs<TJSONNumber>());

{$IFDEF DEBUG}
  Result.OperationName := 'JSONNumber';
{$ENDIF}
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.JSONObject: T;
begin
  Result := Where(TJSONValueMethodFactory.ValueIs<TJSONObject>());

{$IFDEF DEBUG}
  Result.OperationName := 'JSONObject';
{$ENDIF}
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.JSONString: T;
begin
  Result := Where(TJSONValueMethodFactory.ValueIs<TJSONString>());

{$IFDEF DEBUG}
  Result.OperationName := 'JSONString';
{$ENDIF}
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.Map(
  Transformer: TFunc<TJSONValue, TJSONValue>): T;
begin
  Result := TJSONArrayQuery.Create(TIsomorphicTransformEnumerationStrategy<TJSONValue>.Create(Transformer),
                                          IBaseQuery<TJSONValue>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Map(Transformer)';
{$ENDIF}
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.Predicate: TPredicate<TJSONValue>;
begin
  Result := TMethodFactory<TJSONValue>.QuerySingleValue(FQuery);
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.Skip(Count: Integer): T;
begin
  Result := SkipWhile(TMethodFactory<TJSONValue>.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [Count]);
{$ENDIF}
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.SkipWhile(
  Predicate: TPredicate<TJSONValue>): T;
begin
  Result := TJSONArrayQuery.Create(TSkipWhileEnumerationStrategy<TJSONValue>.Create(Predicate),
                                          IBaseQuery<TJSONValue>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipWhile(Predicate)';
{$ENDIF}
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.SkipWhile(
  UnboundQuery: IUnboundJSONValueQuery): T;
begin
  Result := SkipWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipWhile(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.Take(Count: Integer): T;
begin
  Result := TakeWhile(TMethodFactory<TJSONValue>.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Take(%d)', [Count]);
{$ENDIF}
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.TakeWhile(
  UnboundQuery: IUnboundJSONValueQuery): T;
begin
  Result := TakeWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeWhile(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.TakeWhile(
  Predicate: TPredicate<TJSONValue>): T;
begin
  Result := TJSONArrayQuery.Create(TTakeWhileEnumerationStrategy<TJSONValue>.Create(Predicate),
                                          IBaseQuery<TJSONValue>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeWhile(Predicate)';
{$ENDIF}
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.Where(
  Predicate: TPredicate<TJSONValue>): T;
begin
  Result := TJSONArrayQuery.Create(TWhereEnumerationStrategy<TJSONValue>.Create(Predicate),
                                          IBaseQuery<TJSONValue>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Where(Predicate)';
{$ENDIF}
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.WhereNot(
  Predicate: TPredicate<TJSONValue>): T;
begin
  Result := Where(TMethodFactory<TJSONValue>.Not(Predicate));

{$IFDEF DEBUG}
  Result.OperationName := 'WhereNot(Predicate)';
{$ENDIF}
end;

function TJSONArrayQuery.TJSONArrayQueryImpl<T>.WhereNot(
  UnboundQuery: IUnboundJSONValueQuery): T;
begin
  Result := WhereNot(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('WhereNot(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

{ TJSONArrayQuery }

constructor TJSONArrayQuery.Create(
  EnumerationStrategy: TEnumerationStrategy<TJSONValue>;
  UpstreamQuery: IBaseQuery<TJSONValue>;
  SourceData: IMinimalEnumerator<TJSONValue>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundQuery := TJSONArrayQueryImpl<IBoundJSONValueQuery>.Create(self);
  FUnboundQuery := TJSONArrayQueryImpl<IUnboundJSONValueQuery>.Create(self);
end;

destructor TJSONArrayQuery.Destroy;
begin
  FBoundQuery.Free;
  FUnboundQuery.Free;
  inherited;
end;

end.
