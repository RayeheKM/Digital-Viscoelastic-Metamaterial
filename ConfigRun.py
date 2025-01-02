"""Extract viscoelastic response from abaqus output ODB to TSV"""
import os
import sys
import numpy as np
from odbAccess import openOdb

# configNumber = str(sys.argv[-1])
configNumber = str(sys.argv[-3])
modelingtype = str(sys.argv[-2])
UseServer = str(sys.argv[-1])
# print(str(sys.argv))
# print(configNumber)
# print(modelingtype)
# print(str(UseServer))
# print('OK')
# # Run the Abaqus command
# abaqus_command = r'abaqus job=Config{configNumber} input=C:\temp\Config{configNumber}.inp'
# os.system(abaqus_command)
#
# input_inp = os.path.join(r'C:/Users/BrinsonLab/Desktop/DigitalMetamaterial/', 'Config{0}.inp'.format(configNumber))
#
# #callCode = "abaqus job=MicroCube input=" + input_inp + " user=" + input_script + " int"
#
# callcode2 = "abaqus job="MicroCube99 input=" + input_inp + " user=" + input_script + " int"
#
# #os.system(callcode1+';'+callcode2)
#
# lines = subprocess.call(callcode2,shell=True)

# MyOdbAdress = os.path.join(r'C:/Users/BrinsonLab/Desktop/DigitalMetamaterial/', 'Config{}.odb'.format(configNumber))
if UseServer == '0':
    print('0')
    MyOdbAdress = 'C:\\Users\\BrinsonLab\\Desktop\\DigitalMetamaterial\\Codes\\' + modelingtype + 'Config' + str(configNumber) + '.odb'
    print(MyOdbAdress)
else:
    print('1')
    MyOdbAdress = '/home/rkm41/DigitalMetamaterial/' + modelingtype + 'Config' + str(configNumber) + '.odb'
    print(MyOdbAdress)
# MyOdbAdress=os.path.join(cwd, 'MicroCube99.odb')
MyOdb = openOdb(MyOdbAdress)

# MyOdb = openOdb(odb_path, readOnly=True)
MyStep = MyOdb.steps['Step-1']

# Finding the number of elements in ODB file
MyPart=MyOdb.rootAssembly.instances["PART-1-1"]
EleNum=len(MyPart.elements)
if UseServer == '0':
    MyText = 'C:\\Users\\BrinsonLab\\Desktop\\DigitalMetamaterial\\Codes\\' + modelingtype + 'Config' + str(configNumber) + '.txt'
else:
    MyText = '/home/rkm41/DigitalMetamaterial/' + modelingtype + 'Config' + str(configNumber) + '.txt'

with open(MyText, 'w') as file:
    # Write the header row
    file.write('Frequency\tStorage\tLoss\n')

    for frame in MyStep.frames:
        frequency = frame.frameValue
        if frequency == 0:
                continue

        MyStress=frame.fieldOutputs['S']
        MyStrain=frame.fieldOutputs['E']

        sum_R_Sxx = sum_I_Sxx = sum_R_Epxx = 0

        for stress in MyStress.values:
            sum_R_Sxx = sum_R_Sxx + stress.data[0]
            # print(stress.data[0])
            sum_I_Sxx = sum_I_Sxx + stress.conjugateData[0]
            # print(stress.conjugateData[0])
        for strain in MyStrain.values:
            sum_R_Epxx = sum_R_Epxx + strain.data[0]
            # print(strain.data[0])

        StorageExx=sum_R_Sxx/sum_R_Epxx
        LossExx=sum_I_Sxx/sum_R_Epxx

        file.write('{}\t{}\t{}\n'.format(frequency, StorageExx, LossExx))
