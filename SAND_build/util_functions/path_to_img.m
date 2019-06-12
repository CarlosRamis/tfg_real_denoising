function [img_raw, img_rgb] = path_to_img(path)

    img_tiff = Tiff(path,'r');
    offsets = getTag(img_tiff,'SubIFD');
    setSubDirectory(img_tiff,offsets(1));
    img_info = imfinfo(path);
    
    img_raw = read(img_tiff);
    img_rgb = camerapipeline(img_raw,img_info);

end

