import os
import shutil

def init_mesh(path):
    print('Prepering the meshs to be calculated in Nemoh.\n\n')
    
    os.system(f'meshmagick {path}/Nemoh/float/Nfloat.stl -s 0.001 -i -o {path}/Nemoh/float/Nfloat.nem && meshmagick {path}/Nemoh/spar/Nspar.stl -s 0.001 -i -o {path}/Nemoh/spar/Nspar.nem')

    # modificare il file Mesh.cal !!!!
    # modificare il file .nem e .dat per entrambi i corpi
    # modificare i file Nemoh.cal per i due corpi e per l'assembly

    os.system(f'''./mesh  {path}/Nemoh/float && ./mesh  {path}/Nemoh/spar''')

    shutil.copy(f'{path}/Nemoh/float/mesh/Hydrostatics.dat', f'{path}/WecSim/input_data/mesh/Hydrostatics_0.dat')
    shutil.copy(f'{path}/Nemoh/float/mesh/KH.dat', f'{path}/WecSim/input_data/mesh/KH_0.dat')
    shutil.copy(f'{path}/Nemoh/float/Nfloat.nem.dat', f'{path}/Nemoh/Nfloat.dat')
    
    shutil.copy(f'{path}/Nemoh/spar/mesh/Hydrostatics.dat', f'{path}/WecSim/input_data/mesh/Hydrostatics_1.dat')
    shutil.copy(f'{path}/Nemoh/spar/mesh/KH.dat', f'{path}/WecSim/input_data/mesh/KH_1.dat')
    shutil.copy(f'{path}/Nemoh/spar/Nspar.nem.dat', f'{path}/Nemoh/Nspart.dat')
    return

def init_Nemoh(path):
    # Change the Nemoh.cal
    # Change the Mesh.cal
    # Once done it, preparetion is ended. Nemoh can run perfectly.
    print(f'Nemoh has perfectly prepered.\n')
    return

def postProc_Nemoh(path):
    shutil.copy(f'{path}/Nemoh/Nemoh.cal', f'{path}/WecSim/input_data/Nemoh.cal')
    shutil.copytree(f'{path}/Nemoh/results', f'{path}/WecSim/input_data/results')
    return

def Nemoh(path):
    init_Nemoh(path=path)
    print('\nNemoh started.')

    # Solve only the first order equations
    
    os.system(f'''./preProc {path}/Nemoh && ./hydrosCal {path}/Nemoh && ./solve {path}/Nemoh && ./postProc {path}/Nemoh''')
    postProc_Nemoh(path=path)

    print('\nNemoh finished\n')
    return