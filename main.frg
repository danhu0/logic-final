#lang forge

// option run_sterling "viz.js"

abstract sig Boolean{}
one sig True, False extends Boolean {}

abstract sig partOfSpeech {
    capitalized: one Boolean,
    next: lone partOfSpeech
}

sig Noun extends partOfSpeech{}
sig Verb extends partOfSpeech{
    subject: set Noun,
    object: set Noun,
    transitive: one Boolean
}
abstract sig Adjective extends partOfSpeech{
    describedNoun: one Noun 
}
sig Determiner extends Adjective{} //e.g. a, an, the
sig Quantity extends Adjective{} //e.g. four, many, few
sig Opinion extends Adjective{} //e.g. good, bad
sig Size extends Adjective{} //e.g. big, small
sig Shape extends Adjective{} //e.g. round, square
sig Condition extends Adjective{} //e.g. broken, clean
sig Age extends Adjective{} //e.g. old, young
sig Color extends Adjective{} //e.g. green, yellow
sig Origin extends Adjective{} //e.g. Brazilian, Russian
sig Material extends Adjective{} //e.g. antique, new
sig Purpose extends Adjective{} //e.g. gardening, running

sig Adverb extends partOfSpeech{
    describedVerb: one Verb
}
sig CoordinatingConjunction extends partOfSpeech{}
sig Punctuation extends partOfSpeech {}

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

pred subjectNotAndBeforeObject {
    //subject is not object
    all v: Verb | {
        v.subject != v.object //subject and object are not the same
        v.object in v.subject.^next //object comes after subject
    }
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

pred adjectivesBeforeNoun {
    all a: Adjective | {
        (a.describedNoun in a.^next and //either adjective is before the noun
        (all w: partOfSpeech | { // (and nothing in between them but maybe more adjectives)
            w in (a.^next - a.describedNoun.^next - a.describedNoun) implies
            (w in Adjective or w in CoordinatingConjunction) // e.g. the big blue cat ... / the big and blue cat ...
        }))
        or
        (a in a.describedNoun.^next and (some v: Verb | {
            a.describedNoun = v.subject //or the it's after the noun, which is the subject of a preceding verb: e.g. the cat was blue
            a in v.^next //and the adjective is after the verb
        })) 
    }
}

pred adjOrdering {
    
}

pred coordinatingConjunctions {
    //cannot be be noun verb coordinating conjunction noun
    // no n: Noun | {
    //     n.next in Verb
    //     n.next.next in CoordinatingConjunction
    //     n.next.next.next in Noun
    // }

    all c: CoordinatingConjunction | {
        {some disj n1, n2: Noun | { //case 1: cc spliitting two nouns
            n2 in n1.^next
            c in n1.^next
            c not in n2.^next
            (all w: partOfSpeech | { // which could have adjectives in between them
                w in (n1.^next - n2.^next - n2 - c) implies
                w in Adjective
            }) 
        }}
        or
        {some disj v1, v2: Verb | { //case 2: cc splitting two verbs
            v2 in v1.^next
            c in v1.^next
            c not in v2.^next
            (all w: partOfSpeech | { // which could have adverbs in between them
                w in (v1.^next - v2.^next - v2 - c) implies
                w in Adverb
            }) 
        }}
        or
        {some disj a1, a2: Adjective | {
            a1.next = c //case 3: cc splitting two adjectives
            c.next = a2 //(adjectives can't have other parts of speech in between them -- unless they are dependent clauses)
        }}
        or
        {some disj a1, a2: Adverb | {
            a1.next = c //case 4: cc splitting two adverbs
            c.next = a2 //(adverbs can't have other parts of speech in between them -- unless they are dependent clauses)
        }}
    }
}

pred allVerbsHaveSubject {
    all v: Verb | {
        #(v.subject) > 0 //all verbs have at least one subject
    }
}
//can we infinitely add adjectives? Extendable sentences


//Valid sentence
pred validSentence{
    firstWordCapitalized
    allWordsInSentence
    endsWithPunctuation
    wellformedCapitalization
    nounBeforeVerb
    intransitiveMeansNoObject
    subjectNotAndBeforeObject
    adjectivesBeforeNoun
    allVerbsHaveSubject
    coordinatingConjunctions
}

pred taiwaneseBill { //"Old and Taiwanese Bill ran."
    some a: Age | {
        a.next in CoordinatingConjunction
        a.next.next in Origin
        a.next.next.next in Noun
        a.next.next.next.next in Verb
        a.next.next.next.next.next in Punctuation
    }
}

run {
    validSentence
    taiwaneseBill
} for exactly 1 Origin, exactly 1 Age, exactly 1 Noun, exactly 1 Verb, exactly 1 Punctuation, exactly 1 CoordinatingConjunction for {next is linear}



// https://csci1710.github.io/forge-documentation/sterling/custom-basics.html