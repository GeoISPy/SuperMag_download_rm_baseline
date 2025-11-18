function data=download_supermag(year,month,month_day,station,usrid)

data=[];
for i=1:month_day
    sm_data = fetchSuperMAG('data',usrid,[year,month,i,0,0,0],86400,'all,baseline=none',station);
    if ischar(sm_data)
        sm_data=regexprep(sm_data, 'nan', 'null');
        index=find(sm_data=='[',1);
        sm_data=jsondecode(sm_data(index:end-26));
    end
    TVAL=[sm_data.tval];
    tval=datevec(datetime(datenum(datetime(1970,1,1,0,0,0))+TVAL/86400, 'ConvertFrom', 'datenum').');
    N_NEZ = arrayfun(@(k) sm_data(k).N.nez, 1:numel(sm_data));
    E_NEZ = arrayfun(@(k) sm_data(k).E.nez, 1:numel(sm_data));
    Z_NEZ = arrayfun(@(k) sm_data(k).Z.nez, 1:numel(sm_data));
    MLT=[sm_data.mlt];
    MCOLAT=[sm_data.mcolat];
    GLON=[sm_data.glon];
    GLAT=[sm_data.glat];
    SZA=[sm_data.sza];
    data=[data;tval,GLAT.',GLON.',N_NEZ.',E_NEZ.'];
end
path=['E:\DATA\MAG\Ground\Ground_main\',station,'\'];
if ~exist(path,"dir")
    mkdir(path)
end

save(['E:\DATA\MAG\Ground\Ground_main\',station,'\',num2str(year),num2str(month,'%02d'),'.mat'],'data')
