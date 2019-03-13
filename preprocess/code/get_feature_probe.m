% --------------------------------------------------------
% Copyright (c) Weiyang Liu, Yandong Wen
% Licensed under The MIT License [see LICENSE for details]
%
% Intro:
% This script is used to evaluate the performance of the trained model on LFW dataset.
% We perform 10-fold cross validation, using cosine similarity as metric.
% More details about the testing protocol can be found at http://vis-www.cs.umass.edu/lfw/#views.
% 
% Usage:
% cd $SPHEREFACE_ROOT/test
% run code/evaluation.m
% --------------------------------------------------------

function evaluation()
fprintf('----------------\n');
clear;clc;close all;
cd('../')


%% caffe setttings
matCaffe = fullfile(pwd, '../tools/caffe_face/matlab');
addpath(genpath(matCaffe));
gpu = 1;
if gpu
   gpu_id = 0;
   caffe.set_mode_gpu();
   caffe.set_device(gpu_id);
else
   caffe.set_mode_cpu();
end
caffe.reset_all();

model   = '../train/code/data2_2/64layers_arc/sphereface_64_norm_deploy.prototxt';
weights = '../train/code/data2_2/64layers_arc/face_data2_2_iter_78000.caffemodel';
net     = caffe.Net(model, weights, 'test');
net.save('result/sphereface_model.caffemodel');

%% compute features
%pairs = parseList('pairs.txt', fullfile(pwd, 'lfw'));
%for i = 1:length(pairs)
%    fprintf('extracting deep features from the %dth face pair...\n', i);
%    pairs(i).featureL = extractDeepFeature(pairs(i).fileL, net);
%    pairs(i).featureR = extractDeepFeature(pairs(i).fileR, net);
%end
%save result/pairs.mat pairs

testList  = collectData(fullfile(pwd, 'result/facescrub_images12 '),'facescrub_images12 ');
dataList = testList;
for i = 1:length(dataList)
    filepath=dataList(i).file
    img     = single(imread(filepath));
    img     = (img - 127.5)/128;
    try
        img     = permute(img, [2,1,3]);
        img     = img(:,:,[3,2,1]);
        res     = net.forward({img});
        res_    = net.forward({flip(img, 1)});
    catch
        continue;
    end
    try
        
        feature = single([res{1}; res_{1}]);
    %feature = extractDeepFeature(filepath, net);
        houzui='_vulture.bin';
        featurename=[filepath,houzui]
        fid =fopen(featurename,'wb');
        fwrite(fid,1024,'int');
        fwrite(fid,1,'int');
        fwrite(fid,4,'int');
        fwrite(fid,5,'int');
        fwrite(fid,feature,'float');
        sta=fclose(fid);
    catch
        continue;
    end
    
end
end
%save result/feature.bin feature



%function feature = extractDeepFeature(file, net)
%   
%        img     = single(imread(file));
%        img     = (img - 127.5)/128;
%        img     = permute(img, [2,1,3]);
%        img     = img(:,:,[3,2,1]);
%        res     = net.forward({img});
%        res_    = net.forward({flip(img, 1)});
%        feature = double([res{1}; res_{1}]);
    
%end

function list = collectData(folder, name)
    subFolders = struct2cell(dir(folder))';
    subFolders = subFolders(3:end, 1);
    files      = cell(size(subFolders));
    for i = 1:length(subFolders)
        %fprintf('%s --- Collecting the %dth folder (total %d) ...\n', name, i, length(subFolders));
        subList  = struct2cell(dir(fullfile(folder, subFolders{i}, '*.png')))';
        files{i} = fullfile(folder, subFolders{i}, subList(:, 1));
    end
    files      = vertcat(files{:});
    dataset    = cell(size(files));
    dataset(:) = {name};
    list       = cell2struct([files dataset], {'file', 'dataset'}, 2);
end
