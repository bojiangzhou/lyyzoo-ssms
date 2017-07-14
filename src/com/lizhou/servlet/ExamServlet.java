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

import com.lizhou.bean.Clazz;
import com.lizhou.bean.Exam;
import com.lizhou.bean.Grade;
import com.lizhou.bean.Page;
import com.lizhou.bean.Student;
import com.lizhou.bean.Teacher;
import com.lizhou.bean.User;
import com.lizhou.service.ExamService;
import com.lizhou.service.StudentService;
import com.lizhou.service.TeacherService;
import com.lizhou.tools.StringTool;

import net.sf.json.JSONObject;

/**
 * 考试类Servlet
 * @author bojiangzhou
 *
 */
public class ExamServlet extends HttpServlet {
	
	//创建服务层对象
	private ExamService service = new ExamService();
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//获取请求的方法
		String method = request.getParameter("method");
		if("toExamListView".equalsIgnoreCase(method)){ //转发到考试列表页
			request.getRequestDispatcher("/WEB-INF/view/other/examList.jsp").forward(request, response);
		}
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//获取请求的方法
		String method = request.getParameter("method");
		//请求分发
		if("ExamList".equalsIgnoreCase(method)){ //获取所有考试数据
			examList(request, response);
		} else if("AddExam".equalsIgnoreCase(method)){ //添加考试
			addExam(request, response);
		} else if("DeleteExam".equalsIgnoreCase(method)){ //删除考试信息
			deleteExam(request, response);
		} else if("TeacherExamList".equalsIgnoreCase(method)){ //获取属于某个老师的考试
			teacherExamList(request, response);
		} else if("StudentExamList".equalsIgnoreCase(method)){ //获取属于某个学生的考试
			studentExamList(request, response);
		}
		
		
		
	}
	
	private void studentExamList(HttpServletRequest request, HttpServletResponse response) throws IOException {
		//获取当前用户
		User user = (User) request.getSession().getAttribute("user");
		String number = user.getAccount();
		
		String result = service.studentExamList(number);
		response.getWriter().write(result);
	}

	private void teacherExamList(HttpServletRequest request, HttpServletResponse response) throws IOException {
		//获取当前用户
		User user = (User) request.getSession().getAttribute("user");
		String number = user.getAccount();
		String result = service.teacherExamList(number);
		response.getWriter().write(result);
	}

	private void deleteExam(HttpServletRequest request, HttpServletResponse response) throws IOException {
		//获取要删除的id
		int id = Integer.parseInt(request.getParameter("id"));
		try {
			service.deleteExam(id);
			response.getWriter().write("success");
		} catch (Exception e) {
			response.getWriter().write("fail");
			e.printStackTrace();
		}
	}

	private void addExam(HttpServletRequest request, HttpServletResponse response) throws IOException {
		//获取参数名
		Enumeration<String> pNames = request.getParameterNames();
		Exam exam = new Exam();
		while(pNames.hasMoreElements()){
			String pName = pNames.nextElement();
			String value = request.getParameter(pName);
			try {
				BeanUtils.setProperty(exam, pName, value);
			} catch (IllegalAccessException | InvocationTargetException e) {
				e.printStackTrace();
			}
		}
		try {
			service.addExam(exam);
			response.getWriter().write("success");
		} catch (Exception e) {
			response.getWriter().write("fail");
			e.printStackTrace();
		}
	}

	private void examList(HttpServletRequest request, HttpServletResponse response) throws IOException {
		//获取分页参数
		int page = Integer.parseInt(request.getParameter("page"));
		int rows = Integer.parseInt(request.getParameter("rows"));
		
		//年级ID
		String gradeid = request.getParameter("gradeid");
		//班级ID
		String clazzid = request.getParameter("clazzid");
		
		Exam exam = new Exam();
		
		if(!StringTool.isEmpty(gradeid)){
			exam.setGradeid(Integer.parseInt(gradeid));
		}
		if(!StringTool.isEmpty(clazzid)){
			exam.setClazzid(Integer.parseInt(clazzid));
		}
		
		//获取数据
		String result = service.getExamList(exam, new Page(page, rows));
		//返回数据
        response.getWriter().write(result);
	}
	
}
