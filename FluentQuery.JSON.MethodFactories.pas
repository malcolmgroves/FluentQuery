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
unit FluentQuery.JSON.MethodFactories;

interface
uses
  FluentQuery.Core.MethodFactories, System.SysUtils, System.JSON;

type
  TJSONPairMethodFactory = class(TMethodFactory<TJSONPair>)
  public
    // predicates
    class function NameMatchesPredicate(Predicate : TPredicate<string>) : TPredicate<TJSONPair>;
    class function IsNamed(const Name : string): TPredicate<TJSONPair>;
    class function ValueIs<T : class> : TPredicate<TJSonPair>;
  end;

  TJSONValueMethodFactory = class(TMethodFactory<TJSONValue>)
  public
    // predicates
    class function ValueIs<T : class> : TPredicate<TJSonValue>;
  end;

implementation
uses
  FluentQuery.Strings.MethodFactories;

{ TJSONPairMethodFactory }

class function TJSONPairMethodFactory.IsNamed(
  const Name: string): TPredicate<TJSONPair>;
begin
  Result := NameMatchesPredicate(TStringMethodFactory.Matches(Name, True));
end;

class function TJSONPairMethodFactory.NameMatchesPredicate(
  Predicate: TPredicate<string>): TPredicate<TJSONPair>;
begin
  Result := function (Pair : TJsonPair) : Boolean
            begin
              Result := Predicate(Pair.JsonString.Value);
            end;
end;

class function TJSONPairMethodFactory.ValueIs<T>: TPredicate<TJSonPair>;
begin
  Result := function (Pair : TJsonPair) : Boolean
            var
              LValue : T;
            begin
              Result := Pair.JsonValue.ClassType = T;
            end;
end;

{ TJSONValueMethodFactory }

class function TJSONValueMethodFactory.ValueIs<T>: TPredicate<TJSonValue>;
begin
  Result := function (Value : TJsonValue) : Boolean
            begin
              Result := Value.ClassType = T;
            end;
end;

end.
