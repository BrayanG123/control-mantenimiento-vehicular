from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.tipos import PeriodoGastos
from app.database import get_db
from app.schemas.gastos import ResumenGastos
from app.services import gastos_service


router = APIRouter(prefix="/mantenimiento", tags=["Gastos"])


@router.get("/gastos", response_model=ResumenGastos)
def obtener_gastos(
    periodo: PeriodoGastos = PeriodoGastos.ESTE_ANIO,
    db: Session = Depends(get_db),
):
    return gastos_service.obtener_resumen_gastos(db, periodo)
