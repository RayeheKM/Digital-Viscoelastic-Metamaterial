function PlotConfigNumber(config, modelingTypes, Size)

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

    filename = [modelingTypes, 'Config', num2str(config),'.mat'];
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
