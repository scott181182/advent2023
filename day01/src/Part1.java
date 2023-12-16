import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.function.Predicate;
import java.util.regex.Matcher;
import java.util.regex.Pattern;



public class Part1
{
    public static final Pattern FIRST_NUMBER_PATTERN = Pattern.compile("^[^\\d]*(\\d)");
    public static final Pattern LAST_NUMBER_PATTERN = Pattern.compile("(\\d)[^\\d]*$");

    public static int line2number(String line) {
        Matcher fm = FIRST_NUMBER_PATTERN.matcher(line);
        if(!fm.find()) {
            System.err.format("No first digit match in string '%s'\n", line);
        }
        String firstDigit = fm.group(1);
        Matcher lm = LAST_NUMBER_PATTERN.matcher(line);
        if(!lm.find()) {
            System.err.format("No last digit match in string '%s'\n", line);
        }
        String lastDigit = lm.group(1);

        // System.out.format("    %s -> %s%s\n", line, firstDigit, lastDigit);

        return Integer.parseInt(firstDigit + lastDigit);
    }

    public static void main(String[] args) {
        Path filepath = FileSystems.getDefault().getPath(args[0]);

        try {
           int total = Files.lines(filepath)
                .filter(Predicate.not(String::isEmpty))
                .map(Part1::line2number)
                .reduce(0, Integer::sum);

            System.out.format("Part 1 Calibration: %d\n", total);
        } catch (IOException ioe) {
            ioe.printStackTrace();
        }
    }
}
