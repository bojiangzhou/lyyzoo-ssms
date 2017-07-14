package com.lizhou.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lizhou.bean.Course;
import com.lizhou.bean.Page;
import com.lizhou.service.ClazzService;
import com.lizhou.service.CourseService;
import com.lizhou.service.GradeService;
import com.lizhou.tools.StringTool;

/**
 * 课程
 * @author bojiangzhou
 *
 */
public class CourseServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
      
	private CourseService service = new CourseService();
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//获取请求的方法
		String method = request.getParameter("method");
		if("toCourseListView".equalsIgnoreCase(method)){ //转发到教师列表页
			request.getRequestDispatcher("/WEB-INF/view/other/courseList.jsp").forward(request, response);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//获取请求的方法
		String method = request.getParameter("method");
		
		if("CourseList".equalsIgnoreCase(method)){ //获取所有课程
			courseList(request, response);
		} else if("AddCourse".equalsIgnoreCase(method)){ //添加课程
			addCourse(request, response);
		} else if("deleteCourse".equalsIgnoreCase(method)){ //删除课程
			deleteCourse(request, response);
		}
		
	}
	
	private void deleteCourse(HttpServletRequest request, HttpServletResponse response) throws IOException {
		int courseid = Integer.parseInt(request.getParameter("courseid"));
		try {
			service.deleteClazz(courseid);
			response.getWriter().write("success");
		} catch (Exception e) {
			response.getWriter().write("fail");
			e.printStackTrace();
		}
	}

	private void addCourse(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String name = request.getParameter("name");
		Course course = new Course();
		course.setName(name);
		service.addCourse(course);
		response.getWriter().write("success");
	}
	
	private void courseList(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String gradeid = request.getParameter("gradeid");
		
		String result = service.getCourseList(gradeid);
		//返回数据
        response.getWriter().write(result);
	}

}
