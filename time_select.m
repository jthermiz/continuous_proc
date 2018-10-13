function X = time_select(X,trange)
%Return new data structure from trange(1) to trange(2)
%Example:
%   X = time_select(X, [10 15]); %units are in seconds

n = numel(X);

%Time selects

for i =1:n    
    
    [~,a] = min(abs(trange(1) - X(1).time));
    [~,b] = min(abs(trange(2) - X(1).time));
    
    X(i).data = X(i).data(:,a:b);
    X(i).time = X(i).time(:,a:b);
    
    if isfield(X,'rej')
        X(i).rej = X(i).rej(a:b);
    end
    
    if isfield(X,'adc')
        X(i).adc = X(i).adc(a:b);
    end
    
    if isfield(X,'error')
        X(i).error = X(i).error(:,a:b);
    end
    
    if isfield(X,'gtime')
        X(i).gtime = X(i).gtime(a:b);
    end
end

end