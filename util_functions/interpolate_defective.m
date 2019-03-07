function image = interpolate_defective(image, indices_defective)

    for j = 1:length(indices_defective)
        i_img = indices_defective(j,1); 
        j_img = indices_defective(j,2);
        
        image(i_img,j_img) = round((image(i_img+2,j_img) + image(i_img,j_img+2) + image(i_img-2,j_img) + image(i_img,j_img-2))/4); 
        
    end
    
end