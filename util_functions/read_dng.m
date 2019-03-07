function [img_info, img_raw] = read_dng(name_dng)
    img_info = imfinfo(name_dng); % --> Read meta data

    img_tiff = Tiff(name_dng,'r');
    offsets = getTag(img_tiff,'SubIFD');
    setSubDirectory(img_tiff,offsets(1));
    img_raw = read(img_tiff); % --> Get raw data, Bayer CFA data

    % Crop to only valid pixels
    x_origin = img_info.SubIFDs{1}.ActiveArea(2)+1;
    width = img_info.SubIFDs{1}.DefaultCropSize(1);
    y_origin = img_info.SubIFDs{1}.ActiveArea(1)+1;
    height = img_info.SubIFDs{1}.DefaultCropSize(2);
    img_raw = double(img_raw(y_origin:y_origin+height-1,x_origin:x_origin+width-1));
end