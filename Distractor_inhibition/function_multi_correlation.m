%%
% sub is the label of subject (across subject)
% X is kernel data (N*1)
% Y is multi-data (N*Dimension1*Dimension2)
% plotindex is wheather oupt figures (1=Yes,0=No)
function [R1,P1,R2,P2,R3,P3,Rs,Ps,Target_data] = function_multi_correlation(sub,X,X_label,Y,Y_label,Dimension1,plotindex,D1_window,oupt_threshold)
nsub=length(sub);
type_str={X_label,Y_label};
n=1;
target_data=[];
for T=1:length(Dimension1)
%% robust regression
y=[];y=Y(:,T);b_robust=[];stats_robust=[];
[b_robust,stats_robust]=robustfit(X,y);
y_robustfit = y-stats_robust.resid;%
p1=stats_robust.p(2);%
r1=b_robust(2)./stats_robust.se(2)/sqrt(nsub);
%% simple line regression
bint=[];resid=[];rint=[];stats=[];
[b,bint,resid,rint,stats] = regress(y,[X,ones(nsub,1)]);
y_linefit = y - resid;
r2=sqrt(stats(1));
p2=stats(3);
%% outlierÒì³£µã
mul=[];outer_I=[];in_I=[];X_outer=[];y_linefit_outer=[];resid_outer=[];stats_outer=[];
mul=rint(:,1).*rint(:,2);
outer_I=find(mul>0);
in_I = find(mul<0);
X_outer = X(in_I);
[bb_outer,bint_outer,resid_outer,rint_outer,stats_outer] = ...
regress(y(in_I),[X(in_I),ones(length(in_I),1)]);
y_linefit_outer = y(in_I) - resid_outer;
r3=sqrt(stats_outer(1));
p3=stats_outer(3);
[rs,ps]=corr(X,y,'tail','both','type','spearman'); 
switch plotindex
    case 0  % find roi data
% plot
  if  (p3 < oupt_threshold)
      if (Dimension1(T)>D1_window(1))&&(Dimension1(T)<D1_window(2))
%           if (Dimension2(bb)>D2_window(1))&&(Dimension2(bb)<D2_window(2))
          target_data(n,:)=y;
          n=n+1;
%           end
      end
  end
    case 1    %% plot every correlation points
  if  (p3 < oupt_threshold)
      if (Dimension1(T)>D1_window(1))&&(Dimension1(T)<D1_window(2))
%           if (Dimension2(bb)>D2_window(1))&&(Dimension2(bb)<D2_window(2))
  figure
  scatter(X,y,25,'o')%
  hold on %
     for i=1:length(sub)
     c=num2str(sub(i));
     c=[' ',c];
     text(X(i),y(i),c)
     end
% hold on
     scatter(X(outer_I),y(outer_I),25,'*','red')%
     [aaaa,i]=sort(X);
     hold on
     plot(X(i),y_linefit(i),'g','linewidth',2)
     plot(X(i),y_robustfit(i),'red','linewidth',2)
     hold on
     %%without out_lier
     [aaaa,i]=sort(X_outer);
     plot(X_outer(i),y_linefit_outer(i),'blue','linewidth',2)%
     %%set xLab yLab
     xlabel(type_str{1},'fontsize',14,'fontweight','b','color','b');
     ylabel(type_str{2},'fontsize',14,'fontweight','b','color','b');
%%no weight
    texts={['line\_r2=',num2str(r2),'\_p2=',num2str(p2)],...
    ['rbs\_r1=',num2str(r1),'\_p1=',num2str(p1)],...
    ['spr\_rs=',num2str(rs),'\_ps=',num2str(ps)],...
    ['line\_outer\_r3=',num2str(r3),'\_p3=',num2str(p3)]};
    h=legend(texts);
    set(h,'Location','Southwest');
    tlow=Dimension1(T);%
    title(['corr_',type_str{1},num2str(tlow),'&',type_str{2}]);
%   saveas(gcf,[path_out,'\','corr_alpha_',num2str(tlow),'&ERP.jpg'],'jpg');
%           end
      end
  end
end
    %% 
   R1(T,:)=r1;
   P1(T,:)=p1;
   R2(T,:)=r2;
   P2(T,:)=p2;
   R3(T,:)=r3;
   P3(T,:)=p3;
   Rs(T,:)=rs;
   Ps(T,:)=ps;
end
  if  isempty(target_data)
      Target_data=zeros(1,nsub);    
  else
      Target_data=(mean(target_data,1));  
  end
end
