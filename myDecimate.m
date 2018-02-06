function Y = myDecimate(X,cfg)
%Assume X is samples x columns
%Return Y which is samples x columns

ds = cfg.ds;


b = fir1(30,1/ds,'low');
Y = filter(b,1,X);

delay = 15;

Y = Y(delay:end,:);

Y = downsample(Y,ds);

end