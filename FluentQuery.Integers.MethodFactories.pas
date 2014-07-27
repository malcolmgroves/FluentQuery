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

unit FluentQuery.Integers.MethodFactories;

interface

uses
  FluentQuery.Core.MethodFactories, System.SysUtils;

type
  TIntegerMethodFactory = class(TMethodFactory<Integer>)
  public
    // predicates
    class function GreaterThanOrEquals(Amount : Integer): TPredicate<Integer>;
    class function LessThanOrEquals(Amount : Integer): TPredicate<Integer>;
    class function Equals(Amount : Integer): TPredicate<Integer>; reintroduce;
    class function Even: TPredicate<Integer>;
  end;

implementation

{ TIntegerMethodFactory }

class function TIntegerMethodFactory.Equals(
  Amount: Integer): TPredicate<Integer>;
begin
  Result := function (Value : Integer) : Boolean
            begin
              Result := Value = Amount;
            end;
end;

class function TIntegerMethodFactory.Even: TPredicate<Integer>;
begin
  Result := function (Value : Integer) : Boolean
            begin
              Result := Value mod 2 = 0;
            end;
end;

class function TIntegerMethodFactory.GreaterThanOrEquals(
  Amount: Integer): TPredicate<Integer>;
begin
  Result := function (Value : Integer) : Boolean
            begin
              Result := Value >= Amount;
            end;
end;

class function TIntegerMethodFactory.LessThanOrEquals(
  Amount: Integer): TPredicate<Integer>;
begin
  Result := function (Value : Integer) : Boolean
            begin
              Result := Value <= Amount;
            end;
end;

end.
