%%��ʼ��
close all;
clear;
clc;
%%�Ϳ���
%bark=[1 1 1 0 0 0 1 0 0 1 0];
bark=[0 1 0 0 0 1 0 0 1 0 1 0 1 1 0 0 0 0 1 1 1 0 0 1 1 0 1 1 1 1 1 0]; %m
%�����
[val,idx]=xcorr(bark);
%��ͼ
stem(idx,val,'b','MarkerFaceColor','b');
xlabel('��ʱ','fontsize',13);
ylabel('����غ���ֵ','fontsize',13);
axis([min(idx) max(idx) 0 max(val)+0.5]);