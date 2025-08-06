Feature: Este servicio recibe un token de autenticacion, confirma la veracidad del token y devuelve un token con un nuevo tiempo de expiración

  Background:
    * url baseUrl + '/refreshToken'
    * print 'URL del endpoint de refreshToken:', baseUrl + '/refreshToken'
    * def schemaUtil = Java.type('util.JsonSchemaUtil')
    * def schemaText = karate.readAsString('classpath:Schema/sc_refreshToken.json')
    * configure headers = headers
    * print 'HEADERS CONFIGURADOS:', karate.get('headers')

  @refreshToken
  Scenario: Validar que un token valido pueda ser refrescado correctamente

    # Llamando a loginToken.feature para obtener el Token.
    * def loginResult = call read('classpath:api/loginToken.feature')
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
