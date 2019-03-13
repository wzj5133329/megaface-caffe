
function face_detect_demo()
clear;clc;close all;
cd('../');

for a=100:999

str = int2str(a) 
filepath='../../megaface_testpack_v1.0/megaface_images/';
filepath_new=[filepath,str];
filename='megaface_images/';
filename_new=[filename,str];
fileresult='result/MegaFace_dataset_';
fileresult_new=[fileresult,str,'.mat'];
testList  = collectData(fullfile(pwd,filepath_new), filename_new);
%% mtcnn settings
minSize   = 20;
factor    = 0.85;
threshold = [0.6 0.7 0.9];

%% add toolbox paths
matCaffe       = fullfile(pwd, '../tools/caffe-sphereface/matlab');
pdollarToolbox = fullfile(pwd, '../tools/toolbox');
MTCNN          = fullfile(pwd, '../tools/MTCNN_face_detection_alignment/code/codes/MTCNNv1');
addpath(genpath(matCaffe));
addpath(genpath(pdollarToolbox));
addpath(genpath(MTCNN));

%% caffe settings
gpu = 1;
if gpu
   gpu_id = 0;
   caffe.set_mode_gpu();
   caffe.set_device(gpu_id);
else
   caffe.set_mode_cpu();
end
caffe.reset_all();
modelPath = fullfile(pwd, '../tools/MTCNN_face_detection_alignment/code/codes/MTCNNv1/model');
PNet = caffe.Net(fullfile(modelPath, 'det1.prototxt'), ...
                 fullfile(modelPath, 'det1.caffemodel'), 'test');
RNet = caffe.Net(fullfile(modelPath, 'det2.prototxt'), ...
                 fullfile(modelPath, 'det2.caffemodel'), 'test');
ONet = caffe.Net(fullfile(modelPath, 'det3.prototxt'), ...
                 fullfile(modelPath, 'det3.caffemodel'), 'test');


for a=100:999

str = int2str(a) 
filepath='../../megaface_testpack_v1.0/megaface_images/';
filepath_new=[filepath,str];
filename='megaface_images/';
filename_new=[filename,str];
fileresult='result/MegaFace_dataset_';
fileresult_new=[fileresult,str,'.mat'];
testList  = collectData(fullfile(pwd,filepath_new), filename_new);
%% face and facial landmark detection
dataList = testList;
for i = 1:length(dataList)
    fprintf('detecting the %dth image...\n', i);
    fprintf('%s \n', dataList(i).file);
    %if dir(dataList(i).file)
    % load image 
    try
        img = imread(dataList(i).file); 
    catch
        continue;
    end

    if size(img, 3)==1
       img = repmat(img, [1,1,3]);
    end
    % detection
    [bboxes, landmarks] = detect_face(img, minSize, PNet, RNet, ONet, threshold, false, factor);

    if size(bboxes, 1)>1
       % pick the face closed to the center
       center   = size(img) / 2;
       distance = sum(bsxfun(@minus, [mean(bboxes(:, [2, 4]), 2), ...
                                      mean(bboxes(:, [1, 3]), 2)], center(1:2)).^2, 2);
       [~, Ix]  = min(distance);
       dataList(i).facial5point = reshape(landmarks(:, Ix), [5, 2]);
    elseif size(bboxes, 1)==1
       dataList(i).facial5point = reshape(landmarks, [5, 2]);
    else
       dataList(i).facial5point = [];
    end
end

save (fileresult_new,  'dataList')

end

end
end


function list = collectData(folder, name)
    subFolders = struct2cell(dir(folder))';
    subFolders = subFolders(3:end, 1);
    files      = cell(size(subFolders));
    for i = 1:length(subFolders)
        fprintf('%s --- Collecting the %dth folder (total %d) ...\n', name, i, length(subFolders));
        subList  = struct2cell(dir(fullfile(folder, subFolders{i}, '*.jpg')))';
        files{i} = fullfile(folder, subFolders{i}, subList(:, 1));
    end
    files      = vertcat(files{:});
    dataset    = cell(size(files));
    dataset(:) = {name};
    list       = cell2struct([files dataset], {'file', 'dataset'}, 2);
end
