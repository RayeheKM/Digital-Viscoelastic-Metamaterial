clc
clear all
close all

%% Loading data
% Old mastercurve

% Import the data from the Excel file
data = importdata('C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\MasterCurve.xlsx');

% Skip the first two rows (assuming data starts from the third row)
MasterCurveData1 = data.data(3:end, :);  % Adjust '3:end' to skip rows 1 and 2

T1 = [303.15, 308.15, 313.15, 318.15, 323.15, 328.15, 333.15, 338.15, 343.15, 348.15, 353.15, 358.15, 363.15];
a_T1 = [1.64E+05, 7.47E+04, 8.14E+03, 3.24E+02, 1.48E+01, 1.00E+00, 1.09E-01, 1.82E-02, 3.95E-03, 9.93E-04, 2.74E-04, 4.30E-05, 3.14E-06];

% figure
% semilogy(T1, a_T1)
% xlabel('T (K)')
% ylabel('a_T')
% title('Old data')

% New mastercurve

% Import the data from the Excel file
[data, ~, ~] = xlsread('C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\PETMP-TATATO OLD wide bar.xls', 3);
% MasterCurveData2 = data(1:13:end,[14,7,8]); % mastercurve at 29-30 C
CurveData = data(:,[14,7,8, 3]); % mastercurve at 29-30 C

T2 = [30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90];
T2 = T2 + 273.15;  % Convert to Kelvin
a_T2 = [1.00E+00, 3.07E-01, 1.85E-02, 6.59E-04, 3.00E-05, 1.96E-06, 1.95E-07, 3.10E-08, 6.93E-09, 1.96E-09, 6.60E-10, 2.52E-10, 1.15E-10];

shiftFactors = interp1(T2, a_T2, (CurveData(:,4)+273.15), 'pchip', 'extrap');
MasterCurveData2 = CurveData(:,1:3);
freq = MasterCurveData2(:,1);
freq = log10(freq) + log10(shiftFactors);
freq = 10.^freq;
MasterCurveData2(:,1) = freq;
% Sort the MasterCurveData2 based on the first column (frequency)
MasterCurveData2 = sortrows(MasterCurveData2, 1);

% figure
% semilogy(T2, a_T2)
% xlabel('T (K)')
% ylabel('a_T')
% title('New data')

%% Plot data

figure

% Top subplot (Storage Modulus)
subplot(2,1,1); % 2 rows, 1 column, first plot
freq = MasterCurveData1(:,1);
freq = log10(freq) - log10(a_T1(1));
freq = 10.^freq;
loglog(freq, MasterCurveData1(:,2), 'o', 'MarkerFaceColor', [0.6, 0.8, 1], 'MarkerEdgeColor', 'none', 'MarkerSize', 4);   % Stiff at 303.15
hold on;
loglog(MasterCurveData1(:,1), MasterCurveData1(:,2), 'o', 'MarkerFaceColor', [1, 0.5, 0.5], 'MarkerEdgeColor', 'none', 'MarkerSize', 4);   % Visco at 328.15
freq = log10(MasterCurveData1(:,1)) - log10(a_T1(end-2));
freq = 10.^freq;
loglog(freq, MasterCurveData1(:,2), 'o', 'MarkerFaceColor', [1, 0.8, 0.5], 'MarkerEdgeColor', 'none', 'MarkerSize', 4);   % Soft at 353.15
ylabel('E'' (Pa)'); % Label for the left y-axis
% xlabel('Frequency (Hz)'); % X-axis label
set(gca, 'XTickLabel', []); % Remove x-axis tick labels
set(gca, 'XTick', []); % Remove x-axis ticks
freq = log10(MasterCurveData2(:,1)) - log10(a_T2(1));
freq = 10.^freq;
loglog(freq, MasterCurveData2(:,2), 'o', 'MarkerFaceColor', [0.3, 0.4, 0.5], 'MarkerEdgeColor', 'none', 'MarkerSize', 4);   % Stiff at 303.15
hold on;
freq = log10(freq) - log10(a_T2(6));
freq = 10.^freq;
loglog(freq, MasterCurveData2(:,2), 'o', 'MarkerFaceColor', [0.5, 0.25, 0.25], 'MarkerEdgeColor', 'none', 'MarkerSize', 4);   % Visco at 328.15
freq = log10(MasterCurveData2(:,1)) - log10(a_T2(end-2));
freq = 10.^freq;
loglog(freq, MasterCurveData2(:,2), 'o', 'MarkerFaceColor', [0.5, 0.4, 0.25], 'MarkerEdgeColor', 'none', 'MarkerSize', 4);   % Soft at 353.15
legend('Old data at 303.15 K', 'Old data at 328.15 K', 'Old data at 353.15 K', 'New data at 303.15 K', 'New data at 328.15 K', 'New data at 353.15 K', 'Orientation', 'horizontal', 'NumColumns', 3)


% Bottom subplot (tan \delta)
subplot(2,1,2); % 2 rows, 1 column, second plot
freq = MasterCurveData1(:,1);
freq = log10(freq) - log10(a_T1(1));
freq = 10.^freq;
semilogx(freq, MasterCurveData1(:,3)./MasterCurveData1(:,2), 'o', 'MarkerFaceColor', [0.6, 0.8, 1], 'MarkerEdgeColor', 'none', 'MarkerSize', 4);  % Stiff at 303.15
hold on;
semilogx(MasterCurveData1(:,1), MasterCurveData1(:,3)./MasterCurveData1(:,2), 'o', 'MarkerFaceColor', [1, 0.5, 0.5], 'MarkerEdgeColor', 'none', 'MarkerSize', 4); % Visco at 328.15
freq = log10(MasterCurveData1(:,1)) - log10(a_T1(end-2));
freq = 10.^freq;
semilogx(freq, MasterCurveData1(:,3)./MasterCurveData1(:,2), 'o', 'MarkerFaceColor', [1, 0.8, 0.5], 'MarkerEdgeColor', 'none', 'MarkerSize', 4); % Soft at 353.15
ylabel('tan \delta'); % Label for the right y-axis
xlabel('Frequency (Hz)'); % X-axis label

freq = log10(MasterCurveData2(:,1)) - log10(a_T2(1));
freq = 10.^freq;
semilogx(freq, MasterCurveData2(:,3)./MasterCurveData2(:,2), 'o', 'MarkerFaceColor', [0.3, 0.4, 0.5], 'MarkerEdgeColor', 'none', 'MarkerSize', 4);  % Stiff at 303.15
hold on;
freq = log10(freq) - log10(a_T2(6));
freq = 10.^freq;
semilogx(freq, MasterCurveData2(:,3)./MasterCurveData2(:,2), 'o', 'MarkerFaceColor', [0.5, 0.25, 0.25], 'MarkerEdgeColor', 'none', 'MarkerSize', 4); % Visco at 328.15
freq = log10(MasterCurveData2(:,1)) - log10(a_T2(end-2));
freq = 10.^freq;
semilogx(freq, MasterCurveData2(:,3)./MasterCurveData2(:,2), 'o', 'MarkerFaceColor', [0.5, 0.4, 0.25], 'MarkerEdgeColor', 'none', 'MarkerSize', 4); % Soft at 353.15
% legend('Old data at 303.15 K', 'Old data at 328.15 K', 'Old data at 353.15 K', 'Old data at 303.15 K', 'Old data at 328.15 K', 'Old data at 353.15 K')

