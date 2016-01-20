/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.axiata.dialog.util;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import com.google.gdata.util.common.util.Base64;

/**
 * 
 * @author WSO2Telco
 */
public class EncryptAES {

	private static Cipher cipher;

	private static byte[] keyValue;

	static {
		keyValue = FileUtil.getApplicationProperty("key").getBytes();
	}

	public static String encrypt(String plainText) throws Exception {

		SecretKey key = new SecretKeySpec(keyValue, "AES");
		String encryptedText = "";
		cipher = Cipher.getInstance("AES");

		if (plainText != null) {
			byte[] plainTextByte = plainText.getBytes();
			cipher.init(Cipher.ENCRYPT_MODE, key);
			byte[] encryptedByte = cipher.doFinal(plainTextByte);
			encryptedText = Base64.encode(encryptedByte);
		} else {
			// nop
		}

		return encryptedText;
	}

}
