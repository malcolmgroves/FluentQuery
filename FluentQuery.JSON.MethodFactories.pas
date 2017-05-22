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
    class function IsNamed(const Name : string): TPredicate<TJSONPair>;
    class function ValueIs<T : class> : TPredicate<TJSonPair>;
  end;


implementation

{ TJSONPairMethodFactory }

class function TJSONPairMethodFactory.IsNamed(
  const Name: string): TPredicate<TJSONPair>;
begin
  Result := function (Pair : TJsonPair) : Boolean
            begin
              Result := CompareText(Pair.JsonString.Value, Name) = 0;
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

end.
