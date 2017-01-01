close all;
clear;

addpath('SegyMAT');

dir      = 'C:\Users\Oryair\Desktop\Workarea\Elbit\Data\1227062016\';
fileName = '08860.SGY';

% [Data, SegyTraceHeaders, SegyHeader] = ReadSegy_nadav([dir, fileName], 'revision' , 1 , 'dsf' , 5 , 'endian' , 'l');

% mData = xlsread('logbook - balmas.xlsx', 2);
% [~, sensorOrder] = sort(mData(:,4));

% figure; wiggle(Data(:, sensorOrder)); colorbar;

dirTimeStart  = 27;
fileTimeStart = 44;
fileTimeEnd   = 51;

firstFile  = 11739;

fileStart = firstFile + (fileTimeStart - dirTimeStart)  * 60 / 5;
fileEnd   = fileStart + (fileTimeEnd   - fileTimeStart) * 60 / 5;

signal_definition.directory = dir;
signal_definition.type      = 'SGY';
signal_definition.geophones = int32( 8:32 );
signal_definition.files_vec = int32(fileStart : fileEnd);



NewSig = Signal_Disp(signal_definition);

%%
win    = 30;
Fs     = 2000;
length = Fs * win;

% M = 4;
figure;
for ii = 1 : 500 : (size(NewSig, 1) - length)
    vT = (ii : (ii + length)) / Fs;
    vT = vT / 60 + fileTimeStart;
    subplot(1,2,1);
    plot(vT, NewSig(ii : ii + length, 1:12)); 
    xlim([vT(1), vT(end)]);
    set(gca, 'YTick', (7:1:20) + 0.5);
    ylim([7.5, 20.5]);
    grid on;
     
    subplot(1,2,2);
    plot(vT, NewSig(ii : ii + length, 13:25)); 
    xlim([vT(1), vT(end)]);
    set(gca, 'YTick', (19:1:32) + 0.5);
    ylim([19.5, 32.5]);
    grid on;
    drawnow;
end



% [b,a]    = butter(5 , 60/(Fs/2) , 'high' );
% signal   = filter(b,a,signal);
% signal   = signal(5*2000:end,:);
% time_vec = time_vec(5*2000:end);