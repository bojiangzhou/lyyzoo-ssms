package com.lizhou.dao.inter;

import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;

import com.lizhou.bean.User;

/**
 * 上传照片
 * @author bojiangzhou
 *
 */
public interface PhotoDaoInter {
	
	/**
	 * 插入照片
	 * @param user
	 * @param is
	 * @throws SQLException 
	 * @throws IOException 
	 * @throws Exception 
	 */
	void setPhoto(User user, InputStream is) throws Exception;
	
	/**
	 * 获取照片，返回输入流
	 * @param user
	 * @return
	 */
	InputStream getPhoto(User user);
}
