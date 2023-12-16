import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.function.Predicate;
import java.util.regex.Matcher;
import java.util.regex.Pattern;



public class Part2
{
    // Same as Part 1, but with added strings to capture words for digits (and a non-greedy matcher for non-digits).
    public static final Pattern FIRST_NUMBER_PATTERN    = Pattern.compile("^[^\\d]*?(\\d|one|two|three|four|five|six|seven|eight|nine)");

    // If we took the same approach for the last number in the string, the RegEx engine would greedily take the last
    // digit or the first number word and not extract the last number word (if present).
    // To avoid this forward-matching, we simply reverse the input string and run a forward matched RegEx on it!
    // Now this regular expression is the same as the first number matcher, but the words are reversed.
    public static final Pattern LAST_NUMBER_PATTERN_REV = Pattern.compile("^[^\\d]*?(\\d|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin)");



    /** Convenience method for reversing a String. */
    public static String reverse(String str) {
        return new StringBuilder(str).reverse().toString();
    }

    /** Take a matched number, numeric or otherwise, and return the numeric version. */
    public static String numberMatch2digit(String match) {
        switch(match) {
            case "one":   return "1";
            case "two":   return "2";
            case "three": return "3";
            case "four":  return "4";
            case "five":  return "5";
            case "six":   return "6";
            case "seven": return "7";
            case "eight": return "8";
            case "nine":  return "9";
            default:      return match;
        }
    }

    public static int line2number(String line) {
        Matcher fm = FIRST_NUMBER_PATTERN.matcher(line);
        if(!fm.find()) {
            System.err.format("No first digit match in string '%s'\n", line);
        }
        String firstDigit = numberMatch2digit(fm.group(1));

        // Reverse, reverse!
        String lineRev = reverse(line);
        Matcher lm = LAST_NUMBER_PATTERN_REV.matcher(lineRev);
        if(!lm.find()) {
            System.err.format("No last digit match in string '%s'\n", line);
        }
        // Re-reverse before turning it into a numeric digit.
        String lastDigit = numberMatch2digit(reverse(lm.group(1)));

        // System.out.format("    %s -> %s%s\n", line, firstDigit, lastDigit);

        return Integer.parseInt(firstDigit + lastDigit);
    }

    public static void main(String[] args) {
        Path filepath = FileSystems.getDefault().getPath(args[0]);

        try {
            int total = Files.lines(filepath)
                .filter(Predicate.not(String::isEmpty))
                .map(Part2::line2number)
                .reduce(0, Integer::sum);

            System.out.format("Part 2 Calibration: %d\n", total);
        } catch (IOException ioe) {
            ioe.printStackTrace();
        }
    }
}
