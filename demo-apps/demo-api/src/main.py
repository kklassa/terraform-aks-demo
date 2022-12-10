from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import os

try:
    pod_name = os.environ['POD_NAME']
except KeyError:
    pod_name = 'unknown'

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'],
    allow_methods=['*'],
    allow_headers=['*'],
)


@app.get('/')
async def root():
    return {'pod_name': f'{pod_name}'}

