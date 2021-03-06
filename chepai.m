close all
clc
% I=imread('5.jpg');
I=imread('car.jpg');
figure(1),imshow(I);title('原图');
I1=rgb2gray(I);   %将真彩色图像转换为灰度图像
figure(2),subplot(1,2,1),imshow(I1);title('灰度图');
hold on;
figure(2),subplot(1,2,2),imhist(I1);title('灰度图直方图');
I2=edge(I1,'roberts',0.08,'both');  %高斯滤波器,方差为0.08
figure(3),imshow(I2);title('robert算子边缘检测')
se=[1;1;1];
I3=imerode(I2,se);  %图像的腐蚀
figure(4),imshow(I3);title('腐蚀后图像');
se=strel('rectangle',[40,40]);  %构造结构元素，以长方形构造一个se
I4=imclose(I3,se); %对图像实现闭运算，闭运算也能平滑图像的轮廓，但与开运算相反，它一般融合窄的缺口和细长的弯口，去掉小洞，填补轮廓上的缝隙。
figure(5),imshow(I4);title('膨胀后目标区域');
I5=bwareaopen(I4,2000); %从二进制图像中移除所有少于p像素的连接的组件（对象），产生另一个二进制图像
figure(6),imshow(I5);title('从图像中移除小目标');
[y,x,z]=size(I5);  %返回I5各维的尺寸--长、宽、色度，并存储在变量y、x、z中
myI=double(I5); %换成双精度数值。I5中白色是车牌的区域，值是1.背景是黑，值是0
    %begin横向扫描
tic  %计算tic与toc之间程序的运行时间
Blue_y=zeros(y,1); %产生y*1的全0矩阵，y是图像row
      for i=1:y
         for j=1:x
             if(myI(i,j,1)==1) 
          %如果myI(i,j,1)即myI图像中坐标为(i,j)的点为车牌区域点
          
Blue_y(i,1)= Blue_y(i,1)+1;%车牌区域点统计
              end  
end       
 end
 [temp MaxY]=max(Blue_y);%temp为向量white_y的元素中的最大值，MaxY为该值的索引（在向量中的位置）
 PY1=MaxY;
     while ((Blue_y(PY1,1)>=120)&&(PY1>1)) %所在行包含目标，且在图像中，上边界-1
          PY1=PY1-1;
 end    
 PY2=MaxY;
     while ((Blue_y(PY2,1)>=40)&&(PY2<y))%所在行包含目标，且在图像中，下边界+1
        PY2=PY2+1;
 end
     IY=I(PY1:PY2,:,:);
%IY为原始图像I中截取的纵坐标在PY1：PY2之间的部分
 %横向扫描结束
 %开始纵向扫描
Blue_x=zeros(1,x);%进一步确定x方向的车牌区域
 for j=1:x
         for i=PY1:PY2
             if(myI(i,j,1)==1)
Blue_x(1,j)= Blue_x(1,j)+1;               
               end  
           end       
 end

 PX1=1;
      while ((Blue_x(1,PX1)<3)&&(PX1<x))%所在列不包含目标，且在图像中，下边界+1
          PX1=PX1+1;
      end    
 PX2=x;
      while ((Blue_x(1,PX2)<3)&&(PX2>PX1))%所在列不包含目标，且大于下界，上边界-1
             PX2=PX2-1;
       end 
      %end纵向扫描
 PX1=PX1-2;%对车牌区域的校正
 PX2=PX2+2;
dw=I(PY1:PY2,:,:);%dw包含车牌的图像带,里面有车牌和周围背景
        t=toc; 
figure(7),subplot(1,2,1),imshow(IY),title('行方向合理区域');
figure(7),subplot(1,2,2),imshow(dw),title('定位剪切后的彩色车牌图像')
imwrite(dw,'dw.jpg'); %将图像数据写入到图像文件中
[filename,filepath]=uigetfile('dw.jpg','输入一个定位裁剪后的车牌图像'); 
%读取
jpg=strcat(filepath,filename); %将数组filepath,filename水平地连接成单个字符串，并保存于变量jpg中
a=imread('dw.jpg');  %读取图片文件中的数据
b=rgb2gray(a);  %将真彩色图像转换为灰度图像
imwrite(b,'1.车牌灰度图像.jpg');  %将图像数据写入到图像文件中
figure(8);subplot(3,2,1),imshow(b),title('1.车牌灰度图像')
%从灰度图像中提取车牌，字是白色的，对应的值高值
g_max=double(max(max(b)));  %换成双精度数值
g_min=double(min(min(b)));  %换成双精度数值
T=round(g_max-(g_max-g_min)/3); % T 为二值化的阈值
[m,n]=size(b);  %返回矩阵b的尺寸信息，并存储在m、n中。其中m中存储的是行数，n中存储的是列数。
d=(double(b)>=T);  % d:二值图像，小的是0，黑，背景，大是1，白，字
imwrite(d,'2.车牌二值图像.jpg');  %将图像数据写入到图像文件中
figure(8);subplot(3,2,2),imshow(d),title('2.车牌二值图像')
figure(8),subplot(3,2,3),imshow(d),title('3.均值滤波前')
% 滤波
h=fspecial('average',3); %建立预定义的滤波算子，average指定算子的类型，3为相应的参数
d=im2bw(round(filter2(h,d)));  %转换为二值图像
imwrite(d,'4.均值滤波后.jpg');  %将图像数据写入到图像文件中
figure(8),subplot(3,2,4),imshow(d),title('4.均值滤波后')
% 某些图像进行操作
% 膨胀或腐蚀
% se=strel('square',3); % 使用一个3X3的正方形结果元素对象对创建的图像膨胀
% 'line'/'diamond'/'ball'...
se=eye(2); % eye(n) returns the n-by-n identity matrix 单位矩阵
[m,n]=size(d); %返回矩阵b的尺寸信息，并存储在m、n中。其中m中存储的是行数，n中存储的是列数
if bwarea(d)/m/n>=0.365  %计算二值图像中对象的总面积
        d=imerode(d,se);  %图像的腐蚀
elseifbwarea(d)/m/n<=0.235  %计算二值图像中对象的总面积
         d=imdilate(d,se);  %实现膨胀操作
end
imwrite(d,'5.膨胀或腐蚀处理后.jpg');  %将图像数据写入到图像文件中
figure(8),subplot(3,2,5),imshow(d),title('5.膨胀或腐蚀处理后')
% 寻找连续有文字的块，若长度大于某阈值，则认为该块有两个字符组成，需要分割
d=qiege(d);  %切割，打开此函数，阅读
[m,n]=size(d); %返回矩阵b的尺寸信息，并存储在m、n中。其中m中存储的是行数，n中存储的是列数
figure,subplot(2,1,1),imshow(d),title(n)
k1=1;k2=1;s=sum(d);j=1;
% d is a row vector with the sum over each  column
% k1 k2 指示目标子区域左右边界
while j~=n
        while s(j)==0
             j=j+1;
        end
               k1=j;
          while s(j)~=0 && j<=n-1
               j=j+1;
         end
                 k2=j-1;
       if k2-k1>=round(n/6.5) %
              [val,num]=min(sum(d(:,[k1+5:k2-5])));
           d(:,k1+num+5)=0;  % 分割
          end
end
% 再切割
d=qiege(d);
% 切割出 7 个字符
y1=10;y2=0.25;flag=0;word1=[]; %y1字宽度的阈值，小于y1太窄不是字.y1 y2是根据经验设定
while flag==0
            [m,n]=size(d);
        left=1;wide=0;
        while sum(d(:,wide+1))~=0
            wide=wide+1;
         end
         if wide<y1   % 认为是左侧干扰
              d(:,[1:wide])=0;
              d=qiege(d);
         else
              temp=qiege(imcrop(d,[1 1 wide m]));% 切割出 1 个字符
              [m,n]=size(temp);
              all=sum(sum(temp));
two_thirds=sum(sum(temp([round(m/3):2*round(m/3)],:)));
          if two_thirds/all>y2    %如果中间1/3含字量占总信息量的0.25以上，认为找到一个字
               flag=1;word1=temp;   
               % 找到第一个字，保存起来。第一个字的左边有车牌的边缘，难找。
             end
              d(:,[1:wide])=0;d=qiege(d); %从图中去掉第一个字
          end
end
% 分割出第二个字符，打开getword函数，学习一下
[word2,d]=getword(d);
% 分割出第三个字符
[word3,d]=getword(d);
% 分割出第四个字符
[word4,d]=getword(d);
% 分割出第五个字符
[word5,d]=getword(d);
% 分割出第六个字符
[word6,d]=getword(d);
% 分割出第七个字符
[word7,d]=getword(d);
figure(9),imshow(word1),title('车牌的第一个字符');
figure(10),imshow(word2),title('车牌的第二个字符');
figure(11),imshow(word3),title('车牌的第三个字符');
figure(12),imshow(word4),title('车牌的第四个字符');
figure(13),imshow(word5),title('车牌的第五个字符');
figure(14),imshow(word6),title('车牌的第六个字符');
figure(15),imshow(word7),title('车牌的第七个字符');
[m,n]=size(word1); %返回矩阵b的尺寸信息，并存储在m、n中。其中m中存储的是行数，n中存储的是列数

word1=imresize(word1,[40 20]);% 商用系统程序中归一化大小为 40*20,此处演示
word2=imresize(word2,[40 20]); %对图像做缩放处理，高40，宽20
word3=imresize(word3,[40 20]);
word4=imresize(word4,[40 20]);
word5=imresize(word5,[40 20]);
word6=imresize(word6,[40 20]);
word7=imresize(word7,[40 20]);
figure(16)
subplot(3,7,8),imshow(word1),title('字符1');
subplot(3,7,9),imshow(word2),title('字符2');
subplot(3,7,10),imshow(word3),title('字符3');
subplot(3,7,11),imshow(word4),title('字符4');
subplot(3,7,12),imshow(word5),title('字符5');
subplot(3,7,13),imshow(word6),title('字符6');
subplot(3,7,14),imshow(word7),title('字符7');
imwrite(word1,'1.jpg');
imwrite(word2,'2.jpg');
imwrite(word3,'3.jpg');
imwrite(word4,'4.jpg');
imwrite(word5,'5.jpg');
imwrite(word6,'6.jpg');
imwrite(word7,'7.jpg');
liccode=char(['0':'9' 'A':'Z' '鲁陕苏渝京']); 
%建立自动识别字符代码表，将t'0':'9' 'A':'Z' '鲁陕苏豫'多个字符串组成一个字符数组，每行对应一个字符串，字符数不足的自动补空格
SubBw2=zeros(32,16);
l=1;
for I=1:7
     SubBw2=zeros(32,16); %产生32*16的全0矩阵
      ii=int2str(I);%转换为串
      t=imread([ii '.jpg']);%读取图片文件中的数据
      SegBw2=imresize(t,[32 16],'nearest'); %对图像做缩放处理，高32，宽16，'nearest'：这个参数,是默认的，即改变图像尺寸时采用最近邻插值算法
      SegBw2=double(SegBw2)>20;
        if l==1                 %第一位汉字识别
kmin=37;
kmax=40;
elseif l==2             %第二位 A~Z 字母识别
kmin=11;
kmax=36;
        else l>=3               %第三位以后是字母或数字识别
kmin=1;
kmax=36;
        end
        for k2=kmin:kmax
fname=strcat('字符模板\',liccode(k2),'.bmp'); %把一个行向量转化成字符串
            SamBw2 = imread(fname);%读取图片文件中的数据
            SamBw2=double(SamBw2)>1;%变成二值图像
            for  i=1:32
                for j=1:16
                    SubBw2(i,j)=SegBw2(i,j)-SamBw2(i,j);
                end
            end
           % 以上相当于两幅图相减得到第三幅图。相等像素减后是0
Dmax=0;
            for k1=1:32
                for l1=1:16
                    if  ( SubBw2(k1,l1) > 0 | SubBw2(k1,l1) <0 )
Dmax=Dmax+1;
                    end
                end
            end
            Error(k2)=Dmax;%第k2个图像是匹配使用的模板，用数组记录它的不同像素数
        end
        Error1=Error(kmin:kmax);
MinError=min(Error1);
findc=find(Error1==MinError);
        Code(l*2-1)=liccode(findc(1)+kmin-1);
        Code(l*2)=' ';
        l=l+1;
end
figure(5),imshow(dw),title (['车牌号码:', Code],'Color','b');%子程序：（getword子程序）
