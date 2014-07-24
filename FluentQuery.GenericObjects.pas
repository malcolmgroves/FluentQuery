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
  FluentQuery.Core.Enumerators;

type
  IUnboundObjectQueryEnumerator<T : class> = interface;

  IBoundObjectQueryEnumerator<T : class> = interface(IBaseQueryEnumerator<T>)
    function GetEnumerator: IBoundObjectQueryEnumerator<T>;
    // query operations
//    function Map(Transformer : TFunc<T, T>) : IBoundObjectQueryEnumerator<T>;
//    function MapWhere(Transformer : TFunc<T, T>; Predicate : TPredicate<T>) : IBoundObjectQueryEnumerator<T>;
//    function Skip(Count : Integer): IBoundObjectQueryEnumerator<T>;
//    function SkipWhile(Predicate : TPredicate<T>) : IBoundObjectQueryEnumerator<T>; overload;
//    function SkipWhile(UnboundQuery : IUnboundObjectQueryEnumerator<T>) : IBoundObjectQueryEnumerator<T>; overload;
//    function Take(Count : Integer): IBoundObjectQueryEnumerator<T>;
//    function TakeWhile(Predicate : TPredicate<T>): IBoundObjectQueryEnumerator<T>; overload;
//    function TakeWhile(UnboundQuery : IUnboundObjectQueryEnumerator<T>): IBoundObjectQueryEnumerator<T>; overload;
    function Where(Predicate : TPredicate<T>) : IBoundObjectQueryEnumerator<T>;
//    function WhereNot(UnboundQuery : IUnboundObjectQueryEnumerator<T>) : IBoundObjectQueryEnumerator<T>; overload;
//    function WhereNot(Predicate : TPredicate<T>) : IBoundObjectQueryEnumerator<T>; overload;
    // terminating operations
//    function ToTList : TList<T>;
//    function First : T;
    function ToTObjectList(AOwnsObjects: Boolean = True) : TObjectList<T>;
  end;

  IUnboundObjectQueryEnumerator<T : class> = interface(IBaseQueryEnumerator<T>)
    function GetEnumerator: IUnboundObjectQueryEnumerator<T>;
    function From(Container : TEnumerable<T>) : IBoundObjectQueryEnumerator<T>;
    // query operations
//    function Map(Transformer : TFunc<T, T>) : IUnboundObjectQueryEnumerator<T>;
//    function MapWhere(Transformer : TFunc<T, T>; Predicate : TPredicate<T>) : IUnboundObjectQueryEnumerator<T>;
//    function Skip(Count : Integer): IUnboundObjectQueryEnumerator<T>;
//    function SkipWhile(Predicate : TPredicate<T>) : IUnboundObjectQueryEnumerator<T>; overload;
//    function SkipWhile(UnboundQuery : IUnboundObjectQueryEnumerator<T>) : IUnboundObjectQueryEnumerator<T>; overload;
//    function Take(Count : Integer): IUnboundObjectQueryEnumerator<T>;
//    function TakeWhile(Predicate : TPredicate<T>): IUnboundObjectQueryEnumerator<T>; overload;
//    function TakeWhile(UnboundQuery : IUnboundObjectQueryEnumerator<T>): IUnboundObjectQueryEnumerator<T>; overload;
    function Where(Predicate : TPredicate<T>) : IUnboundObjectQueryEnumerator<T>;
//    function WhereNot(UnboundQuery : IUnboundObjectQueryEnumerator<T>) : IUnboundObjectQueryEnumerator<T>; overload;
//    function WhereNot(Predicate : TPredicate<T>) : IUnboundObjectQueryEnumerator<T>; overload;
    // terminating operations
//    function Predicate : TPredicate<T>;
  end;

  TObjectQueryEnumerator<T : class> = class(TBaseQueryEnumerator<T>,
                              IBoundObjectQueryEnumerator<T>,
                              IUnboundObjectQueryEnumerator<T>)
  protected
    type
      TObjectQueryEnumeratorImpl<TReturnType : IBaseQueryEnumerator<T>> = class
      private
        FQuery : TObjectQueryEnumerator<T>;
      public
        constructor Create(Query : TObjectQueryEnumerator<T>); virtual;
        function GetEnumerator: TReturnType;
{$IFDEF DEBUG}
        function GetOperationName : String;
        function GetOperationPath : String;
        property OperationName : string read GetOperationName;
        property OperationPath : string read GetOperationPath;
{$ENDIF}
        function From(Container : TEnumerable<T>) : IBoundObjectQueryEnumerator<T>;
        // Primitive Operations
//        function Map(Transformer : TFunc<T, T>) : TReturnType;
//        function MapWhere(Transformer : TFunc<T, T>; Predicate : TPredicate<T>) : TReturnType;
//        function SkipWhile(Predicate : TPredicate<T>) : TReturnType; overload;
//        function TakeWhile(Predicate : TPredicate<T>): TReturnType; overload;
        function Where(Predicate : TPredicate<T>) : TReturnType;
        // Derivative Operations
//        function Skip(Count : Integer): TReturnType;
//        function SkipWhile(UnboundQuery : IUnboundObjectQueryEnumerator<T>) : TReturnType; overload;
//        function Take(Count : Integer): TReturnType;
//        function TakeWhile(UnboundQuery : IUnboundObjectQueryEnumerator<T>): TReturnType; overload;
//        function WhereNot(UnboundQuery : IUnboundObjectQueryEnumerator<T>) : TReturnType; overload;
//        function WhereNot(Predicate : TPredicate<T>) : TReturnType; overload;
        // Terminating Operations
//        function Predicate : TPredicate<T>;
//        function ToTList : TList<T>;
//        function First : T;
        function ToTObjectList(AOwnsObjects: Boolean = True) : TObjectList<T>;
      end;
  protected
    FBoundQueryEnumerator : TObjectQueryEnumeratorImpl<IBoundObjectQueryEnumerator<T>>;
    FUnboundQueryEnumerator : TObjectQueryEnumeratorImpl<IUnboundObjectQueryEnumerator<T>>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<T>;
                       UpstreamQuery : IBaseQueryEnumerator<T> = nil;
                       SourceData : IMinimalEnumerator<T> = nil); override;
    destructor Destroy; override;
    property BoundQueryEnumerator : TObjectQueryEnumeratorImpl<IBoundObjectQueryEnumerator<T>>
                                       read FBoundQueryEnumerator implements IBoundObjectQueryEnumerator<T>;
    property UnboundQueryEnumerator : TObjectQueryEnumeratorImpl<IUnboundObjectQueryEnumerator<T>>
                                       read FUnboundQueryEnumerator implements IUnboundObjectQueryEnumerator<T>;
  end;

  Query = class
  public
    class function Select<T : class> : IUnboundObjectQueryEnumerator<T>;
  end;

  ObjectQuery = Query;


implementation

{ TObjectQueryEnumerator<T>.TObjectQueryEnumeratorImpl<TReturnType> }

constructor TObjectQueryEnumerator<T>.TObjectQueryEnumeratorImpl<TReturnType>.Create(
  Query: TObjectQueryEnumerator<T>);
begin
  FQuery := Query;
end;

function TObjectQueryEnumerator<T>.TObjectQueryEnumeratorImpl<TReturnType>.From(
  Container: TEnumerable<T>): IBoundObjectQueryEnumerator<T>;
var
  EnumeratorWrapper : IMinimalEnumerator<T>;
begin
  EnumeratorWrapper := TGenericEnumeratorAdapter<T>.Create(Container.GetEnumerator) as IMinimalEnumerator<T>;
  Result := TObjectQueryEnumerator<T>.Create(TEnumerationStrategy<T>.Create,
                                       IBaseQueryEnumerator<T>(FQuery),
                                       EnumeratorWrapper);
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Container.ToString]);
{$ENDIF}
end;

function TObjectQueryEnumerator<T>.TObjectQueryEnumeratorImpl<TReturnType>.GetEnumerator: TReturnType;
begin
  Result := FQuery;
end;

{$IFDEF DEBUG}
function TObjectQueryEnumerator<T>.TObjectQueryEnumeratorImpl<TReturnType>.GetOperationName: String;
begin
  Result := FQuery.OperationName;
end;

function TObjectQueryEnumerator<T>.TObjectQueryEnumeratorImpl<TReturnType>.GetOperationPath: String;
begin
  Result := FQuery.OperationPath;
end;
function TObjectQueryEnumerator<T>.TObjectQueryEnumeratorImpl<TReturnType>.ToTObjectList(
  AOwnsObjects: Boolean): TObjectList<T>;
var
  LObjectList : TObjectList<T>;
  Item : T;
begin
  LObjectList := TObjectList<T>.Create(AOwnsObjects);

  while FQuery.MoveNext do
    LObjectList.Add(FQuery.GetCurrent);

  Result := LObjectList;
end;

function TObjectQueryEnumerator<T>.TObjectQueryEnumeratorImpl<TReturnType>.Where(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := TObjectQueryEnumerator<T>.Create(TWhereEnumerationStrategy<T>.Create(Predicate),
                                             IBaseQueryEnumerator<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Where(Predicate)';
{$ENDIF}
end;

{$ENDIF}

{ TObjectQueryEnumerator<T> }

constructor TObjectQueryEnumerator<T>.Create(
  EnumerationStrategy: TEnumerationStrategy<T>;
  UpstreamQuery: IBaseQueryEnumerator<T>; SourceData: IMinimalEnumerator<T>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundQueryEnumerator := TObjectQueryEnumeratorImpl<IBoundObjectQueryEnumerator<T>>.Create(self);
  FUnboundQueryEnumerator := TObjectQueryEnumeratorImpl<IUnboundObjectQueryEnumerator<T>>.Create(self);
end;

destructor TObjectQueryEnumerator<T>.Destroy;
begin
  FBoundQueryEnumerator.Free;
  FUnboundQueryEnumerator.Free;
  inherited;
end;

{ Query }

class function Query.Select<T>: IUnboundObjectQueryEnumerator<T>;
begin
  Result := TObjectQueryEnumerator<T>.Create(TEnumerationStrategy<T>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'Query.Select<T>';
{$ENDIF}
end;

end.
