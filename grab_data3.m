%Given a cell array of file names, it will import the data in chronological
%order. Be aware that this doesn't gurantee that the files don't have
%pauses b/w them.

function [data, meta, adc, path] = grab_data3(cfg,files)

ds = cfg.ds; %downsample factor
n = numel(files);
path = cfg.path;

files = sort_nat(files); %sorts in choronological based on file name

tmp = read_Intan_RHD2000_file(files{1},path);
meta.notes = tmp.notes;
meta.frequency_parameters = tmp.frequency_parameters;
meta.file = tmp.file;
meta.path = tmp.path;


meta.amplifier_channels = tmp.amplifier_channels;
meta.spike_triggers = tmp.spike_triggers;

data = cell(1,n);
adc = cell(1,n);
chan_names = make_chan_names_pretty([tmp.amplifier_channels.native_channel_name]);

try
    chan_names_idx = zeros(size(cfg.chan_names,1),1);
    chan_sel_flag = 1;
catch
    chan_names_idx = 1:size(chan_names,1);
    chan_sel_flag = 0;
end

if (chan_sel_flag == 1)
    for i=1:size(cfg.chan_names,1)
        for j=1:size(chan_names,1)
            
            if strcmp(cfg.chan_names(i,:),chan_names(j,:))
                chan_names_idx(i) = j;
                break;
            end
            
        end
    end
end

data{1,1} = tmp.amplifier_data(chan_names_idx,:);
if (cfg.adc)
    try
        adc{1,1} = tmp.board_adc_data';
    catch
        disp('No ADC Chan Found');
        cfg.adc = 0; %assumes if there is not adc channel is first file there will be none in subsequent
    end
end

if (n > 4)
    parfor i=2:n
        tmp = read_Intan_RHD2000_file(files{i},path);
        
        data{1,i} = tmp.amplifier_data(chan_names_idx,:);
        if (cfg.adc)
            adc{1,i} = tmp.board_adc_data';
        end
        
        %     a = data_seg_length*(i-1)+1;
        %     b = data_seg_length*i;
        %
        %     data(:,a:b) = downsample(tmp.amplifier_data',ds)';
        
    end
else
    for i=2:n
        tmp = read_Intan_RHD2000_file(files{i},path);
        
        data{1,i} = tmp.amplifier_data(chan_names_idx,:);
        if (cfg.adc)
            adc{1,1} = tmp.board_adc_data';
        end
        
        %     a = data_seg_length*(i-1)+1;
        %     b = data_seg_length*i;
        %
        %     data(:,a:b) = downsample(tmp.amplifier_data',ds)';
        
    end
end
dec.ds = ds;
data = cell2mat(data);
if (cfg.ds > 1)
    data = myDecimate(data',dec)';
end

if (cfg.adc == 1)
    adc = cell2mat(adc')';
    %[rows,cols] = size(adc);
    %adc = reshape(adc,1,rows*cols); %not sure why this is here? but if
    %multiple adc channels are recorded need to keep separate!
    if (cfg.ds > 1)
        adc = myDecimate(adc',dec)';
    end
end

%delete(gcp('nocreate'))