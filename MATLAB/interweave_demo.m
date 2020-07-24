%%初始化
close all;
clear;
clc;
%%读入图片
origin_image=rgb2gray(imread('新冠CT.jpg'));
[height,width]=size(origin_image);
%%传输过程
%发生失真的区域
begin_height=48;
end_height=77;
begin_width=51;
end_width=77;
%直接传输失真
direct_image=origin_image;
direct_image(begin_height:end_height,begin_width:end_width)=zeros(size(direct_image(begin_height:end_height,begin_width:end_width)));
%伪随机交织传输失真
%保存失真区域下标
area=origin_image(begin_height:end_height,begin_width:end_width);
point_number=size(area,1)*size(area,2);
area=zeros(point_number,1);
cnt=1;
for h=begin_height:end_height
    for w=begin_width:end_width
        area(cnt)=sub2ind(size(origin_image),h,w);
        cnt=cnt+1;
    end
end
%伪随机交织传输
array=randperm(height*width);
img_idx=1:height*width;
img_idx=img_idx';
interweave_data=intrlv(img_idx,array);
loss_area=interweave_data(area);
interweave_image=origin_image;
interweave_image(loss_area)=zeros(size(interweave_image(loss_area)));
%%滤波
direct_filt_img=medfilt2(direct_image,[3 3]);
interweave_filt_img=medfilt2(interweave_image,[3 3]);
%%显示结果
figure;
subplot(2,2,1);
imshow(direct_image,[]);
title('直接传输失真','fontsize',13);
subplot(2,2,2);
imshow(interweave_image,[]);
title('伪随机交织传输失真','fontsize',13);
subplot(2,2,3);
imshow(direct_filt_img,[]);
title('直接传输失真后滤波','fontsize',13);
subplot(2,2,4);
imshow(interweave_filt_img,[]);
title('伪随机交织传输失真后滤波','fontsize',13);
%%保存结果
imwrite(direct_image,'直接传输新冠CT.jpg');
imwrite(interweave_image,'伪随机交织传输新冠CT.jpg');
imwrite(direct_filt_img,'直接传输滤波新冠CT.jpg');
imwrite(interweave_filt_img,'伪随机交织传输滤波新冠CT.jpg');