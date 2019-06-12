% INTENSITY ALIGNMENT OF A SET OF IMAGES
function [raw_intensity_aligned, I] = intensity_alignment(images_raw)

    % i) Average intensity of all images
    mean_i = avg_imgs(images_raw);

    % ii) Calculate mean_a and std_a of dist. of all mean_i
    mean_a = mean(mean_i);
    std_a = std(mean_i);%.*(length(mean_i)-1);

    % iii) Remove all images outside a 99.9% of confidence interval
    
    [IC_low, IC_high] = confidence(mean_i, mean_a, std_a, 0);
    % ENCONTRAR UN INTERVALO M·S GRANDE (10% de la media p.ex.)
   
    new_mean_i = mean_i;
    new_mean_i(IC_high < new_mean_i) = -10;
    new_mean_i(IC_low > new_mean_i) = -10;
    I = find(new_mean_i == -10);

    new_mean_i(I) = [];

    new_images_raw = images_raw;
    new_images_raw(I) = [];

    % iv) Recalculate mean_a and perform intensity alignment
    new_mean_a = mean(new_mean_i);
    new_std_a = std(new_mean_i);

    raw_intensity_aligned = {};
    rgb_intensity_aligned = {};

    for i = 1:length(new_images_raw)
        img_raw = new_images_raw{i};

        c = round(-new_mean_i(i) + new_mean_a);
        new_img_raw = img_raw + c;
        raw_intensity_aligned{i} = new_img_raw;

    end

end



