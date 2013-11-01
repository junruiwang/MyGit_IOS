package com.jje.mobile.util;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

public class MapGenerateHelper {

    private static Logger logger = LoggerFactory.getLogger(MapGenerateHelper.class);

    public static Map<String, String> prepareObjectToMap(Object obj) throws Exception {
        Map<String, String> params = new HashMap<String, String>();
        try {
            //当前Class放入Map
            reflectToMap(params, obj.getClass().getDeclaredFields(), obj);

            if (!obj.getClass().getSuperclass().getSimpleName().equals("Object")) {
                //如果父类为 Object的子类,执行父类的反射操作
                reflectToMap(params, obj.getClass().getSuperclass().getDeclaredFields(), obj);
            }
        } catch (Exception ex) {
            logger.error("对象反射发生错误",ex);
        }
        return params;
    }

    private static void reflectToMap(Map<String, String> params,Field[] fields,Object obj) throws Exception{
        for (Field field : fields) {
            String fieldName = field.getName();
            char ch = Character.toUpperCase(fieldName.charAt(0));
            Method method = obj.getClass().getMethod("get" + ch + fieldName.substring(1));
            Object val = method.invoke(obj);
            params.put(fieldName,String.valueOf(val));
        }
    }

}
