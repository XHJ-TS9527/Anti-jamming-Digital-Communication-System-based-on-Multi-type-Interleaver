%%初始化
close all;
clear;
clc;
%%巴克码
%bark=[1 1 1 0 0 0 1 0 0 1 0];
bark=[0 1 0 0 0 1 0 0 1 0 1 0 1 1 0 0 0 0 1 1 1 0 0 1 1 0 1 1 1 1 1 0]; %m
%自相关
[val,idx]=xcorr(bark);
%作图
stem(idx,val,'b','MarkerFaceColor','b');
xlabel('延时','fontsize',13);
ylabel('自相关函数值','fontsize',13);
axis([min(idx) max(idx) 0 max(val)+0.5]);