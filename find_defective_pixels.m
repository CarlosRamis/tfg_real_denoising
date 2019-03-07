% FIND DEFFECTIVE PIXELS OF A CAMERA
% 
% Given the mean and std of a sort of lightless images taken with a certain 
% camera, this following code find the position of defective pixels.
% 

clear all;
warning('off','all');
addpath('util_functions')

%% i) Load mean and std images
mat_file = matfile('MAT_FILES/mean_img_defective_D3100_2.mat');
mean_image = mat_file.mean_image;

mat_file = matfile('MAT_FILES/std_img_defective_D3100_2.mat');
std_image = mat_file.std_image;

%% ii) Order the mean and std values
[sorted_mean,index_sorted_mean] = sort(mean_image(:),'descend');
[sorted_std,index_sorted_std] = sort(std_image(:),'descend');
twenty_i_mean = index_sorted_mean(1:141); % ---> 0.001% of pixels
twenty_i_std = index_sorted_std(1:141);

%% iii) Find defective pixels
ind_std_mean = intersect(twenty_i_mean,twenty_i_std);

[i_indices,j_indices] = ind2sub([size(mean_image,1),size(mean_image,2)],ind_std_mean);

indices_defective = [i_indices,j_indices];

save('MAT_FILES/indices_defective.mat','indices_defective')
