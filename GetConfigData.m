clc
clear all
close all

% Define the directory where your files are located
directory = 'C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\';

% Size of the model
Size = 6*6;

% Modeling types

modelingTypes = {'ST'};
% tolerance1 = 0.001;
% tolerance2 = 0.0000001;
% Data = [0.0586934,618.715; 0.0512259,487.744; 0.0618618,507.15;0.0621031,190.305;0.0689227,426.781];
tolerance1 = 0.001;
tolerance2 = 0.0000001;
% Data=[0.0841743,86.8282;0.0781555,157.164;0.0621471,263.535;0.0526026,527.147;0.0559697,609.009];
Data=[0.06, 154352271];
for i=1:size(Data,1)
targetData = Data(i,:);
PlotConfigurations(directory, Size, modelingTypes, targetData, tolerance1, tolerance2)
end
%%

modelingTypes = {'VT'};
% tolerance1 = 0.01;
% tolerance2 = 0.00001;
% Data = [0.276854, 1427.29; 0.468207, 961.428; 0.289153, 614.172; 0.492088, 917.926; 0.485764, 907.139];
tolerance1 = 0.001;
tolerance2 = 0.000001;
Data=[0.312436,908.051;0.397911,797.923;0.34422,750.255;0.549249,667.028;0.783335,437.036];
for i=1:size(Data,1)
targetData = Data(i,:);
PlotConfigurations(directory, Size, modelingTypes, targetData, tolerance1, tolerance2)
end
%%

modelingTypes = {'SV'};
% tolerance1 = 0.0001;
% tolerance2 = 0.000001;
% Data = [0.82536, 96.4141; 0.49809, 99.518; 0.440004, 92.5563; 0.456286, 95.4824; 0.588794, 54.547];
tolerance1 = 0.0001;
tolerance2 = 0.000001;
Data=[0.272287,63.3553;0.365563,67.3976;0.573271,72.8892;0.492584,77.4758;0.587391,76.2572];
for i=1:size(Data,1)
targetData = Data(i,:);
PlotConfigurations(directory, Size, modelingTypes, targetData, tolerance1, tolerance2)
end