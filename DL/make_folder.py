import os

def make_dirs(*folders:str):
    path = os.getcwd()
    full_path = os.path.join(path, *folders)
    
    if not os.path.exists(full_path):
        os.makedirs(full_path)
