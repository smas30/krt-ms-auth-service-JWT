function fn() {
    var env = karate.env || 'dev';
    var baseUrl = '';

    karate.log('Configurando entorno:', env);

    if (env === 'dev') {
        baseUrl = 'http://10.161.169.27:8511';
    } else if (env === 'e2e') {
        baseUrl = 'http:/examples.com';
    }

    var config = {
        env: env,
        baseUrl: baseUrl,
        headers: {
            'Content-Type': 'application/json',
            'correlationId': '1445|E11011|234234',
            'X-USER-ID': 'E11011'
        },
        // Tiempo maximo que Karate esperara para leer una respuesta del servidor
        readTimeout: 30000,
        //Tiempo maximo que Karate esperara para establecer una conexion inicial con el servidor.
        connectTimeout: 10000,
    };

    // Variables globales utiles para validaciones de tiempo general y logs
    config.currentTimestamp = java.lang.System.currentTimeMillis();
    config.dateTime = java.time.LocalDateTime.now().toString();

    return config;
}
