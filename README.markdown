What is FluentQuery?
====================
FluentQuery allows you to query containers of items in Delphi in a fluent, declarative fashion. 


Huh?
----

OK, I agree, that was not very helpful. 

Let's say you have a TListbox of names, and you want to display the first two that start with 'Miss' (case-insensitive) and contain a hyphen.  

The standard solution in Delphi would be something like this:

    var
      LName : String;
      LFoundCount : Integer;
    begin
      LFoundCount := 0;
      for LName in Listbox1.Items do
        if (LName.StartsWith('Miss', True)) and
           (LName.Contains('-')) then
        begin
          Inc(LFoundCount);
          ShowMessage(LName);

          if LFoundCOunt = 2 then
            break;
        end;
    end;


There's nothing incorrect about that code, but it's unclear both in terms of what items in the listbox we're acting on, and unclear what we're doing to those items. This is becuase the code that selects the strings we want to display, and the code that actually displays them, are all mixed in together.

FluidQuery lets you represent the same thing like this:

    var
      LName : String;
    begin
      for LName in Query
                     .From(ListBox1.Items)
                     .StartsWith('Miss')
                     .Contains('-')
                     .Take(2) do
        ShowMessage(LName);
    end;

 
Yes, it's less code, but more importantly, it is much clearer. The statement of what items we're going to act on (in the for..in statement) reads fairly naturally, and the code that acts on the items is seperate and self contained. 

You can of course include the same operation multiple times in your query, eg: 

    StartsWith('Miss').Contains('-').Contains('VII').Take(2)


Not just for strings
--------------------

FluentQuery is not just for strings in Listboxes though. Want all the char's in a string that are either letters or digits? Use:
   
    for LChar in Query.From(FMyString).IsLetterOrDigit do
    
If FluentQuery does not contain a query operation you need, no problem. You can use the Where operation which takes a TPredicate&LT;T> to do your custom querying. This example finds the first TPerson object in your TObjectList&lt;TPerson> that is over 18: 

    var
      LPerson : TPerson;
      LOver18 : TPredicate<TPerson>;
    begin
      LOver18 := function (Person : TPerson) : boolean
                 begin
                   Result := Person.Age > 18;
                 end;

      for LPerson in Query<TPerson>
                       .From(FPersonCollection)
                       .Where(LOver18)
                       .First do
      begin
          // do something here with your adult LPerson
      end;
    end;
    
    
Not just for..in loops
--------------------------
FluentQuery is not just for for..in loops though. You can export the results of a query as another collection, such as:

    var
      LStrings : TStrings;
    begin
      LStrings := Query
                    .From(FStrings)
                    .Skip(4)
                    .Take(3)
                    .ToTStrings;

You can also use FluentQuery to define a TPredicate&lt;T> for use in other classes, such as this example filtering a listbox:

    Listbox.FilterPredicate := Query.EndsWith('e').Predicate;

The goal is to define a declarative query language for any Delphi container. 

Containers
----------
FluentQuery currently supports querying over the following types of containers:

- Anything with a TEnumerator&lt;T>, such as TList&lt;T>, TObjectList&lt;T>, etc 
- Strings in a TStrings, such as TStringList, etc
- Chars in a String
- Pointers in a TList

The latest list is on the [wiki](https://github.com/malcolmgroves/FluentQuery/wiki/Supported-Containers).


Query Operations
----------------
FluentQuery supports a common set of query operations across all collection types. These include operations such as Where, First, Skip, Take, TakeWhile and more. The latest list of query operations supported across all containers is on the [wiki](https://github.com/malcolmgroves/FluentQuery/wiki/common-query-operations)

 
In addition to the common query operations mentioned above, FluentQuery supports operations specific to the type being queried. For example, if you are querying for strings, you have operations such as StartsWith, EndsWith, Contains, etc.

FLuentQuery has type-specific query operatiosn for Strings, Chars, Pointers and others. The latest list of type-specific query operations is on the [wiki](https://github.com/malcolmgroves/FluentQuery/wiki/Type-specific-Operations) 


Back Story
----------
This issue of mixing Selection code and Action code has bugged me for awhile, but I've never really found a solution I'm happy with. I tried some [experiments](http://www.malcolmgroves.com/blog/?p=273) but was never satisfied that the cure was better than the disease. A series of functional languages sessions at the recent [Yow Conference](http://yowconference.com.au/) in Australia was the light bulb moment that led me to this. John Kaster later pointed me at the .NET Enumerable Extension Methods, that let me resolve my clumsy naming. 