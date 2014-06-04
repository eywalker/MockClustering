%{
mock.KalmanAutomatic (computed) # my newest table

-> sort.Electrodes
---
model                       : longblob                      # The fitted model
git_hash=""                 : varchar(40)                   # git hash of MoKsm package
kalmanautomatic_ts=CURRENT_TIMESTAMP: timestamp             # automatic timestamp. Do not edit
%}

classdef KalmanAutomatic < dj.Relvar & dj.AutoPopulate

    properties
        popRel = sort.Electrodes * sort.Methods('sort_method_name = "MoKsm"') & mock.KalmanParams;
    end

    methods
        function self = KalmanAutomatic(varargin)
            self.restrict(varargin)
        end
    end

    methods (Access=protected)
        function makeTuples( this, key )
            % Cluster spikes
            
            de_key = fetch(detect.Electrodes(key));
            
            m = MoKsmInterface(de_key);

            % Obtain detection method dependent parameters
            params = fetch1(mock.KalmanParams & (detect.Methods & de_key), 'params');
            
            m = getFeatures(m, params.feature_name, params.feature_num);
            
            m.params.DriftRate = params.DriftRate;
            m.params.ClusterCost = params.ClusterCost;
            m.params.Df = params.Df;
            m.params.Tolerance = params.Tolerance;
            m.params.CovRidge = params.CovRidge;
            m.params.DTmu = params.DTmu;
            
            fprintf('Fetched sorting parameters\n');
            
            
            fitted = fit(m);
            plot(fitted);
            drawnow
            
            tuple = key;
            tuple.model = saveStructure(compress(fitted));
            tuple.git_hash = gitHash('MoKsm');
            insert(this, tuple);
            
            makeTuples(mock.KalmanTemp, key, fitted);
        end
    end
end
