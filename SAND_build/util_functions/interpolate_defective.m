function image = interpolate_defective(image, indices_defective)

    for j = 1:length(indices_defective)
        i_img = indices_defective(j,1); 
        j_img = indices_defective(j,2);

        if i_img > 3 && j_img > 3 && i_img < size(image,1) - 3 && j_img < size(image,2) - 3
            image(i_img,j_img) = floor((image(i_img+2,j_img) + image(i_img,j_img+2) + image(i_img-2,j_img) + image(i_img,j_img-2))/4); 
        end
    end
    
end