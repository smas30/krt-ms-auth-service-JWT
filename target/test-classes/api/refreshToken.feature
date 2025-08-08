@refreshToken
Feature: Este servicio recibe un token de autenticacion, confirma la veracidad del token y devuelve un token con un nuevo tiempo de expiración

  Background:
    * url baseUrl + '/refreshToken'
    * print 'URL del endpoint de refreshToken:', baseUrl + '/refreshToken'
    * def schemaUtil = Java.type('util.JsonSchemaUtil')
    * def schemaText = karate.readAsString('classpath:Schema/sc_refreshToken.json')
    * def expiredTokenRequest = read('classpath:JsonRequest/tokenExpiradoRequest.json')
    * def invalidTokenRequest = read('classpath:JsonRequest/refreshTokenInvalidRequest.json')
    * configure headers = headers
    * print 'HEADERS CONFIGURADOS:', karate.get('headers')

  @refreshTokenValido
  Scenario: Validar que el servicio cumple su funcion principal,
  Un Token valido que se refresca correctamente y responde Status 200 + nuevo token JWT valido

    # Llamando al archivo loginTokenValido.feature que contiene solo el escenario @loginValido
    * def loginResult = call read('classpath:api/loginTokenValido.feature')
    * def authToken = loginResult.response.token
    * print 'Token obtenido del login:', authToken

    # Validar que se obtuvo un token no nulo
    * match authToken != null

    # Construir request con el token
    * def refreshTokenRequest = { "token": "#(authToken)" }

    # Ejecutar refreshToken
    Given request refreshTokenRequest
    When method POST
    Then status 200

    # Validar estructura completa de respuesta mediante JSON schema
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(schemaText, responseText)
    * match isValid == true

    # Log del token nuevo y tiempo de respuesta
    * print 'Token JWT refrescado recibido:', response.token
    And print '=== TIEMPO DE RESPUESTA DEL FEATURE ===', responseTime / 1000, 's'

  @refreshTokenExpirado
  Scenario: El endpoint debe rechazar y retornar error 401 Unauthorized cuando se envia un token JWT que ya ha expirado
    Given request expiredTokenRequest
    When method POST
    Then status 401
    And match response contains { "error": "#string" }
    And print 'Error de token expirado:', response.error

  @refreshTokenInvalido
  Scenario: El endpoint debe rechazar y retornar error 400 Bad Request cuando se envia un token JWT invalido o malformado
    Given request invalidTokenRequest
    When method POST
    Then status 400
    And match response contains { "error": "#string" }
    And print 'Error de token inválido:', response.error

