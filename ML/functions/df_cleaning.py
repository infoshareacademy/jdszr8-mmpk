import pandas as pd

def df_cleaning(df):

    'initial preprocessing of insurance dataset'
    
    print('1. All duplicated rows within dataset will be dropped. Found:', df.duplicated().sum(), 'duplicated rows.')
    df = df.drop_duplicates()
    
    print('2. All missing values within dataset will be replaced with 0. Found:', df.isna().sum().sum(), 'missing values. ')
    df = df.fillna(value=0)
    
    df = pd.get_dummies(df, drop_first=True)
    
    new_cols = [col for col in df.columns if col != 'charges'] + ['charges']
    df = df[new_cols]
    
    return df