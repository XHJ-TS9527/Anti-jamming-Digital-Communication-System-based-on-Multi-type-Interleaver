%%��ʼ��
close all;
clear;
clc;
%%����
time=1:300;
out_time=zeros(size(time));
%%������ʱ
choice=0;
for t=time
    switch choice
        case 0
            delay=0;
        case 1
            delay=5;
        case 2
            delay=10;
        case 3
            delay=15;
    end
    out_time(t)=t+4*delay;
    choice=mod(choice+1,4);
end
%%��ͼ
figure;
plot(time,out_time,'b','LineWidth',1);
xlabel('��������ʱ��','fontsize',13);
ylabel('�������ʱ��','fontsize',13);