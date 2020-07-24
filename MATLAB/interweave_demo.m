%%��ʼ��
close all;
clear;
clc;
%%����ͼƬ
origin_image=rgb2gray(imread('�¹�CT.jpg'));
[height,width]=size(origin_image);
%%�������
%����ʧ�������
begin_height=48;
end_height=77;
begin_width=51;
end_width=77;
%ֱ�Ӵ���ʧ��
direct_image=origin_image;
direct_image(begin_height:end_height,begin_width:end_width)=zeros(size(direct_image(begin_height:end_height,begin_width:end_width)));
%α�����֯����ʧ��
%����ʧ�������±�
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
%α�����֯����
array=randperm(height*width);
img_idx=1:height*width;
img_idx=img_idx';
interweave_data=intrlv(img_idx,array);
loss_area=interweave_data(area);
interweave_image=origin_image;
interweave_image(loss_area)=zeros(size(interweave_image(loss_area)));
%%�˲�
direct_filt_img=medfilt2(direct_image,[3 3]);
interweave_filt_img=medfilt2(interweave_image,[3 3]);
%%��ʾ���
figure;
subplot(2,2,1);
imshow(direct_image,[]);
title('ֱ�Ӵ���ʧ��','fontsize',13);
subplot(2,2,2);
imshow(interweave_image,[]);
title('α�����֯����ʧ��','fontsize',13);
subplot(2,2,3);
imshow(direct_filt_img,[]);
title('ֱ�Ӵ���ʧ����˲�','fontsize',13);
subplot(2,2,4);
imshow(interweave_filt_img,[]);
title('α�����֯����ʧ����˲�','fontsize',13);
%%������
imwrite(direct_image,'ֱ�Ӵ����¹�CT.jpg');
imwrite(interweave_image,'α�����֯�����¹�CT.jpg');
imwrite(direct_filt_img,'ֱ�Ӵ����˲��¹�CT.jpg');
imwrite(interweave_filt_img,'α�����֯�����˲��¹�CT.jpg');