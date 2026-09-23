class ConfiguracionApi {
  ConfiguracionApi._();

  static const urlBase = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://cmv-api-dj.azurewebsites.net',
  );
}
