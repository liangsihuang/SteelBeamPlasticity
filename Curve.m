clc;
clear;

%��ȡ����
[fileID,message]=fopen('node5.out','r');  %fileID�Ǹ��������������������Ϊ-1
if fileID==-1
   disp(message);
end
%��������Ϊfloat���ָ���Ϊ�ո�
data=textscan(fileID,'%f %f','Delimiter',' '); 
fclose(fileID);

displacement=data{2}.*(-1);

load_times=data{1};

%��ͼ
plot(displacement,load_times);

% % ��������
% grid on
% 
% 
% % % ���������ʾ��Χ
% % axis([0 3 0 4])
% 
% 
% xlabel('���λ��');
% ylabel('���������');
% title('S1����');

% %�Ҽ���ֵ�������
% [peak,location]=findpeaks(moment);
% hold on; %plot��plot֮��Ҫholdס
% peak_x=displacement(location);
% peak_y=peak;
% plot(peak_x,peak_y,'ro');
% 
% %��ע����ֵ�����굽ͼ��
% s=['(',num2str(peak_x),',',num2str(peak_y),')'];
% text(peak_x,peak_y+0.1,s);