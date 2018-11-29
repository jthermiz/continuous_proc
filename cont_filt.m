function A = cont_filt(A, cfg)
% Example:
% fcfg.range = [1 10];
% fcfg.invert = 0;
% B = cont_filt(A, fcfg);

range = cfg.range;
ny = A.fs/2;
order = 2;

%design filter
if cfg.range(1) == 0
    %low pass filter
    [b,a] = butter(order, range(2)/ny, 'low');
elseif cfg.range(2) == 0
    %high pass filter
    [b,a] = butter(order, range(1)/ny, 'high');
else
    if cfg.invert == 0
        %bandpass
        [b,a] = butter(order, range./ny,'bandpass');
    else
        %notch
        [b,a] = butter(order, range./ny,'stop');
    end
end

X = A.data';

%filter forward and back
y = filtfilt(b,a,X(:));

A.data = reshape(y,size(X))';


