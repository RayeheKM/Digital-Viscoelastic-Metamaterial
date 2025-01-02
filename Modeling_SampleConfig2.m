function Modeling(config, binaryStr, UseServer, modelingtype)
    
    % Open the original text file for reading
    if UseServer
        originalFile = fopen('/home/rkm41/DigitalMetamaterial/SampleConfig2.inp', 'r');
    else
        originalFile = fopen('C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\SampleConfig2.inp', 'r');
    end

    % Open a new text file for writing the modified content
    if UseServer
        modifiedFile = fopen(['/home/rkm41/DigitalMetamaterial/',modelingtype,'Config',num2str(config),'.inp'],'w');
    else
         modifiedFile = fopen(['C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\',modelingtype,'Config',num2str(config),'.inp'],'w');
    end

    % Number of lines to copy exactly
    linesToCopyExactly = 7185;
    
    % Number of additional lines to add
    additionalLines = 108;
    
    % Copy lines exactly until line 7185
    for i = 1:linesToCopyExactly
        line = fgetl(originalFile);
        fprintf(modifiedFile, '%s\n', line);
    end
    
    % Add additional lines
    for i = 1:additionalLines/3
        %ST (for soft-stiff) VT (for visco-stiff) SV (for soft-visco)
        if strcmp(modelingtype,'ST')
            % disp(binaryStr(i))
            if binaryStr(i)=='0'
                fprintf(modifiedFile, '** Section: Soft\n');
                fprintf(modifiedFile, ['*Solid Section, elset=Set-',num2str(i),', material=Soft\n']);
                fprintf(modifiedFile, ',\n');
            elseif binaryStr(i)=='1'
                fprintf(modifiedFile, '** Section: Stiff\n');
                fprintf(modifiedFile, ['*Solid Section, elset=Set-',num2str(i),', material=Stiff\n']);
                fprintf(modifiedFile, ',\n');
            end
        elseif strcmp(modelingtype,'VT')
            if binaryStr(i)=='0'
                fprintf(modifiedFile, '** Section: Visco\n');
                fprintf(modifiedFile, ['*Solid Section, elset=Set-',num2str(i),', material=Visco\n']);
                fprintf(modifiedFile, ',\n');
            elseif binaryStr(i)=='1'
                fprintf(modifiedFile, '** Section: Stiff\n');
                fprintf(modifiedFile, ['*Solid Section, elset=Set-',num2str(i),', material=Stiff\n']);
                fprintf(modifiedFile, ',\n');
            end
        elseif strcmp(modelingtype,'SV')
            if binaryStr(i)=='0'
                fprintf(modifiedFile, '** Section: Soft\n');
                fprintf(modifiedFile, ['*Solid Section, elset=Set-',num2str(i),', material=Soft\n']);
                fprintf(modifiedFile, ',\n');
            elseif binaryStr(i)=='1'
                fprintf(modifiedFile, '** Section: Visco\n');
                fprintf(modifiedFile, ['*Solid Section, elset=Set-',num2str(i),', material=Visco\n']);
                fprintf(modifiedFile, ',\n');
            end
        end
        
    end
    
    % Copy the rest of the lines from line 7185 onwards
    while ~feof(originalFile)
        line = fgetl(originalFile);
        fprintf(modifiedFile, '%s\n', line);
    end
    
    % Close both files
    fclose(originalFile);
    fclose(modifiedFile);

end