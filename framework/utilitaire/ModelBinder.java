package framework.utilitaire;

import jakarta.servlet.http.HttpServletRequest;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

public class ModelBinder {
    public static Object bind(HttpServletRequest request, Class<?> targetType) {
        try {
            Object instance = targetType.getDeclaredConstructor().newInstance();
            // Bind by setters first
            Method[] methods = targetType.getMethods();
            for (Method m : methods) {
                if (isSetter(m)) {
                    String prop = decapitalize(m.getName().substring(3));
                    String raw = request.getParameter(prop);
                    if (raw != null) {
                        Class<?> paramType = m.getParameterTypes()[0];
                        Object converted = convert(raw, paramType);
                        try { m.invoke(instance, converted); } catch (Exception ignore) {}
                    }
                }
            }
            // Fallback: direct fields
            Field[] fields = targetType.getDeclaredFields();
            for (Field f : fields) {
                String name = f.getName();
                String raw = request.getParameter(name);
                if (raw != null) {
                    Object converted = convert(raw, f.getType());
                    try {
                        f.setAccessible(true);
                        f.set(instance, converted);
                    } catch (Exception ignore) {}
                }
            }
            return instance;
        } catch (Exception e) {
            return null;
        }
    }

    private static boolean isSetter(Method m) {
        return m.getName().startsWith("set") && m.getParameterCount() == 1;
    }

    private static String decapitalize(String s) {
        if (s == null || s.isEmpty()) return s;
        return Character.toLowerCase(s.charAt(0)) + s.substring(1);
    }

    private static Object convert(String raw, Class<?> type) {
        if (raw == null) return null;
        if (type == String.class) return raw;
        try {
            if (type == int.class || type == Integer.class) return Integer.parseInt(raw);
            if (type == long.class || type == Long.class) return Long.parseLong(raw);
            if (type == double.class || type == Double.class) return Double.parseDouble(raw);
            if (type == float.class || type == Float.class) return Float.parseFloat(raw);
            if (type == boolean.class || type == Boolean.class) return Boolean.parseBoolean(raw);
            if (type == short.class || type == Short.class) return Short.parseShort(raw);
            if (type == byte.class || type == Byte.class) return Byte.parseByte(raw);
            if (type == char.class || type == Character.class) return raw.isEmpty() ? '\0' : raw.charAt(0);
            if (type.isEnum()) {
                @SuppressWarnings({"rawtypes", "unchecked"})
                Class<? extends Enum> et = (Class<? extends Enum>) type;
                return Enum.valueOf(et, raw);
            }
        } catch (Exception ignore) {}
        return null;
    }
}
