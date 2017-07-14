package com.lizhou.servlet;

import java.awt.image.BufferedImage;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileUploadException;

import com.lizhou.bean.SystemInfo;
import com.lizhou.bean.User;
import com.lizhou.exception.FileFormatException;
import com.lizhou.exception.NullFileException;
import com.lizhou.exception.ProtocolException;
import com.lizhou.exception.SizeException;
import com.lizhou.service.SystemService;
import com.lizhou.tools.VCodeGenerator;

/**
 * 系统类
 * @author bojiangzhou
 *
 */
public class SystemServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
      
	private SystemService service = new SystemService();
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//获取请求的方法
		String method = request.getParameter("method");
		
		if("LoginOut".equals(method)){ //退出系统
			loginOut(request, response);
		} else if("toAdminView".equalsIgnoreCase(method)){ //到管理员界面
			request.getRequestDispatcher("/WEB-INF/view/admin/admin.jsp").forward(request, response);
		} else if("toStudentView".equals(method)){ //到学生界面
			request.getRequestDispatcher("/WEB-INF/view/student/student.jsp").forward(request, response);
		} else if("toTeacherView".equals(method)){ //到教师界面
			request.getRequestDispatcher("/WEB-INF/view/teacher/teacher.jsp").forward(request, response);
		} else if("toAdminPersonalView".equals(method)){ //到系统管理员系统设置界面
			request.getRequestDispatcher("/WEB-INF/view/admin/adminPersonal.jsp").forward(request, response);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//获取请求的方法
		String method = request.getParameter("method");
		
		if("AllAccount".equalsIgnoreCase(method)){ //获取所有账号
			allAccount(request, response);
		} else if("EditPasswod".equals(method)){ //修改密码
			editPasswod(request, response);
		} else if("EditSystemInfo".equals(method)){ //修改系统信息
			editSystemInfo(request, response);
		}
	}
	
	private void editSystemInfo(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String name = request.getParameter("name");
		String value = request.getParameter("value");
		
		SystemInfo sys = service.editSystemInfo(name, value);
		//放到域中
    	request.getServletContext().setAttribute("systemInfo", sys);
    	
		response.getWriter().write("success");
	}

	private void editPasswod(HttpServletRequest request, HttpServletResponse response) throws IOException {
		User user = new User();
		user.setAccount(request.getParameter("account"));
		user.setPassword(request.getParameter("password"));
		service.editPassword(user);
		response.getWriter().write("success");
	}

	/**
	 * 退出系统
	 * @param request
	 * @param response
	 * @throws IOException 
	 * @throws ServletException 
	 */
	private void loginOut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//退出系统时清除系统登录的用户
		request.getSession().removeAttribute("user");
		String contextPath = request.getContextPath();
		//转发到登录界面
		response.sendRedirect(contextPath+"/index.jsp");
	}
	
	private void allAccount(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String result = service.getAccountList();
		//返回数据
        response.getWriter().write(result);
	}

}
