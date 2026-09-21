import unittest
from datetime import date

from pydantic import ValidationError
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from app.core.excepciones import OperacionNoPermitida, RecursoNoEncontrado
from app.core.seguridad import crear_token_acceso, obtener_usuario_id_desde_token
from app.core.tipos import EstadoMantenimiento, PeriodoGastos
from app.database import Base
from app.main import app
from app.schemas.mantenimiento import MantenimientoCreate
from app.schemas.usuario import CredencialesUsuario
from app.schemas.vehiculo import VehiculoCreate
from app.services import (
    gastos_service,
    mantenimiento_service,
    usuario_service,
    vehiculo_service,
)


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
        self.usuario = usuario_service.registrar_usuario(
            self.db,
            CredencialesUsuario(
                correo="mariana@correo.com",
                contrasena="123456",
            ),
        )

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
            self.usuario.id,
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
            self.usuario.id,
        )

        vehiculo = vehiculo_service.obtener_vehiculo(self.db, self.usuario.id)
        self.assertEqual(vehiculo.kilometraje_actual, 12500)

    def test_proximos_incluyen_estado_calculado(self):
        self.registrar_vehiculo()
        vehiculo_service.actualizar_kilometraje(self.db, 4500, self.usuario.id)

        proximos = mantenimiento_service.obtener_proximos(self.db, self.usuario.id)

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
            self.usuario.id,
        )

        historial = mantenimiento_service.obtener_historial(self.db, self.usuario.id)
        gastos = gastos_service.obtener_resumen_gastos(
            self.db,
            PeriodoGastos.ESTE_ANIO,
            self.usuario.id,
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

    def test_autenticacion_usa_hash_y_reconoce_credenciales(self):
        usuario = usuario_service.autenticar_usuario(
            self.db,
            CredencialesUsuario(
                correo="mariana@correo.com",
                contrasena="123456",
            ),
        )
        usuario_invalido = usuario_service.autenticar_usuario(
            self.db,
            CredencialesUsuario(
                correo="mariana@correo.com",
                contrasena="incorrecta",
            ),
        )

        self.assertIsNotNone(usuario)
        self.assertIsNone(usuario_invalido)
        self.assertNotEqual(usuario.clave_hash, "123456")

    def test_registro_no_permite_correos_repetidos(self):
        with self.assertRaises(OperacionNoPermitida):
            usuario_service.registrar_usuario(
                self.db,
                CredencialesUsuario(
                    correo="mariana@correo.com",
                    contrasena="123456",
                ),
            )

    def test_token_identifica_al_usuario_que_inicio_sesion(self):
        token = crear_token_acceso(self.usuario.id)

        self.assertEqual(
            obtener_usuario_id_desde_token(token),
            self.usuario.id,
        )
        self.assertIsNone(obtener_usuario_id_desde_token(f"{token}alterado"))

    def test_vehiculos_de_usuarios_distintos_no_se_mezclan(self):
        self.registrar_vehiculo()
        otro_usuario = usuario_service.registrar_usuario(
            self.db,
            CredencialesUsuario(
                correo="otro@correo.com",
                contrasena="123456",
            ),
        )

        with self.assertRaises(RecursoNoEncontrado):
            vehiculo_service.obtener_vehiculo(self.db, otro_usuario.id)

    def test_contrato_http_conserva_las_rutas(self):
        rutas = app.openapi()["paths"]

        self.assertIn("/autenticacion/registro", rutas)
        self.assertIn("/autenticacion/inicio-sesion", rutas)
        self.assertIn("/autenticacion/sesion", rutas)
        self.assertIn("/vehiculo/", rutas)
        self.assertIn("/vehiculo/kilometraje", rutas)
        self.assertIn("/mantenimiento/", rutas)
        self.assertIn("/mantenimiento/historial", rutas)
        self.assertIn("/mantenimiento/proximo", rutas)
        self.assertIn("/mantenimiento/pendientes", rutas)
        self.assertIn("/mantenimiento/gastos", rutas)


if __name__ == "__main__":
    unittest.main()
