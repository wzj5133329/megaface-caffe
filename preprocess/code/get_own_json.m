function get_json()

clear;clc;close all;
cd('../');
json_path='result/json2.txt';
diary(json_path);
diary on;
for a=100:315
str = int2str(a);
filepath_all='data/MegaFace_dataset/';
filepath_new=[filepath_all,str,'-MegaFace_data_',str];
filename='MegaFace_dataset/';
filename_new=[filename,str,'-MegaFace_data_',str];
filepath2='/media/admin1/E8D8E40DD8E3D838/1080TI/MEGAFACE/test/data/MegaFace_dataset';
filepath2_new=[filepath2,str,'-MegaFace_data_',str];
testList  = collectData(fullfile(pwd, filepath_new), filename_new);
%% face and facial landmark detection
dataList = testList;
for i = 1:length(dataList)
    %fprintf('detecting the %dth image...\n', i);
    %fprintf('%s \n', dataList(i).file);
    path=strrep(dataList(i).file,filepath2_new,''); 
    path_bin=strrep(path,'_vulture.bin','');
    %fprintf('%s \n', path_bin);
    %path_nameall = strsplit(path_bin,'//');
    %path_nameall = regexp(path_bin, '/', 'split');
    %path_name=path_nameall(1);
    %s1 = char(path_name);
    path2=['"',path_bin,'",']; 
    filepath2_new=[filepath2,'/'];
    path_feature=strrep(path2,filepath2_new,'');   
    path_nameall = regexp(path_feature, '/', 'split');  %
    path_name=path_nameall(1);     %
    s1 = char(path_name);   %
    path3=[s1,'",'];   %
    fprintf('%s \n', path3);  %
    %strrep(str1,str2,str3) 把str1中含有str2的所有位置用str3来代替
    %fprintf('%s \n', dataList(i).file);
    %fprintf('%s \n', path_feature)
    
end
end
diary off
end



function list = collectData(folder, name)
    subFolders = struct2cell(dir(folder))';
    subFolders = subFolders(3:end, 1);
    files      = cell(size(subFolders));
    for i = 1:length(subFolders)
        %fprintf('%s --- Collecting the %dth folder (total %d) ...\n', name, i, length(subFolders));
        subList  = struct2cell(dir(fullfile(folder, subFolders{i}, '*.bin')))';
        files{i} = fullfile(folder, subFolders{i}, subList(:, 1));
    end
    files      = vertcat(files{:});
    dataset    = cell(size(files));
    dataset(:) = {name};
    list       = cell2struct([files dataset], {'file', 'dataset'}, 2);
end