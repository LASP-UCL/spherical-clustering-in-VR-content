clc
clear all
close all 

%% Spherical clustering of users navigating in 360-degree content
% This script evaluates the clique clustering 
% presented in "SPHERICAL CLUSTERING OF USERS NAVIGATING 360? CONTENT"
%
% Author: s.rossi@ucl.ac.uk
%        F.De.Simone@cwi.nl
%        pascal.frossard@epfl.ch
%        l.toni@ucl.ac.uk
%
% User data position from Database presented in : 
%%% Xavier Corbillon, Francesca De Simone, and Gwendal Simon. 
%%% "360-Degree Video Head Movement Dataset". 
%%% In Proceedings of ACM Multimedia System (MMSys) 2017
% and algorithm 

addpath('Data_input/')
addpath('Functions/')
addpath('Results/')

flag = input(sprintf('Which Video to analyse? \n 1) Timelapse \n 2) Rollercoaster \n \n'));
if flag == 1
    Video_name = 'Timelapse';
    load('UsersData_Timelapse.mat')
elseif flag == 2
    Video_name = 'Rollercoaster';
    load('UsersData_Rollercoaster.mat')
end

geod_dist_th = pi/10;
D = 1.8;    %sec
frame_rate = 30;
D = D*frame_rate;   %in n. frames

n_users = size(Traj,2);
n_frames = size(Traj(1).data,1);


ch_length = input('Frame-based clustering ? [1] \n Trajectory-clustering? [n. fr. chunk - 90] ')    ;        %30 frames = %1 sec
if ch_length == 1
    D = 1;
end
clustering_rate = 1;        %input('Clustering rate ? [frames - 30 = 1sec] ')            %15;
ch = 1:ch_length:n_frames;


for i_ch = 1:length(ch)
    
    name = sprintf('Ch_%0.2d',i_ch);
    start_fr = ch(i_ch);
    selected_frames = start_fr:clustering_rate:start_fr+ch_length;
    selected_frames = selected_frames(1:end-1);
    
    
    for i_u = 1:n_users
        temp = Traj(i_u).data;
        Traj_temp(i_u,:).data = [temp(selected_frames,1) temp(selected_frames,2) temp(selected_frames,3)];
    end
    
    clique_clusters.(name) =  spherical_clustering(Traj_temp,geod_dist_th,D);
    
    
    %% Analysis Clique
%         filter_user = [];
%         Index_Clusters = [clique_clusters.(name)]';
%         K = max(Index_Clusters);
%         for i_frame = ch(i_ch):ch(i_ch)+ch_length-1
%             overlap_cl = zeros(K,1);
%             users_cl = zeros(K,1);
%             for i_cl = 1:K
%     
%                 user_cl = find(Index_Clusters == i_cl);
%                 if length(user_cl)>=1
%     
%                     overlap_cl(i_cl) = overall_intersection_quat(user_cl,quat,i_frame);
%     
%                 end
%                 users_cl(i_cl) = length(user_cl);
%             end
%             AnalysisResult(i_frame).overlap_clique = overlap_cl;
%             AnalysisResult(i_frame).Nusers = users_cl;
%         end
    
end

name_file = sprintf('%s_Results_overTime_ch_%0.2d_clRate_%d.mat',Video_name,ch_length,clustering_rate);
%  save(name_file,'AnalysisResult')

%% Plot results + 

load(name_file)
cc_Results = AnalysisResult;

if D==1
    name_file = sprintf('Results/%s_Results_overTime_ch_%0.2d_clRate_%d_otherAlg.mat',Video_name,ch_length,clustering_rate);
    load(name_file)
    
    Plot_results_traj(cc_Results,AnalysisResult,n_users)
else
    name_file = sprintf('Results/%s_results_Overlap_singleFrame_others.mat',Video_name);
    load(name_file)
    Plot_results_singleFrame(cc_Results,Itersec_ComDect,Itersec_Kmean_1,Itersec_Kmean_2,n_users)
end
