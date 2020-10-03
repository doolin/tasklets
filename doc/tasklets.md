# Tasklets

Tasklets are little tasks or todo items that take between 15 minutes
to 1 hour to complete.

If a tasklet takes longer than an hour, it should be decomposed
into two or more tasks. Notice: decomposed, not "refactored."
Refactoring comes later, when building checklists.

The whole point is to chop things down into their smallest
logical linear piece.

## The Rules...

- **A tasklet should take between 15-60 minutes to accomplish.** This
  time unit is not arbitrary. Breaking time into 15 minutes sections
  allows rational billing, and allows just enough time to concentrate
  on the task at hand.

- **Use as many tags for your tasklet as you want.** Create categories
  automatically by chaining tags together with a slash "/".

## Notes

I have some notions for data display that I've never seen done.
Despite all the bloviation about how "life is not linear and we shouldn't
work that way" it turns out that, in the end, the actual, physical
work has to be done one thing at a time.

Most of the people preaching non-linearity don't actually _do_ work.
They get other people to do work.

Data display:
Given a set of tasks with associated tags, how best to display?

How best to organize?
How best to bill?
These are very messy problems.
Also, categories can be considered a special case of tags.
Consider the list of tags:
dog, animal/mammal, mammal/dog, canine, man's best friend, pet
cat, mammal/cat

mammal/gerbil
Now, the datastore becomes important.
Traditionally, it's all RDBMS.
Is that best?
Probably not.
Maybe an ORMS - Object Relational Management
So I"m looking into couchdb, redis and mongodb.

For the moment, Rails makes using RDBM very easy with ActiveModel. Built in CRUD.
Create, Replace, Update, Delete... maps very well onto RESTful
protocols which are practically native HTTP.
his is what people don't get about Rails. It leverages the
fuck out of HTTP. That's why it's so useful.
Non-linear design, "ideation" (ugh), talk talk talk blah blah blah, collaboration, etc.
Yes. Once you hit the metal, it has to be linear.
A few people can do more than one thing at a time, but I
guarantee, they have mastered at least one of things _cold_.

Rearranging is a UX thing.
dave: For tabular layouts, that's just a piece of jQuery. Separation of model and view.
roberto: Ok. Compartmentalization is the way to go there.
roberto: I think.
Each tasklet is no longer than 1 hour.
If you can't do in an hour or less, decompose it into two or more tasklets.

This is to 1. leverage billing on 15 minute increments,
and 2. most people need to take a break hourly.

Especially doing mental work.
I have 800 tickets in my Trac system right now, about 350 closed.
maybe 400 closed.
So I'm getting to know quite a bit about tasking.
The other thing is that a short, 1 hour task can be written up in a few minutes as a gist.

https://gist.github.com/gists
Can't search a red triangle.
At an hour max length, each tasklet can be wrapped in
semantic html and passed around as a transclusion.

Having attachments to extended descriptions is fine.
But not necessary for getting the structure done right.
Remember cacklist.com?

Each task can be cloned into a checklist.

So your checklist becomes a strictly linear thing. Like aviation preflights.

Once you have that you can start predicting.

For example, adding tags to the tasklet model took 15 minutes,
which included adding to the database, fixing all the html.

5 more minutes to write a private gist.

Now, when bidding that work, I can look back and see it took me
20 minutes for mine, so I can bid it at hour and be safe.

## Decomposition

All that's necessary is splitting a task into two parts.

You can split into a halves, or you can "shave off pieces."
The important thing is to make the split, then let the algorithm
take over.
