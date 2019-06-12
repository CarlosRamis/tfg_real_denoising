function [mean_i] = avg_imgs(images_raw)
    mean_i = [];
    for i = 1:length(images_raw)
        img_raw = images_raw{i};

        % interpolation
        img_raw(1992,3227) = round(mean([img_raw(1992+2,3227),img_raw(1992,3227+2),img_raw(1992-2,3227),img_raw(1992,3227-2)]));
        
        % Avg intensity of img
        mean_i = [mean_i, mean(mean(img_raw))];
    end
end