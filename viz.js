const stage = new Stage();
const verbs = instance.signature('Verb').atoms();
const nouns = instance.signature('Noun').atoms();
const determiners = instance.signature('Determiner').atoms();
const quantities = instance.signature('Quantity').atoms();

const nextField = instance.field('next');
const subjectField = instance.field('subject');
const objectField = instance.field('object');
const capitalizedField = instance.field('capitalized');

verbs.forEach((v, idx) => {
  // handle subject field
  const rawSubjects = v.join(subjectField);
  const subjectAtoms = Array.isArray(rawSubjects)
    ? rawSubjects
    : rawSubjects ? [rawSubjects] : [];
  const subjectNames = subjectAtoms.map(a => a.toString()).join(', ') || '(no subjects)';

  // handle object field
  const rawObjects = v.join(objectField);
  const objectAtoms = Array.isArray(rawObjects)
    ? rawObjects
    : rawObjects ? [rawObjects] : [];
  const objectNames = objectAtoms.map(a => a.toString()).join(', ') || '(no objects)';

  // subject TextBox
  stage.add(new TextBox({
    text:    `${v.toString()} has subject ${subjectNames} and object ${objectNames}`,
    coords:  { x: 190, y: 100 + idx * 24 },
    color:   'black',
    fontSize: 16
  }));

  // object TextBox (to the right)
  stage.add(new TextBox({
    text:    `${v.toString()} has object ${objectNames}`,
    coords:  { x: 500, y: 100 + idx * 24 },
    color:   'gray',
    fontSize: 16
  }));
});

nouns.forEach((n, idx) => {
  //Handling the capitalized fields
  const rawCapitalized = n.join(capitalizedField);
  const capitalizedAtoms = Array.isArray(rawCapitalized)
    ? rawCapitalized
    : rawCapitalized ? [rawCapitalized] : [];
  const capitalizedNames = capitalizedAtoms.map(a => a.toString()).join(', ') || '(error)';

  // subject TextBox
  stage.add(new TextBox({
    text:    `${n.toString()} is capitalized? ${capitalizedNames}`,
    coords:  { x: 190, y: 200 + idx * 24 },
    color:   'black',
    fontSize: 16
  }));
});



stage.render(svg, document);
