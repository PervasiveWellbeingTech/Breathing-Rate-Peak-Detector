close all;
clear all; clc;
%Remember every 2 points are separated by 40 ms, or 25 Hz in this data
trial = 2; %Change it for the 6 trials
% Length of each trial (in seconds)
period = 120; %seconds, need to change based on trial length
samp_freq = 25; %Hz is the rate at which it seems to have been collected assuming equal spacing between consecutive

Trial_Start_Idx = 75; %Need to change the first index from Zephyr raw data when 1st trial starts for each subject
Start_idx = Trial_Start_Idx + (trial-1)*period*samp_freq; 
End_idx = Start_idx + period*samp_freq-1;


[filename, pathname] = uigetfile('*.csv', ' Please select the Breathing Rate & R-R Input file');

CompletePathwFilename = strcat(pathname,filename);
fid = fopen(CompletePathwFilename);
BR_RR_data = textscan(fid,'%s %f %f','HeaderLines',1,'Delimiter',',','CollectOutput',1);
fclose(fid);

Actual_BR_RR_Data = BR_RR_data{1,2};
Breathing_Rate_Data = Actual_BR_RR_Data(:,1);

BR_Data = Breathing_Rate_Data(Start_idx:End_idx);


timeBR = transpose(0:1/samp_freq:length(BR_Data)/samp_freq-1/samp_freq);
clearvars -except timeBR samp_freq BR_Data trial BR_Data_unfiltered period;


figure('units','normalized','outerposition',[0 0 1 1]);
subbreathe_plot = tight_subplot(1,1, [0.05 0], [0.15 0.05], [0.05 0.01]);
axes(subbreathe_plot(1));
plot(timeBR,BR_Data,'b');
xlabel('Time (s)','fontsize', 12,'fontweight','bold');
set(gca,'TickDir','in','fontsize',12,'fontweight','bold');
ylabel('Breathing Rate Raw','fontsize', 12, 'fontweight','bold');
title(['Trial :',num2str(trial)],'fontsize', 12, 'fontweight','bold');
xlim([0 period]);

[LOCS_BR,PKS_BR] = ginput(2);  %%gives you start and end time, need to convert to index
start_user_val = LOCS_BR(1,1)*samp_freq; %25 hz sample rate
start_user_idx = round(start_user_val); %start index value once user has selected
end_user_val = LOCS_BR(2,1)*samp_freq; %25 hz sample rate
end_user_idx = round(end_user_val); %start index value once user has selected

% cuts data with ginput places
BR_Data_User_Input = BR_Data(start_user_idx:end_user_idx);

BR_Data_unfiltered = BR_Data_User_Input;

timeBR = transpose(0:1/samp_freq:length(BR_Data_User_Input)/samp_freq-1/samp_freq);
clearvars -except timeBR samp_freq BR_Data_User_Input trial BR_Data_unfiltered;

%%
max_BR_cut_off = 30; %in Hz This we can consider to change, this is the max BR we expect subject to have
minPeakDist = 60/(max_BR_cut_off/samp_freq);

[PKS_BR2,LOCS_BR2] = findpeaks(BR_Data_User_Input,'MinPeakHeight',median(BR_Data_User_Input),'MinPeakDistance',minPeakDist,'MaxPeakWidth',50,'MinPeakWidth',2); %in this I am using mean BR as the min size of the peak to be detected but we can change it if it doesn't work for most of the data

TimeBetweenPeaks = timeBR(LOCS_BR2,1);
Diff_TimePeaks = diff(TimeBetweenPeaks);
BR_freq = 60./Diff_TimePeaks; %bpm
BR_Time = LOCS_BR2(2:end,1)/samp_freq;
BR_freq2 = medfilt1(BR_freq);

figure('units','normalized','outerposition',[0 0 1 1]);
subbreathe_plot = tight_subplot(2,1, [0.05 0], [0.15 0.05], [0.05 0.01]);
axes(subbreathe_plot(1));
plot(timeBR,BR_Data_unfiltered,'r',timeBR,BR_Data_User_Input,'b',timeBR(LOCS_BR2),BR_Data_User_Input(LOCS_BR2),'k*');
target =median(BR_Data_User_Input);
yline(target,'k', 'LineWidth', 2);
legend('BR unfiltered','BR Peaks','BR Median');
set(gca,'XTick',[],'TickDir','in','fontsize',12,'fontweight','bold');
ylabel('Breathing Rate Raw','fontsize', 12, 'fontweight','bold');
title(['Trial :',num2str(trial)],'fontsize', 12, 'fontweight','bold');

axes(subbreathe_plot(2));
plot(BR_Time,BR_freq,'b', BR_Time, BR_freq2, 'r');
xlabel('Time (s)','fontsize', 12,'fontweight','bold');
ylabel('Breathing Rate (BPM)','fontsize', 12,'fontweight','bold');
set(gca,'TickDir','in','fontsize',12,'fontweight','bold');
legend('BR from Peaks','BR Median filter');

saveas(gca, "pilot_01_trial_" + num2str(trial) + ".tif"); %edit for each pilot number

to_save = [BR_Time,BR_freq, BR_freq2];
save(['pilot_01_trial_',num2str(trial),'.mat'],'to_save');
