close all
clc
% I=imread('5.jpg');
I=imread('car.jpg');
figure(1),imshow(I);title('ԭͼ');
I1=rgb2gray(I);   %�����ɫͼ��ת��Ϊ�Ҷ�ͼ��
figure(2),subplot(1,2,1),imshow(I1);title('�Ҷ�ͼ');
hold on;
figure(2),subplot(1,2,2),imhist(I1);title('�Ҷ�ͼֱ��ͼ');
I2=edge(I1,'roberts',0.08,'both');  %��˹�˲���,����Ϊ0.08
figure(3),imshow(I2);title('robert���ӱ�Ե���')
se=[1;1;1];
I3=imerode(I2,se);  %ͼ��ĸ�ʴ
figure(4),imshow(I3);title('��ʴ��ͼ��');
se=strel('rectangle',[40,40]);  %����ṹԪ�أ��Գ����ι���һ��se
I4=imclose(I3,se); %��ͼ��ʵ�ֱ����㣬������Ҳ��ƽ��ͼ������������뿪�����෴����һ���ں�խ��ȱ�ں�ϸ������ڣ�ȥ��С����������ϵķ�϶��
figure(5),imshow(I4);title('���ͺ�Ŀ������');
I5=bwareaopen(I4,2000); %�Ӷ�����ͼ�����Ƴ���������p���ص����ӵ���������󣩣�������һ��������ͼ��
figure(6),imshow(I5);title('��ͼ�����Ƴ�СĿ��');
[y,x,z]=size(I5);  %����I5��ά�ĳߴ�--������ɫ�ȣ����洢�ڱ���y��x��z��
myI=double(I5); %����˫������ֵ��I5�а�ɫ�ǳ��Ƶ�����ֵ��1.�����Ǻڣ�ֵ��0
    %begin����ɨ��
tic  %����tic��toc֮����������ʱ��
Blue_y=zeros(y,1); %����y*1��ȫ0����y��ͼ��row
      for i=1:y
         for j=1:x
             if(myI(i,j,1)==1) 
          %���myI(i,j,1)��myIͼ��������Ϊ(i,j)�ĵ�Ϊ���������
          
Blue_y(i,1)= Blue_y(i,1)+1;%���������ͳ��
              end  
end       
 end
 [temp MaxY]=max(Blue_y);%tempΪ����white_y��Ԫ���е����ֵ��MaxYΪ��ֵ���������������е�λ�ã�
 PY1=MaxY;
     while ((Blue_y(PY1,1)>=120)&&(PY1>1)) %�����а���Ŀ�꣬����ͼ���У��ϱ߽�-1
          PY1=PY1-1;
 end    
 PY2=MaxY;
     while ((Blue_y(PY2,1)>=40)&&(PY2<y))%�����а���Ŀ�꣬����ͼ���У��±߽�+1
        PY2=PY2+1;
 end
     IY=I(PY1:PY2,:,:);
%IYΪԭʼͼ��I�н�ȡ����������PY1��PY2֮��Ĳ���
 %����ɨ�����
 %��ʼ����ɨ��
Blue_x=zeros(1,x);%��һ��ȷ��x����ĳ�������
 for j=1:x
         for i=PY1:PY2
             if(myI(i,j,1)==1)
Blue_x(1,j)= Blue_x(1,j)+1;               
               end  
           end       
 end

 PX1=1;
      while ((Blue_x(1,PX1)<3)&&(PX1<x))%�����в�����Ŀ�꣬����ͼ���У��±߽�+1
          PX1=PX1+1;
      end    
 PX2=x;
      while ((Blue_x(1,PX2)<3)&&(PX2>PX1))%�����в�����Ŀ�꣬�Ҵ����½磬�ϱ߽�-1
             PX2=PX2-1;
       end 
      %end����ɨ��
 PX1=PX1-2;%�Գ��������У��
 PX2=PX2+2;
dw=I(PY1:PY2,:,:);%dw�������Ƶ�ͼ���,�����г��ƺ���Χ����
        t=toc; 
figure(7),subplot(1,2,1),imshow(IY),title('�з����������');
figure(7),subplot(1,2,2),imshow(dw),title('��λ���к�Ĳ�ɫ����ͼ��')
imwrite(dw,'dw.jpg'); %��ͼ������д�뵽ͼ���ļ���
[filename,filepath]=uigetfile('dw.jpg','����һ����λ�ü���ĳ���ͼ��'); 
%��ȡ
jpg=strcat(filepath,filename); %������filepath,filenameˮƽ�����ӳɵ����ַ������������ڱ���jpg��
a=imread('dw.jpg');  %��ȡͼƬ�ļ��е�����
b=rgb2gray(a);  %�����ɫͼ��ת��Ϊ�Ҷ�ͼ��
imwrite(b,'1.���ƻҶ�ͼ��.jpg');  %��ͼ������д�뵽ͼ���ļ���
figure(8);subplot(3,2,1),imshow(b),title('1.���ƻҶ�ͼ��')
%�ӻҶ�ͼ������ȡ���ƣ����ǰ�ɫ�ģ���Ӧ��ֵ��ֵ
g_max=double(max(max(b)));  %����˫������ֵ
g_min=double(min(min(b)));  %����˫������ֵ
T=round(g_max-(g_max-g_min)/3); % T Ϊ��ֵ������ֵ
[m,n]=size(b);  %���ؾ���b�ĳߴ���Ϣ�����洢��m��n�С�����m�д洢����������n�д洢����������
d=(double(b)>=T);  % d:��ֵͼ��С����0���ڣ�����������1���ף���
imwrite(d,'2.���ƶ�ֵͼ��.jpg');  %��ͼ������д�뵽ͼ���ļ���
figure(8);subplot(3,2,2),imshow(d),title('2.���ƶ�ֵͼ��')
figure(8),subplot(3,2,3),imshow(d),title('3.��ֵ�˲�ǰ')
% �˲�
h=fspecial('average',3); %����Ԥ������˲����ӣ�averageָ�����ӵ����ͣ�3Ϊ��Ӧ�Ĳ���
d=im2bw(round(filter2(h,d)));  %ת��Ϊ��ֵͼ��
imwrite(d,'4.��ֵ�˲���.jpg');  %��ͼ������д�뵽ͼ���ļ���
figure(8),subplot(3,2,4),imshow(d),title('4.��ֵ�˲���')
% ĳЩͼ����в���
% ���ͻ�ʴ
% se=strel('square',3); % ʹ��һ��3X3�������ν��Ԫ�ض���Դ�����ͼ������
% 'line'/'diamond'/'ball'...
se=eye(2); % eye(n) returns the n-by-n identity matrix ��λ����
[m,n]=size(d); %���ؾ���b�ĳߴ���Ϣ�����洢��m��n�С�����m�д洢����������n�д洢��������
if bwarea(d)/m/n>=0.365  %�����ֵͼ���ж���������
        d=imerode(d,se);  %ͼ��ĸ�ʴ
elseifbwarea(d)/m/n<=0.235  %�����ֵͼ���ж���������
         d=imdilate(d,se);  %ʵ�����Ͳ���
end
imwrite(d,'5.���ͻ�ʴ�����.jpg');  %��ͼ������д�뵽ͼ���ļ���
figure(8),subplot(3,2,5),imshow(d),title('5.���ͻ�ʴ�����')
% Ѱ�����������ֵĿ飬�����ȴ���ĳ��ֵ������Ϊ�ÿ��������ַ���ɣ���Ҫ�ָ�
d=qiege(d);  %�и�򿪴˺������Ķ�
[m,n]=size(d); %���ؾ���b�ĳߴ���Ϣ�����洢��m��n�С�����m�д洢����������n�д洢��������
figure,subplot(2,1,1),imshow(d),title(n)
k1=1;k2=1;s=sum(d);j=1;
% d is a row vector with the sum over each  column
% k1 k2 ָʾĿ�����������ұ߽�
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
           d(:,k1+num+5)=0;  % �ָ�
          end
end
% ���и�
d=qiege(d);
% �и�� 7 ���ַ�
y1=10;y2=0.25;flag=0;word1=[]; %y1�ֿ�ȵ���ֵ��С��y1̫խ������.y1 y2�Ǹ��ݾ����趨
while flag==0
            [m,n]=size(d);
        left=1;wide=0;
        while sum(d(:,wide+1))~=0
            wide=wide+1;
         end
         if wide<y1   % ��Ϊ��������
              d(:,[1:wide])=0;
              d=qiege(d);
         else
              temp=qiege(imcrop(d,[1 1 wide m]));% �и�� 1 ���ַ�
              [m,n]=size(temp);
              all=sum(sum(temp));
two_thirds=sum(sum(temp([round(m/3):2*round(m/3)],:)));
          if two_thirds/all>y2    %����м�1/3������ռ����Ϣ����0.25���ϣ���Ϊ�ҵ�һ����
               flag=1;word1=temp;   
               % �ҵ���һ���֣�������������һ���ֵ�����г��Ƶı�Ե�����ҡ�
             end
              d(:,[1:wide])=0;d=qiege(d); %��ͼ��ȥ����һ����
          end
end
% �ָ���ڶ����ַ�����getword������ѧϰһ��
[word2,d]=getword(d);
% �ָ���������ַ�
[word3,d]=getword(d);
% �ָ�����ĸ��ַ�
[word4,d]=getword(d);
% �ָ��������ַ�
[word5,d]=getword(d);
% �ָ���������ַ�
[word6,d]=getword(d);
% �ָ�����߸��ַ�
[word7,d]=getword(d);
figure(9),imshow(word1),title('���Ƶĵ�һ���ַ�');
figure(10),imshow(word2),title('���Ƶĵڶ����ַ�');
figure(11),imshow(word3),title('���Ƶĵ������ַ�');
figure(12),imshow(word4),title('���Ƶĵ��ĸ��ַ�');
figure(13),imshow(word5),title('���Ƶĵ�����ַ�');
figure(14),imshow(word6),title('���Ƶĵ������ַ�');
figure(15),imshow(word7),title('���Ƶĵ��߸��ַ�');
[m,n]=size(word1); %���ؾ���b�ĳߴ���Ϣ�����洢��m��n�С�����m�д洢����������n�д洢��������

word1=imresize(word1,[40 20]);% ����ϵͳ�����й�һ����СΪ 40*20,�˴���ʾ
word2=imresize(word2,[40 20]); %��ͼ�������Ŵ�����40����20
word3=imresize(word3,[40 20]);
word4=imresize(word4,[40 20]);
word5=imresize(word5,[40 20]);
word6=imresize(word6,[40 20]);
word7=imresize(word7,[40 20]);
figure(16)
subplot(3,7,8),imshow(word1),title('�ַ�1');
subplot(3,7,9),imshow(word2),title('�ַ�2');
subplot(3,7,10),imshow(word3),title('�ַ�3');
subplot(3,7,11),imshow(word4),title('�ַ�4');
subplot(3,7,12),imshow(word5),title('�ַ�5');
subplot(3,7,13),imshow(word6),title('�ַ�6');
subplot(3,7,14),imshow(word7),title('�ַ�7');
imwrite(word1,'1.jpg');
imwrite(word2,'2.jpg');
imwrite(word3,'3.jpg');
imwrite(word4,'4.jpg');
imwrite(word5,'5.jpg');
imwrite(word6,'6.jpg');
imwrite(word7,'7.jpg');
liccode=char(['0':'9' 'A':'Z' '³�����復']); 
%�����Զ�ʶ���ַ��������t'0':'9' 'A':'Z' '³����ԥ'����ַ������һ���ַ����飬ÿ�ж�Ӧһ���ַ������ַ���������Զ����ո�
SubBw2=zeros(32,16);
l=1;
for I=1:7
     SubBw2=zeros(32,16); %����32*16��ȫ0����
      ii=int2str(I);%ת��Ϊ��
      t=imread([ii '.jpg']);%��ȡͼƬ�ļ��е�����
      SegBw2=imresize(t,[32 16],'nearest'); %��ͼ�������Ŵ�����32����16��'nearest'���������,��Ĭ�ϵģ����ı�ͼ��ߴ�ʱ��������ڲ�ֵ�㷨
      SegBw2=double(SegBw2)>20;
        if l==1                 %��һλ����ʶ��
kmin=37;
kmax=40;
elseif l==2             %�ڶ�λ A~Z ��ĸʶ��
kmin=11;
kmax=36;
        else l>=3               %����λ�Ժ�����ĸ������ʶ��
kmin=1;
kmax=36;
        end
        for k2=kmin:kmax
fname=strcat('�ַ�ģ��\',liccode(k2),'.bmp'); %��һ��������ת�����ַ���
            SamBw2 = imread(fname);%��ȡͼƬ�ļ��е�����
            SamBw2=double(SamBw2)>1;%��ɶ�ֵͼ��
            for  i=1:32
                for j=1:16
                    SubBw2(i,j)=SegBw2(i,j)-SamBw2(i,j);
                end
            end
           % �����൱������ͼ����õ�������ͼ��������ؼ�����0
Dmax=0;
            for k1=1:32
                for l1=1:16
                    if  ( SubBw2(k1,l1) > 0 | SubBw2(k1,l1) <0 )
Dmax=Dmax+1;
                    end
                end
            end
            Error(k2)=Dmax;%��k2��ͼ����ƥ��ʹ�õ�ģ�壬�������¼���Ĳ�ͬ������
        end
        Error1=Error(kmin:kmax);
MinError=min(Error1);
findc=find(Error1==MinError);
        Code(l*2-1)=liccode(findc(1)+kmin-1);
        Code(l*2)=' ';
        l=l+1;
end
figure(5),imshow(dw),title (['���ƺ���:', Code],'Color','b');%�ӳ��򣺣�getword�ӳ���
