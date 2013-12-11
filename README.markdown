What is CollectionQuery?
========================
CollectionQuery is a group of Enumerators that allow you to operate on a Generic Collection of items in a more declarative fashion. 


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
          // do something with your adult LPerson
          if LOver18Count = 2 then
            break;
        end;
      end;
    end;

There's nothing incorrect about that code, but I find it messy because the code that selects the objects you want to act on, and the code that acts on them, are all mixed in together.

CollectionQuery lets you represent the same thing like this:

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
          // do something with your adult LPerson
      end;
    end;
 
It's about the same length of code, but it is, in my mind, much clearer. The statement of what objects we're going to act on (in the for..in statement) reads fairly naturally, and the code that acts on the objects is self contained. 

Further, over time you tend to build up a set of reusable Predicates appropriate to your objects and so for example, the LOver18 definition does not need to be declared locally. You can also chain them together, eg Where(Over18).Where(VisitedRecently).Where(HasPurchased)

I'm adding more "operators" ie. the From, Where and Take parts, as I need them, but the code is fairly simple if you want to add more.


Back Story
----------
This issue of mixing Selection code and Action code has bugged me for awhile, but I've never really found a solution I'm happy with. I tried some [experiments](http://www.malcolmgroves.com/blog/?p=273) but was never satisfied that the cure was better than the disease. A functional languages session at the recent [Yow Conference](http://yowconference.com.au/) in Australia was the light bulb moment that led me to this.