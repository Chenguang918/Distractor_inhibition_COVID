%%
clear
sub=[3:34];
load('Valid_correlation_data.mat')
load('time.mat')
load('PD_Mean.mat');
% PD(20)=[];valide(20,:)=[];
MI=mean(valide(:,362:372),2);

[rho,pval]=corr(PD,MI);
plot(X,pval);
