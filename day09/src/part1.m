
function prediction = next_value(row)
    if ~any(row)
        prediction = 0;
    else
        next_pred = next_value(diff(row));
        prediction = next_pred + row(end);
    end
end

args = argv();
filename = args{1};

input = int64(dlmread(filename, " "));
row_cells = num2cell(input, 2);

% next_value(input(end-1, :))
next_values = cellfun(@next_value, row_cells);

answer = sum(next_values);
printf("Answer = %lu\n", answer)
