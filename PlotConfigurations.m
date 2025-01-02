function PlotConfigurations(directory, Size, modelingTypes, targetData, tolerance1, tolerance2)
    
    %colors
    if strcmp(modelingTypes,'ST')
        color1 = [0.6, 0.8, 1]; % Light blue
        color2 = [1, 0.8, 0.5]; % Lighter orange
        
    elseif strcmp(modelingTypes,'VT')
        color1 = [0.6, 0.8, 1]; % Light blue
        color2 = [1, 0.5, 0.5]; % Light red
    
    elseif strcmp(modelingTypes,'SV')
        color1 = [1, 0.5, 0.5]; % Light red
        color2 = [1, 0.8, 0.5]; % Lighter orange
    
    end
    % Initialize variables to store configuration names
    matchingConfigurations = {};
    
    % Loop through each modeling type
    for m = 1:numel(modelingTypes)
        modelingtype = modelingTypes{m};
    
        % Get a list of files matching the pattern
        filePattern = fullfile(directory, [modelingtype, 'Config*.mat']);
        fileList = dir(filePattern);
    
        % Loop through each file and check for matching data points
        for i = 1:length(fileList)
            % Load the data from the current file
            filename = fullfile(directory, fileList(i).name);
            Configuration = load(filename);
    
            % Check if any data point matches the target within the tolerance
            for j = 1:length(Configuration.Loss)
                if abs(Configuration.Loss(j)/Configuration.Storage(j) - targetData(1)) < tolerance2 && ...
                        abs(Configuration.Storage(j)/10^6 - targetData(2)) < tolerance1
                    % Found a matching configuration
                    matchingConfigurations{end+1} = filename;
                    break; % Move to the next file
                end
            end
        end
    end
    
    % Display the matching configuration names
    disp('Matching configuration(s):');
    disp(matchingConfigurations);
    
    % Extract the number from each filename and convert to binary representation
    for k = 1:numel(matchingConfigurations)
        % Load the data from the current file
        filename = matchingConfigurations{k};
        Configuration = load(filename);
        
        % Extract the number from the Config parameter
        fileNumber = Configuration.config; % Assuming Config contains the number
        
        % Convert the number to its binary representation
        binaryRepresentation = dec2bin(fileNumber, Size);
    
        % Reshape binary representation into a 6x6 matrix
        binaryMatrix = reshape(binaryRepresentation', 6, 6)';
    
        % Create a figure
        figure;
    
        % Loop through each row of the binary matrix
        for row = 1:size(binaryMatrix, 1)
            % Loop through each column in the row
            for col = 1:size(binaryMatrix, 2)
                % Determine color based on the value
                if binaryMatrix(row, col) == '1'
                    color = color1;
                else
                    color = color2;
                end
    
                % Plot a square at the current position
                rectangle('Position', [col-1, -row+size(binaryMatrix, 1), 1, 1], 'FaceColor', color);
                hold on;
            end
        end
    
        % Remove axis ticks
        set(gca, 'XTick', [], 'YTick', []);
    
        % Remove grid lines
        grid off;
    
    end
end
