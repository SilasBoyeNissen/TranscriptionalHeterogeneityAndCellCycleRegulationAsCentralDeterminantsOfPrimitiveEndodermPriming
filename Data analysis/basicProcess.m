clc; clear; close all; tic;
%% This is the second file
% This script uses the converted Matlab files generated with basicConvert.m
% It calculates the lineage tree, the displacement and the speed pr. cell
% It takes into consideration the time where the medium was changed
% Finally, it outputs various plots and compiled XLS documents

%% Parameters
CONVERTED = '__Matlab converted files'; % The folder name where the converted Matlab files are saved.
OUTPUT = '__Output XLS files'; % The folder name where the compiled output XLS files will be saved.
PROCESSALL = 0; % 1 processes all converted Matlab files. 0 only processes the specific Matlab file names.
MATLABNAMES = {'4-71.mat','4-72.mat','4-73.mat','4-74.mat','4-75.mat','4-76.mat','4-77.mat','4-78.mat','4-79.mat','4-80.mat','4-81.mat','4-82.mat','4-83.mat','4-84.mat','4-85.mat','4-86.mat','4-87.mat','4-88.mat'}; % Specific Matlab file(s) to be processed (requires PROCESSALL = 0).

DIVIDECH1 = 5000; % normalize the intensities in channel 1 with this factor
DIVIDECH2 = 1400; % normalize the intensities in channel 2 with this factor

SAVEOUTPUTFILES = 0; % 1 saves the output XLS files. 0 does not create these files.
MAKECH2vsDISPLACEMENT = 0; % 1 makes the scatter plot: channel 2 vs displacement. 0 does not make this plot.
MAKECH1vsCH2 = 0; % 1 makes the scatter plot: channel 1 vs channel 2. 0 does not make this plot.
MAKETIMEvsCH2 = 0; % 1 makes the scatter plot: time vs channel 2. 0 does not make this plot.
MAKEDOUBLINGPLOTS = 0; % 1 makes doubling plots. 0 does not make doubling plots.
MAKELINEAGES = 0; % 1 makes lineage trees. 0 does not make lineage trees.
MAKEMOVIES = 0; % 1 makes movies. 0 does not make movies.

%% Time shifts
% this table indicates when the medium was changed
% the first number in {} is the unique file number
% the following numbers are the time in hours
% required to find the diplacement and the speed
TS{1}  = [23.33 49.33 88.33];
TS{2}  = [23.33 49.33 88.33];
TS{3}  = [23.33 49.33 88.33];
TS{4}  = [23.33 49.33 88.33];
TS{5}  = [23.33 49.33 88.33];
TS{6}  = [23.33 49.33 88.33];
TS{7}  = [23.33 49.33 88.33];
TS{8}  = [23.33 49.33 88.33];
TS{9}  = [23.33 49.33 88.33];
TS{10} = [23.33 49.33 88.33];
TS{19} = [21.66 45.33 67.66 91.00];
TS{20} = [21.66 45.33 67.66 91.00];
TS{21} = [21.66 45.33 67.66 91.00];
TS{22} = [21.66 45.33 67.66 91.00];
TS{23} = [21.66 45.33 67.66 91.00];
TS{24} = [21.66 45.33 67.66 91.00];
TS{30} = [23.33 49.33];
TS{31} = [23.33 49.33];
TS{32} = [23.33 49.33];
TS{33} = [23.33 49.33];
TS{34} = [23.33 49.33];
TS{35} = [23.33 49.33];
TS{36} = [23.33 49.33];
TS{37} = [23.33 49.33];
TS{38} = [23.33 49.33];
TS{51} = [23.33 45.66 91.33];
TS{52} = [23.33 45.66 91.33];
TS{53} = [23.33 45.66 91.33];
TS{54} = [23.33 45.66 91.33];
TS{55} = [23.33 45.66 91.33];
TS{56} = [23.33 45.66 91.33];
TS{57} = [25.33 47.00 73.66 96.33 118.33];
TS{58} = [25.33 47.00 73.66 96.33 118.33];
TS{59} = [25.33 47.00 73.66 96.33 118.33];
TS{60} = [25.33 47.00 73.66 96.33 118.33];
TS{61} = [25.33 47.00 73.66 96.33 118.33];
TS{62} = [25.33 47.00 73.66 96.33 118.33];
TS{63} = [25.33 47.00 73.66 96.33 118.33];
TS{64} = [25.33 47.00 73.66 96.33 118.33];
TS{65} = [23.33 45.66 91.00];
TS{66} = [23.33 45.66 91.00];
TS{67} = [25.33 47.00 73.66 96.33 118.33];
TS{68} = [25.33 47.00 73.66 96.33 118.33];
TS{69} = [25.33 47.00 73.66 96.33 118.33];
TS{70} = [25.33 47.00 73.66 96.33 118.33];
TS{71}  = [];
TS{72}  = [];
TS{73}  = [];
TS{74}  = [];
TS{75}  = [];
TS{76}  = [];
TS{77}  = [];
TS{78}  = [];
TS{79}  = [];
TS{80}  = [];
TS{81}  = [];
TS{82}  = [];
TS{83}  = [];
TS{84}  = [];
TS{85}  = [];
TS{86}  = [];
TS{87}  = [];
TS{88}  = [];

%% Script
mat = struct2cell(dir([CONVERTED '/Ch1/*.mat'])); % searches for all converted Matlab files
if PROCESSALL == 1
    rep = mat(1, :); % the Matlab file names to be processed
else
    rep = MATLABNAMES; % the Matlab file names to be processed
end
RA = zeros(1e6, 14); % initializes the compiled time dynamics matrix
SA = zeros(1e4, 17); % initializes the compiled single cell matrix
for no = 1:size(rep, 2) % loop over the requested Matlab files
    n = rep{no}(1:end-4); % the current file name before .mat
    disp(n); % displays the current file name to know how far the script is
    load([CONVERTED '/Position/' n]); % loads the position
    load([CONVERTED '/Time/' n]); % loads the time
    load([CONVERTED '/Ch1/' n]); % loads channel 1
    load([CONVERTED '/Ch2/' n]); % loads channel 2
    r = [repmat([str2double(n(1)) str2double(n(3:end))], size(pos, 1), 1) pos(:, 8) ones(size(pos, 1), 2) ...
        pos(:, 1:2) tim(:, 1) ch1(:, 1) ch2(:, 1)]; % merges all the time dynamics information for this file into one matrix
    r(:, 10) = r(:, 10)/DIVIDECH2; % divides channel 2 with the requested factor
    r(:, 9) = r(:, 9)/DIVIDECH1; % divides channel 1 with the requested factor
    if r(1, 2) == 51 % fixes an issue in '3-51.xls'
        r(r(:, 3) == 1000007150, :) = [];
        r(7708, :) = [];
    end
    r = timeshift(r, TS); % calculates the displacement and the speed
    id = unique(r(:, 3)); % list all unique original cell IDs
    s = zeros(size(id, 1), 17); % initializes the current file's single cell matrix
    for i = 1:size(id, 1) % loop over all original cell IDs
        r(r(:, 3) == id(i), 15) = i; % introduces a new and shorter cell ID
        ss = r(r(:, 3) == id(i), :); % takes all time indices with this cell ID
        s(i, [1:4 6:17]) = [ss(1, 1:5) ss(1, 6:7) ss(end, 6:7) min(ss(:, 8))-1/3 max(ss(:, 8)) max(ss(:, 8))-min(ss(:, 8)) ...
            mean(ss(:, 9:10)) sum(ss(:, 13)) mean(ss(:, 14))]; % merges all the single cell information for this file and this cell
        if i > 1 % do not do this for the first cell
            num = find(abs(s(1:i, 12) - s(i, 11)) < min(abs(s(1:i, 12) - s(i, 11)))+0.01); % finds all occurences of this cell
            if size(num, 1) > 1 % do this if this cell ID exists multiple times at the same time point
                num = num(sum(s(:, 5)==num') < 2); % remove number if it is already taken twice
                ID = knnsearch(s(num, 9:10), s(i, 7:8), 'K', 2); % find the nearest match
                num = num(ID(1)); % separates duplicates
            end
            s(i, 5) = num; % new cell ID
        end
    end
    triple = find(sum(s(:, 5)==s(:, 5)') == 3); % looks for cells with three children
    if ~isempty(triple) % if any cell has three children
        del = triple(ismember(triple, s(:, 5)) == 0); % looks for any of these children that does not have children themself
        s(del, :) = []; % remove a children without any children
        r(r(:, 15) > del, 15) = r(r(:, 15) > del, 15) - 1; % shifts the numbers correspondingly in r
        s(s(:, 5) > del, 5) = s(s(:, 5) > del, 5) - 1; % shifts the numbers correspondingly in s
    end
    [r, s] = calculate(max(SA(:, 4)), r, s); % calculates the lineage tree for the current file
    RA(find(RA(:, 1) == 0, 1):find(RA(:, 1) == 0, 1)+size(r, 1)-1, :) = r; % inserts the current file's time dynamics matrix into the compiled time dynamics matrix
    SA(find(SA(:, 1) == 0, 1):find(SA(:, 1) == 0, 1)+size(s, 1)-1, :) = s; % inserts the current file's single cell matrix into the compiled single cell matrix
end
RA(RA(:, 2) == 0, :) = []; % deletes unused preallocated rows in the compiled time dynamics matrix
SA(SA(:, 2) == 0, :) = []; % deletes unused preallocated rows in the compiled single cell matrix

%% Identify group 1-4 cells
[~, ~, ib] = intersect(setdiff(SA(:, 5), SA(SA(:, 11) < 0, 4)), SA(:, 4)); % find the indices for group 2 cells
SA(SA(:, 11) < 0, 18) = 1; % defines group 1 cells (does not have the start of the cell cycle, i.e. the first cell)
SA(ib, 18) = 2; % defines group 2 cells (have the entire cell cycle information, used for statistics)
for n = unique(SA(:, 2))' % loops over all data sets
    SA((SA(:, 2) == n) + (SA(:, 12) == max(SA(SA(:, 2) == n, 12))) == 2, 18) = 4; % defines group 4 cells (does not have the end of the cell cycle)
end
SA(SA(:, 18) == 0, 18) = 3; % defines group 3 cells (undergoes apoptosis)
SA(SA(:, 18) ~= 2, [13 16]) = 0; % sets doublingTime and Displacement to 0 for non-group 2 cells

%% Identify the cell types
SA = doublingAll(SA); % makes a compiled scatter plot and finds the different cell types
[~, ia] = setdiff(SA(:, 4), SA(:, 5)); % return cells that are not themcell a parent
[~, jb] = ismember(SA(ia, 5), SA(:, 4)); % finds the indices to change
SA(ia, 6) = SA(jb, 6); % spreads the cell type to all not full-cycle length in the single cell matrix
[ia, ib] = ismember(RA(:, 4), SA(:, 4)); % finds the indices to change
RA(ia, 5) = SA(ib(ib>0), 6); % spreads the cell type to all not full-cycle length in the time dynamics matrix

%% Various output options
for n = unique(SA(:, 2))' % loop over the requested Matlab files
    disp(n); % displays the current file name to know how far the script is
    if MAKELINEAGES == 1 % only if MAKELINEAGES is set to 1
        lineage(RA(RA(:, 2) == n, :), SA(SA(:, 2) == n, :)); % make lineage trees if requested
    end
    if MAKEDOUBLINGPLOTS == 1 % only if MAKEDOUBLINGPLOTS is set to 1
        doubling(SA(SA(:, 2) == n, :)); % make doubling plots if requested
    end
    if MAKEMOVIES == 1 % only if MAKEMOVIES is set to 1
        movies(RA(RA(:, 2) == n, :)); % make movies if requested
    end
end
if MAKECH1vsCH2 == 1 % only if MAKECH1vsCH2 is set to 1
    Ch1VsCh2(SA); % makes the scatter plot channel 1 vs channel 2
end
if MAKETIMEvsCH2 == 1 % only if MAKETIMEvsCH2 is set to 1
    TimeVsCh2(SA); % makes the scatter plot time vs channel 2
end
if MAKECH2vsDISPLACEMENT == 1 % only if MAKECH2vsDISPLACEMENT is set to 1
    Ch2VsDisplacement(SA); % makes the scatter plot channel 2 vs displacement
end
if SAVEOUTPUTFILES == 1 % only if SAVEOUTPUTFILES is set to 1
    writetable(array2table(SA, 'VariableNames', {'Setting', 'Dataset', 'OrgID', 'NewID', 'Parent', 'CellType', 'FirstXPos', ...
        'FirstYPos', 'LastXPos', 'LastYPos', 'FirstTime', 'LastTime', 'DoublingTime', 'MeanCh1', 'MeanCh2', 'Displacement', ...
        'Speed', 'Group'}), [OUTPUT '/Single cell data.xls']); % saves the compiled single cell matrix in the 'Single cell data.xls' file
    for i = 25:25:ceil(n/25)*25 % the 'Time dynamics data' file is huge and has to be split into multiple files
        writetable(array2table(RA((RA(:, 2) > i-25) + (RA(:, 2) <= i) == 2, :), 'VariableNames', {'Setting', 'Dataset', 'OrgID', ...
            'NewID', 'CellType', 'XPos', 'YPos', 'Time', 'Ch1', 'Ch2', 'XDisplacement', 'YDisplacement', 'Displacement', 'Speed'}), ...
            [OUTPUT '/Time dynamics data ' num2str(i/25) '.xls']); % saves the compiled time dynamics matrix in the 'Time dynamics data.xls' files
    end
end
toc;