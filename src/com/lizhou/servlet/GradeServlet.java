package com.lizhou.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lizhou.service.GradeService;

public class GradeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
      
	private GradeService service = new GradeService();
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//获取请求的方法
		String method = request.getParameter("method");
		if("toGradeListView".equalsIgnoreCase(method)){ //转发到教师列表页
			request.getRequestDispatcher("/WEB-INF/view/other/gradeList.jsp").forward(request, response);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//获取请求的方法
		String method = request.getParameter("method");
		
		if("GradeList".equalsIgnoreCase(method)){ //获取所有年级
			gradeList(request, response);
		} else if("AddGrade".equalsIgnoreCase(method)){ //添加年级
			addGrade(request, response);
		} else if("deleteGrade".equalsIgnoreCase(method)){ //删除年级
			deleteGrade(request, response);
		}
		
	}
	
	private void deleteGrade(HttpServletRequest request, HttpServletResponse response) throws IOException {
		int gradeid = Integer.parseInt(request.getParameter("gradeid"));
		try {
			service.deleteGrade(gradeid);
			response.getWriter().write("success");
		} catch (Exception e) {
			response.getWriter().write("fail");
			e.printStackTrace();
		}
	}

	private void addGrade(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String[] clazzids = request.getParameterValues("clazzid");
		String name = request.getParameter("name");
		
		service.addGrade(name, clazzids);
        response.getWriter().write("success");
	}
	
	private void gradeList(HttpServletRequest request, HttpServletResponse response) throws IOException {
		//获取参数：course=course：是否获取年级的同时返回该年级下的课程
		String course = request.getParameter("course");
		
		String result = service.getGradeList(course);
		//返回数据
        response.getWriter().write(result);
	}

}
