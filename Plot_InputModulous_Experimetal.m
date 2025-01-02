clc
clear all
close all

%%
% Import the master curve data from the Excel file
data = importdata('C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\MasterCurve.xlsx');

% Skip the first two rows (assuming data starts from the third row)
MasterCurveData = data.data(3:end, :);  % Adjust '3:end' to skip rows 1 and 2

% % Extract frequency, storage, and loss data
% frequency = MasterCurveData(:,1);
% storageModulus = MasterCurveData(:,2);
% lossModulus = MasterCurveData(:,3);

% Savitzky-Golay Smoothing (Polynomial filter)
polynomialOrder = 3;  % Order of the polynomial fit
frameSize = 21;  % Must be odd and greater than polynomialOrder

% Apply Savitzky-Golay filter to storage and loss moduli
smoothStorage_SG = sgolayfilt(MasterCurveData(:,2), polynomialOrder, frameSize);
smoothLoss_SG = sgolayfilt(MasterCurveData(:,3), polynomialOrder, frameSize);

Smoothed_MasterCurve(:,1)=MasterCurveData(:,1);
Smoothed_MasterCurve(:,2)=smoothStorage_SG;
Smoothed_MasterCurve(:,3)=smoothLoss_SG;

%%
Modulus_TempSweepData = importdata('C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\Modulus_TempSweepData.xlsx');

targetFrequency = Modulus_TempSweepData.data(1,1)/2/pi; % = 1 Hz

TemperatureMap = Modulus_TempSweepData.data(:,5);

% Convert the temperatures from Celsius to Kelvin
TemperatureMap_K = TemperatureMap + 273.15;  % Convert to Kelvin

T = [303.15, 308.15, 313.15, 318.15, 323.15, 328.15, 333.15, 338.15, 343.15, 348.15, 353.15, 358.15, 363.15];
a_T = [1.64E+05, 7.47E+04, 8.14E+03, 3.24E+02, 1.48E+01, 1.00E+00, 1.09E-01, 1.82E-02, 3.95E-03, 9.93E-04, 2.74E-04, 4.30E-05, 3.14E-06];

% Interpolate the shift factors for each unique temperature in the map
shiftFactors = interp1(T, a_T, TemperatureMap_K, 'linear', 'extrap');  % 'extrap' handles temperatures outside range

%%
% Maching two curves from experiment
% Match values at ~1 Hz with values at temperature 328.15 K
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
% Smoothed_MasterCurve(:,2) = Smoothed_MasterCurve(:,2);
% Smoothed_MasterCurve(:,3) = Smoothed_MasterCurve(:,3);
%%
% Define the Poisson's ratio at the highest and lowest temperatures
poissonMin = 0.35;
poissonMax = 0.49;

% Create an array of Poisson's ratios linearly interpolated between the min and max temperatures
poissonRatio = poissonMin + (TemperatureMap_K - min(TemperatureMap_K)) * (poissonMax - poissonMin) / (max(TemperatureMap_K) - min(TemperatureMap_K));

%%

youngs_cplx = complex(Smoothed_MasterCurve(:,2), Smoothed_MasterCurve(:,3));

for i = 1:length(TemperatureMap_K)
% Apply shift and broadening factors to frequency
freq = log10(Smoothed_MasterCurve(:,1)) - log10(shiftFactors(i));
% [~, i] = max(imag(youngs_cplx) ./ real(youngs_cplx));
% f = freq(i);
% freq(1:i) = left_broadening * (freq(1:i) - f) + f;
% freq(i:end) = right_broadening * (freq(i:end) - f) + f;
freq = 10.^freq;

% Find the index of the frequency closest to 1 Hz (or targetFrequency)
[~, idx] = min(abs(freq - targetFrequency));

% Get the corresponding Young's modulus at that frequency
Storage(i) = real(youngs_cplx(idx))./10^6;
Loss(i) = imag(youngs_cplx(idx))./10^6;
LossTangent(i) = Loss(i)/Storage(i);

end

%%
% figure

yyaxis left;
plot(TemperatureMap_K, Storage, 'b', 'LineWidth', 2)
hold on
plot(TemperatureMap_K, Modulus_TempSweepData.data(:,6), '--b', 'LineWidth', 2)
ylabel('Storage Modulus (MPa)');

yyaxis right;
plot(TemperatureMap_K, LossTangent, 'r', 'LineWidth', 2);
hold on
plot(TemperatureMap_K, Modulus_TempSweepData.data(:,8), '--r', 'LineWidth', 2)
ylabel('tan \delta');

xlabel('Temperature (K)');

legend('Frequency Sweep', 'Temperature Sweep', 'Frequency Sweep', 'Temperature Sweep')