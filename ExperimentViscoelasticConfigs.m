clc
clear all
close all

SampledConfigs =0:5;
Storage =zeros(numel(SampledConfigs),1);

for i = 1:numel(SampledConfigs)
    confignumber=SampledConfigs(i);

    % Make inp
    % Experiment_ViscoelsaticModel(confignumber);
    Updated_Experiment_ViscoelsaticModel(confignumber);

    % run abaqus input file and call a python code to extract moduli
    a=system(['abaqus job=','config',num2str(confignumber),' input=C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\config', num2str(confignumber),'.inp int']);
    a=system(['abaqus python C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\ViscoelasticHomogenization.py ',num2str(confignumber)]);

    data_config = dlmread(['C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\config',num2str(confignumber),'.txt'], '\t', 1, 0);
    
    Storage (i) = data_config(end,2);
    Loss (i) = data_config(end,3);
    freq (i) = data_config(end,1);
    tandelta (i) = data_config(end,3)/data_config(end,2);

end

experiment = [  0	1751.295	0.043003694
                1	1732.511875	0.062374794
                2	1667.143125	0.077492356
                3	1650.2075	0.0926928
                4	1421.533125	0.139684
                5	1208.93875	0.168955563];

yyaxis left;
plot(SampledConfigs, Storage./Storage(3), 'LineWidth', 2)
hold on
plot(experiment(:,1), experiment(:,2)./experiment(3,2));
ylabel('Normalized Storage Modulus');
yyaxis right;
plot(SampledConfigs, tandelta./tandelta(3), 'LineWidth', 2);
hold on
plot(experiment(:,1), experiment(:,3)./experiment(3,3));
legend('Simulation', 'Experiment','Simulation', 'Experiment', 'Location','best')
ylabel('Normalized tan \delta');
xlabel('Configuration Number');

figure
yyaxis left;
plot(SampledConfigs, Storage./10^6, 'LineWidth', 2)
hold on
plot(experiment(:,1), experiment(:,2));
ylabel('Storage Modulus (MPa)');
yyaxis right;
plot(SampledConfigs, tandelta, 'LineWidth', 2);
hold on
plot(experiment(:,1), experiment(:,3));
legend('Simulation', 'Experiment','Simulation', 'Experiment', 'Location','best')
ylabel('tan \delta');
xlabel('Configuration Number');