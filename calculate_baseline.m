function []=calculate_baseline(year,month,month_day,station,usrid)
data=download_supermag(year,month,month_day,station,usrid);
% load(['E:\DATA\MAG\Ground\Ground_main\',station,'\',num2str(year),num2str(month,'%02d'),'.mat']);
extracted_data=extract_q_values('E:\DATA\INDEX\Quiet_days.txt');
[ia,~]=find(extracted_data(:,1)==year&extracted_data(:,2)==month);
q_date=extracted_data(ia,3:7);
[ia,~]=find(data(:,3)==q_date(1)|data(:,3)==q_date(2)|data(:,3)==q_date(3)|data(:,3)==q_date(4)|data(:,3)==q_date(5));
q_data=data(ia,:);
lt=datevec(datetime(q_data(:,1:6))+minutes(q_data(1,8)));
lt=lt(:,4)+lt(:,5)/60+lt(:,6)/3600;
[ia,~]=find(lt>=22&lt<=4);
baseline=mean(q_data(ia,9));
data_rb=data(:,9)-baseline;
data=[data,data_rb];
save(['E:\DATA\MAG\Ground\Ground_main\',station,'\',num2str(year),num2str(month,'%02d'),'_rb.mat'],'data')




