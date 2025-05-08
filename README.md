# logic-final

We plan on modeling our sentances by first having sigs that model parts of speech, like nouns, verbs, adjectives, adverbs.
The predicates will model grammatical rules like subject-verb-object agreement.

Sigs:
- sentence (list of words, periods, commas, etc.)
- words (capitalized or not capitalized, etc.)

- Types of words:
-   nouns
-   verbs
-   adjectives
-   etc.


Excluded items for simplification of our model:
- Nouns which follow verbs but are not their objects (e.g. He is a teacher, She died a hero, Tim became president). 

stretch goal: establish clauses that can either stand on their own as sentences or be joined by coordinating conjunctions with a preceding comma, and set all the main preds to evaluate clauses rather than "all words"