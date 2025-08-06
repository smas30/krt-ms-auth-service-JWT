Feature:

  Background:
    * url baseUrl + '/checkToken'
    * def schemaUtil = Java.type('util.JsonSchemaUtil')
    * def schemaText = karate.readAsString('classpath:Schema/sc_loginToken.json')
    * def tokenExpiradoRequest = read('classpath:JsonRequest/tokenExpiradoRequest.json')
    * configure headers = headers

  @tokenExpirado
  Scenario: Consulta fallida por token expirado
    Given request tokenExpiradoRequest
    When method POST
    Then status 401
    And match response.error contains 'JWT expired'
    * print 'Respuesta esperada de token expirado:', response

  # Tiempo de respuesta
    And print '=== TIEMPO DE RESPUESTA DEL FEATURE ===', responseTime / 1000, 's'

    ##Debe devolver un token expirado con codigo 401, pero devuelve codigo 500 "error de servidor"