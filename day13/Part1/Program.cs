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

    public int findRowReflection() {
        string[] rows = this.getRows();
        return Part1.findArrayReflection(rows);
    }
    public int findColReflection() {
        string[] cols = this.getCols();
        return Part1.findArrayReflection(cols);
    }

    public int getAnswer() {
        int left = this.findColReflection();
        int above = this.findRowReflection();
        return left + 1 + 100 * (above + 1);
    }
}



class Part1 {
    public static void Main(string[] args) {
        string filepath = args[0];
        string filedata = File.ReadAllText(filepath);

        int answer = filedata.Split("\n\n")
            .Select(Pattern.parse)
            .Select((p) => p.getAnswer())
            .Sum();

        Console.WriteLine("Answer: " + answer);
    }



    public static int findArrayReflection(string[] arr) {
        for(int i = 0; i < arr.Length - 1; i++) {
            if(testReflection(arr, i)) { return i; }
        }
        return -1;
    }
    private static bool testReflection(string[] arr, int start) {
        for (int i = start, j = start + 1; i >= 0 && j < arr.Length; i--, j++) {
            if(arr[i] != arr[j]) { return false; }
        }
        return true;
    }
}