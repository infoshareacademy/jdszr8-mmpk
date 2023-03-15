def cell_t(cell_type):
    infected = ['trophozoite','schizont','difficult','gametocyte', 'ring']
    not_infected = ['red blood cell', 'leukocyte']
    if cell_type in infected:
        return 'infected'
    else:
        return 'not_infected'

