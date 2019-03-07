% CAMERA PIPELINE FUNCTION

function [img_nlsrgb] = camerapipeline(img_raw, img_info)

    % Crop to only valid pixels
    x_origin = img_info.SubIFDs{1}.ActiveArea(2)+1;
    width = img_info.SubIFDs{1}.DefaultCropSize(1);
    y_origin = img_info.SubIFDs{1}.ActiveArea(1)+1;
    height = img_info.SubIFDs{1}.DefaultCropSize(2);
    img_raw = double(img_raw(y_origin:y_origin+height-1,x_origin:x_origin+width-1));

    %% LINEARITZATION

    if isfield(img_info.SubIFDs{1},'LinearizationTable')
        ltab=img_info.SubIFDs{1}.LinearizationTable;
        img_raw_1 = img_raw + 1;
        img_raw_1(img_raw_1>772)=772;
        img_raw = ltab(img_raw_1);
    end

    black = img_info.SubIFDs{1}.BlackLevel(1);
    saturation = img_info.SubIFDs{1}.WhiteLevel;
    img_lin = (img_raw-black)/(saturation-black);
    img_lin = max(0,min(img_lin,1));

    %cd('../../')

    %% WHITE BALANCE

    wb_multipliers = (img_info.AsShotNeutral).^-1;
    wb_multipliers = wb_multipliers/wb_multipliers(2);
    % mask = wbmask(size(img_lin,1),size(img_lin,2),wb_multipliers,'rggb'); % --> Nikon 7100
    mask = wbmask(size(img_lin,1),size(img_lin,2),wb_multipliers,'gbrg'); % --> Nikon 3100
    img_wb = img_lin .* mask;

    %% DEMOSAICING

    temp = uint16(img_wb/max(img_wb(:))*2^16); % --> Scale the entire image so that the max value is 65535
    % img_rgb = double(demosaic(temp,'rggb'))/2^16; % --> Nikon d7100 
    img_rgb = double(demosaic(temp,'gbrg'))/2^16; % --> Nikon d3100

    %% COLOR SPACE CONVERSION


    xyz2cam = [8322,-3112,-1047;-6367,14342,2179;-988,1638,6394]*10^(-4);
    % xyz2cam = reshape(img_info.ColorMatrix2,[3,3])'; % --> XYZ to Camera matrix
    rgb2xyz = [ 0.4124564  0.3575761  0.1804375;
     0.2126729  0.7151522  0.0721750;
     0.0193339  0.1191920  0.9503041]; % --> RGB to XYZ matrix

    rgb2cam = xyz2cam*rgb2xyz; % Assuming previously defined matrices
    rgb2cam = rgb2cam ./ repmat(sum(rgb2cam,2),1,3); % Normalize rows to 1
    cam2rgb = rgb2cam^-1;
    % cam2rgb = [1.4187     0.1705     0.1355;    
    % 0.1135     1.1392     -0.3633;     
    %  0.0471     -0.2103     2.1576];
    % cam2rgb = [1.7810 -0.6097 -0.0973; -0.0307 1.3337 -0.1885; 0.1012 -0.6676 1.6813];

    img_srgb = apply_cmatrix(img_rgb, cam2rgb);
    img_srgb = max(0,min(img_srgb,1));

    %% TONE CURVE APPLICATION


    %% BRIGHTNESS & GAMMA CORRECTION

    img_gray = rgb2gray(img_srgb);
    img_grayscale = 0.25/mean(img_gray(:));
    img_brightsrgb = min(1,img_srgb*img_grayscale);

    img_nlsrgb = img_brightsrgb.^(1/2.2);
%     figure();
%     imshow(img_nlsrgb);

end
