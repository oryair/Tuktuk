close all;
clear;

% addpath('SegyMAT');
% 
% dir      = 'C:\Users\Oryair\Desktop\Workarea\Elbit\Data\1227062016\';
% dir      = 'E:\Elbit\Data\1227062016\';
% 
% fileStart = 12381;
% signal_definition.directory = dir;
% signal_definition.type      = 'SGY';
% signal_definition.geophones = int32( 8:32 );
% % signal_definition.files_vec = int32(09903 : 10178);
% % signal_definition.files_vec = int32(09903 : 10000);
% signal_definition.files_vec = int32(fileStart : 12458);
% 
% 
% NewSig = Signal_Disp(signal_definition);

[mData2, vS, vM, vH] = GetEventsData([122700, 123700]);
%%

mData = mData2;
vStd  = std(mData);
mData = bsxfun(@minus,   mData, mean(mData));
mData = bsxfun(@rdivide, mData, 20*vStd);
mData = bsxfun(@plus,    mData, 8:32);

%%
secondsWin = 60;
Fs         = 2000;
length     = Fs * secondsWin;

% M = 4;
% [~, header, ~] = ReadSegy_nadav([dir, num2str(fileStart ), '.SGY'], 'revision' , 1 , 'dsf' , 5 , 'endian' , 'l');
% fileTimeStart = header(1).MinuteOfHour;
% fileTimeStart = 27;
% fileTimeStart = rem(vTime(1), 100);
figure;
for ii = 1 : 1000 : (size(mData, 1) - length)
    
    vIdx = ii : ii + length;
    vT   = vM(vIdx) + vS(vIdx) / 60;

    subplot(1,2,1);
    plot(vT, mData(ii : ii + length, 1:13)); 
    title('60s window');
    ax            = gca;
    ax.YTick      = (8 : 20);
    ax.YTickLabel = 8 : 20; 
%     ax.XTickLabel = vT;
    xlim([vT(1), vT(end)]);
    ylim([7.5, 20.5]);
    grid on; set(gca, 'FontSize', 20');
    xlabel('Time');
     
    subplot(1,2,2);
    plot(vT, mData(ii : ii + length, 14:25)); 
    ax            = gca;
    ax.YTick      = 21 : 32;
    ax.YTickLabel = 21 : 32; 
%     ax.XTickLabel = vT;
    xlim([vT(1), vT(end)]);
    ylim([20.5, 32.5]);
    grid on; set(gca, 'FontSize', 20');
    xlabel(['Hour - ', num2str( vH(ii) )]);
    drawnow;
end



% [b,a]    = butter(5 , 60/(Fs/2) , 'high' );
% signal   = filter(b,a,signal);
% signal   = signal(5*2000:end,:);
% time_vec = time_vec(5*2000:end);