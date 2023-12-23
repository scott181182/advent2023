
function prediction = prev_value(row)
    if ~any(row)
        prediction = 0;
    else
        prev_pred = prev_value(diff(row));
        prediction = row(1) - prev_pred;
    end
end

args = argv();
filename = args{1};

input = int64(dlmread(filename, " "));
row_cells = num2cell(input, 2);

% prev_value(input(end-1, :))
prev_values = cellfun(@prev_value, row_cells);

answer = sum(prev_values);
printf("Answer = %lu\n", answer)
