%{
mock.KalmanParams (lookup) # Association of detection method with Kalman sorting parameters
# add primary key here
-> detect.Methods
-----
params                : longblob                # Sorting parameter
%}

classdef KalmanParams < dj.Relvar
    methods
        function self = KalmanParams(varargin)
            self.restrict(varargin{:});
        end
    end
end