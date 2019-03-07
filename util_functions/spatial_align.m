function [final_moved_raw, final_moved_rgb] = spatial_align(img_raw1, img_raw2, path_ref)
    %[img_raw1, ref_rgb] = path_to_img(path_ref);
    %[img_raw2, ~] = path_to_img(path_mov);
    %%
    image_ref = img_raw1(1:2:end,1:2:end);
    [h_ref, w_ref] = size(image_ref);

    image_i = img_raw2(1:2:end,1:2:end);

    % Split channels
    img_raw1_g1 = image_ref;
    img_raw1_b = img_raw1(1:2:end,2:2:end);
    img_raw1_r = img_raw1(2:2:end,1:2:end);
    img_raw1_g2 = img_raw1(2:2:end,2:2:end);

    img_raw2_g1 = image_i;
    img_raw2_b = img_raw2(1:2:end,2:2:end);
    img_raw2_r = img_raw2(2:2:end,1:2:end);
    img_raw2_g2 = img_raw2(2:2:end,2:2:end);

    landmarks_dest_r = [];
    landmarks_source_r = [];
    landmarks_dest_g1 = [];
    landmarks_source_g1 = [];
    landmarks_dest_g2 = [];
    landmarks_source_g2 = [];
    landmarks_dest_b = [];
    landmarks_source_b = [];
    path_size = 400;
    step = 399;
    usfac = 10;

    disp('init patch dftR')
    for i =1+path_size/2:step:h_ref - path_size
        for j =1+path_size/2:step:w_ref - path_size

            landmarks_dest_r = [landmarks_dest_r; [i,j]];
            img_ref_patch_r = img_raw1_r(i-path_size/2:i+path_size/2,j-path_size/2:j+path_size/2);
            img_i_patch_r = img_raw2_r(i-path_size/2:i+path_size/2,j-path_size/2:j+path_size/2);

            [output, ~] = dftregistration(fft2(img_ref_patch_r), fft2(img_i_patch_r), usfac);
            landmarks_source_r = [landmarks_source_r; [i-output(3), j-output(4)]];

            landmarks_dest_g1 = [landmarks_dest_g1; [i,j]];
            img_ref_patch_g1 = img_raw1_g1(i-path_size/2:i+path_size/2,j-path_size/2:j+path_size/2);
            img_i_patch_g1 = img_raw2_g1(i-path_size/2:i+path_size/2,j-path_size/2:j+path_size/2);

            [output, ~] = dftregistration(fft2(img_ref_patch_g1), fft2(img_i_patch_g1), usfac);
            landmarks_source_g1 = [landmarks_source_g1; [i-output(3), j-output(4)]];

            landmarks_dest_g2 = [landmarks_dest_g2; [i,j]];
            img_ref_patch_g2 = img_raw1_g2(i-path_size/2:i+path_size/2,j-path_size/2:j+path_size/2);
            img_i_patch_g2 = img_raw2_g2(i-path_size/2:i+path_size/2,j-path_size/2:j+path_size/2);

            [output, ~] = dftregistration(fft2(img_ref_patch_g2), fft2(img_i_patch_g2), usfac);
            landmarks_source_g2 = [landmarks_source_g2; [i-output(3), j-output(4)]];

            landmarks_dest_b = [landmarks_dest_b; [i,j]];
            img_ref_patch_b = img_raw1_b(i-path_size/2:i+path_size/2,j-path_size/2:j+path_size/2);
            img_i_patch_b = img_raw2_b(i-path_size/2:i+path_size/2,j-path_size/2:j+path_size/2);

            [output, ~] = dftregistration(fft2(img_ref_patch_b), fft2(img_i_patch_b), usfac);
            landmarks_source_b = [landmarks_source_b; [i-output(3), j-output(4)]];

        end
    end
    disp('finished patch dftR')
    %%
    addpath('tpsWarp')
    disp('init tpsWarp')
    interp.method = 'nearest'; %'invdist'; %'nearest'; %'none' % interpolation method
    interp.radius = 5; % radius or median filter dimension
    interp.power = 2; %power for inverse wwighting interpolation method

    [imgw_r, imgwr_r, map_r] = tpswarp(img_raw2_r, size(image_ref'), landmarks_source_r , landmarks_dest_r, interp);
    [imgw_g1, imgwr_g1, map_g1] = tpswarp(img_raw2_g1, size(image_ref'), landmarks_source_g1 , landmarks_dest_g1, interp);
    [imgw_g2, imgwr_g2, map_g2] = tpswarp(img_raw2_g2, size(image_ref'), landmarks_source_g2 , landmarks_dest_g2, interp);
    [imgw_b, imgwr_b, map_b] = tpswarp(img_raw2_b, size(image_ref'), landmarks_source_b , landmarks_dest_b, interp);


    disp('finished tpsWarp')

    %% 
    final_moved_raw = uint16(zeros(size(img_raw1)));

    final_moved_raw(1:2:end,1:2:end) = imgw_g1;
    final_moved_raw(1:2:end,2:2:end) = imgw_b;
    final_moved_raw(2:2:end,1:2:end) = imgw_r;
    final_moved_raw(2:2:end,2:2:end) = imgw_g2;

    img_info2 = imfinfo(path_ref);
    
    if (0)
        final_moved_rgb = camerapipeline(final_moved_raw,img_info2);
    else
        final_moved_rgb = 0;
    end
end 
