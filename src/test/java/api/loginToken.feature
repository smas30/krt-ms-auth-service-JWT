@loginToken
Feature: Servicio de autenticacion de la gerencia de soporte a la operacion

  Background:
    * url baseUrl + '/intraLogin'
    * print 'URL del endpoint de login:', baseUrl + '/intraLogin'
    * def schemaUtil = Java.type('util.JsonSchemaUtil')
    * def schemaText = karate.readAsString('classpath:Schema/sc_loginToken.json')
    * def validBodyRequest = read('classpath:JsonRequest/loginTokenRequest.json')
    * def invalidBodyRequest = read('classpath:JsonRequest/loginTokenInvalidRequest.json')
    * def emptyBodyRequest = read('classpath:JsonRequest/loginTokenEmptyRequest.json')
    * configure headers = headers

  @loginValido
  Scenario: La respuesta del endpoint entrega un token JWT valido
    Given request validBodyRequest
    When method POST
    Then status 200

  # Validar que la respuesta contenga el campo token
    And match response.token == '#string'

  # Validar la estructura completa de la respuesta usando el schema JSON
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(schemaText, responseText)
    * match isValid == true

  # Log del resultado exitoso
    * print 'Token JWT valido recibido:', response.token
  # Tiempo de respuesta
    And print '=== TIEMPO DE RESPUESTA DEL FEATURE ===', responseTime / 1000, 's'

  @loginInvalido
  Scenario: El endpoint debe rechazar y retornar error 401 cuando se envían credenciales incorrectas o inexistentes
    Given request invalidBodyRequest
    When method POST
    Then status 401
    And match response contains { "error": "#string" }
    And match response.error contains 'LDAP: error code 49'
    And match response.error contains 'data 52e'
    And print 'Error de autenticacion:', response.error

  @loginVacio
  Scenario: El endpoint debe validar y rechazar cuando se envían campos obligatorios vacíos o nulos
    Given request emptyBodyRequest
    When method POST
    Then status 400
    And match response contains { "error": "#string" }
    And print 'Error de validación de campos vacíos:', response.error


