import os
import random
from make_folder import make_dirs
import shutil

def make_valid_set():
    path = os.getcwd()
    txt = os.listdir('labels/training')
    img = os.listdir('images/training')
    random.shuffle(txt)
    file_txt = txt[:120]
    
    make_dirs('labels','valid')
    make_dirs('images','valid')
    
    for x in file_txt:
        old_txt_path = os.path.join(path,'labels','training',x)
        new_txt_path = os.path.join(path,'labels','valid' ,x) 
        shutil.move(old_txt_path, new_txt_path)
        name = x[:-4]
        for y in img:
            if name == y[:-4]:
                old_image_path = os.path.join(path,'images','training', y)
                new_image_path = os.path.join(path,'images','valid' ,y)
                shutil.move(old_image_path, new_image_path)