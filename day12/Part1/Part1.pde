


String stringifyIntArray(int[] nums) {
    return "[ " + join(str(nums), ", ") + " ]";
}


class SpringRow {
    String parts;
    int[] sequences;

    SpringRow(String parts, int[] sequences) {
        this.parts = parts;
        this.sequences = sequences;
    }

    String toString() {
        return "Row('" + this.parts + "', [ " + join(str(this.sequences), ", ") + " ])";
    }
}
SpringRow parseInputLine(String line) {
    String[] lr = split(line, " ");
    String[] sequenceStrings = split(lr[1], ",");

    int[] sequences = new int[sequenceStrings.length];
    for(int i = 0; i < sequenceStrings.length; i++) {
        sequences[i] = int(sequenceStrings[i]);
    }

    return new SpringRow(lr[0], sequences);
}

SpringRow[] parseInputFile(String filename) {
    final String[] inputLines = loadStrings(filename);

    SpringRow[] rows = new SpringRow[inputLines.length];
    for(int i = 0; i < inputLines.length; i++) {
        rows[i] = parseInputLine(inputLines[i]);
    }

    return rows;
}



int[] calculateSequences(String parts) {
    IntList seqs = new IntList();

    int running = 0;
    for(int i = 0; i < parts.length(); i++) {
        if(parts.charAt(i) == '#') {
            running++;
        } else if(running > 0) {
            seqs.append(running);
            running = 0;
        }
    }

    // Catch damaged parts on the end.
    if(running > 0) {
        seqs.append(running);
    }

    return seqs.toArray();
}
boolean arrayEquals(int[] a, int[] b) {
    if(a.length != b.length) { return false; }
    for(int i = 0; i < a.length; i++) {
        if(a[i] != b[i]) { return false; }
    }
    return true;
}
StringList permuteParts(String line) {
    int nextBrokenPart = line.indexOf("?");
    if(nextBrokenPart < 0) {
        StringList ret = new StringList();
        ret.append(line);
        return ret;
    }

    StringList rest = permuteParts(line.substring(nextBrokenPart + 1));
    StringList ret = new StringList();
    for(int i = 0; i < rest.size(); i++) {
        ret.append(line.substring(0, nextBrokenPart) + "." + rest.get(i));
        ret.append(line.substring(0, nextBrokenPart) + "#" + rest.get(i));
    }
    return ret;
}
int matchingPermutations(String line, int[] expectedSequences) {
    final StringList permutations = permuteParts(line);
    // println(stringifyIntArray(expectedSequences));

    int matching = 0;
    for(int i = 0; i < permutations.size(); i++) {
        final int[] permutationSeqs = calculateSequences(permutations.get(i));
        // println("  - " + permutations.get(i) + " => " + stringifyIntArray(permutationSeqs));

        if(arrayEquals(permutationSeqs, expectedSequences)) {
            matching++;
        }
    }

    return matching;
}



void setup() {
    if(args == null) { exit(); }

    final SpringRow[] rows = parseInputFile(args[0]);
    int answer = 0;
    for(final SpringRow row : rows) {
        println(row.toString());
        int matching = matchingPermutations(row.parts, row.sequences);
        println("  - " + str(matching));
        answer += matching;
    }

    println("Answer: " + str(answer));

    noLoop();
}

void draw() {
    println("Draw");

    exit();
}

void stop() {
    println("Stopped");
}