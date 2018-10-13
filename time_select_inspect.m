function A = time_select_inspect(A)
%plots time series can requires user input to truncate beginning and end

plot(A.time,A.adc)
st = input('Enter start time: \n');
ed = input('Enter end time: \n');

if and(isnumeric(st),isnumeric(ed))
    A = time_select(A,[st ed]);
else
    disp('Keeping all time records');
end
