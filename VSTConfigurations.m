clc
clear all
close all

grid_size = 3;

% Generate all possible combinations in ternary representation
combinations = dec2base(0:3^grid_size-1, 3) - '0';  % Convert to array of digits

% Reshape the combinations into a grid
configurations = reshape(combinations, [], grid_size);

% Display the number of configurations generated
disp(['Total number of configurations: ', num2str(size(configurations, 1))]);

% Example: Print the first 9 configurations
disp('First 9 configurations:');
disp(configurations);
