clear;
fid = fopen('feature_data.txt','wt');
regionprops_result = cell(30218,2);
zernike_result = cell(30218,4);
folder = 'train';
folder_list = dir(folder);
total_folder = length(folder_list);
img_counter = 1;
counter = 0;
for folder_index = 1:total_folder
    if (strcmp(folder_list(folder_index).name , '.'))...
       || (strcmp(folder_list(folder_index).name , '..'))...
       || (strcmp(folder_list(folder_index).name , '.DS_Store'))
        continue
    end
    folder_dir = strcat([folder '/'],folder_list(folder_index).name);
    img_list = dir(folder_dir);
    total_img = length(img_list);
    for img_index = 1:total_img
        if (strcmp(img_list(img_index).name , '.'))...
           || (strcmp(img_list(img_index).name , '..'))...
           || (strcmp(img_list(img_index).name , '.DS_Store'))
            continue
        end
        img_dir = strcat(folder_dir,'/');
        img_dir = strcat(img_dir,img_list(img_index).name);
        img = imread(img_dir);
        imgbw = im2bw(img,250/255);
   
        img_square = Make_square(imgbw);
        img_square = 1 - img_square;

        feat_vec = PlanktonImgFeatEx(img_square, 255-img);

        fprintf(fid,'\"%s\"',img_dir(26:end));
        fprintf(fid,', %.4f',feat_vec);
        fprintf(fid,'\n');
        img_counter = img_counter + 1;
    end
    %break;
    counter = counter + 1
end

fclose(fid);