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

unit FluentQuery.GenericObjects.MethodFactories;

interface
uses
  FluentQuery.Core.MethodFactories, System.SysUtils, System.TypInfo, System.Rtti,
  FluentQuery.Integers;

type
  TGenericObjectMethodFactory<T : class> = class(TMethodFactory<T>)
  public
    // predicates
    class function IsA(AClass : TClass): TPredicate<T>;
    class function IsAssigned: TPredicate<T>;
    class function PropertyNamedOfType(const Name: string; PropertyType: TTypeKind): TPredicate<T>;
    class function IntegerPropertyNamedWithValue(const Name: string; Predicate: TPredicate<Integer>): TPredicate<T>;
    class function StringPropertyNamedWithValue(const Name: string; Predicate : TPredicate<string>): TPredicate<T>;
    class function BooleanPropertyNamedWithValue(const Name: string; const Value: Boolean): TPredicate<T>;
  end;


implementation


{ TGenericObjectPredicateFactory<T> }

class function TGenericObjectMethodFactory<T>.BooleanPropertyNamedWithValue(
  const Name: string; const Value: Boolean): TPredicate<T>;
begin
  Result := function (ComponentValue : T) : boolean
            var
              LRTTIContext : TRTTIContext;
              LClassType : TRTTIType;
              LProperty : TRTTIProperty;
            begin
              Result := False;
              LRTTIContext := TRttiContext.Create;
              LClassType := LRTTIContext.GetType(ComponentValue.ClassInfo);
              LProperty := LClassType.GetProperty(Name);
              if Assigned(LProperty) then
                if LProperty.PropertyType is TRttiEnumerationType then
                  if TRttiEnumerationType(LProperty.PropertyType).UnderlyingType.Handle = System.TypeInfo(Boolean) then
                    Result := LProperty.GetValue(TObject(ComponentValue)).AsBoolean = Value;
            end;
end;


class function TGenericObjectMethodFactory<T>.IntegerPropertyNamedWithValue(
  const Name: string; Predicate: TPredicate<Integer>): TPredicate<T>;
begin
  Result := function (ComponentValue : T) : boolean
            var
              LRTTIContext : TRTTIContext;
              LClassType : TRTTIType;
              LProperty : TRTTIProperty;
            begin
              Result := False;
              LRTTIContext := TRttiContext.Create;
              LClassType := LRTTIContext.GetType(ComponentValue.ClassInfo);
              LProperty := LClassType.GetProperty(Name);
              if Assigned(LProperty) then
                if LProperty.PropertyType.TypeKind = tkInteger then
                begin
                  Result := Predicate(LProperty.GetValue(TObject(ComponentValue)).AsOrdinal);
                end;
            end;
end;

class function TGenericObjectMethodFactory<T>.IsA(
  AClass: TClass): TPredicate<T>;
begin
  Result := function (Value : T): boolean
            begin
              Result := Value is AClass;
            end;
end;

class function TGenericObjectMethodFactory<T>.IsAssigned: TPredicate<T>;
begin
  Result := function (Value : T): boolean
            begin
              Result := Assigned(Value);
            end;
end;

class function TGenericObjectMethodFactory<T>.PropertyNamedOfType(
  const Name: string; PropertyType: TTypeKind): TPredicate<T>;
begin
  Result :=  function (Value : T) : boolean
             var
               LRTTIContext : TRTTIContext;
               LClassType : TRTTIType;
               LProperty : TRTTIProperty;
             begin
               Result := False;
               LRTTIContext := TRttiContext.Create;
               LClassType := LRTTIContext.GetType(Value.ClassInfo);
               LProperty := LClassType.GetProperty(Name);
               if Assigned(LProperty) then
                 Result := LProperty.PropertyType.TypeKind = PropertyType;
             end;
end;

class function TGenericObjectMethodFactory<T>.StringPropertyNamedWithValue(
  const Name : string; Predicate : TPredicate<string>): TPredicate<T>;
begin
  Result := function (ComponentValue : T) : boolean
            var
              LRTTIContext : TRTTIContext;
              LClassType : TRTTIType;
              LProperty : TRTTIProperty;
              LPropValue : string;
            begin
              Result := False;
              LRTTIContext := TRttiContext.Create;
              LClassType := LRTTIContext.GetType(ComponentValue.ClassInfo);
              LProperty := LClassType.GetProperty(Name);
              if Assigned(LProperty) then
                if LProperty.PropertyType.TypeKind = tkUString then
                begin
                    LPropValue := LProperty.GetValue(TObject(ComponentValue)).AsString;
                    Result := Predicate(LPropValue);
                end;
            end;
end;

end.
