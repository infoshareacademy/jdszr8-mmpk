import json

def load_j(input_file:str):
    '''Load file json and return data
    input: input_file: json file to load
    '''
    with open(input_file, 'r') as f:
        data = json.load(f)
    return data