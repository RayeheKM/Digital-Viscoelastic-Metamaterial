"""Extract viscoelastic response from abaqus output ODB to TSV"""
import os
import sys
import numpy as np
from odbAccess import openOdb

# configNumber = str(sys.argv[-1])
configNumber = str(sys.argv[-1])

MyOdbAdress = 'C:\\Users\\BrinsonLab\\Desktop\\DigitalMetamaterial\\Codes\\config' + str(configNumber) + '.odb'

MyOdb = openOdb(MyOdbAdress)

# MyOdb = openOdb(odb_path, readOnly=True)
MyStep = MyOdb.steps['Step-1']

# Finding the number of elements in ODB file
MyPart=MyOdb.rootAssembly.instances["PART-1-1"]
EleNum=len(MyPart.elements)
print(str(configNumber))
MyText = 'C:\\Users\\BrinsonLab\\Desktop\\DigitalMetamaterial\\Codes\\config' + str(configNumber) + '.txt'
print(str(configNumber))
with open(MyText, 'w') as file:
    # Write the header row
    file.write('Storage\n')

    for frame in MyStep.frames:
        frequency = frame.frameValue
        if frequency == 0:
                continue

        MyStress=frame.fieldOutputs['S']
        MyStrain=frame.fieldOutputs['E']

        sum_R_Sxx = sum_I_Sxx = sum_R_Epxx = 0

        for stress in MyStress.values:
            sum_R_Sxx = sum_R_Sxx + stress.data[1]
        for strain in MyStrain.values:
            sum_R_Epxx = sum_R_Epxx + strain.data[1]

        StorageExx=sum_R_Sxx/sum_R_Epxx
        file.write('{}\n'.format(StorageExx))
