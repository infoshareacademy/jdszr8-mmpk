import cv2
import os
from make_folder import make_dirs

def resize_img(folder:str, new_size:int):
    ''' function to change size of images.
    Input:
        folder: folder where are images to resize
        new_size: the size to which the photos to be converted 
    '''
    images = os.listdir(folder)
    path = os.getcwd()
    image_path = os.path.join(path, folder)

    for img in images:
        if img[-4:] in ['.png', '.jpg']:
            image = cv2.imread(os.path.join(image_path, img))
            resized_image = cv2.resize(image, (new_size, new_size))
            cv2.imwrite(os.path.join(path, 'images', img), resized_image)

    