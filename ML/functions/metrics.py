from sklearn.metrics import r2_score, mean_absolute_error, mean_squared_error

def metryka(y_test, y_pred):
    '''A function used to assess the quality of a regression model.
    Input:
        y_test - target from test
        y_pred - variable calculated from the model.
    
    Output:
        r2_score
        mean_absolute_error
        mean_squared_error
    '''
    print('Coefficient of determination (R2): ', r2_score(y_test, y_pred))
    print('Mean absolute error (MAE): ', mean_absolute_error(y_test, y_pred))
    print('Mean squared error (MSE): ', mean_squared_error(y_test, y_pred))