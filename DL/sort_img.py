import json
import os
import os.path
import shutil
from make_folder import make_dirs

def sort_image(data:list, test_or_training:str  ):
    """Function to move images to new folders
    data: json data to get image name
    test_or_training: new folder where image will be moved
    """
    
    path = os.getcwd()
    
    make_dirs('images',test_or_training)
           
    for i in range(len(data)):
        image_name = data[i]['image']['pathname'][8:]
        old_image_path = os.path.join(path,'images',image_name)
        new_image_path = os.path.join(path,'images',test_or_training ,image_name) 
        shutil.move(old_image_path, new_image_path)