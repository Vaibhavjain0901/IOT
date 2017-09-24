
clc;

close all;

ard.pinMode(13,'output')
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
out1=Out;
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
figure, imshow(Out);
 a=out1;
 %segmenation start 
 
        a=rgb2gray(a);
        Out=rgb2gray(Out);

c1=imsubtract(a,Out);

d=im2bw(c1);

[r c]=size(d);
%t=graythresh(uint8(d));
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
figure; imshow(C1);title('test');
%segmentation ends

str='.bmp';
for i=1:50
    a=strcat(num2str(i),str);
  
    b=imread(a);
    
    re1=corr2(b,C1);
    
    result1(i)=re1;

end

[re ma]=max(result1);
 a=strcat(num2str(ma),str);
b=imread(a);
figure;
imshow(b);title('recognition result');
   

    
    if ma > 0 && ma <=10

        [y,Fs] = audioread('1.wav');
         sound(y,Fs);
        d = thingSpeakFetch(113405,'FFYI1CUQGOGUES02')
        msgbox(sprintf('temp = %g',d),'temp')
        
    elseif ma > 10 && ma <=20
        
        warndlg('2');
        [y,Fs] = audioread('2.wav');
         sound(y,Fs);
        
         ard.digitalWrite(13,1)
         warndlg('AC TURNED ON');
    elseif ma > 20 && ma <=30
        
        warndlg('3');
        [y,Fs] = audioread('3.wav');
        sound(y,Fs);
        
        ard.digitalWrite(13,0)
    warndlg('AC TURNED OFF');
    elseif ma > 30 && ma <=40
        warndlg('4');
        [y,Fs] = audioread('4.wav');
         sound(y,Fs);
         d = thingSpeakFetch(113405,'FFYI1CUQGOGUES02')
         msgbox(sprintf('temp = %g',d),'temp')
         if d>32
             ard.digitalWrite(13,1);
             warndlg('AC TURNED ON');
         else
             ard.digitalWrite(13,0);
             warndlg('AC TURNED OFF');
         end
          
         
    else
            warndlg('5');
            [y,Fs] = audioread('5.wav');
         sound(y,Fs);
         warndlg('TRY AGAIN');
    end
