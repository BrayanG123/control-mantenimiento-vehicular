String normalizarCorreo(String correo) => correo.trim().toLowerCase();

bool correoTieneFormatoValido(String correo) {
  return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
      .hasMatch(normalizarCorreo(correo));
}
