classdef CalculateHbDiff < nirs.modules.AbstractModule
    %% CalculateHbDiff - This function will add hemoglobin diff to the 
    % data structure.  This function will accept either nirs.core.Data 
    % (time-series). The input must have the hbo/hbr data types. 

    properties

    end
    
    methods
        
        function obj = CalculateHbDiff( prevJob )
            obj.name = 'Add Hb diff to data';
            if nargin > 0
                obj.prevJob = prevJob;
            end
        end
        
        function data = runThis( obj, data )
            if(~all(ismember({'hbo','hbr'},data(1).probe.link.type)))
                warning('data does not contain oxy/deoxy-Hb.  Use the MBLL first');
                return
            end
            for i = 1:numel(data)
                if(isa(data(i),'nirs.core.Data'))
                    %Time series models
                    link=data(i).probe.link;
                    link=link(ismember(link.type,'hbo'),:);
                    HbD=zeros(size(data(i).data,1),height(link));
                    
                    for j=1:height(link)
                        iHbO=find(ismember(data(i).probe.link(:,1:2),link(j,1:2)) & ismember(data(i).probe.link.type,'hbo'));
                        iHbR=find(ismember(data(i).probe.link(:,1:2),link(j,1:2)) & ismember(data(i).probe.link.type,'hbr'));
                        HbO2=data(i).data(:,iHbO);
                        HbR=data(i).data(:,iHbR);
                        HbD(:,j)=HbO2-HbR;
                    end
                    
                    linkHbD=link;
                    linkHbD.type=repmat({'hbd'},height(link),1);
                    data(i).data=[data(i).data HbD];
                    data(i).probe.link=[data(i).probe.link; linkHbD];
                    data(i)=sorted(data(i));
                end
            end
        end
    end
    
end

