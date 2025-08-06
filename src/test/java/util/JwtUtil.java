package util;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.Base64;
import java.util.List;
import java.util.Map;

public class JwtUtil {
    
    private static final ObjectMapper objectMapper = new ObjectMapper();
    
    /**
     * Decodifica un token JWT y retorna el payload como JsonNode
     */
    public static JsonNode decodeJwtPayload(String jwtToken) throws Exception {
        if (jwtToken == null || jwtToken.isEmpty()) {
            throw new IllegalArgumentException("El token JWT no puede ser null o vacío");
        }
        
        String[] parts = jwtToken.split("\\.");
        if (parts.length != 3) {
            throw new IllegalArgumentException("Token JWT inválido: debe tener 3 partes separadas por puntos");
        }
        
        // Decodificar el payload (segunda parte)
        String payload = parts[1];
        
        // Agregar padding si es necesario
        while (payload.length() % 4 != 0) {
            payload += "=";
        }
        
        // Decodificar de Base64
        byte[] decodedBytes = Base64.getUrlDecoder().decode(payload);
        String decodedPayload = new String(decodedBytes);
        
        return objectMapper.readTree(decodedPayload);
    }
    
    /**
     * Extrae los grupos de permisos del token JWT
     */
    public static List<Map<String, Object>> extractGroups(String jwtToken) throws Exception {
        JsonNode payload = decodeJwtPayload(jwtToken);
        
        if (payload.has("grupoPermisos")) {
            JsonNode gruposNode = payload.get("grupoPermisos");
            if (gruposNode.isArray()) {
                return objectMapper.convertValue(gruposNode, 
                    objectMapper.getTypeFactory().constructCollectionType(List.class, Map.class));
            }
        }
        
        return null;
    }
    
    /**
     * Extrae información específica del token JWT
     */
    public static Map<String, Object> extractTokenInfo(String jwtToken) throws Exception {
        JsonNode payload = decodeJwtPayload(jwtToken);
        return objectMapper.convertValue(payload, Map.class);
    }
    
    /**
     * Formatea los permisos de manera legible
     */
    public static String formatPermissions(String jwtToken) throws Exception {
        List<Map<String, Object>> grupos = extractGroups(jwtToken);
        if (grupos == null || grupos.isEmpty()) {
            return "No se encontraron permisos en el token";
        }
        
        StringBuilder sb = new StringBuilder();
        sb.append("=== PERMISOS Y GRUPOS DEL TOKEN ===\n");
        
        for (Map<String, Object> grupo : grupos) {
            sb.append("Grupo: ").append(getSafeString(grupo, "nombreGrupo")).append("\n");
            sb.append("  - ID Aplicativo: ").append(getSafeString(grupo, "idAplicativo")).append("\n");
            sb.append("  - Nombre App: ").append(getSafeString(grupo, "nombreApp")).append("\n");
            sb.append("  - Descripción App: ").append(getSafeString(grupo, "descApp")).append("\n");
            sb.append("  - ID Grupo: ").append(getSafeString(grupo, "idGrupo")).append("\n");
            sb.append("  - Menú Acceso: ").append(getSafeString(grupo, "menuAccesoApp")).append("\n");
            sb.append("  - App Descripción: ").append(getSafeString(grupo, "appDescription")).append("\n");
            sb.append("---\n");
        }
        
        return sb.toString();
    }
    
    /**
     * Obtiene un resumen de permisos para logging
     */
    public static String getPermissionsSummary(String jwtToken) throws Exception {
        List<Map<String, Object>> grupos = extractGroups(jwtToken);
        if (grupos == null || grupos.isEmpty()) {
            return "Sin permisos";
        }
        
        StringBuilder sb = new StringBuilder();
        sb.append("Permisos encontrados: ").append(grupos.size()).append(" grupos\n");
        
        for (Map<String, Object> grupo : grupos) {
            String nombreGrupo = getSafeString(grupo, "nombreGrupo");
            String nombreApp = getSafeString(grupo, "nombreApp");
            sb.append("- ").append(nombreGrupo).append(" (").append(nombreApp).append(")\n");
        }
        
        return sb.toString();
    }
    
    /**
     * Método auxiliar para obtener valores de manera segura
     */
    private static String getSafeString(Map<String, Object> map, String key) {
        Object value = map.get(key);
        return value != null ? value.toString() : "N/A";
    }
} 