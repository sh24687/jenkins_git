# Flask:
import json
import pickle
import numpy as np
import pandas as pd
from flask import Flask, request
import warnings
warnings.filterwarnings('ignore')


flask_app = Flask(__name__)

model_path = 'finalized_model.sav'

@flask_app.route('/', methods=['GET'])
def index_page():
    return_data = {
        "error" : "0",
        "message" : "Successful"
    }
    return flask_app.response_class(response=json.dumps(return_data), mimetype='application/json')

@flask_app.route('/predict',methods=['GET'])
def get_pred():
    try:
        dict_of_data = json.loads(request.data)
        X = dict_of_data['X']
        loaded_model = pickle.load(open(model_path, 'rb'))
        pred = loaded_model.predict([X])

        status_code = 200
        return_data={
          "error": "0",
          "message": "Successfull",
          "predict": pred,
        }

    
    except Exception as e:
        status_code = 500
        return_data = {
            'error':3,
            'message': str(e)
            }
    
    return flask_app.response_class(response=json.dumps(return_data), mimetype='application/json'),status_code


if __name__ == "__main__":
    flask_app.run(port=9090, debug=True)
