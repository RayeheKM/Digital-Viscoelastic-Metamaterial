clc
clear all
close all

UseServer = 0;
modelingtype = 'SV'; %ST (for soft-stiff) VT (for visco-stiff) SV (for soft-visco)

% Define the number of ones and zeros
num_ones = 18;
num_zeros = 18;

% Generate the pattern
pattern = [ones(1, num_ones), zeros(1, num_zeros)];

% Generate a random sample of patterns
total_patterns = 50;
SampledConfigs = zeros(total_patterns, 1);
for i = 1:total_patterns
    % Shuffle the pattern randomly
    shuffled_pattern = pattern(randperm(num_ones + num_zeros));
    
    % Convert the shuffled pattern to binary string without spaces
    binaryStr = char('0' + shuffled_pattern); % Convert to char array
    binaryStr = binaryStr(:)'; % Reshape to row vector
    binaryStr = strjoin(cellstr(binaryStr), ''); % Concatenate characters into a single string
    
    % Convert the binary string to decimal and store it
    config = bin2dec(binaryStr);
    SampledConfigs(i) = config;
    
    % Make inp
    Modeling(config, binaryStr, UseServer, modelingtype)

    % Run abaqus input file and call a python code to extract moduli
    if UseServer
        a=system(['/var/DassaultSystemes/SIMULIA/Commands/abaqus job=',modelingtype,'Config',num2str(config),' input=/home/rkm41/DigitalMetamaterial/', modelingtype, 'Config', num2str(config),'.inp int']);
        a=system(['/var/DassaultSystemes/SIMULIA/Commands/abaqus python /home/rkm41/DigitalMetamaterial/ConfigRun.py ',num2str(config), ' ', modelingtype, ' ', num2str(UseServer)]);
    else
        a=system(['abaqus job=',modelingtype,'Config',num2str(config),' input=C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\', modelingtype, 'Config', num2str(config),'.inp int']);
        a=system(['abaqus python C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\ConfigRun.py ',num2str(config), ' ', modelingtype, ' ', num2str(UseServer)]);
    end

    % Plot E vs E' for the configs
    % (Add your plotting code here if needed)
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
    configMatrix = reshape(shuffled_pattern,6,6)';
    save(filename, 'configMatrix', 'config', 'Loss', 'Storage', 'freq');

end

% Display the sampled configurations
disp(SampledConfigs);
