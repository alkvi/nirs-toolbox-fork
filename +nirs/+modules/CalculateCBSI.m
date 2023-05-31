classdef CalculateCBSI < nirs.modules.AbstractModule
    %% CalculateCBSI - This function will add CBSI (see Cui 2010) to the 
    % data structure.  This function will accept either nirs.core.Data 
    % (time-series). The input must have the hbo/hbr data types. 

    properties

    end
    
    methods
        
        function obj = CalculateCBSI( prevJob )
            obj.name = 'Add CBSI to data';
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
                    CBSI=zeros(size(data(i).data,1),height(link));
                    
                    for j=1:height(link)
                        iHbO=find(ismember(data(i).probe.link(:,1:2),link(j,1:2)) & ismember(data(i).probe.link.type,'hbo'));
                        iHbR=find(ismember(data(i).probe.link(:,1:2),link(j,1:2)) & ismember(data(i).probe.link.type,'hbr'));
                        HbO2=data(i).data(:,iHbO);
                        HbR=data(i).data(:,iHbR);
                        
                        % Cui 2010, Correlation based signal improvement (CBSI)
                        % x_0 = (1/2)*(hbo-alpha*hbr)
                        % See also www.alivelearn.net/nirs/CBSI.m
                        alpha = std(HbO2)./std(HbR);
                        x_0 = (1/2) * (HbO2 - repmat(alpha, size(HbO2,1),1) .* HbR);
                        CBSI(:,j)=x_0;
                    end
                    
                    linkCBSI=link;
                    linkCBSI.type=repmat({'cbsi'},height(link),1);
                    data(i).data=[data(i).data CBSI];
                    data(i).probe.link=[data(i).probe.link; linkCBSI];
                    data(i)=sorted(data(i));
                end
            end
        end
    end
    
end

