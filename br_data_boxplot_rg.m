%% Breathing rate p2p box plot

clear all; clc;

number_trials = 6;
stored_trials = cell(number_trials,1); % empty cell array with rows to store data from each trial
stored_trial_names = cell(number_trials,1); % empty cell array to store trial names for boxplot labels

total_number_data_points = 0; %int to keep track of total number of data points across all trials

%populate cell array
stored_trials{1,1} = load('pilot_01_trial_01.mat');
stored_trials{2,1} =  load('pilot_01_trial_02.mat');
stored_trials{3,1} =  load('pilot_01_trial_03.mat');
stored_trials{4,1} =  load('pilot_01_trial_04.mat');
stored_trials{5,1} =  load('pilot_01_trial_05.mat');
stored_trials{6,1} =  load('pilot_01_trial_06.mat');

total_number_data_points = size(stored_trials{1,1},1) + size(stored_trials{2,1},1) + size(stored_trials{3,1},1) + size(stored_trials{4,1},1) + size(stored_trials{5,1},1) + size(stored_trials{6,1},1);

%populate stored trial names
stored_trial_names{1,1} = 'Baseline';
stored_trial_names{2,1} = 'Supra BR 2';
stored_trial_names{3,1} = 'Sub BR 0.2';
stored_trial_names{4,1} = 'Control';
stored_trial_names{5,1} = 'Sub BR 0.3';
stored_trial_names{6,1} = 'Supra BR 0.9';

%% box plot generation

x = zeros(total_number_data_points,1); % total data values
g = zeros(total_number_data_points,1); % grouping variables - keeps track of which data points are from which trial
index = 1;
for i = 1:number_trials
    for j = 1:size(stored_trials{i,1}.to_save(:,3),1) %iterates through all values in each trial in cell 1. Choose column 3 for median values, 2 otherwise
        x(index,1) = stored_trials{i,1}.to_save(j,3);
        g(index,1) = i;
        index = index + 1;
    end
end

boxplot(x,g,'Labels', stored_trial_names);
ylim([7 27]);
title('Pilot 01: Comparison of 6 trials', 'FontSize', 14);