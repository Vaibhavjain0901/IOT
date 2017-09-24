
    
clc;
clear;
close all;

vid=videoinput('winvideo',1,'YUY2_640x480'); 
set(vid,'ReturnedColorSpace','rgb');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
triggerconfig(vid,'manual'); 
%Capture one frame per trigger
set(vid,'FramesPerTrigger',1 );
set(vid,'TriggerRepeat', Inf);
start(vid); %start video

 BW = imread('mask.bmp');
 BW=im2bw(BW);
 [B,L,N,A] = bwboundaries(BW);
  imshow(BW); hold on;
       for k=1:length(B),
         if(~sum(A(k,:)))
           boundary = B{k};
           plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);
           for l=find(A(:,k))'
             boundary = B{l};
            plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
           end
         end
       end
      
aa=1;

 r=69:390;
 c=83:280;
while(1)

%Get Image
trigger(vid);
im=getdata(vid,1);
imshow(im);
hold on
if aa == 30
    red=im(:,:,1);
Green=im(:,:,2);
Blue=im(:,:,3);

Out(:,:,1)=red(min(r):max(r),min(c):max(c));
Out(:,:,2)=Green(min(r):max(r),min(c):max(c));
Out(:,:,3)=Blue(min(r):max(r),min(c):max(c));
Out=uint8(Out);
out1=Out
figure;
imshow(Out);title('Capturing BackGround');
end


plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
aa=aa+1;
if aa == 60
   break 
end


end

stop(vid),delete(vid),clear vid; 

red=im(:,:,1);
Green=im(:,:,2);
Blue=im(:,:,3);

Out(:,:,1)=red(min(r):max(r),min(c):max(c));
Out(:,:,2)=Green(min(r):max(r),min(c):max(c));
Out(:,:,3)=Blue(min(r):max(r),min(c):max(c));
Out=uint8(Out);
figure, imshow(Out,[])
 a=out1;
 %segmenation start 
 
        a=rgb2gray(a);
        Out=rgb2gray(Out);

c1=imsubtract(a,Out);

d=im2bw(c1);

[r c]=size(d);

for i=1:r
    for j=1:c
        
        if c1(i,j)> 25
            bin(i,j)=255;
        else
            bin(i,j)=0;
            
        end
        
    end
end

bin=medfilt2(bin,[3 3]);

[L num]=bwlabel(bin);

STATS = regionprops(L,'all');

removed=0;
for i=1:num
dd=STATS(i).Area;
if dd < 500
  	L(L==i)=0;
else

end
    
    
end
   %figure; imshow(L);title('test');
    [L num]=bwlabel(L);

 
STATS = regionprops(L,'all');
stats1 = regionprops(L, 'Image'); % get image feature
c = stats1(1);
C = [c.Image]; 
C1 = imresize(C, [256 256], 'bilinear');

 figure; imshow(C1);
%segmentation ends
imwrite(C1,'30.bmp');
   