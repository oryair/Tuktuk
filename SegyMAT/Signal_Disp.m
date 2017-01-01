function [NewSig] = Signal_Disp(signal_definition)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                   %%%%
%                    SIGNAL DEFINITIONS                   %
%%%%                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% signal_definition.directory = 'C:\Users\tc30108\Desktop\files';
% signal_definition.type = 'SGY';
% signal_definition.geophones = int32( 12:15 );
% signal_definition.files_vec  = int32(10301:10325);

files = cell(1,length(signal_definition.files_vec));
for f=1:length(files)
    file_tmp = '00000.SGY';
    file_tmp_dot = find( file_tmp == '.' , 1 , 'last' );
    file_num_str = num2str( signal_definition.files_vec(f) );
    file_tmp( file_tmp_dot-length(file_num_str) : file_tmp_dot-1 ) = file_num_str;
    files{f} = file_tmp;
end


FsSystem = 2000;

ch_disp = 1;

% RUN %
%%%%%%%
signal = [];
time_vec = [];

for f = 1:length(files)
    
    full_path = fullfile( signal_definition.directory , files{f} );
    if ~exist(full_path,'file')
        disp([full_path,' does not exist']);
        continue
    end
    
    file = files{f};
    file_number = str2double( file(1:find(file=='.')-1) );
    if isnan( file_number )
        file_number = f;
    end
    
    disp(file);
    
    % READ SIGNAL
    switch signal_definition.type
        
        case {'dat','DAT','Dat'}                % SEG2
            [signal_new,header] = seg2load( full_path );
            signal_new = signal_new(:,signal_definition.geophones);
            Fs = 1/header.tr.sampling(1);
        case {'sgy','SGY','Sgy'}                % SEGY
            %             [signal_new,~,SegyHeader] = ReadSegy( full_path , 'revision' , 1 , 'dsf' , 5 , 'endian' , 'l' );
            [signal_new,A,SegyHeader] = ReadSegy_nadav( full_path , 'revision' , 1 , 'dsf' , 5 , 'endian' , 'l' , 'traces' , signal_definition.geophones );
%             [signal_new,A,SegyHeader] = ReadSegy_nadav( full_path , 'revision' , 1 , 'dsf' , 5 , 'endian' , 'l');
            signal_new = signal_new(1:end-1,:);
            Fs = 1/SegyHeader.time(1);
            clear SegyTraceHeaders SegyHeader
        case {'mat','MAT','Mat'}                % mat
            data_load = load( full_path );
            signal_new = [];
            for g=1:length(signal_definition.geophones)
                signal_new = eval(['[signal_new data_load.Channel_',num2str(g),'_Data];']);
            end
            Fs = ExpData_NB.Fs;
            clear data_load
    end
    
    DateNum = datenum(double([A(1).YearDataRecorded 0 A(1).DayOfYear A(1).HourOfDay A(1).MinuteOfHour A(1).SecondOfMinute]));
    
    
    %     DateNum = GetDateSTR(A);
    
    if ~exist('time_start')
        time_start = datestr(DateNum);
    end
    
    time_end = datestr(DateNum);
    
    signal_new = resample(signal_new,FsSystem,Fs);
    signal = [ signal ; signal_new ];
    time_vec = [ time_vec ; DateNum + ((0:length(signal_new)-1)'/FsSystem)/3600/24 ];
    Fs = FsSystem;
    clear signal_new;
    
end


time_vec = ( 0 : (size(signal,1)-1) ) / Fs;

% [b,a] = butter( 5 , 60/(Fs/2) , 'high' );
% signal = filter(b,a,signal);
% signal = signal(5*2000:end,:);
% time_vec = time_vec(5*2000:end);

figure
% Max = max(max(signal))
Max = 6e-5;
NewSig = signal;
for (ch=1:size(signal,2))
    NewSig(:,ch) =  signal(:,ch)/Max+double(signal_definition.geophones(ch));
    %    NewSig(:,ch) =  NewSig(:,ch)/max(NewSig(:,ch))+ double(signal_definition.geophones(ch));
end
% plot( time_vec , NewSig );
% xlabel('Time [sec]')
% ylabel('main ch')
% title([time_start,' - ',time_end,' ( ',num2str(signal_definition.files_vec(1)),' - ',num2str(signal_definition.files_vec(end)),' )'])

% for ch = 1:size(signal,2)
%     [S,F,T] = spectrogram(signal(:,ch),hamming(Fs),0,Fs,Fs);
%     figure; imagesc( T,F, 10*log10(abs(S).^2) ); axis xy
%     title(['Channel ',num2str(signal_definition.geophones(ch)),' , ',time_start,' - ',time_end,' ( ',num2str(signal_definition.files_vec(1)),' - ',num2str(signal_definition.files_vec(end)),' )'])
%     ylim([0 600])
%     xlabel('Time [sec]')
%     ylabel('Frequency [Hz]')
% end


end

% %%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%
%
% function DateNum = GetDateSTR(A)
%
% CurrentFileRecordingTime.Year = int32(A(1).YearDataRecorded);
% [CurrentFileRecordingTime.Month,CurrentFileRecordingTime.Day] = DayOfYear2MonthAndDay(CurrentFileRecordingTime.Year, int32(A(1).DayOfYear));
% CurrentFileRecordingTime.Hour = int32(A(1).HourOfDay);
% CurrentFileRecordingTime.Minute = int32(A(1).MinuteOfHour);
% CurrentFileRecordingTime.Second = int32(A(1).SecondOfMinute);
% DateNum = datenum(double([CurrentFileRecordingTime.Year CurrentFileRecordingTime.Month CurrentFileRecordingTime.Day CurrentFileRecordingTime.Hour CurrentFileRecordingTime.Minute CurrentFileRecordingTime.Second]));
%
% end
