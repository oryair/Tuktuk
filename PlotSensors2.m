close all;
clear;

addpath('SegyMAT');

dir      = 'C:\Users\Oryair\Desktop\Workarea\Elbit\Data\\1227062016\';

fileStart = 12381;
signal_definition.directory = dir;
signal_definition.type      = 'SGY';
signal_definition.geophones = int32( 8:32 );
% signal_definition.files_vec = int32(09903 : 10178);
% signal_definition.files_vec = int32(09903 : 10000);
signal_definition.files_vec = int32(fileStart : 12458);


NewSig = Signal_Disp(signal_definition);

%%
win    = 30;
Fs     = 2000;
length = Fs * win;

% M = 4;
[~, header, ~] = ReadSegy_nadav([dir, num2str(fileStart ), '.SGY'], 'revision' , 1 , 'dsf' , 5 , 'endian' , 'l');
fileTimeStart = header(1).MinuteOfHour;
% fileTimeStart = 27;
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