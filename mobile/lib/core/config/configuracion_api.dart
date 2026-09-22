class ConfiguracionApi {
  ConfiguracionApi._();

  static const urlBase = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://127.0.0.1:8001',
  );
}
