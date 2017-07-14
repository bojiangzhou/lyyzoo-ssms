package com.lizhou.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.lizhou.bean.User;
import com.lizhou.dao.impl.PhotoDaoImpl;
import com.lizhou.dao.inter.PhotoDaoInter;
import com.lizhou.exception.FileFormatException;
import com.lizhou.exception.NullFileException;
import com.lizhou.exception.ProtocolException;
import com.lizhou.exception.SizeException;
import com.lizhou.fileload.FileUpload;

/**
 * 上传照片
 * @author bojiangzhou
 *
 */
public class PhotoService {
	
	PhotoDaoInter dao = new PhotoDaoImpl();
	
	/**
	 * 设置照片
	 * @param user 
	 * @param request
	 * @return
	 * @throws IOException
	 */
	public String setPhoto(User user, HttpServletRequest request) {
		FileUpload upload = new FileUpload(request);
		//设置格式
		upload.setFileFormat("jpg");
		upload.setFileFormat("jpeg");
		upload.setFileFormat("png");
		//设置上传文件大小
		upload.setFileSize(1000);
		//返回信息
		String msg = "";
		try {
			//获取上传文件输入流
			InputStream is = upload.getUploadInputStream();
			//更新数据库
			dao.setPhoto(user, is);
			
			msg = "<div id='message'>上传成功!</div>";
		} catch (ProtocolException e) {
			msg = "<div id='message'>请以MIME协议上传文件<br/>您可以为form表单添加如下属性：enctype=\"multipart/form-data\"</div>";
			e.printStackTrace();
		} catch (NullFileException e) {
			msg = "<div id='message'>上传的文件为空</div>";
			e.printStackTrace();
		} catch (SizeException e) {
			msg = "<div id='message'>请上传小于 "+upload.getFileSize()+"k的文件</div>";
			e.printStackTrace();
		} catch (FileFormatException e) {
			msg = "<div id='message'>请上传 "+upload.getFileFormat()+" 格式的文件</div>";
			e.printStackTrace();
		} catch (Exception e) {
			msg = "<div id='message'>上传出错!</div>";
			e.printStackTrace();
		}
		return msg;
	}

	/**
	 * 获取照片
	 * @param user
	 * @return
	 */
	public InputStream getPhoto(User user) {
		
		InputStream is = dao.getPhoto(user);
		
		return is;
	}
	
}
