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

unit FluentQuery.GenericObjects;

interface
uses
  FluentQuery.Core.Types,
  System.SysUtils,
  System.Generics.Collections,
  FluentQuery.Core.EnumerationStrategies,
  FluentQuery.Core.Enumerators,
  System.TypInfo,
  System.Rtti;

type
  IUnboundObjectQuery<T : class> = interface;

  IBoundObjectQuery<T : class> = interface(IBaseBoundQuery<T>)
    function GetEnumerator: IBoundObjectQuery<T>;
    // query operations
    function HasProperty(const Name : string; PropertyType : TTypeKind) : IBoundObjectQuery<T>;
    function IsA(AClass : TClass) : IBoundObjectQuery<T>;
    function IsAssigned : IBoundObjectQuery<T>;
    function Map(Transformer : TProc<T>) : IBoundObjectQuery<T>;
    function Skip(Count : Integer): IBoundObjectQuery<T>;
    function SkipWhile(Predicate : TPredicate<T>) : IBoundObjectQuery<T>; overload;
    function SkipWhile(UnboundQuery : IUnboundObjectQuery<T>) : IBoundObjectQuery<T>; overload;
    function Take(Count : Integer): IBoundObjectQuery<T>;
    function TakeWhile(Predicate : TPredicate<T>): IBoundObjectQuery<T>; overload;
    function TakeWhile(UnboundQuery : IUnboundObjectQuery<T>): IBoundObjectQuery<T>; overload;
    function Where(Predicate : TPredicate<T>) : IBoundObjectQuery<T>;
    function WhereNot(UnboundQuery : IUnboundObjectQuery<T>) : IBoundObjectQuery<T>; overload;
    function WhereNot(Predicate : TPredicate<T>) : IBoundObjectQuery<T>; overload;
    // terminating operations
    function AsTObjectList(AOwnsObjects: Boolean = True) : TObjectList<T>;
  end;

  IUnboundObjectQuery<T : class> = interface(IBaseUnboundQuery<T>)
    function GetEnumerator: IUnboundObjectQuery<T>;
    function From(Container : TEnumerable<T>) : IBoundObjectQuery<T>; overload;
    function From(MinimalEnumerator : IMinimalEnumerator<T>) : IBoundObjectQuery<T>; overload;
    // query operations
    function HasProperty(const Name : string; PropertyType : TTypeKind) : IUnboundObjectQuery<T>;
    function IsA(AClass : TClass) : IUnboundObjectQuery<T>;
    function IsAssigned : IUnboundObjectQuery<T>;
    function Map(Transformer : TProc<T>) : IUnboundObjectQuery<T>;
    function Skip(Count : Integer): IUnboundObjectQuery<T>;
    function SkipWhile(Predicate : TPredicate<T>) : IUnboundObjectQuery<T>; overload;
    function SkipWhile(UnboundQuery : IUnboundObjectQuery<T>) : IUnboundObjectQuery<T>; overload;
    function Take(Count : Integer): IUnboundObjectQuery<T>;
    function TakeWhile(Predicate : TPredicate<T>): IUnboundObjectQuery<T>; overload;
    function TakeWhile(UnboundQuery : IUnboundObjectQuery<T>): IUnboundObjectQuery<T>; overload;
    function Where(Predicate : TPredicate<T>) : IUnboundObjectQuery<T>;
    function WhereNot(UnboundQuery : IUnboundObjectQuery<T>) : IUnboundObjectQuery<T>; overload;
    function WhereNot(Predicate : TPredicate<T>) : IUnboundObjectQuery<T>; overload;
  end;

  TObjectQuery<T : class> = class(TBaseQuery<T>,
                              IBoundObjectQuery<T>,
                              IUnboundObjectQuery<T>)
  protected
    type
      TObjectQueryImpl<TReturnType : IBaseQuery<T>> = class
      private
        FQuery : TObjectQuery<T>;
      public
        constructor Create(Query : TObjectQuery<T>); virtual;
        function GetEnumerator: TReturnType;
{$IFDEF DEBUG}
        function GetOperationName : String;
        function GetOperationPath : String;
        property OperationName : string read GetOperationName;
        property OperationPath : string read GetOperationPath;
{$ENDIF}
        function From(Container : TEnumerable<T>) : IBoundObjectQuery<T>; overload;
        function From(MinimalEnumerator : IMinimalEnumerator<T>) : IBoundObjectQuery<T>; overload;
        // Primitive Operations
        function Map(Transformer : TProc<T>) : TReturnType;
        function SkipWhile(Predicate : TPredicate<T>) : TReturnType; overload;
        function TakeWhile(Predicate : TPredicate<T>): TReturnType; overload;
        function Where(Predicate : TPredicate<T>) : TReturnType;
        // Derivative Operations
        function HasProperty(const Name : string; PropertyType : TTypeKind) : TReturnType; overload;
        function IsA(AClass : TClass) : TReturnType;
        function IsAssigned : TReturnType;
        function Skip(Count : Integer): TReturnType;
        function SkipWhile(UnboundQuery : IUnboundObjectQuery<T>) : TReturnType; overload;
        function Take(Count : Integer): TReturnType;
        function TakeWhile(UnboundQuery : IUnboundObjectQuery<T>): TReturnType; overload;
        function WhereNot(UnboundQuery : IUnboundObjectQuery<T>) : TReturnType; overload;
        function WhereNot(Predicate : TPredicate<T>) : TReturnType; overload;
        // Terminating Operations
        function Predicate : TPredicate<T>;
        function First : T;
        function AsTObjectList(AOwnsObjects: Boolean = True) : TObjectList<T>;
        function Count : Integer;
      end;
  protected
    FBoundQuery : TObjectQueryImpl<IBoundObjectQuery<T>>;
    FUnboundQuery : TObjectQueryImpl<IUnboundObjectQuery<T>>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<T>;
                       UpstreamQuery : IBaseQuery<T> = nil;
                       SourceData : IMinimalEnumerator<T> = nil); override;
    destructor Destroy; override;
    property BoundQuery : TObjectQueryImpl<IBoundObjectQuery<T>>
                                       read FBoundQuery implements IBoundObjectQuery<T>;
    property UnboundQuery : TObjectQueryImpl<IUnboundObjectQuery<T>>
                                       read FUnboundQuery implements IUnboundObjectQuery<T>;
  end;

  ObjectQuery<T : class> = class
  public
    class function Select : IUnboundObjectQuery<T>;
    class function From<TSuperType : class>(Container : TEnumerable<TSuperType>) : IBoundObjectQuery<T>;
  end;


implementation

uses FluentQuery.GenericObjects.MethodFactories, FluentQuery.Core.Reduce;

{ TObjectQueryEnumerator<T>.TObjectQueryEnumeratorImpl<TReturnType> }

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.IsA(
  AClass: TClass): TReturnType;
begin
  Result := Where(TGenericObjectMethodFactory<T>.IsA(AClass));
{$IFDEF DEBUG}
  Result.OperationName := 'IsA';
{$ENDIF}
end;

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.Count: Integer;
begin
  Result := TReducer<T,Integer>.Reduce(FQuery,
                                       0,
                                       function(Accumulator : Integer; NextValue : T): Integer
                                       begin
                                         Result := Accumulator + 1;
                                       end);
end;

constructor TObjectQuery<T>.TObjectQueryImpl<TReturnType>.Create(
  Query: TObjectQuery<T>);
begin
  FQuery := Query;
end;

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.First: T;
begin
  if FQuery.MoveNext then
    Result := FQuery.GetCurrent
  else
    raise EEmptyResultSetException.Create('Can''t call First on an empty Result Set');
end;

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.From(
  MinimalEnumerator: IMinimalEnumerator<T>): IBoundObjectQuery<T>;
begin
  Result := TObjectQuery<T>.Create(TEnumerationStrategy<T>.Create,
                                       IBaseQuery<T>(FQuery),
                                       MinimalEnumerator);
{$IFDEF DEBUG}
  Result.OperationName := 'From(MinimalEnumerator)';
{$ENDIF}
end;

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.From(
  Container: TEnumerable<T>): IBoundObjectQuery<T>;
var
  EnumeratorWrapper : IMinimalEnumerator<T>;
begin
  EnumeratorWrapper := TGenericEnumeratorAdapter<T>.Create(Container.GetEnumerator) as IMinimalEnumerator<T>;
  Result := From(EnumeratorWrapper);
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Container.ToString]);
{$ENDIF}
end;

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.GetEnumerator: TReturnType;
begin
  Result := FQuery;
end;

{$IFDEF DEBUG}
function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.GetOperationName: String;
begin
  Result := FQuery.OperationName;
end;

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.GetOperationPath: String;
begin
  Result := FQuery.OperationPath;
end;
{$ENDIF}

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.HasProperty(
  const Name: string; PropertyType: TTypeKind): TReturnType;
begin
  Result := Where(TGenericObjectMethodFactory<T>.PropertyNamedOfType(Name, PropertyType));
{$IFDEF DEBUG}
  Result.OperationName := 'HasProperty(Name, PropertyType)';
{$ENDIF}
end;

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.IsAssigned: TReturnType;
begin
  Result := Where(TGenericObjectMethodFactory<T>.IsAssigned());
{$IFDEF DEBUG}
  Result.OperationName := 'IsAssigned';
{$ENDIF}
end;

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.Map(
  Transformer: TProc<T>): TReturnType;
begin
  Result := TObjectQuery<T>.Create(
              TIsomorphicTransformEnumerationStrategy<T>.Create(
                TGenericObjectMethodFactory<T>.InPlaceTransformer(Transformer)),
              IBaseQuery<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Map(Transformer)';
{$ENDIF}
end;

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.Predicate: TPredicate<T>;
begin
  Result := TGenericObjectMethodFactory<T>.QuerySingleValue(FQuery);
end;

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.SkipWhile(
  UnboundQuery: IUnboundObjectQuery<T>): TReturnType;
begin
  Result := SkipWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipWhile(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.SkipWhile(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := TObjectQuery<T>.Create(TSkipWhileEnumerationStrategy<T>.Create(Predicate),
                                       IBaseQuery<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipWhile(Predicate)';
{$ENDIF}
end;

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.TakeWhile(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := TObjectQuery<T>.Create(TTakeWhileEnumerationStrategy<T>.Create(Predicate),
                                       IBaseQuery<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeWhile(Predicate)';
{$ENDIF}
end;

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.TakeWhile(
  UnboundQuery: IUnboundObjectQuery<T>): TReturnType;
begin
  Result := TakeWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.AsTObjectList(
  AOwnsObjects: Boolean): TObjectList<T>;
begin
  Result := TReducer<T,TObjectList<T>>.Reduce(FQuery,
                                              TObjectList<T>.Create(AOwnsObjects),
                                              function(Accumulator : TObjectList<T>; NextValue : T): TObjectList<T>
                                              begin
                                                Accumulator.Add(NextValue);
                                                Result := Accumulator;
                                              end);
end;

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.Where(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := TObjectQuery<T>.Create(TWhereEnumerationStrategy<T>.Create(Predicate),
                                             IBaseQuery<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Where(Predicate)';
{$ENDIF}
end;

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.WhereNot(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := Where(TGenericObjectMethodFactory<T>.Not(Predicate));
{$IFDEF DEBUG}
  Result.OperationName := 'WhereNot(Predicate)';
{$ENDIF}
end;

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.WhereNot(
  UnboundQuery: IUnboundObjectQuery<T>): TReturnType;
begin
  Result := WhereNot(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('WhereNot(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.Skip(
  Count: Integer): TReturnType;
begin
  Result := SkipWhile(TGenericObjectMethodFactory<T>.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [Count]);
{$ENDIF}
end;

function TObjectQuery<T>.TObjectQueryImpl<TReturnType>.Take(
  Count: Integer): TReturnType;
begin
  Result := TakeWhile(TGenericObjectMethodFactory<T>.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Take(%d)', [Count]);
{$ENDIF}
end;

{ TObjectQueryEnumerator<T> }

constructor TObjectQuery<T>.Create(
  EnumerationStrategy: TEnumerationStrategy<T>;
  UpstreamQuery: IBaseQuery<T>; SourceData: IMinimalEnumerator<T>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundQuery := TObjectQueryImpl<IBoundObjectQuery<T>>.Create(self);
  FUnboundQuery := TObjectQueryImpl<IUnboundObjectQuery<T>>.Create(self);
end;

destructor TObjectQuery<T>.Destroy;
begin
  FBoundQuery.Free;
  FUnboundQuery.Free;
  inherited;
end;

{ Query }

class function ObjectQuery<T>.Select: IUnboundObjectQuery<T>;
begin
  Result := TObjectQuery<T>.Create(TEnumerationStrategy<T>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'Query.Select<T>';
{$ENDIF}
end;


class function ObjectQuery<T>.From<TSuperType>(
  Container: TEnumerable<TSuperType>): IBoundObjectQuery<T>;
var
  LSuperTypeAdapter : TSuperTypeEnumeratorAdapter<TSuperType, T>;
begin
  LSuperTypeAdapter := TSuperTypeEnumeratorAdapter<TSuperType, T>.Create(
                         ObjectQuery<TSuperType>.Select.From(Container).IsA(T));
  Result := TObjectQuery<T>.Create(TEnumerationStrategy<T>.Create,
                                                    nil,
                                                    LSuperTypeAdapter);
{$IFDEF DEBUG}
  Result.OperationName := 'Query.SelectSubTypeFrom';
{$ENDIF}
end;

end.
