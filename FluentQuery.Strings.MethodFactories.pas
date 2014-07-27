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

unit FluentQuery.Strings.MethodFactories;

interface
uses
  FluentQuery.Core.MethodFactories, System.SysUtils;

type
  TStringMethodFactory = class(TMethodFactory<String>)
  private
    class function CaseCorrect(IgnoreCase : Boolean; const Value : String ) : string; inline;
  public
    // predicates
    class function StartsWith(const Value : string; IgnoreCase : Boolean) : TPredicate<String>;
    class function EndsWith(const Value : string; IgnoreCase : Boolean) : TPredicate<String>;
    class function Contains(const Value : string; IgnoreCase : Boolean) : TPredicate<String>;
    class function Matches(const Value : string; IgnoreCase : Boolean) : TPredicate<String>;
    // transformers
    class function SubString(StartIndex, Length : Integer) : TFunc<String, String>;
    class function SubStringAfter(const AChar : Char; Length : Integer) : TFunc<String, String>;
  end;


implementation

{ TStringPredicateFactory }

class function TStringMethodFactory.CaseCorrect(IgnoreCase: Boolean;
  const Value: String): string;
begin
  if IgnoreCase then
    Result := UpperCase(Value)
  else
    Result := Value;
end;

class function TStringMethodFactory.Contains(const Value: string;
  IgnoreCase: Boolean): TPredicate<String>;
begin
  Result := function (CurrentValue : String) : Boolean
            begin
                Result := CaseCorrect(IgnoreCase,
                                      CurrentValue).Contains(CaseCorrect(IgnoreCase,
                                                                         Value));
            end;
end;

class function TStringMethodFactory.EndsWith(const Value: string;
  IgnoreCase: Boolean): TPredicate<String>;
begin
  Result := function (CurrentValue : String) : Boolean
            begin
                Result := CaseCorrect(IgnoreCase,
                                      CurrentValue).EndsWith(CaseCorrect(IgnoreCase,
                                                                         Value));
            end;
end;

class function TStringMethodFactory.Matches(const Value: string;
  IgnoreCase: Boolean): TPredicate<String>;
begin
  Result := function (CurrentValue : String) : Boolean
            begin
              Result := CurrentValue.Compare(CurrentValue, Value, IgnoreCase) = 0;
            end;
end;

class function TStringMethodFactory.StartsWith(
  const Value: string; IgnoreCase : Boolean): TPredicate<String>;
begin
  Result := function (CurrentValue : String) : Boolean
            begin
                Result := CaseCorrect(IgnoreCase,
                                      CurrentValue).StartsWith(CaseCorrect(IgnoreCase,
                                                                           Value));
            end;
end;


class function TStringMethodFactory.SubString(
   StartIndex, Length: Integer): TFunc<String, String>;
begin
  Result := function (Value : String) : String
            begin
              if Length < 0 then
                Result := Value.Substring(StartIndex)
              else
                Result := Value.Substring(StartIndex, Length);
            end;
end;

class function TStringMethodFactory.SubStringAfter(const AChar: Char;
  Length: Integer): TFunc<String, String>;
begin
  Result := function (Value : String) : String
            begin
              if Length < 0 then
                Result := Value.Substring(Pos(AChar, Value))
              else
                Result := Value.Substring(Pos(AChar, Value), Length);
            end;
end;

end.
