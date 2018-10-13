function A = spatial_filter(A, map)

[r,c] = size(map);
n = numel(A.time);
data = zeros(r,c,n);

holes = [];
for i=1:r
    for j=1:c
        ch = map(i,j);
        idx = find(ch == A.idx);
        if isempty(idx)
            sig = nan(1,n);
            holes = [holes ; i j];
        else
            sig = A.data(idx,:);
        end
        
        data(i,j,:) = sig;
    end
end

%hardcode for now -- fix later
data(3,1,:) = (data(2,1)+data(3,2))./2;
data(3,3,:) = (data(3,2)+data(2,3))./2;

%spatial filter
h = fspecial('log',[3 3],0.5);
data = imfilter(data,h);

z = 1;
for i=1:r
    for j=1:c
        A.data(z,:) = data(i,j,:);
        z = z + 1;
    end
end

A.idx = 1:size(A.data,1);
        

