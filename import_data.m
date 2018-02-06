%Imports data by asking user to select a list of files. Then it parses
%different epochs and structures then in my standard format

function [A, map] = import_data()


%grab all file runs. ensure files start one after another (no breaks) for
%files within the same run
[files, path] = uigetfile('*.rhd','MultiSelect','on');

if (~iscell(files))
    files = {files};
end

%load map
map_file = [path 'electrode_map.csv'];
try
    map = import_map(map_file);
catch
    disp('No electrode_map.csv file found')
    map = 0;
end

%get epoch names
z = 1;
epoch_names{1} = '';
for i=1:numel(files)
    str = files{i};
    ids = strfind(str, '_');
    base = str(1:ids(1)-1);
    
    if (z == 1)    
        eph_name = [];
    else
        eph_name = epoch_names{z-1};
    end
    
    new_name = ~strcmp(base, eph_name);
    if (new_name)        
        epoch_names{z} = base;
        z = z + 1;
    end
end

% grab data parameters
cfg.ds = 1;
cfg.dt = 1;
cfg.adc = 1;
cfg.path = path;
fields = {'data','idx','file','idx_name','adc','adc_fs','fs','time','imp'};
A = struct(fields{1}, [], fields{2}, [], fields{3}, [], fields{4}, [], ...
    fields{5}, [], fields{6}, [], fields{7}, [], fields{8}, [], fields{9}, []);
%A = cell(size(epoch_names));

%loop that imports data
for i=1:numel(epoch_names) %parallelize
    file_ids = zeros(size(files));
    for j=1:numel(files)
        epoch_match = ~isempty(strfind(files{j}, epoch_names{i}));
        file_ids(j) = epoch_match;
    end    
    file_ids_val = find(file_ids);
    cfg.n = numel(file_ids_val);
    %file = files{ file_ids_val(1) }; %first file for this epoch
    [data,meta,adc] = grab_data3(cfg,files);
    
    % Structure data
    cfg.adc_data = adc;
    A(i) = struct_data(data,meta,cfg);
    clearvars data adc    
end

end