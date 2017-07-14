package com.lizhou.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lizhou.bean.User;

/**
 * 如果用户没有登录，返回登录界面
 * @author bojiangzhou
 *
 */
public class VisitFilter implements Filter {

	public void destroy() {
		
	}

	public void doFilter(ServletRequest req, ServletResponse rep, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) rep;
		
		User user = (User) request.getSession().getAttribute("user");
		
		String contextPath = request.getContextPath();
		
		String uri = request.getRequestURI();
		uri = uri.substring(uri.lastIndexOf("/")+1, uri.length());
		
		if(user != null){
			chain.doFilter(request, response);
		} else{
			response.sendRedirect(contextPath+"/index.jsp");
		}
	}

	public void init(FilterConfig arg0) throws ServletException {
		
	}

}
