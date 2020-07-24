%%初始化
close all;
clear;
clc;
%%数据
time=1:300;
out_time=zeros(size(time));
%%传播延时
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
%%作图
figure;
plot(time,out_time,'b','LineWidth',1);
xlabel('数据输入时刻','fontsize',13);
ylabel('数据输出时刻','fontsize',13);