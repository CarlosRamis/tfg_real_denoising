clear all;
warning('off','all');
addpath('util_functions')

scenes = {'Scene_05', 'Scene_06', 'Scene_07', 'Scene_08',...
    'Scene_09', 'Scene_10', 'Scene_11', 'Scene_12', 'Scene_13', 'Scene_14',...
    'Scene_15', 'Scene_16', 'Scene_17', 'Scene_18', 'Scene_19', 'Scene_20', 'Scene_21',...
    'Scene_22', 'Scene_23', 'Scene_24', 'Scene_25', 'Scene_26', 'Scene_27', 'Scene_28',...
    'Scene_29', 'Scene_30', 'Scene_31', 'Scene_32', 'Scene_33', 'Scene_34', 'Scene_35',...
    'Scene_36'};
%% i) Save image windows ref as .jpg
Window = 256;
if false
for i = 1:length(scenes)
    scene = scenes{i};
    disp(scene);
    GT_ref_paths = glob(['Dataset_Final/jpg_images/',scene,'/*']);
    
    for j = 1:length(GT_ref_paths)
        image = imread(GT_ref_paths{i});
        H = size(image,1);
        W = size(image,2);
        
        for x = 1:Window:H
            for y = 1:Window:W
                Save_path = ['Dataset_CNN/',scene,'/Window_', num2str(x),...
                    '-', num2str(y),'/'];
                if ~(exist(Save_path, 'dir'))
                    mkdir(Save_path)
                end
                
                image_window = image(x:x+Window-1,y:y+Window-1,:);
                imwrite(image_window,[Save_path,'w_',num2str(j),'.jpg']);

            end
        end
    end
    
end
end

%% ii) Save image windows GT as .jpg
Window = 256;
if false
for i = 1:length(scenes)
    scene = scenes{i};
    disp(scene);
    
    GT_path = ['Dataset_Final/GT_median_',scene,'.jpg'];
    image_GT = imread(GT_path);
    H = size(image_GT,1);
    W = size(image_GT,2);
    for x = 1:Window:H
        for y = 1:Window:W
            Save_path = ['Dataset_CNN/',scene,'/Window_', num2str(x),...
                '-', num2str(y),'/'];
            if ~(exist(Save_path, 'dir'))
                mkdir(Save_path)
            end

            image_GT_window = image_GT(x:x+Window-1,y:y+Window-1,:);
            imwrite(image_GT_window,[Save_path,'GT.jpg']);

        end
    end
end
end   
%% iii) Create NLF

step = 4;
if 0
for i = 1:length(scenes)
    scene = scenes{i};
    disp(scene);
    paths_windows = glob(['Dataset_CNN/',scene,'/Window_*/']);
    
    for j = 1:length(paths_windows)
        paths_noisy = glob([paths_windows{j},'w_*.jpg']);
        path_GT = [paths_windows{j},'GT.jpg'];
        NLF = NLF_GT_calculator(path_GT, paths_noisy, step);

        NLF_step = NLF(1:step:end);
        save([paths_windows{j},'NLF.mat'],'NLF_step')
    end
end
end

%% iv) Filter NLFs
fc = 0.3;
fs = 2;
step = 4;
if true
for i = 1:length(scenes)
    scene = scenes{i};
    disp(scene);
    paths_windows = glob(['Dataset_CNN/',scene,'/Window_*/']);
    
    for j = 1:length(paths_windows)
        paths_noisy = glob([paths_windows{j},'w_*.jpg']);
        path_GT = [paths_windows{j},'GT.jpg'];
        
        NLF_step = load([paths_windows{j},'NLF.mat']);
        NLF_step = NLF_step.NLF_step;
        NLF_unstep = unstep_NLF(NLF_step, step);
        
        NLF_step_f_r = filter_NLF(NLF_unstep(1:256), fc, fs);
        NLF_step_f_g = filter_NLF(NLF_unstep(257:512), fc, fs);
        NLF_step_f_b = filter_NLF(NLF_unstep(513:768), fc, fs);
        
        NLF_step_filt = [NLF_step_f_r(1:step:end),NLF_step_f_g(1:step:end),...
            NLF_step_f_b(1:step:end)];
        save([paths_windows{j},'NLF_filtered.mat'],'NLF_step_filt')
    end
end
end
    
    
    
    
    
    