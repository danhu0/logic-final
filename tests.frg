#lang forge
open "main.frg" 

// firstWordCapitalized
test suite for firstWordCapitalized {
  // First word should always be capitalized
  example firstWordCorrectlyCapitalized is {firstWordCapitalized} for {
    Noun = `N1
    Verb = `V1
    False=`False
    True= `True
    Boolean=True+False
    Punctuation = `P1
    partOfSpeech = `N1+ `V1 + `P1
    capitalized = `N1->`True+ `V1->`False + `P1->`False
    next = `N1->`V1+ `V1->`P1
  }


  // Again, first word always capitalized
  example firstWordNotCapitalized is {not firstWordCapitalized} for {
    Noun = `N1
    Verb = `V1
    False=`False
    True= `True
    Boolean=True+False
    Punctuation = `P1
    partOfSpeech = `N1+ `V1+ `P1
    capitalized = `N1->`False+ `V1->`False+ `P1->`False
    next = `N1->`V1+ `V1->`P1
  }
}

// allWordsInSentence
test suite for allWordsInSentence {
  // No disconnected words
  example allWordsConnected is {allWordsInSentence} for {
    Noun = `N1
    Verb = `V1
    Punctuation = `P1
    False=`False
    True= `True
    Boolean=True+False
    partOfSpeech = `N1+ `V1+ `P1
    next = `N1->`V1+ `V1->`P1
  }

  // Impossible to have disconnected words
  example disconnectedWords is {not allWordsInSentence} for {
    Noun = `N1+ `N2
    Verb = `V1
    Punctuation = `P1
    False=`False
    True= `True
    Boolean=True+False
    partOfSpeech = `N1+ `N2+ `V1+ `P1
    next = `N1->`V1+ `V1->`P1 // `N2 is not connected to the sentence
  }
}

// endsWithPunctuation
test suite for endsWithPunctuation {
  // simple case with ending punctuation
  example properPunctuation is {endsWithPunctuation} for {
    Noun = `N1
    Verb = `V1
    False=`False
    True= `True
    Boolean=True+False
    Punctuation = `P1
    partOfSpeech = `N1+ `V1+ `P1
    next = `N1->`V1+ `V1->`P1
  }

  // all sentences end with pronunciation
  example noPunctuation is {not endsWithPunctuation} for {
    Noun = `N1+ `N2
    Verb = `V1
    False=`False
    True= `True
    Boolean=True+False
    Punctuation = `P1
    partOfSpeech = `N1+ `N2+ `V1+ `P1
    next = `N1->`V1+ `V1->`N2+ `P1->`N1
  }
}

// wellformedPunctuation
test suite for wellformedPunctuation {
  // punctuation isn't capitalized
  example uncapitalizedPunctuation is {wellformedPunctuation} for {
    Punctuation = `P1
    partOfSpeech = `P1
    False=`False
    True= `True
    Boolean=True+False
    capitalized = `P1->False
  }

  // all punctuation is lowercase
  example capitalizedPunctuation is {not wellformedPunctuation} for {
    Punctuation = `P1
    partOfSpeech = `P1
    False=`False
    True= `True
    Boolean=True+False
    capitalized = `P1->True
  }
}

// wellformedCapitalization
test suite for wellformedCapitalization {
  //  non-first and non-noun is capitalized
  example improperCapitalization is {not wellformedCapitalization} for {
    Noun = `N1
    Verb = `V1
    False=`False
    True= `True
    Boolean=True+False
    Punctuation = `P1
    partOfSpeech = `N1+ `V1+ `P1
    capitalized = `N1->True+ `V1->True+ `P1->False // Verb is capitalized mid-sentence
    next = `N1->`V1+ `V1->`P1
  }
}

// nounBeforeVerb
test suite for nounBeforeVerb {
  // verb comes before its subject noun
  example improperNounVerbOrder is {not nounBeforeVerb} for {
    Noun = `N1
    Verb = `V1
    False=`False
    True= `True
    Boolean=True+False
    Punctuation = `P1
    partOfSpeech = `N1+ `V1+ `P1
    next = `V1->`N1+ `N1->`P1
    subject = `V1->`N1

  }
}

//subjectNotAndBeforeObject
test suite for subjectNotAndBeforeObject {
  // object is the same as subject
  example sameSubjectObject is {not subjectNotAndBeforeObject} for {
    Noun = `N1
    False=`False
    True= `True
    Boolean=True+False
    Verb = `V1
    Punctuation = `P1
    partOfSpeech = `N1+ `V1+ `P1
    next = `N1->`V1+ `V1->`P1
    subject = `V1->`N1
    object = `V1->`N1
  }
  
  //object comes before subject
  example improperSubjectObjectOrder is {not subjectNotAndBeforeObject} for {
    Noun = `N1+ `N2
    Verb = `V1
    False=`False
    True= `True
    Boolean=True+False
    Punctuation = `P1
    partOfSpeech = `N1+ `N2+`V1+ `P1
    next = `N2->`V1+ `V1->`N1+ `N1->`P1
    subject = `V1->`N1
    object = `V1->`N2
  }
}

//intransitiveMeansNoObject
test suite for intransitiveMeansNoObject {
  // intransitive verb with a noun after it
  example intransitiveWithNoun is {not intransitiveMeansNoObject} for {
    Noun = `N1+ `N2
    Verb = `V1
    False=`False
    True= `True
    Boolean=True+False
    Punctuation = `P1
    partOfSpeech = `N1+ `N2+ `V1+ `P1
    next = `N1->`V1+ `V1->`N2+ `N2->`P1
    subject = `V1->`N1

    transitive = `V1->False
  }
}

//adjectivesBeforeNoun
test suite for adjectivesBeforeNoun {
  // simple: adjective comes before its noun
  example adjectiveBeforeNoun is {adjectivesBeforeNoun} for {
    Noun = `N1
    Color = `A1
    Verb = `V1
    False=`False
    True= `True
    Boolean=True+False
    Punctuation = `P1
    partOfSpeech = `N1+ `A1+ `V1+ `P1
    Adjective = `A1
    next =`A1->`N1+ `N1->`V1+ `V1->`P1
    describedNoun = `A1->`N1
    subject = `V1->`N1

  }

  // Test case: multiple adjectives before noun with coordinating conjunction
  example multipleAdjectivesBeforeNoun is {adjectivesBeforeNoun} for {
    Noun = `N1
    Color =`A1
    Size =`A2
    False=`False
    True= `True
    Boolean=True+False
    CoordinatingConjunction =`C1
    Verb = `V1
    Punctuation = `P1
    partOfSpeech = `N1+`A1+`A2+`C1+ `V1+ `P1
    Adjective =`A1+`A2
    next =`A1->`C1+`C1->`A2+`A2->`N1+ `N1->`V1+ `V1->`P1
    describedNoun =`A1->`N1+`A2->`N1
    subject = `V1->`N1
  }

  // adjective after intransitive verb describing subject
  example adjectiveAfterIntransitiveVerb is {adjectivesBeforeNoun} for {
    Noun = `N1
    Color =`A1
    Verb = `V1
    False=`False
    True= `True
    Boolean=True+False
    Punctuation = `P1
    partOfSpeech = `N1+`A1+ `V1+ `P1
    Adjective =`A1
    next = `N1->`V1+ `V1->`A1+`A1->`P1
    describedNoun =`A1->`N1
    subject = `V1->`N1

    transitive = `V1->False
  }
  
  //adjective not before or after noun with proper syntax 
  example improperAdjectivePlacement is {not adjectivesBeforeNoun} for {
    Noun = `N1+ `N2
    Color =`A1
    Verb = `V1
    False=`False
    True= `True
    Boolean=True+False
    Punctuation = `P1
    partOfSpeech = `N1+ `N2+`A1+ `V1+ `P1
    Adjective =`A1
    next = `N1->`V1+ `V1->`A1+`A1->`N2+ `N2->`P1
    describedNoun =`A1->`N1 // Describing `N1 but positioned between `V1 and `N2
    subject = `V1->`N1
    object = `V1->`N2
    transitive = `V1->True
  }
}

//adverbsBeforeVerb
test suite for adverbsBeforeVerb {
  // adverb after verb
  example adverbAfterVerb is {adverbsBeforeVerb} for {
    Noun = `N1
    Adverb = `AV1
    Verb = `V1
    False=`False
    True= `True
    Boolean=True+False
    Punctuation = `P1
    partOfSpeech = `N1+ `AV1+ `V1+ `P1
    next = `N1->`V1+ `V1->`AV1+ `AV1->`P1
    describedVerb = `AV1->`V1
    subject = `V1->`N1
  }
  example multipleAdverbsWithCoordination is {adverbsBeforeVerb} for {
    Noun = `N1
    Adverb = `AV1+ `AV2
    CoordinatingConjunction =`C1
    Verb = `V1
    False=`False
    True= `True
    Boolean=True+False
    Punctuation = `P1
    partOfSpeech = `N1+ `AV1+ `AV2+`C1+ `V1+ `P1
    next = `N1->`AV1+ `AV1->`C1+`C1->`AV2+ `AV2->`V1+ `V1->`P1
    describedVerb = `AV1->`V1+ `AV2->`V1
    subject = `V1->`N1
  }
}

// TcoordinatingConjunctions
test suite for coordinatingConjunctions {
  example conjunctionBetween is {coordinatingConjunctions} for {
    Noun = `N1
    Adverb = `AV1+ `AV2
    CoordinatingConjunction =`C1
    Verb = `V1
    Punctuation = `P1
    False=`False
    True= `True
    Boolean=True+False
    partOfSpeech = `N1+ `AV1+ `AV2+`C1+ `V1+ `P1
    next = `N1->`AV1+ `AV1->`C1+`C1->`AV2+ `AV2->`V1+ `V1->`P1
    describedVerb = `AV1->`V1+ `AV2->`V1
    subject = `V1->`N1
  }
}

//allVerbsHaveSubject
test suite for allVerbsHaveSubject {
  // verbs need a subjects
  example verbMustHaveSubject is {not allVerbsHaveSubject} for {
    Noun = `N1
    Verb = `V1+ `V2
    CoordinatingConjunction =`C1
    Punctuation = `P1
    partOfSpeech = `N1+ `V1+ `V2+`C1+ `P1
    False=`False
    True= `True
    Boolean=True+False
    next = `N1->`V1+ `V1->`C1+`C1->`V2+ `V2->`P1
    subject = `V1->`N1
  }
}

// Everything
test suite for validSentence {
  //Bill ran.
  example simpleValidSentence is {validSentence} for {
    Noun = `N1
    Verb = `V1
    Punctuation = `P1
    False=`False
    True= `True
    Boolean=True+False
    partOfSpeech = `N1+ `V1+ `P1
    capitalized = `N1->True+ `V1->False+ `P1->False
    next = `N1->`V1+ `V1->`P1
    subject = `V1->`N1
    transitive = `V1->False
  }

  //Bill saw jane.
  example transitiveValidSentence is {validSentence} for {
    Noun = `N1+ `N2
    False=`False
    True= `True
    Boolean=True+False
    Verb = `V1
    Punctuation = `P1
    partOfSpeech = `N1+ `N2+ `V1+ `P1
    capitalized = `N1->True+ `N2->True+ `V1->False+ `P1->False
    next = `N1->`V1+ `V1->`N2+ `N2->`P1
    subject = `V1->`N1
    object = `V1->`N2
    transitive = `V1->True
  }

  // The big blue cat ran.
  example adjectiveValidSentence is {validSentence} for {
    Noun = `N1
    False=`False
    True= `True
    Boolean=True+False
    Determiner =`D1
    Size =`A1
    Color =`A2
    Verb = `V1
    Punctuation = `P1
    partOfSpeech = `N1+`D1+`A1+`A2+ `V1+ `P1
    Adjective =`D1+`A1+`A2
    capitalized =`D1->True+`A1->False+`A2->False+ `N1->False+ `V1->False+ `P1->False
    next =`D1->`A1+`A1->`A2+`A2->`N1+ `N1->`V1+ `V1->`P1
    describedNoun =`D1->`N1+`A1->`N1+`A2->`N1
    subject = `V1->`N1
    transitive = `V1->False
  }

  //Old and wise Bill ran.
  example conjunctionValidSentence is {validSentence} for {
    Noun = `N1
    False=`False
    True= `True
    Boolean=True+False
    Age =`A1
    Opinion =`A2
    CoordinatingConjunction =`C1
    Verb = `V1
    Punctuation = `P1
    partOfSpeech = `N1+`A1+`A2+`C1+ `V1+ `P1
    Adjective =`A1+`A2
    capitalized =`A1->True+`A2->False+`C1->False+ `N1->True+ `V1->False+ `P1->False
    next =`A1->`C1+`C1->`A2+`A2->`N1+ `N1->`V1+ `V1->`P1
    describedNoun =`A1->`N1+`A2->`N1
    subject = `V1->`N1
    transitive = `V1->False
  }
}
