clc
clear all
close all

SampledConfigs =0:5;
Storage =zeros(numel(SampledConfigs),1);

for i = 1:numel(SampledConfigs)
    confignumber=SampledConfigs(i);

    % Make inp
    % Experiment_Model(confignumber);
    % Experiment_ViscoelsaticModel(confignumber);
    Updated_Experiment_ViscoelsaticModel(confignumber);
    % TemperatureSweepMasterCurve_Experiment_ViscoelsaticModel(confignumber);

    % run abaqus input file and call a python code to extract moduli
    a=system(['abaqus job=','config',num2str(confignumber),' input=C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\config', num2str(confignumber),'.inp int']);
    a=system(['abaqus python C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\ExperimentConfigHomogenization.py ',num2str(confignumber)]);

    data_config = dlmread(['C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\config',num2str(confignumber),'.txt'], '\t', 1, 0);
    
    Storage(i) = data_config(end,1)

end

plot(SampledConfigs, Storage./Storage(1), 'LineWidth', 2);
ylabel('Storage Modulus (MPa)');
xlabel('Configuration Number');