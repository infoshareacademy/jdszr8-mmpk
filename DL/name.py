import os
from make_folder import make_dirs
from cell_d import cell_t

def name_txt(data:list,  img_size:int, cell_dict:dict, test_or_train:str):
    """ Function to make labels to every image in dataset. 
    It conver bounding box from (Xmin, Ymin, Xmax, Ymax) into (X_center, Y_center, Widith, Height).
    Inputs:
        data: json data
        image_size: what is the current image size 
        cell_dict: dictionary to collect ceels type
        test_or_train: folder where save txt files """
    
    path = os.getcwd()
    make_dirs('labels' , test_or_train) 
        
    for i in range(len(data)):
        info = data[i]['image']
        orginal_img_h = info['shape']['r']# wysokość zdj
        orginal_img_w = info['shape']['c']#szerokość zdj
        new_img_h = new_img_w = img_size
        name = info['pathname'][8:len(info['pathname'])-4]# nazwa zdjęcia do txt
        obj = data[i]['objects']
        for j in range(len(obj)):
            cell_type = obj[j]['category']
            cell_type = cell_t(cell_type)
           
            bounding_box = obj[j]['bounding_box']
            x1 = bounding_box['minimum']['c'] * new_img_w/orginal_img_w
            y1 = bounding_box['minimum']['r'] * new_img_h/orginal_img_h
            x2 = bounding_box['maximum']['c'] * new_img_w/orginal_img_w
            y2 = bounding_box['maximum']['r'] * new_img_h/orginal_img_h
            x_cenetr = ((x2+x1)/2)/new_img_w
            y_center = ((y2+y1)/2)/new_img_h
            width = (x2-x1)/new_img_w
            height =(y2-y1)/new_img_h

            if cell_type not in cell_dict:
                cell_dict[cell_type] = len(cell_dict)
            file_path = os.path.join(path,'labels', test_or_train, name+'.txt')
            with open(file_path, 'a') as f:
                f.writelines([str(cell_dict[cell_type]), ' ',str(x_cenetr), ' ', str(y_center), ' ', str(width), ' ', str(height), '\n' ])

            
    
    