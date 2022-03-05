% Exp2 Beh analysis
clear all;
sub=[1,2,3,4,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,25,29,30,31];
Suball=length(sub);
Stiindex={{'115','215','114','214','116','216'},{'125','225','124','224','123','223','116','216'},{'135','235','131','231','132','232'}}; % 计算所有Target分布
% 4 =DDT 90°~180°；5 =DDT =90°；6 =DDT <90°
% Stiindex={{'114','214'},{'115','215'},{'116','216'},{'124','224'},{'125','225'},{'116','216'},{'134','234'},{'135','235'},{'136','236'}};   % 适用于前4个被试计算S_ES
% Stiindex={{'114','214'},{'115','215'},{'116','216'},{'124','224'},{'125','225'},{'116','216'},{'131','231'},{'132','232'},{'135','235'}}; % 适用于除前4个被试计算S_ES
% Stiindex={{'115','215'},{'125','225'},{'135','235'}};

path_in='G:\COVID\Exp2_beh';
Data_RT=[];Data_ACC=[];RT_in=[];ACC_in=[];
for t=1:length(sub)
    nsub=sub(t);
    ACC=[];RT=[];StiT=[];CueT=[];
    for exe=2    
if exist([path_in,'\sub',num2str(nsub),'_task',num2str(exe),'.mat'])  
    load([path_in,'\sub',num2str(nsub),'_task',num2str(exe),'.mat']);
else disp('error');
end
ACC=[ACC;fidnew.ACC];
RT=[RT;fidnew.RT];
StiT=[StiT;fidnew.StiT];
CueT=[CueT;fidnew.CueT];
    end  
    for cuet=1:9
        sticondindex=Stiindex{cuet};
        indexRT=[];indexACC=[];A=[];
        for c=1:length(sticondindex)
            curr_type=sticondindex{c};
            [a,b]=find(StiT(:,:)==str2num(curr_type));
            A=[A;a];
            for i=1:length(a)
            if ACC(a(i),b(i))==1
                if RT(a(i),b(i))>0.2&&RT(a(i),b(i))<2
                    indexRT=[indexRT,RT(a(i),b(i))];
                    indexACC=[indexACC,ACC(a(i),b(i))];
                end
            end
            end
        end
        Data_RT(t,cuet,:)=mean(indexRT);
        Data_ACC(t,cuet,:)=length(indexACC)/length(A);
        Data_ES(t,cuet,:)=Data_ACC(t,cuet,:)/Data_RT(t,cuet,:);      
    end
end

xx=1:3;
for i=1:3
    for ii=1:Suball
    d=Data_ES(ii,(i-1)*3+1:(i-1)*3+3);  
    fit = polyfit(xx,d,1);
    Data_S_ES(ii,i) = fit(1);
    end
end

% save([path_in,num2str(Suball),'sub_RT_all_1.1.mat'],'Data_RT');
% save([path_in,num2str(Suball),'sub_ACC_all_1.1.mat'],'Data_ACC');
    