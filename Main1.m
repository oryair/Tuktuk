close all;
% clear;

% addpath('SegyMAT');

dir      = 'C:\Users\Oryair\Desktop\Workarea\Elbit\Data\0827062016\';
fileName = '08860.SGY';

[Data2, SegyTraceHeaders2,SegyHeader2] = ReadSegy_nadav([dir, fileName], 'revision' , 1 , 'dsf' , 5 , 'endian' , 'l');

mData = xlsread('logbook - balmas.xlsx', 2);
[~, sensorOrder] = sort(mData(:,4));

figure; wiggle(Data(:, sensorOrder)); colorbar;