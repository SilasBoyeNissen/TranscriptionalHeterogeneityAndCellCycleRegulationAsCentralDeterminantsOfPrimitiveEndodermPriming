function s = calculate(s)
y = 1;
in = [];
id = size(s, 1);
while y <= size(s, 1)
    in = [in id];
    s(id, 5) = y;
    y = y + 1;
    if y <= size(s, 1)
        loo = find(s(:, 4) == id)';
        son = setdiff(loo, in);
        while ~isempty(loo)
            son = setdiff(loo, in);
            if ~isempty(son)
                loo = find(s(:, 4) == son(1))';
            else
                break
            end
        end
        dad = [];
        loo = id;
        while isempty(dad)
            loo = s(loo, 4);
            dad = setdiff(loo, in);
        end
        if isempty(son) 
            id = dad;
        else
            id = son(1);
        end
    end
end
s(2:end, 4) = s(s(2:end, 4), 5);