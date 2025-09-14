import os
import mlflow
import numpy as np
from fastapi import FastAPI
from pydantic import BaseModel
from typing import List

app = FastAPI()

MODEL_URI = os.getenv("MLFLOW_MODEL_URI")
TRACKING_URI = os.getenv("MLFLOW_TRACKING_URI")

mlflow.set_tracking_uri(TRACKING_URI)

_model = None
def get_model():
    global _model
    if _model is None:
        _model = mlflow.pyfunc.load_model(MODEL_URI)
    return _model

class PredictRequest(BaseModel):
    inputs: List[List[float]]

class PredictResponse(BaseModel):
    predictions: List

@app.on_event("startup")
def _startup():
    get_model()

@app.get("/health")
def health():
    try:
        get_model()
        return {"status": "ok"}
    except Exception as e:
        return {"status": "error", "detail": str(e)}

@app.post("/predict", response_model=PredictResponse)
def predict(req: PredictRequest):
    X = np.array(req.inputs, dtype=float)

    predicts = get_model().predict(X)
    predicts = predicts.tolist() if hasattr(predicts, "tolist") else predicts

    return {"predictions": predicts}
