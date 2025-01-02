clc
clear all
close all

%%
% Import the master curve data from the Excel file
MasterCurveData = importdata('C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\MasterCurve.xlsx');
Modulus_TempSweepData = importdata('C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\Modulus_TempSweepData.xlsx');

% Skip the first two rows (assuming data starts from the third row)
MasterCurveData = MasterCurveData.data(3:end, :);  % Adjust '3:end' to skip rows 1 and 2

% Extract frequency, storage, and loss data
frequency = MasterCurveData(:,1);
storageModulus = MasterCurveData(:,2);
lossModulus = MasterCurveData(:,3);

% Savitzky-Golay Smoothing (Polynomial filter)
polynomialOrder = 3;  % Order of the polynomial fit
frameSize = 21;  % Must be odd and greater than polynomialOrder

% Apply Savitzky-Golay filter to storage and loss moduli
smoothStorage_SG = sgolayfilt(storageModulus, polynomialOrder, frameSize);
smoothLoss_SG = sgolayfilt(lossModulus, polynomialOrder, frameSize);

% Create Smoothed_MasterCurve matrix
Smoothed_MasterCurve(:,1) = frequency;
Smoothed_MasterCurve(:,2) = smoothStorage_SG;
Smoothed_MasterCurve(:,3) = smoothLoss_SG;

%% Match values at ~1 Hz with values at temperature 328.15 K
targetFrequency = 1;  % Target frequency (1 Hz)

% Find the index for the frequency closest to 1 Hz in Smoothed_MasterCurve
[~, freqIdx] = min(abs(Smoothed_MasterCurve(:,1) - targetFrequency));

% Get storage and loss modulus at 1 Hz in Smoothed_MasterCurve
storageAt1Hz_Smoothed = Smoothed_MasterCurve(freqIdx, 2)./10^6;
lossAt1Hz_Smoothed = Smoothed_MasterCurve(freqIdx, 3)./10^6;

% Convert the temperatures from Celsius to Kelvin
TemperatureMap_K = Modulus_TempSweepData.data(:,5) + 273.15;

% Find the index for the temperature closest to 328.15 K
targetTemperature = 328.15;
[~, tempIdx] = min(abs(TemperatureMap_K - targetTemperature));

% Extract storage (6th column) and loss modulus (7th column) at the target temperature
storageAt328K_TempSweep = Modulus_TempSweepData.data(tempIdx, 6);
lossAt328K_TempSweep = Modulus_TempSweepData.data(tempIdx, 7);

% Calculate scaling factors to match storage and loss moduli
scalingFactorStorage = storageAt328K_TempSweep / storageAt1Hz_Smoothed;
scalingFactorLoss = lossAt328K_TempSweep / lossAt1Hz_Smoothed;

% Apply scaling factors to Smoothed_MasterCurve
Smoothed_MasterCurve(:,2) = Smoothed_MasterCurve(:,2) * scalingFactorStorage;
Smoothed_MasterCurve(:,3) = Smoothed_MasterCurve(:,3) * scalingFactorLoss;

%% Plot the result

figure;
yyaxis left;
loglog(frequency, Smoothed_MasterCurve(:,2), 'b', 'LineWidth', 2);
ylabel('Scaled Storage Modulus (Pa)');
hold on;

yyaxis right;
loglog(frequency, Smoothed_MasterCurve(:,3)./Smoothed_MasterCurve(:,2), 'r', 'LineWidth', 2);
ylabel('Scaled tan \delta');
xlabel('Frequency (Hz)');
title('Smoothed and Scaled Data');
legend('Scaled Storage Modulus', 'Scaled tan \delta');
