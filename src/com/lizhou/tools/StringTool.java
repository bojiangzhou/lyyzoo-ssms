package com.lizhou.tools;

import java.io.UnsupportedEncodingException;

/**
 * 字符串工具类
 * @author bojiangzhou
 *
 */
public class StringTool {
	
	/**
	 * 判断字符串是否为空
	 * @param str
	 * @return true: 空 | false: 不为空
	 */
	public static boolean isEmpty(String str){
		if(str == null || "".equals(str.trim())){
			return true;
		} else{
			return false;
		}
	}
	
	/**
	 * 将get方式传来的中文转为UTF-8格式
	 * @param str
	 * @return
	 */
	public static String messyCode(String str){
		String code = null;
		try {
			byte[] by = str.getBytes("ISO-8859-1");
			code = new String(by, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return code;
	}
	
	/**
	 * 根据长度生成占位符：即'?,'
	 * @param length
	 * @return
	 */
	public static String getMark(int length){
		StringBuffer mark = new StringBuffer("");
		for(int i = 0;i < length;i++){
			mark.append("?,");
		}
		//删除最后一个逗号
		mark.deleteCharAt(mark.length()-1);
		//返回
		return mark.toString();
	}
	
}
