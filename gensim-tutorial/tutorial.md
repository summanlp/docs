
Summarization module
====================

This module adds to gensim an automatic summarization feature.
The algorithm used to obtain the summaries is a [variation](https://github.com/summanlp/docs/raw/master/articulo/articulo-en.pdf) of [TextRank](http://web.eecs.umich.edu/~mihalcea/papers/mihalcea.emnlp04.pdf).

Because this module uses an extractive approach (the generated summary will be a collection of the most relevant sentences in the text),
the provided text must be well punctuated so that it can be split in sentences.


Basic usage
-----------

The most basic usage is the summarization of a text given as a string:

    >>> from gensim.summarization import summarize
    >>>
    >>> text = """On Friday, the United States Supreme Court declared same-sex marriage legal in all fifty US states. 
    >>> More than 30 states already permitted gay marriage. 
    >>> The Supreme Court ruled by a five-to-four vote that bans on same-sex marriage were not constitutional. 
    >>> The majority decision was delivered by Justice Anthony Kennedy.
    >>> Same-sex marriage was banned in more than a dozen states. 
    >>> Justices Sotomayor, Ginsburg, Kagan, Breyer and Kennedy voted in favour while Justices Roberts, Alito, Scalia and Thomas voted against.
    >>> Kennedy's decision brought tears to the eyes of some lawyers in the courtroom. 
    >>> However, Justice Antonin Scalia in his dissenting opinion derided the majority decision: "The opinion is couched in a style that is as pretentious as its content is egotistic. [...] Of course, the opinion’s showy profundities are often profoundly incoherent."
    >>> When the decision was made, police allowed people outside the court to wave the rainbow flag on the court plaza. 
    >>> Demonstrators outside the court chanted "Love has won". 
    >>> This decision made the United States the 21st country to legalise same-sex marriage.
    >>> President Barack Obama responded to the decision: "Today we can say, in no uncertain terms, that we have made our union a little more perfect."
    >>> After this decision, Facebook introduced a new tool to add rainbow coloring to one's profile picture to celebrate this victory. 
    >>> Mark Zuckerberg posted on Facebook "I'm so happy for all of my friends and everyone in our community who can finally celebrate their love and be recognized as equal couples under the law".
    >>> Later, companies like Google, Yahoo, Tumblr and Vine tweeted with hashtag "#LoveWins". 
    >>> That night, the White House had the rainbow projected on the outside of the building to celebrate the decision."""
    >>>
    >>> print(summarize(text))
    On Friday, the United States Supreme Court declared same-sex marriage legal in all fifty US states.
    The Supreme Court ruled by a five-to-four vote that bans on same-sex marriage were not constitutional.
    This decision made the United States the 21st country to legalise same-sex marriage.

(Sample text taken from [Wikinews](https://en.wikinews.org/wiki/US_Supreme_Court_declares_same-sex_marriage_legal))


If the text is too short (less than ten sentences), a warning will be issued:

    >>> import logging
    >>> logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.WARNING)
    >>>
    >>> shorttext = """On Friday, the United States Supreme Court declared same-sex marriage legal in all fifty US states. 
    >>> More than 30 states already permitted gay marriage. 
    >>> The Supreme Court ruled by a five-to-four vote that bans on same-sex marriage were not constitutional. 
    >>> The majority decision was delivered by Justice Anthony Kennedy.
    >>> Same-sex marriage was banned in more than a dozen states. 
    >>> Justices Sotomayor, Ginsburg, Kagan, Breyer and Kennedy voted in favour while Justices Roberts, Alito, Scalia and Thomas voted against."""
    >>>
    >>> print(summarize(shorttext))
    WARNING: Input text is expected to have at least 10 sentences.
    WARNING: Input corpus is expected to have at least 10 documents.
    The Supreme Court ruled by a five-to-four vote that bans on same-sex marriage were not constitutional.


Extra parameters
----------------

When called with no extra arguments, the `summarize` method returns the summarized text split by setences with newlines.
If the `split` named parameter is set to `True`, the output will be a list instead:

    >>> from pprint import pprint 
    >>> pprint(summarize(text, split=True))
    ['On Friday, the United States Supreme Court declared same-sex marriage legal in all fifty US states.',
     'The Supreme Court ruled by a five-to-four vote that bans on same-sex marriage were not constitutional.',
     'This decision made the United States the 21st country to legalise same-sex marriage.']

Note that in both cases the extracted sentences are returned in the original order.


The summary shown in the first example was composed of three sentences of a text with sixteen.
By default, the summary selects the top 20% most relevant sentences in the text. 
This can be adjusted with the `ratio` and `word_count` parameters.

The `ratio` changes the percentage of relevant sentences selected:

    >>> print(summarize(text, ratio=0.4))
    On Friday, the United States Supreme Court declared same-sex marriage legal in all fifty US states.
    The Supreme Court ruled by a five-to-four vote that bans on same-sex marriage were not constitutional.
    The majority decision was delivered by Justice Anthony Kennedy.
    Same-sex marriage was banned in more than a dozen states.
    This decision made the United States the 21st country to legalise same-sex marriage.
    That night, the White House had the rainbow projected on the outside of the building to celebrate the decision.

The `word_count` parameter determines how many words will the output contain.
For this, the algorithm will select the top sentences trying to make a summary with a word count as close 
as possible as the indicated.

    >>> print(summarize(text, word_count=20))
    On Friday, the United States Supreme Court declared same-sex marriage legal in all fifty US states.

If both the `ratio` and `word_count` parameters are provided, the `ratio` will be ignored.


Corpus summarization
--------------------


Performance
--------------

