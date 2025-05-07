#lang forge

abstract sig Boolean{}
one sig True, False extends Boolean {}

abstract sig partOfSpeech {
    capitalized: one Boolean,
    next: lone partOfSpeech
}

sig Noun extends partOfSpeech{}
sig Verb extends partOfSpeech{
    subject: one Noun,
    object: lone Noun,
    transitive: one Boolean
}
sig Adjective extends partOfSpeech{
    
}
sig Adverb extends partOfSpeech{}
sig CoordinatingConjunction extends partOfSpeech{}
sig Article extends partOfSpeech{}
sig Punctuation extends partOfSpeech {}
sig Pronoun extends partOfSpeech{}

//There is a first word and it's capitalized
pred firstWordCapitalized {
    some w: partOfSpeech |  {
        w.capitalized = True
        no w2: partOfSpeech | {w2.next=w and w2!=w}
    }
}

//No floating words
pred allWordsInSentence {
    some w: partOfSpeech | {
        //w.next
        all w2: partOfSpeech | {
            w2!=w implies w2 in w.^next
        }
    }
}

//Terminates with punctuation
pred endsWithPunctuation {
    some p: Punctuation | {
        no p.next
    }
}

//Punctuation shouldn't be capitalized
pred wellformedPunctuation {
    all p: Punctuation | {
        p.capitalized=False
    }
}

//A word may be capitalized if it's a noun or it's at the beginning of the sentence
pred wellformedCapitalization {
    all p: partOfSpeech | {
        p.capitalized=True implies {
            (no p2: partOfSpeech | (p2!=p and p2.next=p)) or (p in Noun)
        }
    }
}

//Sentences need a noun then verb
//subject --> verb --> object
pred nounBeforeVerb {
    //subject comes before verb
    some n: Noun, v: Verb | { //sentence requires a noun (subject) and a verb
        v in n.^next
        n = v.subject 
        n != v.object
    }
    
    //all verbs have a subject
    all v: Verb | {
        some n: Noun | {
            v in n.^next and v.subject=n
        }
    }
}

pred subjectNotObject {
    //subject is not object
    all v: Verb | {v.subject != v.object} //subject and object are not the same
}

//Intransitive verbs shouldn't have a noun directly after them
pred intransitiveMeansNoObject {
    all v: Verb | {
        v.transitive=False implies (no n: Noun | v.next=n)
    }
    //if the verb has a noun after it and is transitive, it has an object
    all v: Verb | {
        v.transitive = True iff {
            some n: Noun | {
                n in v.^next and v.object=n
            }
        }
    }
}
//the verb needs to come after the subject to which it refers

//the verb needs to come before the object to which it refers
    

//Valid sentence
pred validSentence{
    firstWordCapitalized
    allWordsInSentence
    endsWithPunctuation
    wellformedPunctuation
    wellformedCapitalization
    nounBeforeVerb
    intransitiveMeansNoObject
    subjectNotObject
}

run {
    validSentence
} for exactly 2 Noun, 1 Verb, 1 Punctuation for {next is linear}