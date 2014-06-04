%{
mock.KalmanFinalize (computed) # my newest table
-> mock.KalmanAutomatic
-----
-> mock.KalmanManual
final_model: LONGBLOB # The finalized model
kalmanfinalize_ts=CURRENT_TIMESTAMP: timestamp           # automatic timestamp. Do not edit
%}

classdef KalmanFinalize < dj.Relvar & dj.AutoPopulate

	properties
		popRel = mock.KalmanAutomatic & mock.KalmanManual;
	end

	methods
		function self = KalmanFinalize(varargin)
			self.restrict(varargin)
        end
    end
    
    methods (Access=protected)
        function makeTuples( this, key )
            % Cluster spikes
            %
            % JC 2011-10-21
            close all
            
            names = fetchn(mock.Experimenter & (mock.KalmanManual & key), 'experimenter_name');
            fprintf('Select by number who was more sane:\n');
            for i = 1:length(names)
                
                fprintf('%d) %s\n', i, names{i});
                
            end
            resp = str2num(input('','s'));
            key_manual = fetch(mock.KalmanManual & key & mock.Experimenter(sprintf('experimenter_name = "%s"', names{resp})));
            
            
            tuple = key_manual;
            
            model = fetch1(mock.KalmanManual & key_manual,'manual_model');
 
            m = MoKsmInterface(model);           
            m = uncompress(m);
            m = updateInformation(m);
            
            tuple.final_model = saveStructure(compress(m));
            insert(this,tuple);
           
            % Insert entries for the single units
            %makeTuples(sort.KalmanUnits, key, m);
        end
    end
end
