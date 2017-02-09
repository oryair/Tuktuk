close all;
% clear;

% addpath('SegyMAT');

dir      = 'C:\Users\Oryair\Desktop\Workarea\Elbit\Data\1227062016\';
fileName = '12381.SGY';

[Data2, SegyTraceHeaders2,SegyHeader2] = ReadSegy_nadav([dir, fileName], 'revision' , 1 , 'dsf' , 5 , 'endian' , 'l');
SegyTraceHeaders2(1).MinuteOfHour

mData = xlsread('logbook - balmas.xlsx', 2);
[~, sensorOrder] = sort(mData(:,4));

% figure; wiggle(Data(:, sensorOrder)); colorbar;