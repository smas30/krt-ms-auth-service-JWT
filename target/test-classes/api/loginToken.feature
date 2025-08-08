@intraloginValidaciones
Feature: Servicio de autenticacion de la gerencia de soporte a la operacion

  Background:
    * url baseUrl + '/intraLogin'
    * print 'URL del endpoint de login:', baseUrl + '/intraLogin'
    * def schemaUtil = Java.type('util.JsonSchemaUtil')
    * def schemaText = karate.readAsString('classpath:Schema/sc_loginToken.json')
    * def validBodyRequest = read('classpath:JsonRequest/loginTokenRequest.json')
    * def invalidBodyRequest = read('classpath:JsonRequest/loginTokenInvalidRequest.json')
    * def emptyBodyRequest = read('classpath:JsonRequest/loginTokenEmptyRequest.json')
    * def invalidFormatRequest = read('classpath:JsonRequest/loginTokenInvalidFormatRequest.json')
    * configure headers = headers

  @loginInvalido
  Scenario: El endpoint debe rechazar y retornar error 401 Unauthorized cuando se envian Credenciales incorrectas
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

  @loginFormatoInvalido
  Scenario: El endpoint debe validar y rechazar cuando se envían campos con formato inválido
    Given request invalidFormatRequest
    When method POST
    Then status 400
    And match response contains { "error": "#string" }
    And print 'Error de validacion de formato:', response.error


