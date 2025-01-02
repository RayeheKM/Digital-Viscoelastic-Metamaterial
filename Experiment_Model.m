function Experiment_Model(confignumber)

MaterialsE = readmatrix(['C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\config',num2str(confignumber),'.csv']);
MaterialsE = MaterialsE(2:end,2:end);
MaterialsE = flipud(MaterialsE); % to make the file start from bottom and goes up

fid1 = fopen(['C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\config',num2str(confignumber),'.inp'],'w');

fprintf(fid1,'%s\n', '*Heading');
fprintf(fid1,'%s\n', '** Job name: Experiment Model name: Model-1');
fprintf(fid1,'%s\n', '** Generated by: Abaqus/CAE 2017');
fprintf(fid1,'%s\n', '*Preprint, echo=NO, model=NO, history=NO, contact=NO');
fprintf(fid1,'%s\n', '**');
fprintf(fid1,'%s\n', '** PART INSTANCE: Part-1');
fprintf(fid1,'%s\n', '*Node');

%Dimensions of the cube
xlength=20;
ylength=26.5;
zlength=0.2;

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
for j=1:yelements
    for i=1:xelements
        fprintf(fid1,'%s\n', ['*Elset, elset=Set',num2str(i+xelements*(j-1))]);
        fprintf(fid1,'%s\n', ['  ',num2str(i+xelements*(j-1)),',']);
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
for j=1:yelements
    for i=1:xelements
        fprintf(fid1,'%s\n', ['** Section: Section-',num2str(i+xelements*(j-1))]);
        fprintf(fid1,'%s\n', ['*Solid Section, elset=Set',num2str(i+xelements*(j-1)),', material=MATERIAL-',num2str(i+xelements*(j-1))]);
        fprintf(fid1,'%s\n', ',');
    end
end


%rest of the file
fprintf(fid1,'%s\n', '** ');
fprintf(fid1,'%s\n', '** MATERIALS');
fprintf(fid1,'%s\n', '** ');

%Create materials
for j=1:size(MaterialsE,1)
    for i=1:size(MaterialsE,2)
        fprintf(fid1,'%s\n', ['*Material, name=MATERIAL-',num2str(i+xelements*(j-1))]);
        fprintf(fid1,'%s\n', '*Density');
        fprintf(fid1,'%s\n', '1.,');
        fprintf(fid1,'%s\n', '*Elastic');
        fprintf(fid1,'%s\n', [num2str(MaterialsE(j,i)),', 0.4']);
    end
end

fprintf(fid1,'%s\n', '** ----------------------------------------------------------------');
fprintf(fid1,'%s\n', '**');
fprintf(fid1,'%s\n', '** STEP: Step-1');
fprintf(fid1,'%s\n', '** ');
fprintf(fid1,'%s\n', '*Step, name=Step-1, nlgeom=NO');
fprintf(fid1,'%s\n', '*Static');
fprintf(fid1,'%s\n', '0.01, 1., 1e-05, 1.');
fprintf(fid1,'%s\n', '**');
fprintf(fid1,'%s\n', '** BOUNDARY CONDITIONS');
fprintf(fid1,'%s\n', '** ');
fprintf(fid1,'%s\n', '** Name: BC-1 Type: Displacement/Rotation');
fprintf(fid1,'%s\n', '*Boundary');
fprintf(fid1,'%s\n', 'YMIN, 1, 1');
fprintf(fid1,'%s\n', 'YMIN, 2, 2');
fprintf(fid1,'%s\n', 'YMIN, 3, 3');
fprintf(fid1,'%s\n', '** Name: BC-2 Type: Displacement/Rotation');
fprintf(fid1,'%s\n', '*Boundary');
fprintf(fid1,'%s\n', 'YMAX, 1, 1');
fprintf(fid1,'%s\n', 'YMAX, 2, 2, 1.325');
fprintf(fid1,'%s\n', 'YMAX, 3, 3');
fprintf(fid1,'%s\n', '** ');
fprintf(fid1,'%s\n', '** OUTPUT REQUESTS');
fprintf(fid1,'%s\n', '** ');
fprintf(fid1,'%s\n', '*Restart, write, frequency=0');
fprintf(fid1,'%s\n', '** ');
fprintf(fid1,'%s\n', '** FIELD OUTPUT: F-Output-1');
fprintf(fid1,'%s\n', '** ');
fprintf(fid1,'%s\n', '*Output, field, variable=PRESELECT');
fprintf(fid1,'%s\n', '** ');
fprintf(fid1,'%s\n', '** HISTORY OUTPUT: H-Output-1');
fprintf(fid1,'%s\n', '**');
fprintf(fid1,'%s\n', '*Output, history, variable=PRESELECT');
fprintf(fid1,'%s\n', '** ');
fprintf(fid1,'%s\n', '** HISTORY OUTPUT: H-Output-1');
fprintf(fid1,'%s\n', '** ');
fprintf(fid1,'%s\n', '*Output, history, variable=PRESELECT');
fprintf(fid1,'%s\n', '*End Step');

fclose(fid1);
end
