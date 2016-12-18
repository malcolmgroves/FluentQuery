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

unit FluentQuery.GenericObjects.Tests;

interface

uses
  TestFramework,
  System.Generics.Collections,
  FluentQuery.GenericObjects,
  System.SysUtils;

type
  TPerson = class
  private
    FName : string;
  public
    Age : Integer;
    constructor Create(Name : string; Age : Integer);
    property Name : string read FName write FName;
  end;

  TCustomer = class(TPerson)
  private
    FOverdue: Boolean;
  public
    property Overdue : Boolean read FOverdue;
  end;

  TSpecialCustomer = class(TCustomer)

  end;

  TestTQueryPerson = class(TTestCase)
  strict private
    FPersonCollection: TObjectList<TPerson>;
    FAgedSixOrMore : TPredicate<TPerson>;
    FIncrementAge : TProc<TPerson>;
  public
    procedure SetUp; override;
    procedure TearDown; override;
    constructor Create(MethodName: string; RunCount: Int64); override;
  published
    procedure TestPassThrough;
    procedure TestToObjectList;
    procedure TestMapBefore;
    procedure TestMapAfter;
    procedure TestIsAssigned;
    procedure TestIsA;
    procedure TestHasProperty;
    procedure TestSelectSubTypeFrom;
  end;

var
  DummyInt : Integer; // used to suppress warnings about not using loop variables in tests

implementation
uses
  System.TypInfo;


{ TPerson }

constructor TPerson.Create(Name: string; Age: Integer);
begin
  self.Name := Name;
  self.Age := Age;
end;

{ TestTQueryPerson }

constructor TestTQueryPerson.Create(MethodName: string; RunCount: Int64);
begin
  inherited;
  FAgedSixOrMore := function (Value : TPerson) : Boolean
                    begin
                      Result := Value.Age >= 6;
                    end;

  FIncrementAge := procedure (Value : TPerson)
                   begin
                     Value.Age := Value.Age + 1;
                   end;

end;


procedure TestTQueryPerson.SetUp;
begin
  inherited;
  FPersonCollection := TObjectList<TPerson>.Create;
  FPersonCollection.Add(TPerson.Create('Malcolm', 43));
  FPersonCollection.Add(TPerson.Create('Julie', 41));
  FPersonCollection.Add(TPerson.Create('Jesse', 5));
  FPersonCollection.Add(TPerson.Create('Lauren', 3));
end;

procedure TestTQueryPerson.TearDown;
begin
  inherited;
  FPersonCollection.Free;
end;

procedure TestTQueryPerson.TestToObjectList;
var
  LPersonList : TObjectList<TPerson>;
begin
  LPersonList := ObjectQuery<TPerson>.Select
                      .From(FPersonCollection)
                      .Where(FAgedSixOrMore)
                      .AsTObjectList(False);
  try
    CheckEquals(2, LPersonList.Count);
    CheckEquals('Malcolm', LPersonList.Items[0].Name);
    CheckEquals('Julie', LPersonList.Items[1].Name);
  finally
    LPersonList.Free;
  end;
end;

procedure TestTQueryPerson.TestIsAssigned;
begin
  FPersonCollection.Insert(1, nil);
  FPersonCollection.Insert(3, nil);
  Check(ObjectQuery<TPerson>.Select
                    .From(FPersonCollection)
                    .IsAssigned
                    .Count = 4, 'IsAssigned Query should enumerate four items');
end;

procedure TestTQueryPerson.TestHasProperty;
begin
  FPersonCollection.Insert(2, TCustomer.Create('Acme', 3));
  FPersonCollection.Insert(3, TCustomer.Create('Spacely''s Sprockets', 0));

  CheckEquals(2,
              ObjectQuery<TPerson>.Select
                    .From(FPersonCollection)
                    .HasProperty('Overdue', tkEnumeration)
                    .Count);
end;

procedure TestTQueryPerson.TestIsA;
begin
  FPersonCollection.Insert(2, TCustomer.Create('Acme', 3));
  FPersonCollection.Insert(3, TCustomer.Create('Spacely''s Sprockets', 0));
  FPersonCollection.Insert(3, TSpecialCustomer.Create('Foo', 0));

  CheckEquals(3, ObjectQuery<TPerson>.Select
                    .From(FPersonCollection)
                    .IsA(TCustomer)
                    .Count );
end;

procedure TestTQueryPerson.TestMapAfter;
begin
  CheckEquals(2, ObjectQuery<TPerson>.Select
                      .From(FPersonCollection)
                      .Where(FAgedSixOrMore)
                      .Map(FIncrementAge)
                      .Count);
end;

procedure TestTQueryPerson.TestMapBefore;
begin
  CheckEquals(3, ObjectQuery<TPerson>.Select
                      .From(FPersonCollection)
                      .Map(FIncrementAge)
                      .Where(FAgedSixOrMore)
                      .Count);
end;


procedure TestTQueryPerson.TestPassThrough;
begin
  CheckEquals(FPersonCollection.Count, ObjectQuery<TPerson>.Select.From(FPersonCollection).Count);
end;



procedure TestTQueryPerson.TestSelectSubTypeFrom;
begin
  FPersonCollection.Insert(2, TCustomer.Create('Acme', 3));
  FPersonCollection.Insert(3, TCustomer.Create('Spacely''s Sprockets', 0));

  CheckEquals(2, ObjectQuery<TCustomer>.From<TPerson>(FPersonCollection).Count);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest('Generics/TObjectList<TPerson>', TestTQueryPerson.Suite);
end.

