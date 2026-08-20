from fastapi import FastAPI
from app.database import Base, engine
from app.routers import vehiculo




Base.metadata.create_all(bind=engine)

app = FastAPI(title="API de control de mantenimiento vehicular")

app.include_router(vehiculo.router)

@app.get("/")
def root():
    return {"status": "ok"}