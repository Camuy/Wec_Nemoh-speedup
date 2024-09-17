import os
import shutil

def inizialise_project(path):

    print(f'''The project has initialised inside this path {path}.\n''')

    os.system(f'''export PATH=$PATH:{os.getenv("HOME")}/Nemoh/bin''')

    for folder in ['geometry', 'Nemoh', 'WecSim']:
        match folder:
            case 'geometry':
                try:
                    # create geometries folders (directory to generate the bodies's geometry)
                    os.mkdir(os.path.join(path, folder))
                    print(f'''The folder "{folder}" correcly created inside '{path}'.\n''')
                except FileExistsError:
                    print(f'''The folder "{os.path.join(path, folder)}" existed yet!\n''')
            case 'Nemoh' | 'WecSim':
                copy_folder(os.path.join(path, folder), folder)
    
    list_files(path)
    print(f'\nProject correctly analysed\n')

    return

def copy_folder(path, folder):

    # create folders float & spar
    try:
        # Crea il nuovo directory con i permessi di base
        shutil.copytree(os.path.join(os.getcwd(), f'sample/{folder}'), path)
        print(f'''The folder "{path}" correcly copied.\n''')
    except FileExistsError:
        print(f'''The folder "{path}" existed yet!\n''')
    return

def list_files(startpath):
    for root, dirs, files in os.walk(startpath):
        level = root.replace(startpath, '').count(os.sep)
        indent = ' ' * 4 * (level)
        print('{}{}/'.format(indent, os.path.basename(root)))
        subindent = ' ' * 4 * (level + 1)
        for f in files:
            print('{}{}'.format(subindent, f))
    return