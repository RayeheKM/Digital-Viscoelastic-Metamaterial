clc
clear all
close all

% Import the data from the Excel file
[data, ~, ~] = xlsread('C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\PETMP-TATATO OLD wide bar.xls', 2);
% MasterCurveData2 = data(1:13:end,[14,7,8]); % mastercurve at 29-30 C
CurveData = data(:,[3,7,8]); % mastercurve at 29-30 C
CurveData(:,1) = CurveData(:,1) + 273.15;

% % Import the data from the Excel file
% [data, ~, ~] = xlsread('C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\PETMP-TATATO OLD wide bar.xls', 3);
% % MasterCurveData2 = data(1:13:end,[14,7,8]); % mastercurve at 29-30 C
% CurveData = data(:,[14,7,8, 3]); % mastercurve at 29-30 C

% T = [30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90];
% T = T + 273.15;  % Convert to Kelvin
% a_T = [1.00E+00, 3.07E-01, 1.85E-02, 6.59E-04, 3.00E-05, 1.96E-06, 1.95E-07, 3.10E-08, 6.93E-09, 1.96E-09, 6.60E-10, 2.52E-10, 1.15E-10];
% 
% shifts = interp1(T, a_T, (CurveData(:,4)+273.15), 'pchip', 'extrap');
% MasterCurveData = CurveData(:,1:3);
% freq = MasterCurveData(:,1);
% freq = log10(freq) + log10(shifts);
% freq = 10.^freq;
% MasterCurveData(:,1) = freq;
% % Sort the MasterCurveData2 based on the first column (frequency)
% MasterCurveData = sortrows(MasterCurveData, 1);
% 
% % Given frequency to search for (1 Hz)
% target_freq = 1;
% 
% % Find the index of the row where the frequency is closest to 1 Hz
% [~, idx] = min(abs(MasterCurveData(:,1) - target_freq));
% 
% % Extract the storage and loss moduli at the closest frequency
% storage_modulus = MasterCurveData(idx, 2);
% loss_modulus = MasterCurveData(idx, 3);




%%
figure
yyaxis left;
semilogy(CurveData(:,1), CurveData(:,2))
ylabel('Storage (Pa)')
yyaxis right;
plot(CurveData(:,1), CurveData(:,3)./CurveData(:,2))
ylabel('tan \delta')
xlabel('Temperature (K)')
