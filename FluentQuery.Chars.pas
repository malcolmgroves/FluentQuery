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

unit FluentQuery.Chars;

interface
uses
  FluentQuery.Core.Types,
  System.SysUtils,
  FluentQuery.Core.EnumerationStrategies,
  FluentQuery.Core.Enumerators,
  System.Generics.Collections;

type
  IUnboundCharQueryEnumerator = interface;
  IBoundCharQueryEnumerator = interface(IBaseQueryEnumerator<Char>)
    function GetEnumerator: IBoundCharQueryEnumerator;
    // Query Operations
    function Equals(const Value : Char) : IBoundCharQueryEnumerator;
    function IsControl: IBoundCharQueryEnumerator;
    function IsDigit: IBoundCharQueryEnumerator;
    function IsHighSurrogate: IBoundCharQueryEnumerator;
    function IsInArray(const SomeChars: array of Char): IBoundCharQueryEnumerator;
    function IsLetter: IBoundCharQueryEnumerator;
    function IsLetterOrDigit: IBoundCharQueryEnumerator;
    function IsLower: IBoundCharQueryEnumerator;
    function IsLowSurrogate: IBoundCharQueryEnumerator;
    function IsNumber: IBoundCharQueryEnumerator;
    function IsPunctuation: IBoundCharQueryEnumerator;
    function IsSeparator: IBoundCharQueryEnumerator;
    function IsSurrogate: IBoundCharQueryEnumerator;
    function IsSymbol: IBoundCharQueryEnumerator;
    function IsUpper: IBoundCharQueryEnumerator;
    function IsWhiteSpace: IBoundCharQueryEnumerator;
    function Map(Transformer : TFunc<Char, Char>) : IBoundCharQueryEnumerator;
    function Matches(const Value : Char; IgnoreCase : Boolean = True) : IBoundCharQueryEnumerator;
    function NotEquals(const Value : Char) : IBoundCharQueryEnumerator;
    function Skip(Count : Integer): IBoundCharQueryEnumerator;
    function SkipWhile(Predicate : TPredicate<Char>) : IBoundCharQueryEnumerator; overload;
    function SkipWhile(UnboundQuery : IUnboundCharQueryEnumerator) : IBoundCharQueryEnumerator; overload;
    function Take(Count : Integer): IBoundCharQueryEnumerator;
    function TakeWhile(Predicate : TPredicate<Char>): IBoundCharQueryEnumerator; overload;
    function TakeWhile(UnboundQuery : IUnboundCharQueryEnumerator): IBoundCharQueryEnumerator; overload;
    function Where(Predicate : TPredicate<Char>) : IBoundCharQueryEnumerator;
    function WhereNot(UnboundQuery : IUnboundCharQueryEnumerator) : IBoundCharQueryEnumerator; overload;
    function WhereNot(Predicate : TPredicate<Char>) : IBoundCharQueryEnumerator; overload;
    // terminating operations
    function First : Char;
    function ToAString : String;
  end;

  IUnboundCharQueryEnumerator = interface(IBaseQueryEnumerator<Char>)
    function GetEnumerator: IUnboundCharQueryEnumerator;
    function From(StringValue : String) : IBoundCharQueryEnumerator; overload;
    function From(Container : TEnumerable<Char>) : IBoundCharQueryEnumerator; overload;
    // Query Operations
    function Equals(const Value : Char) : IUnboundCharQueryEnumerator;
    function IsControl: IUnboundCharQueryEnumerator;
    function IsDigit: IUnboundCharQueryEnumerator;
    function IsHighSurrogate: IUnboundCharQueryEnumerator;
    function IsInArray(const SomeChars: array of Char): IUnboundCharQueryEnumerator;
    function IsLetter: IUnboundCharQueryEnumerator;
    function IsLetterOrDigit: IUnboundCharQueryEnumerator;
    function IsLower: IUnboundCharQueryEnumerator;
    function IsLowSurrogate: IUnboundCharQueryEnumerator;
    function IsNumber: IUnboundCharQueryEnumerator;
    function IsPunctuation: IUnboundCharQueryEnumerator;
    function IsSeparator: IUnboundCharQueryEnumerator;
    function IsSurrogate: IUnboundCharQueryEnumerator;
    function IsSymbol: IUnboundCharQueryEnumerator;
    function IsUpper: IUnboundCharQueryEnumerator;
    function IsWhiteSpace: IUnboundCharQueryEnumerator;
    function Map(Transformer : TFunc<Char, Char>) : IUnboundCharQueryEnumerator;
    function Matches(const Value : Char; IgnoreCase : Boolean = True) : IUnboundCharQueryEnumerator;
    function NotEquals(const Value : Char) : IUnboundCharQueryEnumerator;
    function Skip(Count : Integer): IUnboundCharQueryEnumerator;
    function SkipWhile(Predicate : TPredicate<Char>) : IUnboundCharQueryEnumerator; overload;
    function SkipWhile(UnboundQuery : IUnboundCharQueryEnumerator) : IUnboundCharQueryEnumerator; overload;
    function Take(Count : Integer): IUnboundCharQueryEnumerator;
    function TakeWhile(Predicate : TPredicate<Char>): IUnboundCharQueryEnumerator; overload;
    function TakeWhile(UnboundQuery : IUnboundCharQueryEnumerator): IUnboundCharQueryEnumerator; overload;
    function Where(Predicate : TPredicate<Char>) : IUnboundCharQueryEnumerator;
    function WhereNot(UnboundQuery : IUnboundCharQueryEnumerator) : IUnboundCharQueryEnumerator; overload;
    function WhereNot(Predicate : TPredicate<Char>) : IUnboundCharQueryEnumerator; overload;
    // terminating operations
    function Predicate : TPredicate<Char>;
  end;

  function Query : IUnboundCharQueryEnumerator;
  function CharQuery : IUnboundCharQueryEnumerator;




implementation
uses
  System.Character;

type
  TCharQueryEnumerator = class(TBaseQueryEnumerator<Char>,
                               IBoundCharQueryEnumerator,
                               IUnboundCharQueryEnumerator)
  protected
    type
      TCharQueryEnumeratorImpl<T : IBaseQueryEnumerator<Char>> = class
      private
        FQuery : TCharQueryEnumerator;
      public
        constructor Create(Query : TCharQueryEnumerator); virtual;
        function GetEnumerator: T;
{$IFDEF DEBUG}
        function GetOperationName : String;
        function GetOperationPath : String;
        property OperationName : string read GetOperationName;
        property OperationPath : string read GetOperationPath;
{$ENDIF}
        function From(StringValue : String) : IBoundCharQueryEnumerator; overload;
        function From(Collection : TEnumerable<Char>) : IBoundCharQueryEnumerator; overload;
        // Primitive Operations
        function Map(Transformer : TFunc<Char, Char>) : T;
        function SkipWhile(Predicate : TPredicate<Char>) : T; overload;
        function TakeWhile(Predicate : TPredicate<Char>): T; overload;
        function Where(Predicate : TPredicate<Char>) : T;
        // Derivative Operations
        function Equals(const Value : Char) : T; reintroduce;
        function NotEquals(const Value : Char) : T;
        function Skip(Count : Integer): T;
        function SkipWhile(UnboundQuery : IUnboundCharQueryEnumerator) : T; overload;
        function Take(Count : Integer): T;
        function TakeWhile(UnboundQuery : IUnboundCharQueryEnumerator): T; overload;
        function WhereNot(UnboundQuery : IUnboundCharQueryEnumerator) : T; overload;
        function WhereNot(Predicate : TPredicate<Char>) : T; overload;
        function Matches(const Value : Char; IgnoreCase : Boolean = True) : T;
        function IsControl: T;
        function IsDigit: T;
        function IsHighSurrogate: T;
        function IsInArray(const SomeChars: array of Char): T;
        function IsLetter: T;
        function IsLetterOrDigit: T;
        function IsLower: T;
        function IsLowSurrogate: T;
        function IsNumber: T;
        function IsPunctuation: T;
        function IsSeparator: T;
        function IsSurrogate: T;
        function IsSymbol: T;
        function IsUpper: T;
        function IsWhiteSpace: T;
        // Terminating Operations
        function Predicate : TPredicate<Char>;
        function ToAString : String;
        function First : Char;
      end;
  protected
    FBoundCharQueryEnumerator : TCharQueryEnumeratorImpl<IBoundCharQueryEnumerator>;
    FUnboundCharQueryEnumerator : TCharQueryEnumeratorImpl<IUnboundCharQueryEnumerator>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<Char>;
                       UpstreamQuery : IBaseQueryEnumerator<Char> = nil;
                       SourceData : IMinimalEnumerator<Char> = nil); override;
    destructor Destroy; override;
    property BoundCharQueryEnumerator : TCharQueryEnumeratorImpl<IBoundCharQueryEnumerator>
                                       read FBoundCharQueryEnumerator implements IBoundCharQueryEnumerator;
    property UnboundCharQueryEnumerator : TCharQueryEnumeratorImpl<IUnboundCharQueryEnumerator>
                                       read FUnboundCharQueryEnumerator implements IUnboundCharQueryEnumerator;

  end;


function CharQuery : IUnboundCharQueryEnumerator;
begin
  Result := Query;
{$IFDEF DEBUG}
  Result.OperationName := 'CharQuery';
{$ENDIF}
end;

function Query : IUnboundCharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TEnumerationStrategy<Char>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'Query';
{$ENDIF}
end;

{ TCharQueryEnumerator }

constructor TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.Create(
  Query: TCharQueryEnumerator);
begin
  FQuery := Query;
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.Equals(
  const Value: Char): T;
begin
  Result := Matches(Value, False);
{$IFDEF DEBUG}
  Result.OperationName := 'Equals';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.First: Char;
begin
  if FQuery.MoveNext then
    Result := FQuery.GetCurrent
  else
    raise EEmptyResultSetException.Create('Can''t call First on an empty Result Set');
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.From(
  Collection: TEnumerable<Char>): IBoundCharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TEnumerationStrategy<Char>.Create,
                                        IBaseQueryEnumerator<Char>(FQuery),
                                        TGenericEnumeratorAdapter<Char>.Create(Collection.GetEnumerator) as IMinimalEnumerator<Char>);
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Collection.ToString]);
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.From(
  StringValue: String): IBoundCharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TEnumerationStrategy<Char>.Create,
                                        IBaseQueryEnumerator<Char>(FQuery),
                                        TStringEnumeratorAdapter.Create(StringValue));
{$IFDEF DEBUG}
  Result.OperationName := Format('From(''%s'')', [StringValue]);
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.GetEnumerator: T;
begin
  Result := FQuery;
end;

{$IFDEF DEBUG}
function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.GetOperationName: String;
begin
  Result := FQuery.OperationName;
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.GetOperationPath: String;
begin
  Result := FQuery.OperationPath;
end;
{$ENDIF}

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsControl: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsControl;
                       end;

  Result := Where(LMatchesPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsControl';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsDigit: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsDigit;
                       end;

  Result := Where(LMatchesPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsDigit';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsHighSurrogate: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsHighSurrogate;
                       end;

  Result := Where(LMatchesPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsHighSurrogate';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsInArray(const SomeChars: array of Char): T;
var
  LMatchesPredicate : TPredicate<Char>;
  LSomeChars : array of Char;
  I : Integer;
begin
  // was getting an "unable to capture symbol" error when capturing SomeChars directly.
  SetLength(LSomeChars, Length(SomeChars));
  for I := Low(SomeChars) to High(SomeChars) do
    LSomeChars[i] := SomeChars[i];

  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsInArray(LSomeChars);
                       end;

  Result := Where(LMatchesPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsInArray(SomeChars)';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsLetter: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsLetter;
                       end;

  Result := Where(LMatchesPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsLetter';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsLetterOrDigit: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsLetterOrDigit;
                       end;

  Result := Where(LMatchesPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsLetterOrDigit';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsLower: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsLower;
                       end;

  Result := Where(LMatchesPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsLower';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsLowSurrogate: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsLowSurrogate;
                       end;

  Result := Where(LMatchesPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsLowSurrogate';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsNumber: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsNumber;
                       end;

  Result := Where(LMatchesPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsNumber';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsPunctuation: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsPunctuation;
                       end;

  Result := Where(LMatchesPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsPunctuation';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsSeparator: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsSeparator;
                       end;

  Result := Where(LMatchesPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsSeperator';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsSurrogate: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsSurrogate;
                       end;

  Result := Where(LMatchesPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsSurrogate';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsSymbol: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsSymbol;
                       end;

  Result := Where(LMatchesPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsSymbol';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsUpper: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsUpper;
                       end;

  Result := Where(LMatchesPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsUpper';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsWhiteSpace: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsWhiteSpace;
                       end;

  Result := Where(LMatchesPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsWhitespace';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.Map(
  Transformer: TFunc<Char, Char>): T;
begin
  Result := TCharQueryEnumerator.Create(TIsomorphicTransformEnumerationStrategy<Char>.Create(Transformer),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Map(Transformer)';
{$ENDIF}
end;


function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.Matches(const Value: Char;
  IgnoreCase: Boolean): T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                         if IgnoreCase then
                           Result := CurrentValue.ToUpper = Value.ToUpper
                         else
                           Result := CurrentValue = Value;
                       end;

  Result := Where(LMatchesPredicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('Matches(''%s'', %s', [Value, IgnoreCase.ToString]);
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.NotEquals(
  const Value: Char): T;
var
  LPredicate : TPredicate<Char>;
begin
  LPredicate := function (CurrentValue : Char) : Boolean
                begin
                  Result := CurrentValue <> Value;
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('NotEquals(''%s'')', [Value]);
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.Predicate: TPredicate<Char>;
begin
  Result := TPredicateFactory<Char>.QuerySingleValue(FQuery);
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.Skip(Count: Integer): T;
begin
  Result := SkipWhile(TPredicateFactory<Char>.LessThanOrEqualTo(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [Count]);
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.SkipWhile(
  UnboundQuery: IUnboundCharQueryEnumerator): T;
begin
  Result := SkipWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.SkipWhile(
  Predicate: TPredicate<Char>): T;
begin
  Result := TCharQueryEnumerator.Create(TSkipWhileEnumerationStrategy<Char>.Create(Predicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipWhile(Predicate)';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.Take(Count: Integer): T;
begin
  Result := TakeWhile(TPredicateFactory<Char>.LessThanOrEqualTo(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Take(%d)', [Count]);
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.TakeWhile(
  UnboundQuery: IUnboundCharQueryEnumerator): T;
begin
  Result := TakeWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.TakeWhile(
  Predicate: TPredicate<Char>): T;
begin
  Result := TCharQueryEnumerator.Create(TTakeWhileEnumerationStrategy<Char>.Create(Predicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeWhile(Predicate)';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.ToAString: String;
var
  LString : String;
begin
  LString := '';

  while FQuery.MoveNext do
    LString := LString + FQuery.GetCurrent;

  Result := LString;
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.Where(
  Predicate: TPredicate<Char>): T;
begin
  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(Predicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Where(Predicate)';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.WhereNot(
  Predicate: TPredicate<Char>): T;
begin
  Result := Where(TPredicateFactory<Char>.InvertPredicate(Predicate));
{$IFDEF DEBUG}
  Result.OperationName := 'WhereNot(Predicate)';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.WhereNot(
  UnboundQuery: IUnboundCharQueryEnumerator): T;
begin
  Result := WhereNot(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('WhereNot(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;



{ TCharQueryEnumerator }

constructor TCharQueryEnumerator.Create(
  EnumerationStrategy: TEnumerationStrategy<Char>;
  UpstreamQuery: IBaseQueryEnumerator<Char>;
  SourceData: IMinimalEnumerator<Char>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundCharQueryEnumerator := TCharQueryEnumeratorImpl<IBoundCharQueryEnumerator>.Create(self);
  FUnboundCharQueryEnumerator := TCharQueryEnumeratorImpl<IUnboundCharQueryEnumerator>.Create(self);
end;

destructor TCharQueryEnumerator.Destroy;
begin
  FBoundCharQueryEnumerator.Free;
  FUnboundCharQueryEnumerator.Free;
  inherited;
end;

end.
