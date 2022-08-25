function [r, s] = calculate(a, r, s)
y = 1;
in = [];
id = size(s, 1);
while y <= size(s, 1)
    in = [in id];
    r(r(:, 15) == id, 4) = y;
    s(id, 4) = y;
    y = y + 1;
    if y <= size(s, 1)
        loo = find(s(:, 5) == id)';
        son = setdiff(loo, in);
        while ~isempty(loo)
            son = setdiff(loo, in);
            if ~isempty(son)
                loo = find(s(:, 5) == son(1))';
            else
                break
            end
        end
        dad = [];
        loo = id;
        while isempty(dad)
            loo = s(loo, 5);
            dad = setdiff(loo, in);
        end
        if isempty(son) 
            id = dad;
        else
            id = son(1);
        end
    end
end
r(:, 4) = r(:, 4) + a;
s(:, 4) = s(:, 4) + a;
s(2:end, 5) = s(s(2:end, 5), 4);
r(:, end) = [];