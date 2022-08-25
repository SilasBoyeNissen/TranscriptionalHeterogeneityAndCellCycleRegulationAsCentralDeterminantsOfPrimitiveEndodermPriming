clc; clear; close all; tic;
%% Run this script first
% This script extracts the relevant sheets from the original XLS file
% and converts them into tiny Matlab files for further fast usage

%% Required file convention
% The input (original) XLS file has to be named 'X-XX.xls'
% The first number (X) indicates the experimental setup
% The second number (XX) has to be a unique file number
% This file has to be saved in the input XLS folder

%% Parameters
INPUT = '__Input XLS files'; % The folder name where the input (original) XLS files are saved.
CONVERTED = '__Matlab converted files'; % The folder name where the converted Matlab files will be saved.
CONVERTSALL = 0; % 1 converts all XLS files in the input folder. 0 only converts the specific XLS file names.
XLSFILENAME = {'4-71.xls', '4-72.xls', '4-73.xls', '4-74.xls', '4-75.xls', '4-76.xls', '4-77.xls', '4-78.xls', '4-79.xls', '4-80.xls', '4-81.xls', '4-82.xls', '4-83.xls', '4-84.xls', '4-85.xls', '4-86.xls', '4-87.xls', '4-88.xls'}; % Specific XLS file(s) to be converted (requires CONVERTSALL = 0).

%% Script
mat = struct2cell(dir([INPUT '/*.xls'])); % searches for all XLS files in the folder
if CONVERTSALL == 1
    rep = mat(1, :); % the XLS file names to be converted
else
    rep = XLSFILENAME; % the XLS file names to be converted
end
for no = 1:size(rep, 2) % loops over the requested XLS files
    f = num2str(rep{no}(1:end-4)); % the current file name before .xls
    disp(f); % displays the current file name to know how far the script is
    [~, x] = xlsfinfo([INPUT '/' f]); % extracts information about the sheets
    tim = xlsread([INPUT '/' f], 'Time'); % reads the time sheet
    pos = xlsread([INPUT '/' f], 'Position'); % reads the position sheet
    ch1 = xlsread([INPUT '/' f], x{find(contains(x, 'Intensity Median Ch=1'), 1)}); % searchers for and reads the channel 1 sheet
    ch2 = xlsread([INPUT '/' f], x{find(contains(x, 'Intensity Median Ch=2'), 1)}); % searchers for and reads the channel 2 sheet
    ch1(isnan(ch1(:, end-1)), :) = []; % deletes invalid NaN input in channel 1
    ch2(isnan(ch2(:, end-1)), :) = []; % deletes invalid NaN input in channel 2
    pos(isnan(pos(:, end-1)), :) = []; % deletes invalid NaN input in the position
    tim(isnan(tim(:, end-1)), :) = []; % deletes invalid NaN input in the time
    ch1 = sortrows(ch1, size(ch1, 2)); % sorts the channel 1 rows according to the last column
    ch2 = sortrows(ch2, size(ch2, 2)); % sorts the channel 2 rows according to the last column
    pos = sortrows(pos, size(pos, 2)); % sorts the position rows according to the last column
    tim = sortrows(tim, size(tim, 2)); % sorts the time rows according to the last column
    save([CONVERTED '/Position/' f], 'pos'); % saves the position sheet in a matlab file
    save([CONVERTED '/Time/' f], 'tim'); % saves the time sheet in a matlab file
    save([CONVERTED '/Ch1/' f], 'ch1'); % saves the channel 1 sheet in a matlab file
    save([CONVERTED '/Ch2/' f], 'ch2'); % saves the channel 2 sheet in a matlab file
end
toc;