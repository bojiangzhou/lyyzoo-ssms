package com.lizhou.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lizhou.bean.Page;
import com.lizhou.service.ClazzService;
import com.lizhou.service.GradeService;
import com.lizhou.tools.StringTool;

public class ClazzServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
      
	private ClazzService service = new ClazzService();
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//获取请求的方法
		String method = request.getParameter("method");
		if("toClazzListView".equalsIgnoreCase(method)){ //转发到课程列表页
			request.getRequestDispatcher("/WEB-INF/view/other/clazzList.jsp").forward(request, response);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//获取请求的方法
		String method = request.getParameter("method");
		
		if("ClazzList".equalsIgnoreCase(method)){ //获取所有班级
			clazzList(request, response);
		} else if("ClazzDetailList".equalsIgnoreCase(method)){ //获取所有班级详细信息
			clazzDetailList(request, response);
		} else if("AddClazz".equalsIgnoreCase(method)){ //添加班级
			addClazz(request, response);
		} else if("DeleteClazz".equalsIgnoreCase(method)){ //删除班级
			deleteClazz(request, response);
		}
		
	}
	
	private void deleteClazz(HttpServletRequest request, HttpServletResponse response) throws IOException {
		int clazzid = Integer.parseInt(request.getParameter("clazzid"));
		try {
			service.deleteClazz(clazzid);
			response.getWriter().write("success");
		} catch (Exception e) {
			response.getWriter().write("fail");
			e.printStackTrace();
		}
	}

	private void addClazz(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String name = request.getParameter("name");
		String gradeid = request.getParameter("gradeid");
		service.addClazz(name, gradeid);
		response.getWriter().write("success");
	}

	private void clazzDetailList(HttpServletRequest request, HttpServletResponse response) throws IOException {
		//获取参数
		String gradeid = request.getParameter("gradeid");
		//获取分页参数
		int page = Integer.parseInt(request.getParameter("page"));
		int rows = Integer.parseInt(request.getParameter("rows"));
		
		String result = service.getClazzDetailList(gradeid, new Page(page, rows));
		//返回数据
        response.getWriter().write(result);
	}

	private void clazzList(HttpServletRequest request, HttpServletResponse response) throws IOException {
		//获取参数
		String gradeid = request.getParameter("gradeid");
		
		if(StringTool.isEmpty(gradeid)){
			return;
		}
		String result = service.getClazzList(gradeid);
		//返回数据
        response.getWriter().write(result);
	}

}
