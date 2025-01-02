% Define the directory where your files are located
directory = 'C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Data\';

% Initialize figure
figure;
hold on;
box on;

% Initialize empty arrays for plots
STPlot = [];
SVPlot = [];
VTPlot = [];

% Modeling types
modelingTypes = {'ST', 'SV', 'VT'};
% modelingTypes = {'ST'};

% Loop through each modeling type
for m = 1:numel(modelingTypes)
    modelingtype = modelingTypes{m};
    
    % Get a list of files matching the pattern
    filePattern = fullfile(directory, [modelingtype, 'Config*.mat']);
    fileList = dir(filePattern);
    
    % Loop through each file and plot its data
    for i = 1:length(fileList)
        % Load the data from the current file
        filename = fullfile(directory, fileList(i).name);
        Config = load(filename);
        
        % Plot the data
        if strcmp(modelingtype, 'ST')
            STPlot = plot(Config.Loss/Config.Storage, Config.Storage./10^6, 'o', 'MarkerFaceColor', [0 0.5 0.5], 'MarkerEdgeColor', [0.3 0.65 0.65]);
        elseif strcmp(modelingtype, 'SV')
            SVPlot = plot(Config.Loss/Config.Storage, Config.Storage./10^6, 'o', 'MarkerFaceColor', [0.5 0 0.5], 'MarkerEdgeColor', [0.65 0.3 0.65]);
        elseif strcmp(modelingtype, 'VT')
            VTPlot = plot(Config.Loss/Config.Storage, Config.Storage./10^6, 'o', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', [0.5 0.5 0.5]);
        end
    end
end

% Add labels and legend
xlabel('tan \delta')
ylabel('E'' (MPa)')
 % legend('Viscoelastic-Stiff');
legend([STPlot(1), SVPlot(1), VTPlot(1)], 'Soft-Stiff', 'Soft-Viscoelastic', 'Viscoelastic-Stiff');

