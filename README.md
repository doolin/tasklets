# Tasklets

[![Build
Status](https://travis-ci.org/doolin/tasklets.svg)](http://travis-ci.org/doolin/tasklets)

Tasklets is a long term, intermittently developed ongoing project
for achieving the following:

* Toy Rails project suitable for tinkering and experimenting.
* Practicing mastery with habitual and daily increments.
* Exploring the nature of how things get done, how those things
are described, and how they can be measured.

Shortly after starting the project in 2011, it became apparent
that there would need to be quite a lot of javascript necessary
to achieve what I was looking for, the Javascript would be painful
and ugly, and I didn't have the time or inclination to pursue it
at that time. Since then, the Javascript world has advanced
tremendously, especially with the rise of Single Page Applications.
It may be time to revisit the project soon.

In the meantime, it's worth keeping the Ruby and the Rails
code up to date with respect to versions, and keeping up
to date with best practice.

#### More reading on habits and mastery

Mastery is path, not a destination, and requires framing activity
on that path as outcome-independent play and learning. Here are a
couple of links:

* * George Leonard: "Mastery: The Keys to Success and Long-Term
    Fulfillment."
* BJ Fogg: http://www.bjfogg.com/ and http://tinyhabits.com/

There is much, much more available, the above two links are enough
to get started.

What follows is the original README written at project inception.
Most of is still at least somewhat valid, and will be revisited and
updated in the future.

## The Old README text

Tasklets are little tasks or todo items that take between 15 minutes
to 1 hour to complete.

If a tasklet takes longer than an hour, it should be decomposed
into two or more tasks.  Notice: decomposed, not "refactored."
Refactoring comes later, when building checklists.

The whole point is to chop things down into their smallest
logical linear piece.

## The Rules...

* **A tasklet should take between 15-60 minutes to accomplish.**  This
time unit is not arbitrary. Breaking time into 15 minutes sections
allows rational billing, and allows just enough time to concentrate
on the task at hand.

* **Use as many tags for your tasklet as you want.** Create categories
automatically by chaining tags together with a slash "/".

## Notes

I have some notions for data display that I've never seen done.
And with all the caca about how "life is not linear and we shouldn't
work that way" it turns out that, in the end, the actual, physical
work has to be done one thing at a time.

Most of the people preaching non-linearity don't actually *do* work.
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


For the moment, Rails makes using RDBM very easy with ActiveModel.  Built in CRUD.
Create, Replace, Update, Delete... maps very well onto RESTful 
protocols which are practically native HTTP.
his is what people don't get about Rails.  It leverages the 
fuck out of HTTP.  That's why it's so useful.
Non-linear design, "ideation" (ugh), talk talk talk blah blah blah, collaboration, etc.
Yes.  Once you hit the metal, it has to be linear.
A few people can do more than one thing at a time, but I
guarantee, they have mastered at least one of things *cold*.


Rearranging is a UX thing.
mtngrown: For tabular layouts, that's just a piece of jQuery.
Separation of model and view.
Roberto Koci: Ok. Compartmentalization is the way to go there.
Roberto Koci: I think.
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

So your checklist becomes a strictly linear thing.  Like aviation preflights.

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


