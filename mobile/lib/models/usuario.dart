class Usuario {
  const Usuario({required this.id, required this.correo});

  final int id;
  final String correo;

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(id: json['id'] as int, correo: json['correo'] as String);
  }
}

class SesionAutenticada {
  const SesionAutenticada({required this.token, required this.usuario});

  final String token;
  final Usuario usuario;

  factory SesionAutenticada.fromJson(Map<String, dynamic> json) {
    return SesionAutenticada(
      token: json['access_token'] as String,
      usuario: Usuario.fromJson(json['usuario'] as Map<String, dynamic>),
    );
  }
}
