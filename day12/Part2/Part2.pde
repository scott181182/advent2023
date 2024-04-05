import java.util.Arrays;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.LinkedList;
import java.util.List;


String stringifyIntArray(int[] nums) {
    return "[ " + join(str(nums), ", ") + " ]";
}



class Counter {
    long count;

    Counter() {
        this.count = 0;
    }

    void increment() {
        this.count++;
    }
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
final int FOLD_FACTOR = 5;
SpringRow parseInputLine(String line) {
    final String[] lr = split(line, " ");
    final String originalParts = lr[0];
    String parts = originalParts;
    for(int i = 1; i < FOLD_FACTOR; i++) {
        parts += "?" + originalParts;
    }

    String[] sequenceStrings = split(lr[1], ",");

    int[] sequences = new int[sequenceStrings.length * FOLD_FACTOR];
    for(int i = 0; i < FOLD_FACTOR; i++) {
        for(int j = 0; j < sequenceStrings.length; j++) {
            sequences[i * sequenceStrings.length + j] = int(sequenceStrings[j]);
        }
    }

    return new SpringRow(parts, sequences);
}

SpringRow[] parseInputFile(String filename) {
    final String[] inputLines = loadStrings(filename);

    SpringRow[] rows = new SpringRow[inputLines.length];
    for(int i = 0; i < inputLines.length; i++) {
        rows[i] = parseInputLine(inputLines[i]);
    }

    return rows;
}



void countPermutations(int prefixIdx, String line, int running, int[] expectedSequences, int seqIdx, Counter counter) {
    int nextExpectedSequence = seqIdx >= expectedSequences.length ? 0 : expectedSequences[seqIdx];

    for(; prefixIdx < line.length(); prefixIdx++) {
        char c = line.charAt(prefixIdx);
        // println("    - " + prefix + " - " + str(running) + " - " + stringifyIntArray(expectedSequences));

        switch (c) {
            case '.':
                if(running > 0) {
                    if(running != nextExpectedSequence) {
                        // We ended a sequence of unexpected length.
                        // We're in a bad permutation, prune!
                        return;
                    }

                    seqIdx++;
                    nextExpectedSequence = seqIdx >= expectedSequences.length ? 0 : expectedSequences[seqIdx];
                    running = 0;
                }
                break;
            case '#':
                running++;
                if(running > nextExpectedSequence) {
                    // We overran our desired sequence length.concurrent.Callable
                    // We're in a bad permutation, prune!
                    return;
                }
                break;
            case '?':
                // More heuristics for determining permutation possibilities.
                if(running > 0) {
                    // We're in a sequence, what do we have to do?
                    if(running == nextExpectedSequence) {
                        // We have to end the sequence as expected.
                        running = 0;
                        seqIdx++;
                        nextExpectedSequence = seqIdx >= expectedSequences.length ? 0 : expectedSequences[seqIdx];
                    } else {
                        // We have to continue the sequence.
                        running++;
                    }
                    // `running` should never be greater than `nextExpectedSequence` here.
                } else if(nextExpectedSequence > 0) {
                    // Could be a new sequence, could not. Time to fork!
                    // Fork the '#' case.
                    countPermutations(prefixIdx + 1, line, 1, expectedSequences, seqIdx, counter);
                    // Continue the '.' case in this call frame.
                } else {
                    // We can't have any other sequences. Defaults to '.'
                }
                break;
        }
    }

    if(prefixIdx != line.length()) {
        println("Something went wrong with incrementing prefix");
        return;
    }

    if(running != nextExpectedSequence || seqIdx < expectedSequences.length - 1) { return; }

    counter.increment();
}

long matchingPermutationsNoDot(String line, int[] expectedSequences) {
    // Let's try to partition the input by making our own '.'

    // Start in the middle repitition
    final int startSearchIndex = line.length() / 5 * 2;
    final int unknownIndex = line.indexOf('?', startSearchIndex);
    if(unknownIndex < 0) {
        // No unknowns are unlikely, but we can at least calculate it easily.
        Counter counter = new Counter();
        countPermutations(0, line, 0, expectedSequences, 0, counter);
        return counter.count;
    }

    final String lline = line.substring(0, unknownIndex);
    String rline = line.substring(unknownIndex + 1);

    // Add both versions together
    return matchingPermutations(lline + "." + rline, expectedSequences) +
        matchingPermutationsNoDot(lline + "#" + rline, expectedSequences);
}
long matchingPermutations(String line, int[] expectedSequences) {
    // Let's try to partition the input on a known '.'

    // Start in the middle repitition
    final int startSearchIndex = line.length() / 5 * 2;
    final int dotIndex = line.indexOf('.', startSearchIndex);
    if(dotIndex < 0) {
        // No dots to partition on, let's look into this...
        return matchingPermutationsNoDot(line, expectedSequences);
    }

    final String lline = line.substring(0, dotIndex);
    final String rline = line.substring(dotIndex);

    long total = 0;
    for(int i = 0; i <= expectedSequences.length; i++) {
        // Slices would be nice.
        final int[] leftSequences = Arrays.copyOfRange(expectedSequences, 0, i);
        final int[] rightSequences = Arrays.copyOfRange(expectedSequences, i, expectedSequences.length);

        Counter lcounter = new Counter();
        countPermutations(0, lline, 0, leftSequences, 0, lcounter);
        if(lcounter.count == 0) { continue; }

        Counter rcounter = new Counter();
        countPermutations(0, rline, 0, rightSequences, 0, rcounter);
        if(rcounter.count == 0) { continue; }

        total += lcounter.count * rcounter.count;
    }
    return total;
}



void setup() {
    if(args == null) { exit(); }

    final SpringRow[] rows = parseInputFile(args[0]);

    final ExecutorService pool = Executors.newFixedThreadPool(12);
    final LinkedList<Callable<Long>> callables = new LinkedList<Callable<Long>>();

    int idx = 0;
    for(final SpringRow row : rows) {
        final int id = ++idx;
        Callable<Long> rowCallable = () -> {
            // println("[start:" + str(id) + "] " + row.toString());
            long count = matchingPermutations(row.parts, row.sequences);
            // println("[done:" + str(id) + "] " + String.format("%,d", count));
            return count;
        };
        callables.add(rowCallable);
    }

    long answer = 0;
    try {
        for(final Future<Long> result : pool.invokeAll(callables)) {
            answer += result.get();            
        }
    } catch(InterruptedException ie) {
        println("Interruption Error");
    } catch(ExecutionException ee) {
        println("Execution Error");
    }
    println("Answer: " + String.format("%,d", answer));

    noLoop();
}

void draw() {
    // println("Draw");
    exit();
}

void stop() {
    // println("Stopped");
}