import streamlit as st
import joblib
import numpy as np
import pandas as pd 
from streamlit.web import cli as stcli
from streamlit import runtime
import sys

def main():
    html_temp = """
    <div style="background-color:lightblue;padding:16px">
    <h2 style="color:black";text-align:center> Health Insurance Cost Prediction</h2>
    </div>
    
    """
    
    st.markdown(html_temp,unsafe_allow_html=True)
    
    model = joblib.load('model_xgb')
    
    p1 = st.slider('Enter Your Age',18,100)
    
    s1 = st.selectbox('Sex',('Male','Female'))
    
    if s1=='Male':
        p2=1
    else:
        p2=0


    sel_box = st.selectbox("Do you know level of your BMI?", ("Yes", "No"))

    #p3 = st.number_input("Enter Your BMI Value")
    
    if sel_box == "Yes":
        p3 = st.number_input("Enter Your BMI Value")
    else:
        height = st.number_input("Enter your height value in cm", value=10)
        height = height/100
        weight = st.number_input("Enter your weight value in kg", value=10)
        p3 = weight/(height*height)
        st.text("Your BMI is {:.2f}!".format(p3))

    p4 = st.slider("Enter Number of Children",0,10)
    
    
    s2 = st.selectbox("Smoker",("Yes","No"))
    
    
    if s2=='Yes':
        p5=1
    else:
        p5=0
        
    region_names = {1:'Southwest', 2:'Southeast',  3:'Northwest' , 4:'Northeast'}    
   
    
    p6 = st.radio("Select your region", (1,2,3,4),format_func=lambda x: region_names[x] )

    
    data = {'age' : p1,
        'sex' : p2,
        'bmi' : p3,
        'children' : p4,
        'smoker' : p5,
        'region' : p6}

    data = pd.DataFrame(data,index=[0])

    if st.button('Predict'):
        pred = model.predict(data)[0]
        
        pred_round = np.format_float_positional(pred,precision=2)
   
        st.balloons()
        st.success('Your Insurance Cost is {} $'.format(pred_round))
        
        
    
if __name__ == '__main__':
    if runtime.exists():
        main()
    else:
        sys.argv = ["streamlit", "run", sys.argv[0]]
        sys.exit(stcli.main())