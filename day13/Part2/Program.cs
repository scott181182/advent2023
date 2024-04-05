class Pattern {
    private readonly char[,] data;
    public readonly int width, height;
    
    private Pattern(char[,] data, int width, int height) {
        this.data = data;
        this.width = width;
        this.height = height;
    }

    public static Pattern parse(string block) {
        string[] lines = block.Split("\n");
        char[,] data = new char[lines.Length, lines[0].Length];
        for (int i = 0; i < lines.Length; i++) {
            for(int j = 0; j < lines[i].Length; j++) {
                data[i,j] = lines[i][j];
            }
        }

        return new Pattern(data, lines[0].Length, lines.Length);
    }

    public string[] getRows() {
        string[] rows = new string[this.height];
        for(int i = 0; i < this.height; i++) {
            rows[i] = "";
            for(int j = 0; j < this.width; j++) {
                rows[i] += this.data[i,j];
            }
        }
        return rows;
    }
    public string[] getCols() {
        string[] cols = new string[this.width];
        for(int i = 0; i < this.width; i++) {
            cols[i] = "";
            for(int j = 0; j < this.height; j++) {
                cols[i] += this.data[j,i];
            }
        }
        return cols;
    }

    public int findRowReflection(int errors) {
        string[] rows = this.getRows();
        return Part1.findArrayReflection(rows, errors);
    }
    public int findColReflection(int errors) {
        string[] cols = this.getCols();
        return Part1.findArrayReflection(cols, errors);
    }

    public int getAnswer(int errors) {
        int left = this.findColReflection(errors);
        if(left < 0) {
            return 100 * (this.findRowReflection(errors) + 1);
        } else {
            return left + 1;
        }
    }
}



class Part1 {
    public static void Main(string[] args) {
        string filepath = args[0];
        string filedata = File.ReadAllText(filepath);

        int answer = filedata.Split("\n\n")
            .Select(Pattern.parse)
            .Select((p) => p.getAnswer(1))
            .Sum();

        Console.WriteLine("Answer: " + answer);
    }



    public static int findArrayReflection(string[] arr) {
        return findArrayReflection(arr, 0);
    }
    public static int findArrayReflection(string[] arr, int errors) {
        for(int i = 0; i < arr.Length - 1; i++) {
            if(testReflection(arr, i, errors)) { return i; }
        }
        return -1;
    }
    public static int hammingDistance(string a, string b) {
        int d = 0;
        for(int i = 0; i < a.Length && i < b.Length; i++) {
            if(a[i] != b[i]) { d++; }
        }
        return d;
    }
    private static bool testReflection(string[] arr, int start, int errors) {
        int errorCount = 0;
        for (int i = start, j = start + 1; i >= 0 && j < arr.Length; i--, j++) {
            errorCount += hammingDistance(arr[i], arr[j]);
            if(errorCount > errors) { return false; }
        }
        return errorCount == errors;
    }
}