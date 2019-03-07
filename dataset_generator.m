% DATASET IMAGE GENERATOR
% 
% With this script the dataset images are generated. So, given images from
% a same scene are generated:
%     - Ground truth image
%     - Real noisy image
%     - High ISO noisy image
% 

clear all;
warning('off','all');
addpath('util_functions')

%% i) Get the paths of the images that we want as GT
scene = 'Scene_07';
names_dng = glob(['DatasetD3100/',scene,'/ISO400_Fn4.5_exp0.01_*.dng']);
images_aligned_raw = {};

names_highISO_dng = glob(['DatasetD3100/',scene,'/ISO3200_Fn11_exp0.01_2.dng']);
[img_highISO_info, img_raw_highISO] = read_dng(names_highISO_dng{1});

images_raw = {};
for i = 1:length(names_dng)
    [img_info, img_raw] = read_dng(names_dng{i});
    images_raw{i} = img_raw;
end

%% ii) Interpolate defective pixels
mat_file = matfile('MAT_FILES/indices_defective.mat');
indices_defective = mat_file.indices_defective;

for i = 1:length(images_raw)
    
    images_raw{i} = interpolate_defective(images_raw{i}, indices_defective);
    
end

%% iii) Align them in the space 
if 1
    disp('Init spatial alignment')
    for i = 1:length(images_raw)

        disp(i)
        [final_moved_raw, ~] = spatial_align(images_raw{1}, images_raw{i}, names_dng{1});
        images_aligned_raw{i} = final_moved_raw;

    end
    disp('Finished spatial alignment')
end

%% iv) Intensity align (and interpolation defective pixels)
disp('Init intensity align')
[raw_intensity_aligned, I] = intensity_alignment(images_aligned_raw);
disp('Finished intensity align')

%% v) Calculate median image
disp('Init median image')
H = size(final_moved_raw,1);
W = size(final_moved_raw,2);

median_image = uint16(zeros(H,W));
for i = 1:H
    for j = 1:W

        median_pixel = [];
        for k = 1:length(images_aligned_raw)
            raw_aux = images_aligned_raw{k};
            median_pixel(k) = raw_aux(i,j);
        end

        median_image(i,j) = median(median_pixel);

    end
end

save(['MAT_FILES/median_final_img_',scene,'.mat'],'median_image');
disp('Finished mean image')

%% vi) Calculate RGB/RAW reference and mean images
disp('Init RGB')
[img_info, img_raw_ref] = read_dng(names_dng{1});
% mean_image_rgb = camerapipeline((mean_image),img_info);
median_image_rgb = camerapipeline((median_image),img_info);

ref_image_rgb = camerapipeline(img_raw_ref, img_info);
disp('Finished RGB')

%% vii) Save to .jpg
imwrite(ref_image_rgb,['Dataset_Final/GT_ref_', scene,'.jpg']);
imwrite(median_image_rgb,['Dataset_Final/GT_median_', scene,'.jpg']);

%% viii) Generate and save high ISO image
disp('init spatial align with high iso')

[highISO_moved_raw, ~] = spatial_align(raw_intensity_aligned{1}, img_raw_highISO, names_dng{1});
highISO_image_rgb = camerapipeline(highISO_moved_raw, img_highISO_info);
imwrite(highISO_image_rgb,['Dataset_Final/GT_highISO_', scene,'.jpg']);

disp('finished spatial align with high iso')
