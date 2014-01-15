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

unit FluentQuery.Strings;

interface
uses
  FluentQuery.Core.Types,
  System.SysUtils,
  FluentQuery.Core.EnumerationStrategies,
  FluentQuery.Core.Enumerators,
  System.Generics.Collections,
  System.Classes;

type
  IUnboundStringQueryEnumerator = interface;

  IBoundStringQueryEnumerator = interface(IBaseQueryEnumerator<String>)
    function GetEnumerator: IBoundStringQueryEnumerator;
    // common operations
    function First : IBoundStringQueryEnumerator;
    function Skip(Count : Integer): IBoundStringQueryEnumerator;
    function SkipWhile(Predicate : TPredicate<String>) : IBoundStringQueryEnumerator; overload;
    function SkipWhile(UnboundQuery : IUnboundStringQueryEnumerator) : IBoundStringQueryEnumerator; overload;
    function Take(Count : Integer): IBoundStringQueryEnumerator;
    function TakeWhile(Predicate : TPredicate<String>): IBoundStringQueryEnumerator; overload;
    function TakeWhile(UnboundQuery : IUnboundStringQueryEnumerator): IBoundStringQueryEnumerator; overload;
    function Where(Predicate : TPredicate<String>) : IBoundStringQueryEnumerator;
    function WhereNot(UnboundQuery : IUnboundStringQueryEnumerator) : IBoundStringQueryEnumerator; overload;
    function WhereNot(Predicate : TPredicate<String>) : IBoundStringQueryEnumerator; overload;
    // type-specific operations
    function Equals(const Value : String) : IBoundStringQueryEnumerator;
    function NotEquals(const Value : String) : IBoundStringQueryEnumerator;
    function Matches(const Value : String; IgnoreCase : Boolean = True) : IBoundStringQueryEnumerator;
    function Contains(const Value : String; IgnoreCase : Boolean = True) : IBoundStringQueryEnumerator;
    function StartsWith(const Value : String; IgnoreCase : Boolean = True) : IBoundStringQueryEnumerator;
    function EndsWith(const Value : String; IgnoreCase : Boolean = True) : IBoundStringQueryEnumerator;
    // terminating operations
    function ToTStrings : TStrings;
  end;

  IUnboundStringQueryEnumerator = interface(IBaseQueryEnumerator<String>)
    function GetEnumerator: IUnboundStringQueryEnumerator;
    // common operations
    function From(Container : TEnumerable<String>) : IBoundStringQueryEnumerator; overload;
    function From(Strings : TStrings) : IBoundStringQueryEnumerator; overload;
    function First : IUnboundStringQueryEnumerator;
    function Skip(Count : Integer): IUnboundStringQueryEnumerator;
    function SkipWhile(Predicate : TPredicate<String>) : IUnboundStringQueryEnumerator; overload;
    function SkipWhile(UnboundQuery : IUnboundStringQueryEnumerator) : IUnboundStringQueryEnumerator; overload;
    function Take(Count : Integer): IUnboundStringQueryEnumerator;
    function TakeWhile(Predicate : TPredicate<String>): IUnboundStringQueryEnumerator; overload;
    function TakeWhile(UnboundQuery : IUnboundStringQueryEnumerator): IUnboundStringQueryEnumerator; overload;
    function Where(Predicate : TPredicate<String>) : IUnboundStringQueryEnumerator;
    function WhereNot(UnboundQuery : IUnboundStringQueryEnumerator) : IUnboundStringQueryEnumerator; overload;
    function WhereNot(Predicate : TPredicate<String>) : IUnboundStringQueryEnumerator; overload;
    // type-specific operations
    function Matches(const Value : String; IgnoreCase : Boolean = True) : IUnboundStringQueryEnumerator;
    function Equals(const Value : String) : IUnboundStringQueryEnumerator;
    function NotEquals(const Value : String) : IUnboundStringQueryEnumerator;
    function Contains(const Value : String; IgnoreCase : Boolean = True) : IUnboundStringQueryEnumerator;
    function StartsWith(const Value : String; IgnoreCase : Boolean = True) : IUnboundStringQueryEnumerator;
    function EndsWith(const Value : String; IgnoreCase : Boolean = True) : IUnboundStringQueryEnumerator;
    // terminating operations
    function Predicate : TPredicate<string>;
  end;

  function Query : IUnboundStringQueryEnumerator;
  function StringQuery : IUnboundStringQueryEnumerator;

implementation

type
  TStringQueryEnumerator = class(TBaseQueryEnumerator<String>,
                                 IBoundStringQueryEnumerator,
                                 IUnboundStringQueryEnumerator)
  protected
    type
      TStringQueryEnumeratorImpl<T : IBaseQueryEnumerator<String>> = class
      private
        FQuery : TStringQueryEnumerator;
      public
        constructor Create(Query : TStringQueryEnumerator); virtual;
        function GetEnumerator: T;
{$IFDEF DEBUG}
        function GetOperationName : String;
        function GetOperationPath : String;
        property OperationName : string read GetOperationName;
        property OperationPath : string read GetOperationPath;
{$ENDIF}
        function First : T;
        function From(Container : TEnumerable<String>) : IBoundStringQueryEnumerator; overload;
        function From(Strings : TStrings) : IBoundStringQueryEnumerator; overload;
        function Predicate : TPredicate<string>;
        function Skip(Count : Integer): T;
        function SkipWhile(Predicate : TPredicate<String>) : T; overload;
        function SkipWhile(UnboundQuery : IUnboundStringQueryEnumerator) : T; overload;
        function Take(Count : Integer): T;
        function TakeWhile(Predicate : TPredicate<String>): T; overload;
        function TakeWhile(UnboundQuery : IUnboundStringQueryEnumerator): T; overload;
        function Where(Predicate : TPredicate<String>) : T;
        function WhereNot(UnboundQuery : IUnboundStringQueryEnumerator) : T; overload;
        function WhereNot(Predicate : TPredicate<String>) : T; overload;
        function Equals(const Value : String) : T; reintroduce;
        function NotEquals(const Value : String) : T;
        function Matches(const Value : String; IgnoreCase : Boolean = True) : T;
        function Contains(const Value : String; IgnoreCase : Boolean = True) : T;
        function StartsWith(const Value : String; IgnoreCase : Boolean = True) : T;
        function EndsWith(const Value : String; IgnoreCase : Boolean = True) : T;
        function ToTStrings : TStrings;
      end;
  protected
    FBoundStringQueryEnumerator : TStringQueryEnumeratorImpl<IBoundStringQueryEnumerator>;
    FUnboundStringQueryEnumerator : TStringQueryEnumeratorImpl<IUnboundStringQueryEnumerator>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<String>;
                       UpstreamQuery : IBaseQueryEnumerator<String> = nil;
                       SourceData : IMinimalEnumerator<String> = nil
                       ); override;
    destructor Destroy; override;
    property BoundStringQueryEnumerator : TStringQueryEnumeratorImpl<IBoundStringQueryEnumerator>
                                       read FBoundStringQueryEnumerator implements IBoundStringQueryEnumerator;
    property UnboundStringQueryEnumerator : TStringQueryEnumeratorImpl<IUnboundStringQueryEnumerator>
                                       read FUnboundStringQueryEnumerator implements IUnboundStringQueryEnumerator;
  end;


function StringQuery : IUnboundStringQueryEnumerator;
begin
  Result := Query;
{$IFDEF DEBUG}
  Result.OperationName := 'StringQuery';
{$ENDIF}
end;

function Query : IUnboundStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TEnumerationStrategy<String>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'Query';
{$ENDIF}
end;

{ TStringQueryEnumerator }

constructor TStringQueryEnumerator.Create(
  EnumerationStrategy: TEnumerationStrategy<String>;
  UpstreamQuery: IBaseQueryEnumerator<String>;
  SourceData: IMinimalEnumerator<String>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundStringQueryEnumerator := TStringQueryEnumeratorImpl<IBoundStringQueryEnumerator>.Create(self);
  FUnboundStringQueryEnumerator := TStringQueryEnumeratorImpl<IUnboundStringQueryEnumerator>.Create(self);
end;


destructor TStringQueryEnumerator.Destroy;
begin
  FBoundStringQueryEnumerator.Free;
  FUnboundStringQueryEnumerator.Free;
  inherited;
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.Contains(
  const Value: String; IgnoreCase: Boolean): T;
var
  LContainsPredicate : TPredicate<String>;
begin
  LContainsPredicate := function (CurrentValue : String) : Boolean
                        begin
                          if IgnoreCase then
                          begin
                            Result := UpperCase(CurrentValue).Contains(UpperCase(Value));
                          end
                          else
                            Result := CurrentValue.Contains(Value);
                        end;

  Result := TStringQueryEnumerator.Create(TWhereEnumerationStrategy<String>.Create(LContainsPredicate),
                                          IBaseQueryEnumerator<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := Format('Contains(''%s'', %s', [Value, IgnoreCase.ToString]);
{$ENDIF}
end;

constructor TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.Create(Query: TStringQueryEnumerator);
begin
  FQuery := Query;
end;


function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.EndsWith(const Value: String; IgnoreCase: Boolean): T;
var
  LEndsWithPredicate : TPredicate<String>;
begin
  LEndsWithPredicate := function (CurrentValue : String) : Boolean
                        begin
                          if IgnoreCase then
                          begin
                            Result := UpperCase(CurrentValue).EndsWith(UpperCase(Value));
                          end
                          else
                            Result := CurrentValue.EndsWith(Value);
                        end;

  Result := TStringQueryEnumerator.Create(TWhereEnumerationStrategy<String>.Create(LEndsWithPredicate),
                                          IBaseQueryEnumerator<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := Format('EndsWith(''%s'', %s', [Value, IgnoreCase.ToString]);
{$ENDIF}
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.Equals(
  const Value: String): T;
begin
  Result := Matches(Value, False);
{$IFDEF DEBUG}
  Result.OperationName := 'Equals';
{$ENDIF}
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.First: T;
begin
  Result := TStringQueryEnumerator.Create(TTakeWhileEnumerationStrategy<String>.Create(TPredicateFactory<String>.LessThanOrEqualTo(1)),
                                          IBaseQueryEnumerator<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'First';
{$ENDIF}
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.From(Container: TEnumerable<String>): IBoundStringQueryEnumerator;
var
  EnumeratorAdapter : IMinimalEnumerator<String>;
begin
  EnumeratorAdapter := TGenericEnumeratorAdapter<String>.Create(Container.GetEnumerator) as IMinimalEnumerator<String>;
  Result := TStringQueryEnumerator.Create(TEnumerationStrategy<String>.Create,
                                          IBaseQueryEnumerator<String>(FQuery),
                                          EnumeratorAdapter);
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Container.ToString]);
{$ENDIF}
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.From(Strings: TStrings): IBoundStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TEnumerationStrategy<String>.Create,
                                          IBaseQueryEnumerator<String>(FQuery),
                                          TStringsEnumeratorAdapter.Create(Strings.GetEnumerator));
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Strings.ToString]);
{$ENDIF}
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.GetEnumerator: T;
begin
  Result := FQuery;
end;

{$IFDEF DEBUG}
function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.GetOperationName: String;
begin
  Result := FQuery.OperationName;
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.GetOperationPath: String;
begin
  Result := FQuery.OperationPath;
end;
{$ENDIF}

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.Matches(
  const Value: String; IgnoreCase: Boolean): T;
var
  LMatchesPredicate : TPredicate<String>;
begin
  LMatchesPredicate := function (CurrentValue : String) : Boolean
                       begin
                         Result := CurrentValue.Compare(CurrentValue, Value, IgnoreCase) = 0;
                       end;

  Result := TStringQueryEnumerator.Create(TWhereEnumerationStrategy<String>.Create(LMatchesPredicate),
                                          IBaseQueryEnumerator<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := Format('Matches(''%s'', %s', [Value, IgnoreCase.ToString]);
{$ENDIF}
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.NotEquals(
  const Value: String): T;
var
  LPredicate : TPredicate<String>;
begin
  LPredicate := function (CurrentValue : String) : Boolean
                       begin
                         Result := CurrentValue.CompareTo(Value) <> 0;
                       end;

  Result := TStringQueryEnumerator.Create(TWhereEnumerationStrategy<String>.Create(LPredicate),
                                          IBaseQueryEnumerator<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := Format('NotEquals(''%s'')', [Value]);
{$ENDIF}
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.Predicate: TPredicate<string>;
begin
  Result := TPredicateFactory<String>.QuerySingleValue(FQuery);
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.Skip(Count: Integer): T;
begin
  Result := TStringQueryEnumerator.Create(TSkipWhileEnumerationStrategy<String>.Create(TPredicateFactory<String>.LessThanOrEqualTo(Count)),
                                          IBaseQueryEnumerator<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [Count]);
{$ENDIF}
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.SkipWhile(
  UnboundQuery: IUnboundStringQueryEnumerator): T;
begin
  Result := SkipWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipWhile(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.SkipWhile(
  Predicate: TPredicate<String>): T;
begin
  Result := TStringQueryEnumerator.Create(TSkipWhileEnumerationStrategy<String>.Create(Predicate),
                                          IBaseQueryEnumerator<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipWhile(Predicate)';
{$ENDIF}
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.StartsWith(
  const Value: String; IgnoreCase: Boolean): T;
var
  LStartsWithPredicate : TPredicate<String>;
begin
  LStartsWithPredicate := function (CurrentValue : String) : Boolean
                          begin
                            if IgnoreCase then
                            begin
                              Result := UpperCase(CurrentValue).StartsWith(UpperCase(Value));
                            end
                            else
                              Result := CurrentValue.StartsWith(Value);
                          end;

  Result := TStringQueryEnumerator.Create(TWhereEnumerationStrategy<String>.Create(LStartsWithPredicate),
                                          IBaseQueryEnumerator<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := Format('StartsWith(''%s'', %s', [Value, IgnoreCase.ToString]);
{$ENDIF}
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.Take(Count: Integer): T;
begin
  Result := TStringQueryEnumerator.Create(TTakeWhileEnumerationStrategy<String>.Create(TPredicateFactory<String>.LessThanOrEqualTo(Count)),
                                          IBaseQueryEnumerator<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := Format('Take(%d)', [Count]);
{$ENDIF}
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.TakeWhile(
  UnboundQuery: IUnboundStringQueryEnumerator): T;
begin
  Result := TakeWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeWhile(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.TakeWhile(Predicate: TPredicate<String>): T;
begin
  Result := TStringQueryEnumerator.Create(TTakeWhileEnumerationStrategy<String>.Create(Predicate),
                                          IBaseQueryEnumerator<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeWhile(Predicate)';
{$ENDIF}
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.ToTStrings: TStrings;
var
  LStrings : TStrings;
begin
  LStrings := TStringList.Create;

  while FQuery.MoveNext do
    LStrings.Add(FQuery.GetCurrent);

  Result := LStrings;
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.Where(
  Predicate: TPredicate<String>): T;
begin
  Result := TStringQueryEnumerator.Create(TWhereEnumerationStrategy<String>.Create(Predicate),
                                          IBaseQueryEnumerator<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Where(Predicate)';
{$ENDIF}
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.WhereNot(
  UnboundQuery: IUnboundStringQueryEnumerator): T;
begin
  Result := WhereNot(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('WhereNot(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.WhereNot(
  Predicate: TPredicate<String>): T;
begin
  Result := TStringQueryEnumerator.Create(TWhereNotEnumerationStrategy<String>.Create(Predicate),
                                          IBaseQueryEnumerator<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'WhereNot(Predicate)';
{$ENDIF}
end;

end.
