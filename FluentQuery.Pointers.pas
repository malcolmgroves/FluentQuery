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

unit FluentQuery.Pointers;

interface
uses
  FluentQuery.Core.Types,
  System.SysUtils,
  FluentQuery.Core.EnumerationStrategies,
  FluentQuery.Core.Enumerators,
  System.Classes,
  System.Generics.Collections;

type
  IUnboundPointerQueryEnumerator = interface;

  IBoundPointerQueryEnumerator = interface(IBaseQueryEnumerator<Pointer>)
    function GetEnumerator: IBoundPointerQueryEnumerator;
    // common operations
    function First : IBoundPointerQueryEnumerator;
    function Skip(Count : Integer): IBoundPointerQueryEnumerator;
    function SkipWhile(Predicate : TPredicate<Pointer>) : IBoundPointerQueryEnumerator; overload;
    function SkipWhile(UnboundQuery : IUnboundPointerQueryEnumerator) : IBoundPointerQueryEnumerator; overload;
    function Take(Count : Integer): IBoundPointerQueryEnumerator;
    function TakeWhile(Predicate : TPredicate<Pointer>): IBoundPointerQueryEnumerator; overload;
    function TakeWhile(UnboundQuery : IUnboundPointerQueryEnumerator): IBoundPointerQueryEnumerator; overload;
    function Where(Predicate : TPredicate<Pointer>) : IBoundPointerQueryEnumerator;
    function WhereNot(UnboundQuery : IUnboundPointerQueryEnumerator) : IBoundPointerQueryEnumerator; overload;
    function WhereNot(Predicate : TPredicate<Pointer>) : IBoundPointerQueryEnumerator; overload;
    // type-specific operations
    function IsAssigned : IBoundPointerQueryEnumerator;
  end;

  IUnboundPointerQueryEnumerator = interface(IBaseQueryEnumerator<Pointer>)
    function GetEnumerator: IUnboundPointerQueryEnumerator;
    // common operations
    function First : IUnboundPointerQueryEnumerator;
    function From(List : TList) : IBoundPointerQueryEnumerator; overload;
    function From(Container : TEnumerable<Pointer>) : IBoundPointerQueryEnumerator; overload;
    function Skip(Count : Integer): IUnboundPointerQueryEnumerator;
    function SkipWhile(Predicate : TPredicate<Pointer>) : IUnboundPointerQueryEnumerator; overload;
    function SkipWhile(UnboundQuery : IUnboundPointerQueryEnumerator) : IUnboundPointerQueryEnumerator; overload;
    function Take(Count : Integer): IUnboundPointerQueryEnumerator;
    function TakeWhile(Predicate : TPredicate<Pointer>): IUnboundPointerQueryEnumerator; overload;
    function TakeWhile(UnboundQuery : IUnboundPointerQueryEnumerator): IUnboundPointerQueryEnumerator; overload;
    function Where(Predicate : TPredicate<Pointer>) : IUnboundPointerQueryEnumerator;
    function WhereNot(UnboundQuery : IUnboundPointerQueryEnumerator) : IUnboundPointerQueryEnumerator; overload;
    function WhereNot(Predicate : TPredicate<Pointer>) : IUnboundPointerQueryEnumerator; overload;
    // type-specific operations
    function IsAssigned : IUnboundPointerQueryEnumerator;
    // terminating operations
    function Predicate : TPredicate<Pointer>;
  end;

  function Query : IUnboundPointerQueryEnumerator;



implementation

type
  TPointerQueryEnumerator = class(TBaseQueryEnumerator<Pointer>,
                                  IBoundPointerQueryEnumerator,
                                  IUnboundPointerQueryEnumerator,
                                  IBaseQueryEnumerator<Pointer>,
                                  IMinimalEnumerator<Pointer>)
  protected
    type
      TPointerQueryEnumeratorImpl<T : IBaseQueryEnumerator<Pointer>> = class
      private
        FQuery : TPointerQueryEnumerator;
      public
        constructor Create(Query : TPointerQueryEnumerator); virtual;
        function GetEnumerator: T;
{$IFDEF DEBUG}
        function GetOperationName : String;
        function GetOperationPath : String;
        property OperationName : string read GetOperationName;
        property OperationPath : string read GetOperationPath;
{$ENDIF}
        function First : T;
        function From(List : TList) : IBoundPointerQueryEnumerator; overload;
        function From(Container : TEnumerable<Pointer>) : IBoundPointerQueryEnumerator; overload;
        function Skip(Count : Integer): T;
        function SkipWhile(Predicate : TPredicate<Pointer>) : T; overload;
        function SkipWhile(UnboundQuery : IUnboundPointerQueryEnumerator) : T; overload;
        function Take(Count : Integer): T;
        function TakeWhile(Predicate : TPredicate<Pointer>): T; overload;
        function TakeWhile(UnboundQuery : IUnboundPointerQueryEnumerator): T; overload;
        function Where(Predicate : TPredicate<Pointer>) : T;
        function WhereNot(UnboundQuery : IUnboundPointerQueryEnumerator) : T; overload;
        function WhereNot(Predicate : TPredicate<Pointer>) : T; overload;
        function IsAssigned : T;
        function Predicate : TPredicate<Pointer>;
      end;
  protected
    FBoundPointerQueryEnumerator : TPointerQueryEnumeratorImpl<IBoundPointerQueryEnumerator>;
    FUnboundPointerQueryEnumerator : TPointerQueryEnumeratorImpl<IUnboundPointerQueryEnumerator>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<Pointer>;
                       UpstreamQuery : IBaseQueryEnumerator<Pointer> = nil;
                       SourceData : IMinimalEnumerator<Pointer> = nil); override;
    destructor Destroy; override;
    property BoundStringQueryEnumerator : TPointerQueryEnumeratorImpl<IBoundPointerQueryEnumerator>
                                       read FBoundPointerQueryEnumerator implements IBoundPointerQueryEnumerator;
    property UnboundStringQueryEnumerator : TPointerQueryEnumeratorImpl<IUnboundPointerQueryEnumerator>
                                       read FUnboundPointerQueryEnumerator implements IUnboundPointerQueryEnumerator;
  end;


function Query : IUnboundPointerQueryEnumerator;
begin
  Result := TPointerQueryEnumerator.Create(TEnumerationStrategy<Pointer>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'Query';
{$ENDIF}
end;



{ TPointerQueryEnumerator }

constructor TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.Create(
  Query: TPointerQueryEnumerator);
begin
  FQuery := Query;
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.First: T;
begin
  Result := TPointerQueryEnumerator.Create(TTakeWhileEnumerationStrategy<Pointer>.Create(TPredicateFactory<Pointer>.LessThanOrEqualTo(1)),
                                           IBaseQueryEnumerator<Pointer>(FQuery));

{$IFDEF DEBUG}
  Result.OperationName := 'First';
{$ENDIF}
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.From(
  List: TList): IBoundPointerQueryEnumerator;
begin
  Result := TPointerQueryEnumerator.Create(TEnumerationStrategy<Pointer>.Create,
                                           IBaseQueryEnumerator<Pointer>(FQuery),
                                           TListEnumeratorAdapter.Create(List.GetEnumerator));
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [List.ToString]);
{$ENDIF}
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.From(
  Container: TEnumerable<Pointer>): IBoundPointerQueryEnumerator;
begin
  Result := TPointerQueryEnumerator.Create(TEnumerationStrategy<Pointer>.Create,
                                           IBaseQueryEnumerator<Pointer>(FQuery),
                                           TGenericEnumeratorAdapter<Pointer>.Create(Container.GetEnumerator));
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Container.ToString]);
{$ENDIF}
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.GetEnumerator: T;
begin
  Result := FQuery;
end;

{$IFDEF DEBUG}
function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.GetOperationName: String;
begin
  Result := FQuery.OperationName;
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.GetOperationPath: String;
begin
  Result := FQuery.OperationPath;
end;
{$ENDIF}

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.IsAssigned: T;
var
  LIsAssigned : TPredicate<Pointer>;
begin
  LIsAssigned := function (Value : Pointer): boolean
                 begin
                   Result := Assigned(Value);
                 end;

  Result := TPointerQueryEnumerator.Create(TWhereEnumerationStrategy<Pointer>.Create(LIsAssigned),
                                          IBaseQueryEnumerator<Pointer>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'IsAssigned';
{$ENDIF}
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.Predicate: TPredicate<Pointer>;
begin
  Result := TPredicateFactory<Pointer>.QuerySingleValue(FQuery);
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.Skip(Count: Integer): T;
begin
  Result := TPointerQueryEnumerator.Create(TSkipWhileEnumerationStrategy<Pointer>.Create(TPredicateFactory<Pointer>.LessThanOrEqualTo(Count)),
                                           IBaseQueryEnumerator<Pointer>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [Count]);
{$ENDIF}
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.SkipWhile(
  UnboundQuery: IUnboundPointerQueryEnumerator): T;
begin
  Result := SkipWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.SkipWhile(
  Predicate: TPredicate<Pointer>): T;
begin
  Result := TPointerQueryEnumerator.Create(TSkipWhileEnumerationStrategy<Pointer>.Create(Predicate),
                                           IBaseQueryEnumerator<Pointer>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipWhile(Predicate)';
{$ENDIF}
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.Take(Count: Integer): T;
begin
  Result := TPointerQueryEnumerator.Create(TTakeWhileEnumerationStrategy<Pointer>.Create(TPredicateFactory<Pointer>.LessThanOrEqualTo(Count)),
                                           IBaseQueryEnumerator<Pointer>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := Format('Take(%d)', [Count]);
{$ENDIF}
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.TakeWhile(
  UnboundQuery: IUnboundPointerQueryEnumerator): T;
begin
  Result := TakeWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.TakeWhile(
  Predicate: TPredicate<Pointer>): T;
begin
  Result := TPointerQueryEnumerator.Create(TTakeWhileEnumerationStrategy<Pointer>.Create(Predicate),
                                           IBaseQueryEnumerator<Pointer>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeWhile(Predicate)';
{$ENDIF}
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.Where(
  Predicate: TPredicate<Pointer>): T;
begin
  Result := TPointerQueryEnumerator.Create(TWhereEnumerationStrategy<Pointer>.Create(Predicate),
                                          IBaseQueryEnumerator<Pointer>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Where(Predicate)';
{$ENDIF}
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.WhereNot(
  UnboundQuery: IUnboundPointerQueryEnumerator): T;
begin
  Result := WhereNot(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('WhereNot(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.WhereNot(
  Predicate: TPredicate<Pointer>): T;
begin
  Result := TPointerQueryEnumerator.Create(TWhereNotEnumerationStrategy<Pointer>.Create(Predicate),
                                          IBaseQueryEnumerator<Pointer>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'WhereNot(Predicate)';
{$ENDIF}
end;

{ TPointerQueryEnumerator }

constructor TPointerQueryEnumerator.Create(
  EnumerationStrategy: TEnumerationStrategy<Pointer>;
  UpstreamQuery: IBaseQueryEnumerator<Pointer>;
  SourceData: IMinimalEnumerator<Pointer>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundPointerQueryEnumerator := TPointerQueryEnumeratorImpl<IBoundPointerQueryEnumerator>.Create(self);
  FUnboundPointerQueryEnumerator := TPointerQueryEnumeratorImpl<IUnboundPointerQueryEnumerator>.Create(self);
end;

destructor TPointerQueryEnumerator.Destroy;
begin
  FBoundPointerQueryEnumerator.Free;
  FUnboundPointerQueryEnumerator.Free;
  inherited;
end;

end.
