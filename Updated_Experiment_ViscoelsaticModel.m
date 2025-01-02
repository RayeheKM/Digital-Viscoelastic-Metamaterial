function Updated_Experiment_ViscoelsaticModel(confignumber)

targetFrequency = 1; %Hz

TemperatureMap = readmatrix(['C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\config',num2str(confignumber),'_temperature mapping.csv']);

% Import the data from the Excel file
data = importdata('C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\MasterCurve.xlsx');
% % Skip the first two rows (assuming data starts from the third row)
% MasterCurveData = data.data(3:end, :);  % Adjust '3:end' to skip rows 1 and 2
% Import the data from the Excel file
[data, ~, ~] = xlsread('C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\PETMP-TATATO OLD wide bar.xls', 3);
% MasterCurveData2 = data(1:13:end,[14,7,8]); % mastercurve at 29-30 C
CurveData = data(:,[14,7,8, 3]); % mastercurve at 29-30 C

fid1 = fopen(['C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\config',num2str(confignumber),'.inp'],'w');

TemperatureMap = TemperatureMap(2:end,2:end);
TemperatureMap = flipud(TemperatureMap); % to make the file start from bottom and goes up
TemperatureMap = round(TemperatureMap / 5) * 5; % Discretize temperatures in 5°C steps

% Convert the temperatures from Celsius to Kelvin
TemperatureMap_K = TemperatureMap + 273.15;  % Convert to Kelvin

% Find the unique temperatures (in Kelvin)
uniqueTemperatures_K = unique(TemperatureMap_K);

% T = [303.15, 308.15, 313.15, 318.15, 323.15, 328.15, 333.15, 338.15, 343.15, 348.15, 353.15, 358.15, 363.15];
% a_T = [1.64E+05, 7.47E+04, 8.14E+03, 3.24E+02, 1.48E+01, 1.00E+00, 1.09E-01, 1.82E-02, 3.95E-03, 9.93E-04, 2.74E-04, 4.30E-05, 3.14E-06];
T = [30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90];
T = T + 273.15;  % Convert to Kelvin
a_T = [1.00E+00, 3.07E-01, 1.85E-02, 6.59E-04, 3.00E-05, 1.96E-06, 1.95E-07, 3.10E-08, 6.93E-09, 1.96E-09, 6.60E-10, 2.52E-10, 1.15E-10];
shifts = interp1(T, a_T, (CurveData(:,4)+273.15), 'pchip', 'extrap');
MasterCurveData = CurveData(:,1:3);
freq = MasterCurveData(:,1);
freq = log10(freq) + log10(shifts);
freq = 10.^freq;
MasterCurveData(:,1) = freq;
% Sort the MasterCurveData2 based on the first column (frequency)
MasterCurveData = sortrows(MasterCurveData, 1);

% Interpolate the shift factors for each unique temperature in the map
% shiftFactors = interp1(T, a_T, uniqueTemperatures_K, 'linear', 'extrap');  % 'extrap' handles temperatures outside range
shiftFactors = interp1(T, a_T, uniqueTemperatures_K, 'pchip', 'extrap');
% shiftFactors = interp1(T, a_T, uniqueTemperatures_K, 'spline', 'extrap');

% Define the Poisson's ratio at the highest and lowest temperatures
poissonMin = 0.35;
poissonMax = 0.49;

% Create an array of Poisson's ratios linearly interpolated between the min and max temperatures
% poissonRatio = poissonMin + (uniqueTemperatures_K - min(uniqueTemperatures_K)) * (poissonMax - poissonMin) / (max(uniqueTemperatures_K) - min(uniqueTemperatures_K));
if max(uniqueTemperatures_K) == min(uniqueTemperatures_K)
    % Assign a constant Poisson's ratio based on the temperature
    if uniqueTemperatures_K(1) <= mean(T)  % If temperature is on the lower side
        poissonRatio = poissonMin;
    else  % If temperature is on the higher side
        poissonRatio = poissonMax;
    end
else
    % Original interpolation logic
    poissonRatio = poissonMin + (uniqueTemperatures_K - min(uniqueTemperatures_K)) * (poissonMax - poissonMin) / (max(uniqueTemperatures_K) - min(uniqueTemperatures_K));
end

%% inp file
fprintf(fid1,'%s\n', '*Heading');
fprintf(fid1,'%s\n', '** Job name: Experiment Model name: Model-1');
fprintf(fid1,'%s\n', '** Generated by: Abaqus/CAE 2017');
fprintf(fid1,'%s\n', '*Preprint, echo=NO, model=NO, history=NO, contact=NO');
fprintf(fid1,'%s\n', '**');
fprintf(fid1,'%s\n', '** PART INSTANCE: Part-1');
fprintf(fid1,'%s\n', '*Node');

%Dimensions of the cube
xlength=20; % mm
ylength=26.5; % mm
zlength=0.2; % mm

% number of elements in each direction
xelements=42;
yelements=56;
zelements=1;

%number of nodes in each direction
xnodes=xelements+1;
ynodes=yelements+1;
znodes=zelements+1;

%create nodes

x=linspace(0,xlength,xnodes);
y=linspace(0,ylength,ynodes);
z=linspace(0,zlength,znodes);

str1='      ';
str2=',';
str3='  ';
nodes=zeros(xnodes*ynodes*znodes,3);
meshz=zeros(xnodes*ynodes,znodes);
nodenumber=1;

for l=1:znodes
    counter=1;
    for m=1:ynodes
        for n=1:xnodes
            fprintf(fid1,'%s\n',[str1,num2str(nodenumber),str2,str3,num2str(x(n)),str2,str3,num2str(y(ynodes-m+1)),str2,str3,num2str(z(l))]);
            nodes(nodenumber,:)=[x(n),y(ynodes-m+1),z(l)];
            meshz(counter,l)=nodenumber;
            nodenumber=nodenumber+1;
            counter=counter+1;
        end
    end
end
nodenumber=nodenumber-1;

%create elements

fprintf(fid1,'%s\n', '*Element, type=C3D8R');
str4=', ';
str5=',  ';
elementnumber=1;
elements=zeros((xnodes-1)*(ynodes-1)*(znodes-1),8);

for c=1:(znodes-1)
    for b=1:(ynodes-1)
        for a=1:(xnodes-1)
            fprintf(fid1,'%s\n',[num2str(elementnumber),str4,num2str(meshz(a+(b-1)*xnodes+1,c)),str4,num2str(meshz(a+(b-1)*xnodes,c)),str4,num2str(meshz(a+b*xnodes,c)),str4,num2str(meshz(a+b*xnodes+1,c)),str4,num2str(meshz(a+(b-1)*xnodes+1,c+1)),str5,num2str(meshz(a+(b-1)*xnodes,c+1)),str5,num2str(meshz(a+b*xnodes,c+1)),str5,num2str(meshz(a+b*xnodes+1,c+1))]);
            elements(elementnumber,:)=[meshz(a+(b-1)*xnodes+1,c),meshz(a+(b-1)*xnodes,c),meshz(a+b*xnodes,c),meshz(a+b*xnodes+1,c),meshz(a+(b-1)*xnodes+1,c+1),meshz(a+(b-1)*xnodes,c+1),meshz(a+b*xnodes,c+1),meshz(a+b*xnodes+1,c+1)];
            elementnumber=elementnumber+1;
        end
    end
end
elementnumber=elementnumber-1;

% Creating set to assign the property
fprintf(fid1,'%s\n', '*Nset, nset=Set-1, generate');
fprintf(fid1,'%s\n', ['  ',num2str(1),',  ',num2str(nodenumber),',   1']);
fprintf(fid1,'%s\n', '*Elset, elset=Set-1, generate');
fprintf(fid1,'%s\n', [' ',num2str(1),',  ',num2str(elementnumber),',  1']);


%create elementsets

% Initialize a cell array to store locations for each unique temperature
temperatureLocations = cell(length(uniqueTemperatures_K), 1);

% Loop through each unique temperature and find its locations
for i = 1:length(uniqueTemperatures_K)
    [row, col] = find(TemperatureMap_K == uniqueTemperatures_K(i));  % Find row and column indices
    ElementNumbers= (row-1)*xelements+col;
    temperatureLocations{i} = ElementNumbers;  % Store the row and column indices in the cell array
end

for i=1:length(temperatureLocations)

    fprintf(fid1,'%s\n', ['*Elset, elset=Set',num2str(i)]);
    cellNumbers = temperatureLocations{i};
    for j = 1:ceil(length(temperatureLocations{i}) / 16)
        startIdx = (j-1)*16 + 1;
        endIdx = min(j*16, length(cellNumbers));
        % find index numbers
        rowString = sprintf('%d,', cellNumbers(startIdx:endIdx));
        % Remove the trailing comma
        rowString = rowString(1:end-1);
        % Write the string to the file
        fprintf(fid1, '%s\n', rowString);
    end

    % Check if there are remaining numbers
    remainder = mod(length(cellNumbers), 16);
    if remainder > 0
        remainingNumbers = cellNumbers(endIdx+1:end);
        remainingString = sprintf('%d,', remainingNumbers);
        remainingString = remainingString(1:end-1);
        fprintf(fid1, '%s\n', remainingString);
    end

end

%create node sets for the boundaries
xmin=[];
xmax=[];
ymin=[];
ymax=[];

for cc=1:znodes
	for bb=1:ynodes
		xmin=[xmin, meshz(1+(bb-1)*xnodes,cc)];
		xmax=[xmax, meshz(bb*xnodes,cc)];
    end
end

for cc=1:znodes
    for aa=1:xnodes
        ymax=[ymax, meshz(aa,cc)];
        ymin=[ymin, meshz(aa+xnodes*(ynodes-1),cc)];
    end
end


fprintf(fid1,'%s\n', '*Nset, nset=xmin');
for i = 1:ceil(length(xmin) / 16)
    startIdx = (i-1)*16 + 1;
    endIdx = min(i*16, length(xmin));
    rowString = sprintf('%d,', xmin(startIdx:endIdx));
    % Remove the trailing comma
    rowString = rowString(1:end-1);
    % Write the string to the file
    fprintf(fid1, '%s\n', rowString);
end

% Check if there are remaining numbers
remainder = mod(length(xmin), 16);
if remainder > 0
    remainingNumbers = xmin(endIdx+1:end);
    remainingString = sprintf('%d,', remainingNumbers);
    remainingString = remainingString(1:end-1);
    fprintf(fid1, '%s\n', remainingString);
end

fprintf(fid1,'%s\n', '*Nset, nset=xmax');
for i = 1:ceil(length(xmax) / 16)
    startIdx = (i-1)*16 + 1;
    endIdx = min(i*16, length(xmax));
    rowString = sprintf('%d,', xmax(startIdx:endIdx));
    % Remove the trailing comma
    rowString = rowString(1:end-1);
    % Write the string to the file
    fprintf(fid1, '%s\n', rowString);
end

% Check if there are remaining numbers
remainder = mod(length(xmax), 16);
if remainder > 0
    remainingNumbers = xmax(endIdx+1:end);
    remainingString = sprintf('%d,', remainingNumbers);
    remainingString = remainingString(1:end-1);
    fprintf(fid1, '%s\n', remainingString);
end

fprintf(fid1,'%s\n', '*Nset, nset=ymin');
for i = 1:ceil(length(ymin) / 16)
    startIdx = (i-1)*16 + 1;
    endIdx = min(i*16, length(ymin));
    rowString = sprintf('%d,', ymin(startIdx:endIdx));
    % Remove the trailing comma
    rowString = rowString(1:end-1);
    % Write the string to the file
    fprintf(fid1, '%s\n', rowString);
end

% Check if there are remaining numbers
remainder = mod(length(ymin), 16);
if remainder > 0
    remainingNumbers = ymin(endIdx+1:end);
    remainingString = sprintf('%d,', remainingNumbers);
    remainingString = remainingString(1:end-1);
    fprintf(fid1, '%s\n', remainingString);
end

fprintf(fid1,'%s\n', '*Nset, nset=ymax');
for i = 1:ceil(length(ymax) / 16)
    startIdx = (i-1)*16 + 1;
    endIdx = min(i*16, length(ymax));
    rowString = sprintf('%d,', ymax(startIdx:endIdx));
    % Remove the trailing comma
    rowString = rowString(1:end-1);
    % Write the string to the file
    fprintf(fid1, '%s\n', rowString);
end

% Check if there are remaining numbers
remainder = mod(length(ymax), 16);
if remainder > 0
    remainingNumbers = ymax(endIdx+1:end);
    remainingString = sprintf('%d,', remainingNumbers);
    remainingString = remainingString(1:end-1);
    fprintf(fid1, '%s\n', remainingString);
end

%Create sections
% Loop through each unique temperature and find its locations
for i = 1:length(uniqueTemperatures_K)
    fprintf(fid1,'%s\n', ['** Section: Section-',num2str(i)]);
    fprintf(fid1,'%s\n', ['*Solid Section, elset=Set',num2str(i),', material=MATERIAL-',num2str(i)]);
    fprintf(fid1,'%s\n', ',');
end

%rest of the file
fprintf(fid1,'%s\n', '** ');
fprintf(fid1,'%s\n', '** MATERIALS');
fprintf(fid1,'%s\n', '** ');

%Create materials
for i=1:numel(uniqueTemperatures_K)
    fprintf(fid1,'%s\n', ['*Material, name=MATERIAL-',num2str(i)]);
    fprintf(fid1,'%s\n', '*Density');
    fprintf(fid1,'%s\n', '1000,');
    [ViscoelasticTable, Young]=TabularViscoelasticMaterial(MasterCurveData(:,1), complex(MasterCurveData(:,2), MasterCurveData(:,3)), shiftFactors(i), 1, 1, poissonRatio(i), targetFrequency);
    % changing units to MPa
    ViscoelasticTable(:,1:4) = ViscoelasticTable(:,1:4);

    fprintf(fid1,'%s\n', '*Elastic, moduli=LONG TERM');
    fprintf(fid1,'%s\n', [num2str(Young),', ',num2str(poissonRatio(i))]);
    fprintf(fid1,'%s\n', '*Viscoelastic, frequency=TABULAR');
    % Define format specifier for ViscoelasticTable
    [numRows, numCols] = size(ViscoelasticTable);
    formatSpec = repmat('%e, ', 1, numCols); % Use '%e' for scientific notation
    formatSpec = [formatSpec(1:end-2), '\n']; % Remove the last comma and add a newline
    
    % Print each row of the ViscoelasticTable with the format specifier
    for rowNumber = 1:numRows
        fprintf(fid1, formatSpec, ViscoelasticTable(rowNumber, :));
    end

end

fprintf(fid1,'%s\n', '** ----------------------------------------------------------------');
fprintf(fid1,'%s\n', '**');
fprintf(fid1,'%s\n', '** STEP: Step-1');
fprintf(fid1,'%s\n', '** ');
fprintf(fid1,'%s\n', '*Step, name=Step-1, nlgeom=NO, perturbation');
fprintf(fid1,'%s\n', '*Steady State Dynamics, direct, friction damping=NO');
fprintf(fid1,'%s\n', '0.99, 1., 3,');
fprintf(fid1,'%s\n', '**');
fprintf(fid1,'%s\n', '** BOUNDARY CONDITIONS');
fprintf(fid1,'%s\n', '** ');
fprintf(fid1,'%s\n', '** Name: BC-1 Type: Displacement/Rotation');
fprintf(fid1,'%s\n', '*Boundary, real');
fprintf(fid1,'%s\n', 'YMIN, 1, 1');
fprintf(fid1,'%s\n', 'YMIN, 2, 2');
fprintf(fid1,'%s\n', 'YMIN, 3, 3');
fprintf(fid1,'%s\n', '** Name: BC-2 Type: Displacement/Rotation');
fprintf(fid1,'%s\n', '*Boundary, real');
fprintf(fid1,'%s\n', 'YMAX, 1, 1');
fprintf(fid1,'%s\n', 'YMAX, 2, 2, 1.325');
fprintf(fid1,'%s\n', 'YMAX, 3, 3');
fprintf(fid1,'%s\n', '** ');
fprintf(fid1,'%s\n', '** OUTPUT REQUESTS');
fprintf(fid1,'%s\n', '** ');
fprintf(fid1,'%s\n', '** ');
fprintf(fid1,'%s\n', '** FIELD OUTPUT: F-Output-1');
fprintf(fid1,'%s\n', '** ');
fprintf(fid1,'%s\n', '*Output, field, variable=PRESELECT');
fprintf(fid1,'%s\n', '** ');
fprintf(fid1,'%s\n', '** HISTORY OUTPUT: H-Output-1');
fprintf(fid1,'%s\n', '**');
fprintf(fid1,'%s\n', '*Output, history, variable=PRESELECT');
fprintf(fid1,'%s\n', '*End Step');

fclose(fid1);
end
