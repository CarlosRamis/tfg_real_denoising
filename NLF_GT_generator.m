clear all;
warning('off','all');
addpath('util_functions')

scene = 'Scene_5';

name_median = ['Dataset_Final/GT_median_Scene_05.jpg'];
med_img = im2double(imread(name_median));

jpg_noisy_imgs = {};

std_img = (zeros(3072,4608,3));
%%
N = 30;
var = 0.01;
for i = 1:N
    
    jpg_img = imnoise(med_img,'gaussian',0, var^2);
    std_img = std_img + (jpg_img-med_img).^2;
    
end

std_img = sqrt(std_img ./ N);
%%
med_r = med_img(:,:,1);
med_r = med_r(:);

std_r = std_img(:,:,1);
std_r = std_r(:);

%%
figure,plot(med_r,std_r,'*')
%%

[med_r_sorted, med_r_order] = sort(med_r);
new_std_r = std_r(med_r_order);

NLFF = zeros(1,256);

for i = 1:256
    
    aux = find(med_r_sorted < i/256 & med_r_sorted > (i-1)/256 );
    NLFF(i) = mean(new_std_r(aux));
    
end
%%
figure,plot(NLFF)
xlabel('mean intensity')
ylabel('std')
