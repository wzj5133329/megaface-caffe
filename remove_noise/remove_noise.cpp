#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <stdio.h>
#include <sys/stat.h>
#include <dirent.h>
#include<fstream>

using namespace std;



void getFiles(const char* path, vector<string>& files,vector<string> & filenames){

    const string path0 = path;
    DIR* pDir;
    struct dirent* ptr;

    struct stat s;
    lstat(path, &s);

    if(!S_ISDIR(s.st_mode)){
        cout << "not a valid directory: " << path << endl;
        return;
    }

    if(!(pDir = opendir(path))){
        cout << "opendir error: " << path << endl;
        return;
    }
    int i = 0;
    string subFilename;
    string subFile;

    while((ptr = readdir(pDir)) != 0){
        subFilename = ptr -> d_name;
        if(subFilename == "." || subFilename == "..")
            continue;
        subFile = path0 + subFilename;
        //cout << ++i << ": " << subFile << endl;
        files.push_back(subFile);
	filenames.push_back(subFilename);
    }
    closedir(pDir);

}

int CountLines(const string &file)
{
	fstream fin(file,ios::in);
		if(!fin)
		{
			cerr<<"can not open file"<<endl;
			return -1;
		}
	
	
	char c;
	int lineCnt=0;
	while(fin.get(c))
	{	
		if(c=='\n')
		lineCnt++;
	}
	fin.close();
	return lineCnt;

}

int main()
{

    //string folder = "/home/asd/train_data/caffe_data/data1/predict";
    //vector<string> files;
    //vector<string> filenames;
    //getFiles(folder.c_str(), files,filenames);


    //for_each(files.begin(), files.end(), [](const string &s){cout << s << endl; });
    //for_each(filenames.begin(), filenames.end(), [](const string &s){cout << s << endl; });

    string str1("/media/asd/winF/megaface/devkit/templatelists/megaface_features_list.json_1000000_1");             //含有噪声的json文件
    string str2("/media/asd/winF/megaface/megaface_testpack_v1.0/megaface_noises.txt");                             //噪声图片列表
    string str3("/media/asd/winF/megaface/devkit/templatelists/megaface_features_list (no_noise).json_1000000_1");  //保存的没有噪声的json文件
    string str4("/media/asd/winF/megaface/devkit/templatelists/megaface_features_list(real_noise).json");           //因为搜索图片集probe中噪声大部分不在需要的5350张图片中，保存真实噪声
    ifstream facescrub,facescrub_noise;
    ofstream facescrub_no_noise,facescrub_real_noise;
    facescrub.open(str1);
    facescrub_no_noise.open(str3);
    facescrub_real_noise.open(str4);

    string line1,line2,line3;
    int line_count2=CountLines(str2);
    while(getline(facescrub,line1))
    {
    	facescrub_noise.open(str2);
    	int count =0;
    	while(getline(facescrub_noise,line2))
    	{
    		if(line1.find(line2)==line1.npos)
    			++count;
    	}
    	if(count==line_count2)
    		facescrub_no_noise<<line1<<endl;
    	else
    		facescrub_real_noise<<line1<<endl;
    	facescrub_noise.close();
    }
    facescrub.close();
    facescrub_real_noise.close();
    facescrub_no_noise.close();
    
}