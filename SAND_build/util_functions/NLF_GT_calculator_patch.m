function [NLF] = NLF_GT_calculator_patch(path_GT, paths_noisy, step, X, Y, W)
    
    GT_img = im2double(imread(path_GT));
    GT_img = GT_img(X:X+W,Y:Y+W,:);
    std_img = zeros(size(GT_img));
    
    N = length(paths_noisy);
    for i = 1:N
        jpg_img = im2double(imread(paths_noisy{i}));
        jpg_img = jpg_img(X:X+W,Y:Y+W,:);
        std_img = std_img + (jpg_img-GT_img).^2;

    end

    std_img = sqrt(std_img ./ N);
    
    med_r = GT_img(:,:,1);
    med_r = med_r(:);
    std_r = std_img(:,:,1);
    std_r = std_r(:);

    med_g = GT_img(:,:,2);
    med_g = med_g(:);
    std_g = std_img(:,:,2);
    std_g = std_g(:);

    med_b = GT_img(:,:,3);
    med_b = med_b(:);
    std_b = std_img(:,:,3);
    std_b = std_b(:);
    
    [med_r_sorted, med_r_order] = sort(med_r);
    new_std_r = std_r(med_r_order);

    [med_g_sorted, med_g_order] = sort(med_g);
    new_std_g = std_g(med_g_order);

    [med_b_sorted, med_b_order] = sort(med_b);
    new_std_b = std_b(med_b_order);

    NLF_r = zeros(1,256);
    NLF_g = zeros(1,256);
    NLF_b = zeros(1,256);

    for i = 1:step:256

        aux = find(med_r_sorted < i/256 & med_r_sorted > (i-1)/256 );
        NLF_r(i:i+step-1) = mean(new_std_r(aux));

        aux = find(med_g_sorted < i/256 & med_g_sorted > (i-1)/256 );
        NLF_g(i:i+step-1) = mean(new_std_g(aux));

        aux = find(med_b_sorted < i/256 & med_b_sorted > (i-1)/256 );
        NLF_b(i:i+step-1) = mean(new_std_b(aux));

    end
    
    NLF = [NLF_r, NLF_g, NLF_b];
    
end