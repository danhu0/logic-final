# logic-final

One tradeoff we initially made was the choice of using abstractions: "noun," "verb," etc. instead of specific words that carried semantic meaning. This was
done in service of us being able to make general sentences where each word would fill a functional grammatical role, without us having to fuss at first
about the sentence making real semantic sense. That also gave us the ability to try to derive grammar rules in a desriptive way that didn't depend on the
real meaning of the sentence, instead just on each components' part of speech. Most sources for grammar learning that we saw online did not abstract in such
a way, instead providing illustrative sentences with real words that carried meaning instead of the actual atomic function of each part of speech.

The model does not then in the end carry semantic meaning in the sentences that it generates. We also limited the scope of the project to a single independent
clause, so the model is not capacious enough to handle dependent clauses, various joined structures of sentences, and run-on sentences that would be grammatically correct but syntactically very complex. These would require commas, which we did not model.

Our model in the end of things, does not generate Escher or garden path sentences. It does, however, generate some unconventional sentences that forced us to think about the way in which we interpret natural language. We realized that the end goal of being able to spit out a lot of strange sentences and also register their semantics was not realistic. However, we did manage to produce the aforementioned strange sentences, although abstracted to parts of speech rather than
actual words.

In the graph representation of our model's output, we have a linearly linked set of parts of speech, each of which denotes a noun, verb, adjective, coordinating conjunction, adverb, or punctuation. Each part of speech can be capitalized, verbs can be transitive or intransitive and keep track of their subjects and (potential) objects via pointesr. Adjectives and adverbs keep track of the word that they are describing. Our custom visualizer, shows relationships between objects in our program and their fields. For example, verbs show their subjects and objects, and nouns show whether or not they are capitalized. We also have a theme that cleans up the boolean fields and makes the graph representation easier to parse.

Video presentation: https://drive.google.com/file/d/1PRkADWq3r6aXLFSKaLT36Ic2KCQQGsF_/view?usp=sharing
