Word Frequency
===

[Word Frequency](http://nickknowlson.com/projects/word_frequency/) project home page. Contains all of the following information + an in-depth example.

Details
---

My word\_frequency script counts the number of times a each word (or phrase)
occurs in a programming project and produces a sorted list of which ones appear
most frequently. It helps identify simple trends and recurring patterns and is
most useful when trying to get familiar with a new codebase.

It answers the questions "What is the most frequently occurring phrase in this project that is 1 word long? What about 2 words long? What about 8?" etc. 

At low word counts, it mostly reflects the keywords of the language, as you would expect.  Once you get into higher counts it can reveal interesting things about patterns in the code, as well as code duplication.

Usage
---

{% highlight bash %}
cd my_csharp_project
ruby word_frequency.rb 1 cs

cd ../my_website
ruby word_frequency.rb 5 js
{% endhighlight %}

String Frequency 
---

I made an alternate version of the previous tool with one modification: it only searches inside of string literals in the source code. It is good for finding out there are 89 occurrences of `"SELECT * FROM"` (among other things). This version might be more useful for finding actual problems with code than the initial version.

It should ideally be merged with `word_frequency.rb` and be enabled with a flag,
but for now it works well enough as is.

Example
---

Check the [Word Frequency](http://nickknowlson.com/projects/word_frequency/) project home page for a long example.
