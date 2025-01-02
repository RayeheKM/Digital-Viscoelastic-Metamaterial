clc
clear all
close all

UseServer = 0;
modelingtype = 'ST'; %ST (for soft-stiff) VT (for visco-stiff) SV (for soft-visco)
% make configs
numCells = 6*6;
%Frequency 1 Hz
numConfigurations = 2^numCells;

total_range = 2^36; % Total range

num_samples = [1, 3, 9, 27, 81, 243, 729, 2187, 6561, 19683];

total_samples = sum(num_samples);

% Initialize the sampled indices array
SampledConfigs = zeros(2*total_samples+2, 1);

% Define the ranges and the corresponding number of samples
ranges1 = [0, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000, total_range-1];
ranges2 = [total_range-1, total_range-11, total_range-110, total_range-1110, total_range-11110, total_range-111110, total_range-1111110, total_range-11111110, total_range-111111110, total_range-1111111110, total_range-11111111110];

% Initialize the index for storing sampled indices
index = 1;

% Sample from each subrange
for i = 1:numel(ranges1)-1
    % Determine the start and end indices of the current subrange
    start_index1 = ranges1(i) + 1;
    end_index1 = ranges1(i+1);

    start_index2 = ranges2(i+1);
    end_index2 = ranges2(i)+1;

    % Calculate the number of samples to take from this subrange
    samples_from_subrange = num_samples(i);
    
    % Sample from the current subrange
    sampled_indices1 = randperm(end_index1 - start_index1 + 1, samples_from_subrange) + start_index1 - 1;
    
    % Store the sampled indices
    SampledConfigs(index:index+samples_from_subrange-1) = sampled_indices1;

    % Increment index
    index = index + samples_from_subrange;

    % Sample from the current subrange
    sampled_indices2 = randperm(end_index2 - start_index2 + 1, samples_from_subrange) + start_index2 - 1;
    
    % Store the sampled indices
    SampledConfigs(index:index+samples_from_subrange-1) = sampled_indices2;
    
    % Increment index
    index = index + samples_from_subrange;
end

SampledConfigs(index:index+1) = [0, total_range-1];

% Iterate through sampled configurations
% figure
% hold on
% box on
for i = 1:numel(SampledConfigs)
    config=SampledConfigs(i);
    binaryStr = dec2bin(config, numCells); % Convert decimal to binary

    % Make inp
    Modeling(config, binaryStr, UseServer, modelingtype)

    % run abaqus input file and call a python code to extract moduli
    if UseServer
        a=system(['/var/DassaultSystemes/SIMULIA/Commands/abaqus job=',modelingtype,'Config',num2str(config),' input=/home/rkm41/DigitalMetamaterial/', modelingtype, 'Config', num2str(config),'.inp int']);
        a=system(['/var/DassaultSystemes/SIMULIA/Commands/abaqus python /home/rkm41/DigitalMetamaterial/ConfigRun.py ',num2str(config), ' ', modelingtype, ' ', num2str(UseServer)]);
    else
        a=system(['abaqus job=',modelingtype,'Config',num2str(config),' input=C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\', modelingtype, 'Config', num2str(config),'.inp int']);
        a=system(['abaqus python C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\ConfigRun.py ',num2str(config), ' ', modelingtype, ' ', num2str(UseServer)]);
    end

    %plot E vs E' for the configs
    if UseServer
        data_config = dlmread(['/home/rkm41/DigitalMetamaterial/',modelingtype,'Config',num2str(config),'.txt'], '\t', 1, 0);
    else
        data_config = dlmread(['C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\',modelingtype,'Config',num2str(config),'.txt'], '\t', 1, 0);
    end
    
    Storage = data_config(end,2);
    Loss = data_config(end,3);
    freq = data_config(end,1);
    % 
    % plot(Loss/Storage, Storage./10^6, 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none')
    
    % Save the variables to a .mat file
    filename = [modelingtype,'Config',num2str(config),'.mat'];
    configMatrix = an;
    save(filename, 'configMatrix', 'config', 'Loss', 'Storage', 'freq');

end
filename2 = [modelingtype,'SampledConfig.mat'];
save(filename2, 'SampledConfigs')
% xlabel('tan \delta')
% ylabel('E'' (MPa)')