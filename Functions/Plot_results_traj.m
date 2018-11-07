function [] = Plot_results_traj(cc_Results,AnalysisResult,n_users)
%This function plot results presented in
%       "SPHERICAL CLUSTERING OF USERS NAVIGATING 360? CONTENT"
%
%Author: s.rossi@ucl.ac.uk
%        F.De.Simone@cwi.nl
%        pascal.frossard@epfl.ch
%        l.toni@ucl.ac.uk

n_frames = size(cc_Results,2);

inter_cc = zeros(n_frames,1);
var_cc = zeros(n_frames,1);
inter_sc_1 = zeros(n_frames,1);
var_sc_1 = zeros(n_frames,1);
inter_sc_2 = zeros(n_frames,1);
var_sc_2 = zeros(n_frames,1);
inter_sc_3 = zeros(n_frames,1);
var_sc_3 = zeros(n_frames,1);

for i_frame = 1:n_frames
    total_intersec_cc = cc_Results(i_frame).overlap_clique;
    user_cc = cc_Results(i_frame).Nusers;
    
    %%Gw results
    total_intersec_sc_1 = AnalysisResult(i_frame).overlap_ori; %clustering per chunk
    total_intersec_sc_2 = AnalysisResult(i_frame).overlap_myK; % given K
    total_intersec_sc_3 = AnalysisResult(i_frame).overlap_constantK; % clustering entire video
    
    
    user_sc_1 = AnalysisResult(i_frame).Nusers_ori;
    user_sc_2 = AnalysisResult(i_frame).Nusers_myK;
    user_sc_3 = AnalysisResult(i_frame).Nusers_constantK;
    
    inter_cc(i_frame) = mean(total_intersec_cc);
    var_cc(i_frame) = var(total_intersec_cc(:));
    inter_sc_1(i_frame) = mean(total_intersec_sc_1);
    var_sc_1(i_frame) = var(total_intersec_sc_1(1,:));
    inter_sc_2(i_frame) = mean(total_intersec_sc_2);
    var_sc_2(i_frame) = var(total_intersec_sc_2(1,:));
    inter_sc_3(i_frame) = mean(total_intersec_sc_3);
    var_sc_3(i_frame) = var(total_intersec_sc_3(1,:));
    
    filter = find(user_cc~=1);
    inter_cc_f(i_frame) = mean(total_intersec_cc(filter));
    var_cc_f(i_frame) = var(total_intersec_cc(filter));
    pop_cc(i_frame) = sum(user_cc(filter))/n_users;
    
    filter = find(user_sc_1~=1);
    inter_sc_1_f(i_frame) = mean(total_intersec_sc_1(filter));
    var_4_f(i_frame) = var(total_intersec_sc_1(filter));
    pop_4(i_frame) = sum(user_sc_1(filter))/n_users;
    
    filter = find(user_sc_2~=1);
    inter_sc_2_f(i_frame) = mean(total_intersec_sc_2(filter));
    var_5_f(i_frame) = var(total_intersec_sc_2(filter));
    pop_5(i_frame) = sum(user_sc_2(filter))/n_users;
    
    filter = find(user_sc_3~=1);
    inter_sc_3_f(i_frame) = mean(total_intersec_sc_3(filter));
    var_6_f(i_frame) = var(total_intersec_sc_3(filter));
    pop_6(i_frame) = sum(user_sc_3(filter))/n_users;
    
    
end

inter_cc(2:end) = filtfilt(ones(1,15)/15,1,inter_cc(2:end));
inter_sc_1(2:end) = filtfilt(ones(1,15)/15,1,inter_sc_1(2:end));
inter_sc_2(2:end) = filtfilt(ones(1,15)/15,1,inter_sc_2(2:end));
inter_sc_3(2:end) = filtfilt(ones(1,15)/15,1,inter_sc_3(2:end));

var_cc(2:end) = filtfilt(ones(1,15)/15,1,var_cc(2:end));
var_sc_1(2:end) = filtfilt(ones(1,15)/15,1,var_sc_1(2:end));
var_sc_2(2:end) = filtfilt(ones(1,15)/15,1,var_sc_2(2:end));
var_sc_3(2:end) = filtfilt(ones(1,15)/15,1,var_sc_3(2:end));

figure
x = [1:i_frame]/30;
x = x;
hold on
clear y
y = inter_sc_1(1:i_frame);
yu = y+var_sc_1(1:i_frame);
yl = y-var_sc_1(1:i_frame);
fill([x fliplr(x)], [yu'*100 fliplr(yl'*100)],[0.85 0.85 0.85], 'linestyle', 'none', 'HandleVisibility','off')
hold on
clear y
y = inter_sc_3(1:i_frame);
yu = y+var_sc_3(1:i_frame);
yl = y-var_sc_3(1:i_frame);
fill([x fliplr(x)], [yu'*100 fliplr(yl'*100)],[222, 150, 210]/255, 'linestyle', 'none', 'HandleVisibility','off')
clear y
y = inter_sc_2(1:i_frame);
yu = y+var_sc_2(1:i_frame);
yl = y-var_sc_2(1:i_frame);
fill([x fliplr(x)], [yu'*100 fliplr(yl'*100)],[0 0.6 0.3], 'linestyle', 'none', 'HandleVisibility','off')
hold on
clear y
y = inter_cc(1:i_frame);
yu = y+var_cc(1:i_frame);
yl = y-var_cc(1:i_frame);
fill([x fliplr(x)], [yu'*100 fliplr(yl'*100)],[255, 99, 75]/255, 'linestyle', 'none', 'HandleVisibility','off')
hold on

xlabel('sec')
ylabel('% Overall intersection VPs')
%title(sprintf('%s - Average NO weighted overall intersection ',Video_name))
grid on
set(gca,'fontsize',30)
axis([1/30 (i_frame)/30 0 100])
y = inter_cc(1:i_frame);
plot(x,y*100,'r','LineWidth',3)
y = inter_sc_1(1:i_frame);
plot(x,y*100,'k','LineWidth',3)
y = inter_sc_3(1:i_frame);
plot(x,y*100,'m','LineWidth',3)
y = inter_sc_2(1:i_frame);
plot(x,y*100,'g','LineWidth',3)


legend(sprintf(' Clique clustering (%0.2f )',mean(inter_cc_f)*100),sprintf(' SC - T = 3s (%0.2f ) ',mean(inter_sc_1_f)*100),sprintf(' SC - entire video (%0.2f )',mean(inter_sc_3_f)*100),sprintf('SC - K given (%0.2f )',mean(inter_sc_2_f)*100))

end

