What is FluidQuery?
========================
FluidQuery allows you to query containers of items in Delphi in a fluid, declarative fashion. 


Huh?
----

OK, I agree, that was not very helpful. 

Let's say you have a TObjectList&lt;TPerson>, and you want to retrieve the first 2 TPerson objects that have an Age > 18. 

The standard solution in Delphi would be something like this:

    var
      LOver18Count : Integer;
      LPerson : TPerson;
    begin
      LOver18Count := 0;

      for LPerson in FPersonCollection do
      begin
        if LPerson.Age > 18 then
        begin
          Inc(LOver18Count);
     
          // do something here with your adult LPerson
     
          if LOver18Count = 2 then
            break;
        end;
      end;
    end;

There's nothing incorrect about that code, but I find it messy because the code that selects the objects you want to act on, and the code that acts on them, are all mixed in together.

FluidQuery lets you represent the same thing like this:

    var
      LPerson : TPerson;
      LOver18 : TPredicate<TPerson>;
    begin
      LOver18 := function (Person : TPerson) : boolean
                 begin
                   Result := Person.Age > 18;
                 end;

      for LPerson in Query<TPerson>.From(FPersonCollection).Where(LOver18).Take(2) do
      begin
          // do something here with your adult LPerson
      end;
    end;
 
It's about the same length of code, but it is, in my mind, much clearer. The statement of what objects we're going to act on (in the for..in statement) reads fairly naturally, and the code that acts on the objects is self contained. 

Further, over time you tend to build up a set of reusable Predicates appropriate to your objects and so for example, the LOver18 definition does not need to be declared locally. 

You can of course include the same operation multiple times in your query, eg Where(Over18).Where(VisitedRecently).Where(HasPurchased)

Containers Supported
---------------------
FluidQuery currently supports querying over the following types of containers:

- Anything with a TEnumerator&lt;T>, such as TList&lt;T>, TObjectList&lt;T>, etc 
- TStrings

Query Operations Supported
--------------------------
FluidQuery currently supports the following operations across all collection types:

Operation | Description 
:-------- | :---------- 
First     | Enumerate the first item, ignoring the remainder. 
Skip      | Skip will bypass the specified number of items from the start of the enumeration, after which it will enumerate the remaining items as normal.
SkipWhile | SkipWhile will bypass items at the start of the enumeration while the supplied Predicate evaluates True. Once the Predicate evaluates false, all remaining items will be enumerated as normal.
Take      | Take will enumerate up to the specified number of items, then ignore the remainder.
TakeWhile | TakeWhile will continue enumerating items while the supplied Predicate evaluates True, after which it will ignore the remaining items.
Where     | Filter the items enumerated to only those that evaluate true when passed into the supplied Predicate 
 
FluidQuery also supports type-specific query operations, in addition to the common items above:  

Operation | Types Supported | Description 
:-------- | :-------------- | :----------  
Matches   | String          | Enumerates items that match the supplied string. Can be either a case-sensitive or case-insensitive comparison, but case insensitive by default. 
Contains  | String          | Enumerates items that contain the supplied string. Can be either a case-sensitive or case-insensitive comparison, but case insensitive by default. 
StartsWith| String          | Enumerates items that start with the supplied string. Can be either a case-sensitive or case-insensitive comparison, but case insensitive by default. 
EndsWith  | String          | Enumerates items that end with the supplied string. Can be either a case-sensitive or case-insensitive comparison, but case insensitive by default. 


I'm adding more operations as I need them, but the code is fairly simple if you want to add more.


Back Story
----------
This issue of mixing Selection code and Action code has bugged me for awhile, but I've never really found a solution I'm happy with. I tried some [experiments](http://www.malcolmgroves.com/blog/?p=273) but was never satisfied that the cure was better than the disease. A series of functional languages sessions at the recent [Yow Conference](http://yowconference.com.au/) in Australia was the light bulb moment that led me to this. John Kaster later pointed me at the .NET Enumerable Extension Methods, that let me resolve my clumsy naming. 