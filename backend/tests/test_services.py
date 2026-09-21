import unittest
from datetime import date

from pydantic import ValidationError
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from app.core.tipos import EstadoMantenimiento, PeriodoGastos
from app.database import Base
from app.main import app
from app.schemas.mantenimiento import MantenimientoCreate
from app.schemas.vehiculo import VehiculoCreate
from app.services import gastos_service, mantenimiento_service, vehiculo_service


class ServiciosTest(unittest.TestCase):
    def setUp(self):
        self.engine = create_engine(
            "sqlite://",
            connect_args={"check_same_thread": False},
            poolclass=StaticPool,
        )
        self.session_factory = sessionmaker(
            autocommit=False,
            autoflush=False,
            bind=self.engine,
        )
        Base.metadata.create_all(bind=self.engine)
        self.db = self.session_factory()

    def tearDown(self):
        self.db.close()
        Base.metadata.drop_all(bind=self.engine)
        self.engine.dispose()

    def registrar_vehiculo(self):
        return vehiculo_service.registrar_vehiculo(
            self.db,
            VehiculoCreate(
                marca="Honda",
                modelo="CB 150",
                anio=2021,
                placa="ABC-123",
            ),
        )

    def test_registrar_mantenimiento_actualiza_kilometraje(self):
        self.registrar_vehiculo()

        mantenimiento_service.registrar_mantenimiento(
            self.db,
            MantenimientoCreate(
                tipo="aceite",
                fecha=date.today(),
                kilometraje=12500,
                costo=180,
            ),
        )

        vehiculo = vehiculo_service.obtener_vehiculo(self.db)
        self.assertEqual(vehiculo.kilometraje_actual, 12500)

    def test_proximos_incluyen_estado_calculado(self):
        self.registrar_vehiculo()
        vehiculo_service.actualizar_kilometraje(self.db, 4500)

        proximos = mantenimiento_service.obtener_proximos(self.db)

        aceite = next(item for item in proximos if item.tipo.value == "aceite")
        self.assertEqual(aceite.estado, EstadoMantenimiento.PROXIMO)
        self.assertFalse(aceite.vencido)

    def test_historial_y_gastos_usan_datos_persistidos(self):
        self.registrar_vehiculo()
        mantenimiento_service.registrar_mantenimiento(
            self.db,
            MantenimientoCreate(
                tipo="cadena",
                fecha=date.today(),
                kilometraje=9000,
                costo=350,
            ),
        )

        historial = mantenimiento_service.obtener_historial(self.db)
        gastos = gastos_service.obtener_resumen_gastos(
            self.db,
            PeriodoGastos.ESTE_ANIO,
        )

        self.assertEqual(len(historial), 1)
        self.assertEqual(gastos.total, 350)
        self.assertEqual(gastos.reparacion, 350)

    def test_validaciones_rechazan_datos_invalidos(self):
        with self.assertRaises(ValidationError):
            VehiculoCreate(
                marca="",
                modelo="CB 150",
                anio=1900,
                placa="",
            )

    def test_contrato_http_conserva_las_rutas(self):
        rutas = app.openapi()["paths"]

        self.assertIn("/vehiculo/", rutas)
        self.assertIn("/vehiculo/kilometraje", rutas)
        self.assertIn("/mantenimiento/", rutas)
        self.assertIn("/mantenimiento/historial", rutas)
        self.assertIn("/mantenimiento/proximo", rutas)
        self.assertIn("/mantenimiento/pendientes", rutas)
        self.assertIn("/mantenimiento/gastos", rutas)


if __name__ == "__main__":
    unittest.main()
