package com.lizhou.servlet;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.fileupload.FileUploadException;

import com.lizhou.bean.Clazz;
import com.lizhou.bean.Grade;
import com.lizhou.bean.Page;
import com.lizhou.bean.Student;
import com.lizhou.bean.Teacher;
import com.lizhou.bean.User;
import com.lizhou.exception.FileFormatException;
import com.lizhou.exception.NullFileException;
import com.lizhou.exception.ProtocolException;
import com.lizhou.exception.SizeException;
import com.lizhou.service.StudentService;
import com.lizhou.service.TeacherService;
import com.lizhou.tools.StringTool;

import net.sf.json.JSONObject;

/**
 * 教师类Servlet
 * @author bojiangzhou
 *
 */
public class TeacherServlet extends HttpServlet {
	
	//创建服务层对象
	private TeacherService service = new TeacherService();
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//获取请求的方法
		String method = request.getParameter("method");
		if("toTeacherListView".equalsIgnoreCase(method)){ //转发到教师列表页
			request.getRequestDispatcher("/WEB-INF/view/teacher/teacherList.jsp").forward(request, response);
		} else if("toTeacherNoteListView".equalsIgnoreCase(method)){ //转发到教师列表页
			request.getRequestDispatcher("/WEB-INF/view/teacher/teacherNoteList.jsp").forward(request, response);
		} else if("toExamTeacherView".equalsIgnoreCase(method)){ //转发到教师列表页
			request.getRequestDispatcher("/WEB-INF/view/teacher/examTeacherList.jsp").forward(request, response);
		} else if("toTeacherPersonalView".equalsIgnoreCase(method)){ //转发到教师列表页
			toPersonal(request, response);
		}  
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//获取请求的方法
		String method = request.getParameter("method");
		//请求分发
		if("TeacherList".equalsIgnoreCase(method)){ //获取所有教师数据
			teacherList(request, response);
		} else if("AddTeacher".equalsIgnoreCase(method)){ //添加教师
			addTeacher(request, response);
		} else if("DeleteTeacher".equalsIgnoreCase(method)){ //删除教师
			deleteTeacher(request, response);
		} else if("EditTeacher".equalsIgnoreCase(method)){ //修改教师信息
			editTeacher(request, response);
		} else if("GetTeacher".equalsIgnoreCase(method)){ //获取某个教师信息
			getTeacher(request, response);
		} else if("GetExamClazz".equalsIgnoreCase(method)){ //获取某次考试老师的班级
			getExamClazz(request, response);
		} else if("GetExamCourse".equalsIgnoreCase(method)){ //获取某次考试老师的课程
			getExamCourse(request, response);
		} else if("EditTeacherPersonal".equalsIgnoreCase(method)){ //修改个人信息
			editTeacherPersonal(request, response);
		}
		
		
		
		
	}
	
	private void editTeacherPersonal(HttpServletRequest request, HttpServletResponse response) throws IOException {
		//获取参数名
		Enumeration<String> pNames = request.getParameterNames();
		Teacher teacher = new Teacher();
		while(pNames.hasMoreElements()){
			String pName = pNames.nextElement();
			String value = request.getParameter(pName);
			try {
				BeanUtils.setProperty(teacher, pName, value);
			} catch (IllegalAccessException | InvocationTargetException e) {
				e.printStackTrace();
			}
		}
		service.editTeacherPersonal(teacher);
		response.getWriter().write("success");
	}

	/**
	 * 转到个人信息页，加载个人信息
	 * @param request
	 * @param response
	 * @throws IOException 
	 * @throws ServletException 
	 */
	private void toPersonal(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User user = (User) request.getSession().getAttribute("user");
		Teacher teacher = service.getTeacher(user.getAccount());
		request.getSession().setAttribute("userDetail", teacher);
		request.getRequestDispatcher("/WEB-INF/view/teacher/teacherPersonal.jsp").forward(request, response);
	}
	
	private void getExamCourse(HttpServletRequest request, HttpServletResponse response) throws IOException {
		int gradeid = Integer.parseInt(request.getParameter("gradeid"));
		Grade grade = new Grade();
		grade.setId(gradeid);
		String scid = request.getParameter("clazzid");
		if(StringTool.isEmpty(scid)){
			response.getWriter().write("");
			return;
		}
		int clazzid = Integer.parseInt(scid);
		Clazz clazz = new Clazz();
		clazz.setId(clazzid);
		
		User user = (User) request.getSession().getAttribute("user");
		
		String result = service.getExamClazz(user.getAccount(), grade, clazz);
		
		response.getWriter().write(result);
	}

	private void getExamClazz(HttpServletRequest request, HttpServletResponse response) throws IOException {
		int gradeid = Integer.parseInt(request.getParameter("gradeid"));
		Grade grade = new Grade();
		grade.setId(gradeid);
		
		User user = (User) request.getSession().getAttribute("user");
		
		String result = service.getExamClazz(user.getAccount(), grade);
		
		response.getWriter().write(result);
	}

	private void getTeacher(HttpServletRequest request, HttpServletResponse response) throws IOException {
		//获取当前用户
		User user = (User) request.getSession().getAttribute("user");
		String number = user.getAccount();
		String result = service.getTeacherResult(number);
		response.getWriter().write(result);
	}

	private void editTeacher(HttpServletRequest request, HttpServletResponse response) throws IOException {
		//获取参数名
		Enumeration<String> pNames = request.getParameterNames();
		Teacher teacher = new Teacher();
		while(pNames.hasMoreElements()){
			String pName = pNames.nextElement();
			String value = request.getParameter(pName);
			try {
				if("course[]".equals(pName)){//设置所选课程
					BeanUtils.setProperty(teacher, "course", request.getParameterValues("course[]"));
				} else{
					BeanUtils.setProperty(teacher, pName, value);
				}
			} catch (IllegalAccessException | InvocationTargetException e) {
				e.printStackTrace();
			}
		}
		try {
			service.editTeacher(teacher);
			response.getWriter().write("success");
		} catch (Exception e) {
			response.getWriter().write("fail");
			e.printStackTrace();
		}
	}

	private void deleteTeacher(HttpServletRequest request, HttpServletResponse response) throws IOException {
		//获取要删除的学号
		String[] ids = request.getParameterValues("ids[]");
		String[] numbers = request.getParameterValues("numbers[]");
		try {
			service.deleteTeacher(ids, numbers);
			response.getWriter().write("success");
		} catch (Exception e) {
			response.getWriter().write("fail");
			e.printStackTrace();
		}
	}

	private void addTeacher(HttpServletRequest request, HttpServletResponse response) throws IOException {
		//获取参数名
		Enumeration<String> pNames = request.getParameterNames();
		Teacher teacher = new Teacher();
		while(pNames.hasMoreElements()){
			String pName = pNames.nextElement();
			String value = request.getParameter(pName);
			try {
				if("course[]".equals(pName)){//设置所选课程
					BeanUtils.setProperty(teacher, "course", request.getParameterValues("course[]"));
				} else{
					BeanUtils.setProperty(teacher, pName, value);
				}
			} catch (IllegalAccessException | InvocationTargetException e) {
				e.printStackTrace();
			}
		}
		try {
			service.addTeacher(teacher);
			response.getWriter().write("success");
		} catch (Exception e) {
			response.getWriter().write("fail");
			e.printStackTrace();
		}
	}

	private void teacherList(HttpServletRequest request, HttpServletResponse response) throws IOException {
		//获取分页参数
		int page = Integer.parseInt(request.getParameter("page"));
		int rows = Integer.parseInt(request.getParameter("rows"));
		
		//获取数据
		String result = service.getTeacherList(new Page(page, rows));
		//返回数据
        response.getWriter().write(result);
	}
	
}
