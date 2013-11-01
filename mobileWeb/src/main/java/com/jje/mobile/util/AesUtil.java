package com.jje.mobile.util;


import com.jje.common.utils.MD5Utils;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.lang.StringUtils;

public class AesUtil {

    private static String key = "mobile_team_pkey";

    private static final String SECURITY_KEY = "f0623a19527b364e9e42ea36fe6c8350";

    public static String decrypts(String source) {

        if ("0".equals(source)) {
            return null;
        }

    	try {
            byte[] raw = key.getBytes("ASCII");
            SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
            Cipher cipher = Cipher.getInstance("AES");
            cipher.init(Cipher.DECRYPT_MODE, skeySpec);
            byte[] encrypted1 = hex2byte(source);
            byte[] original = cipher.doFinal(encrypted1);
            return new String(original);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public static String encrypt(String source) {
    	if (StringUtils.isBlank(source)) {
            return null;
        }
    	try {
            byte[] raw = key.getBytes("ASCII");
            SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
            Cipher cipher = Cipher.getInstance("AES");
            cipher.init(Cipher.ENCRYPT_MODE, skeySpec);
            byte[] encrypted = cipher.doFinal(source.getBytes());
            return byte2hex(encrypted).toLowerCase();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public static String generateSignByUserId(String userId) {

        return MD5Utils.generatePassword(userId+SECURITY_KEY);
    }

    private static byte[] hex2byte(String sourceString) {
        if (sourceString == null) {
            return null;
        }
        int l = sourceString.length();
        if (l % 2 == 1) {
            return null;
        }
        byte[] b = new byte[l / 2];
        for (int i = 0; i != l / 2; i++) {
            b[i] = (byte) Integer.parseInt(sourceString.substring(i * 2, i * 2 + 2), 16);
        }
        return b;
    }

    private static String byte2hex(byte[] sourceByteArray) {
        StringBuilder result = new StringBuilder();
        for (int n = 0; n < sourceByteArray.length; n++) {
            String temp = (java.lang.Integer.toHexString(sourceByteArray[n] & 0XFF));
            if (temp.length() == 1) {
                result.append("0" + temp);
            } else {
                result.append(temp);
            }
        }
        return result.toString().toUpperCase();
    }
    
    public static void main(String[] args) {
        System.out.println(MD5Utils.generatePassword("0b451ab108a4b4b872ba3620a444f313"));

        System.out.println(AesUtil.encrypt("11283"));
        System.out.println(AesUtil.decrypts("2cdfb8899079490875fe920190fb7542"));
    }
}
