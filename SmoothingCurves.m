clc
clear all
close all

%%
% Import the master curve data from the Excel file
data = importdata('C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\MasterCurve.xlsx');

% Skip the first two rows (assuming data starts from the third row)
MasterCurveData = data.data(3:end, :);  % Adjust '3:end' to skip rows 1 and 2

% Extract frequency, storage, and loss data
frequency = MasterCurveData(:,1);
storageModulus = MasterCurveData(:,2);
lossModulus = MasterCurveData(:,3);

%% Choose Smoothing Method

% 1. Moving Average Smoothing
windowSize = 25;  % Adjust based on how smooth you want the curve

% Apply moving average filter to storage and loss moduli
smoothStorage = movmean(storageModulus, windowSize);
smoothLoss = movmean(lossModulus, windowSize);

% 2. Savitzky-Golay Smoothing (Polynomial filter)
polynomialOrder = 3;  % Order of the polynomial fit
frameSize = 21;  % Must be odd and greater than polynomialOrder

% Apply Savitzky-Golay filter to storage and loss moduli
smoothStorage_SG = sgolayfilt(storageModulus, polynomialOrder, frameSize);
smoothLoss_SG = sgolayfilt(lossModulus, polynomialOrder, frameSize);

%% Plot the Original and Smoothed Data in a Single Plot

figure;
% Plot original storage modulus
yyaxis left;
loglog(frequency, storageModulus, '--k', 'LineWidth', 1.5);  % Original in dashed black
hold on;
% Plot smoothed storage modulus (Moving Average)
loglog(frequency, smoothStorage, '-b', 'LineWidth', 1.5);  % Moving average in blue
% Plot smoothed storage modulus (Savitzky-Golay)
loglog(frequency, smoothStorage_SG, '-r', 'LineWidth', 1.5);  % Savitzky-Golay in red

ylabel('Storage Modulus (Pa)');

% Plot original and smoothed tan delta
yyaxis right;
% Original tan delta
loglog(frequency, lossModulus./storageModulus, '--k', 'LineWidth', 1.5);  % Original in dashed black
% Smoothed tan delta (Moving Average)
loglog(frequency, smoothLoss./smoothStorage, '-b', 'LineWidth', 1.5);  % Moving average in blue
% Smoothed tan delta (Savitzky-Golay)
loglog(frequency, smoothLoss_SG./smoothStorage_SG, '-r', 'LineWidth', 1.5);  % Savitzky-Golay in red

ylabel('tan \delta');
xlabel('Frequency (Hz)');

% Add title and legend
legend('Original', 'Moving Avg Smoothed','Savitzky-Golay Smoothed');

hold off;

