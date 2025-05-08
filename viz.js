(async () => {
    // Helper function to extract the first atom from an expression
    function firstAtomOf(expr) {
        if (!expr.empty()) return expr.tuples()[0].atoms()[0];
        return 'none';
    }
    const fam = firstAtomOf;

    // Fetch signatures and fields
    const posSig = await viz.signature("partOfSpeech");
    const nounSig = await viz.signature("Noun");
    const verbSig = await viz.signature("Verb");
    const punctSig = await viz.signature("Punctuation");

    const capitalized = await viz.field("capitalized");
    const next = await viz.field("next");
    const subject = await viz.field("subject");
    const object = await viz.field("object");
    const transitive = await viz.field("transitive");

    const allPOS = posSig.atoms();

    const gridConfig = {
        grid_location: { x: 10, y: 10 },
        cell_size: { x_size: 120, y_size: 40 },
        grid_dimensions: {
            y_size: allPOS.length + 1,
            x_size: 7 // ID, Type, Capitalized, Next, Subject, Object, Transitive
        }
    };

    const grid = new Grid(gridConfig);

    // Define headers
    const headers = ["ID", "Type", "Capitalized", "Next", "Subject", "Object", "Transitive"];
    headers.forEach((h, i) => {
        grid.add({ x: i, y: 0 }, new TextBox({
            text: h,
            coords: { x: 0, y: 0 },
            color: "black",
            fontSize: 14
        }));
    });

    // Populate grid rows
    for (let i = 0; i < allPOS.length; i++) {
        const atom = allPOS[i];
        const id = atom.id();
        const short = atom.shortName;

        let type = "Unknown";
        if (nounSig.atoms().includes(atom)) type = "Noun";
        else if (verbSig.atoms().includes(atom)) type = "Verb";
        else if (punctSig.atoms().includes(atom)) type = "Punctuation";

        const cap = fam(await capitalized.get(atom))?.shortName || "none";
        const nxt = fam(await next.get(atom))?.shortName || "none";
        const subj = type === "Verb" ? (fam(await subject.get(atom))?.shortName || "none") : "";
        const obj = type === "Verb" ? (fam(await object.get(atom))?.shortName || "none") : "";
        const trans = type === "Verb" ? (fam(await transitive.get(atom))?.shortName || "none") : "";

        const rowData = [short, type, cap, nxt, subj, obj, trans];

        rowData.forEach((val, col) => {
            grid.add({ x: col, y: i + 1 }, new TextBox({
                text: val,
                coords: { x: 0, y: 0 },
                color: "black",
                fontSize: 12
            }));
        });
    }

    const stage = new Stage();
    stage.add(grid);
    stage.render(svg, document); // Ensure both svg and document are passed
})();
