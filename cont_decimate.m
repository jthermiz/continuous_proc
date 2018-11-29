function B = cont_decimate(A,cfg)

ds = cfg.ds;

[n,T] = size(A.data);
T = floor(T/ds);

B = A;
B.time = downsample(A.time,ds);
B.fs = A.fs/ds;
B.data = zeros(n,T);
B.adc = downsample(A.adc,ds);

B.data = myDecimate(A.data',cfg)';
