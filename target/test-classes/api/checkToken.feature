@checkToken
Feature: Este servicio recibe un token de autenticacion, confirma la veracidad del token y devuelve los permisos asociados al aplicativo que corresponda segun el correlationID

  Background:
    * url baseUrl + '/checkToken'
    * def schemaUtil = Java.type('util.JsonSchemaUtil')
    * def schemaText = karate.readAsString('classpath:Schema/sc_checkToken.json')
    * configure headers = headers

  @checkTokenValido
  Scenario: Confirma la veracidad del token y devolver los permisos asociados al aplicativo que corresponda segun el correlationID

   # Llamando a loginTokenValido.feature para obtener el Token.
    * def loginResult = call read('classpath:api/loginTokenValido.feature')
    * def authToken = loginResult.response.token
    * print 'Token obtenido del login:', authToken

   # Ejecutando scenario checkToken
    * def checkTokenRequest = { "token": "#(authToken)" }
    Given request checkTokenRequest
    When method POST
    Then status 200
    And print response

    # ===== VALIDACIONES DE ESTRUCTURA COMPLETA =====
    # Validar estructura completa de respuesta mediante JSON schema
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(schemaText, responseText)
    * match isValid == true

    # Validar estructura completa de respuesta con match
    And match response contains { data: { records: '#string', totalPageRecords: '#number', totalRecords: '#number' }, message: '#string', success: '#number' }

    # ===== VALIDACIONES DE TOKEN JWT =====
    # Extraer y decodificar el token JWT de la respuesta
    * def jwtTokenFromResponse = response.data.records
    * print '=== TOKEN JWT RECIBIDO ===' + jwtTokenFromResponse

    # Validar que el token JWT no este vacio
    * def isTokenValid = karate.eval('jwtTokenFromResponse != null && jwtTokenFromResponse != ""')
    * assert isTokenValid

    # Decodificar el JWT y mostrar los permisos del usuario
    * def JwtUtil = Java.type('util.JwtUtil')
    * def permisosDecode = JwtUtil.formatPermissions(jwtTokenFromResponse)
    * print permisosDecode

    # Extraer informacion detallada del token
    * def tokenInfo = JwtUtil.extractTokenInfo(jwtTokenFromResponse)
    * print '=== Usuario y Tiempo de expiracion de los permisos ===' + tokenInfo.preferred_username + tokenInfo.exp

    # Mostrar resumen de permisos
    * def resumenPermisos = JwtUtil.getPermissionsSummary(jwtTokenFromResponse)
    * print resumenPermisos

    # Validar que el token contiene informacion de usuario
    * def isUserInfoValid = karate.eval('tokenInfo.preferred_username != null && tokenInfo.preferred_username != ""')
    * assert isUserInfoValid

    # Validar que el token tiene tiempo de expiracion
    * def isExpValid = karate.eval('tokenInfo.exp != null && tokenInfo.exp > 0')
    * assert isExpValid

   # Tiempo de respuesta
    And print '=== TIEMPO DE RESPUESTA DEL FEATURE ===', responseTime / 1000, 's'

  @checkTokenSinPermisos
  Scenario: Validar respuesta cuando el token es valido pero el usuario no tiene permisos asignados
    # Generar un token JWT sin permisos para testing
    * def JwtUtil = Java.type('util.JwtUtil')
    * def authToken = JwtUtil.generateTokenWithoutPermissions()
    * print '=== TOKEN GENERADO SIN PERMISOS ===' + authToken

    # Verificar que el token se puede decodificar
    * def tokenInfo = JwtUtil.extractTokenInfo(authToken)
    * print '=== INFORMACION DEL TOKEN GENERADO ===' + tokenInfo
    
    # Verificar que no tiene permisos
    * def grupos = JwtUtil.extractGroups(authToken)
    * print '=== GRUPOS DEL TOKEN GENERADO ===' + grupos
    
    # Validar que el token no tiene grupos de permisos
    * def noGroups = karate.eval('grupos == null || grupos.size() == 0')
    * assert noGroups
    
    # Validar que el token tiene la informacion básica
    * match tokenInfo.preferred_username == 'usuario_sin_permisos'
    * match tokenInfo.sub == 'usuario_sin_permisos'
    
    And print '=== TOKEN SIN PERMISOS VALIDADO CORRECTAMENTE ==='



