% --------------------------------------------------------
% Copyright (c) Weiyang Liu, Yandong Wen
% Licensed under The MIT License [see LICENSE for details]
%
% Intro:
% This script is used to detect the faces in training & testing datasets (CASIA & LFW).
% Face and facial landmark detection are performed by MTCNN 
% (paper: http://kpzhang93.github.io/papers/spl.pdf, 
%  code: https://github.com/kpzhang93/MTCNN_face_detection_alignment).
%
% Note:
% If you want to use this script for other dataset, please make sure
% (a) the dataset is structured as `dataset/idnetity/image`, e.g. `casia/id/001.jpg`
% (b) the folder name and image format (bmp, png, etc.) are correctly specified.
% 
% Usage:
% cd $SPHEREFACE_ROOT/preprocess
% run code/face_detect_demo.m
% --------------------------------------------------------

function face_detect_demo()

clear;clc;close all;
cd('../');

%% collect a image list of CASIA & LFW
%trainList = collectData(fullfile(pwd, 'data/CASIA-WebFace'), 'CASIA-WebFace');
testList  = collectData(fullfile(pwd, 'data/Adrienne Frantz'), 'MegaFace_probe');

%% face and facial landmark detection
dataList = testList;
for i = 1:length(dataList)
    fprintf('detecting the %dth image...\n', i);
    fprintf('detecting the %s ...\n', dataList(i));
    %img = imread(dataList(i).file); 
    %TF = isempty(img);
    %if(TF)
    %   continue;
    %end
    %if size(img, 3)==1
    %   img = repmat(img, [1,1,3]);
    %end
    % detection
    %[bboxes, landmarks] = detect_face(img, minSize, PNet, RNet, ONet, threshold, false, factor);

    %if size(bboxes, 1)>1
       % pick the face closed to the center
    %   center   = size(img) / 2;
    %   distance = sum(bsxfun(@minus, [mean(bboxes(:, [2, 4]), 2), ...
     %                                 mean(bboxes(:, [1, 3]), 2)], center(1:2)).^2, 2);
    %   [~, Ix]  = min(distance);
     %  dataList(i).facial5point = reshape(landmarks(:, Ix), [5, 2]);
    %elseif size(bboxes, 1)==1
    %   dataList(i).facial5point = reshape(landmarks, [5, 2]);
    %else
    %   dataList(i).facial5point = [];
    %end
end
%save result/dataList.mat dataList

end


