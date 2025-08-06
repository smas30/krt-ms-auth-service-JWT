Feature: Este servicio recibe un token de autenticacion, confirma la veracidad del token y devuelve los permisos asociados al aplicativo que corresponda segun el correlationID

  Background:
    * url baseUrl + '/checkToken'
    * def schemaUtil = Java.type('util.JsonSchemaUtil')
    * def schemaText = karate.readAsString('classpath:Schema/sc_checkToken.json')
    * configure headers = headers

  @checkToken
  Scenario: Confirma la veracidad del token y devolver los permisos asociados al aplicativo que corresponda segun el correlationID

   # Llamando a loginToken.feature para obtener el Token.
    * def loginResult = call read('classpath:api/loginToken.feature')
    * def authToken = loginResult.response.token
    * print 'Token obtenido del login:', authToken

   # Ejecutando scenario checkToken
    * def checkTokenRequest = { "token": "#(authToken)" }
    Given request checkTokenRequest
    When method POST
    Then status 200
    And print response
    
    # Validar estructura completa de respuesta mediante JSON schema
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(schemaText, responseText)
    * match isValid == true
    
    # Extraer y decodificar el token JWT de la respuesta
    * def jwtTokenFromResponse = response.data.records
    * print '=== TOKEN JWT RECIBIDO ==='
    * print jwtTokenFromResponse
    
    # Decodificar el JWT y mostrar los permisos del usuario
    * def JwtUtil = Java.type('util.JwtUtil')
    * def permisosDecode = JwtUtil.formatPermissions(jwtTokenFromResponse)
    * print permisosDecode
    
    # Extraer informacion detallada del token
    * def tokenInfo = JwtUtil.extractTokenInfo(jwtTokenFromResponse)
    * print '=== Usuario y Tiempo de expiracion de los permisos ==='
    * print 'Username:', tokenInfo.preferred_username
    * print 'Expiration:', tokenInfo.exp
    
    # Mostrar resumen de permisos
    * def resumenPermisos = JwtUtil.getPermissionsSummary(jwtTokenFromResponse)
    * print resumenPermisos
    
    # Validar que la respuesta contenga la información esperada
    * match response.data.totalRecords == '#number'
    * match response.data.totalPageRecords == '#number'
    * match response.message == 'fetched groups successfully!'
    * match response.success == 1

   # Tiempo de respuesta
    And print '=== TIEMPO DE RESPUESTA DEL FEATURE ===', responseTime / 1000, 's'

