package com.lizhou.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.LinkedList;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.junit.Test;

import com.lizhou.bean.Clazz;
import com.lizhou.bean.Course;
import com.lizhou.bean.CourseItem;
import com.lizhou.bean.Grade;
import com.lizhou.bean.Page;
import com.lizhou.bean.Student;
import com.lizhou.bean.Teacher;
import com.lizhou.dao.inter.BaseDaoInter;
import com.lizhou.dao.inter.StudentDaoInter;
import com.lizhou.dao.inter.TeacherDaoInter;
import com.lizhou.tools.MysqlTool;

/**
 * 教师数据层
 * @author bojiangzhou
 *
 */
public class TeacherDaoImpl extends BaseDaoImpl implements TeacherDaoInter {

	public List<Teacher> getTeacherList(String sql, Object[] param, Grade grade, Clazz clazz) {
		//数据集合
		List<Teacher> list = new LinkedList<>();
		try {
			//获取数据库连接
			Connection conn = MysqlTool.getConnection();
			//预编译
			PreparedStatement ps = conn.prepareStatement(sql);
			//设置参数
			if(param != null && param.length > 0){
				for(int i = 0;i < param.length;i++){
					ps.setObject(i+1, param[i]);
				}
			}
			//执行sql语句
			ResultSet rs = ps.executeQuery();
			//获取元数据
			ResultSetMetaData meta = rs.getMetaData();
			//遍历结果集
			while(rs.next()){
				//创建对象
				Teacher teacher = new Teacher();
				//遍历每个字段
				for(int i=1;i <= meta.getColumnCount();i++){
					String field = meta.getColumnName(i);
					BeanUtils.setProperty(teacher, field, rs.getObject(field));
				}
				
				List<Object> itemParam = new LinkedList<>();
				StringBuffer itemSql = new StringBuffer("SELECT * FROM clazz_course_teacher WHERE teacherid=? ");
				itemParam.add(teacher.getId());
				if(grade != null){
					itemSql.append(" AND gradeid=?");
					itemParam.add(grade.getId());
				}
				if(clazz != null){
					itemSql.append(" AND clazzid=?");
					itemParam.add(clazz.getId());
				}
				
				List<Object> objList = getList(CourseItem.class, itemSql.toString(), itemParam);
				List<CourseItem> itemList = new LinkedList<>();
				for(Object obj : objList){
					CourseItem item = (CourseItem) obj;
					//查询班级
					Clazz sclazz = (Clazz) getObject(Clazz.class, "SELECT * FROM clazz WHERE id=?", new Object[]{item.getClazzid()});
					Grade sgrade = (Grade) getObject(Grade.class, "SELECT * FROM grade WHERE id=?", new Object[]{item.getGradeid()});
					Course course = (Course) getObject(Course.class, "SELECT * FROM course WHERE id=?", new Object[]{item.getCourseid()});
					
					item.setClazz(sclazz);
					item.setGrade(sgrade);
					item.setCourse(course);
					
					itemList.add(item);
				}
				//添加
				teacher.setCourseList(itemList);
				//添加到集合
				list.add(teacher);
			}
			//关闭连接
			MysqlTool.closeConnection();
			MysqlTool.close(ps);
			MysqlTool.close(rs);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	

}
