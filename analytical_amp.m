function A = analytical_amp(A,cfg)
%compute analytical amplitude of designated passband range
%cfg.freqLP is optional low pass frequency cutoff

%Example: 
%cfg_aa = [];
%cfg_aa.freqLP = 25;
%cfg_aa.freq = [70 170];
%B = analytical_amp(A,cfg_aa);

if isfield(cfg,'freqLP')
    freqLP = cfg.freqLP;
    [bl,al] = butter(3,freqLP./(A.fs/2),'low');
    LP_flag = 1;
else
    LP_flag = 0;
end


freq = cfg.freq;
[b,a] = butter(3,freq./(A.fs/2),'bandpass');

Y = A.data;

for i=1:numel(A.idx)
    Y(i,:) = filtfilt(b, a, A.data(i,:))';
    Y(i,:) = abs(hilbert(Y(i,:)));
    if LP_flag
        Y(i,:) = filtfilt(bl, al, Y(i,:));
    end
end


A.data = Y;