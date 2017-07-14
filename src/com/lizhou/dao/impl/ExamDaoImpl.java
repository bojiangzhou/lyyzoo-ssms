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
import com.lizhou.bean.Exam;
import com.lizhou.bean.Grade;
import com.lizhou.bean.Page;
import com.lizhou.bean.Student;
import com.lizhou.dao.inter.BaseDaoInter;
import com.lizhou.dao.inter.ExamDaoInter;
import com.lizhou.dao.inter.StudentDaoInter;
import com.lizhou.tools.MysqlTool;

/**
 * 
 * @author bojiangzhou
 *
 */
public class ExamDaoImpl extends BaseDaoImpl implements ExamDaoInter {

	public List<Exam> getExamList(String sql, List<Object> param) {
		//数据集合
		List<Exam> list = new LinkedList<>();
		try {
			//获取数据库连接
			Connection conn = MysqlTool.getConnection();
			//预编译
			PreparedStatement ps = conn.prepareStatement(sql);
			//设置参数
			if(param != null && param.size() > 0){
				for(int i = 0;i < param.size();i++){
					ps.setObject(i+1, param.get(i));
				}
			}
			//执行sql语句
			ResultSet rs = ps.executeQuery();
			//获取元数据
			ResultSetMetaData meta = rs.getMetaData();
			//遍历结果集
			while(rs.next()){
				//创建对象
				Exam exam = new Exam();
				//遍历每个字段
				for(int i=1;i <= meta.getColumnCount();i++){
					String field = meta.getColumnName(i);
					Object value = rs.getObject(field);
					BeanUtils.setProperty(exam, field, rs.getObject(field));
				}
				//查询班级
				Clazz clazz = (Clazz) getObject(Clazz.class, "SELECT * FROM clazz WHERE id=?", new Object[]{exam.getClazzid()});
				//查询年级
				Grade grade = (Grade) getObject(Grade.class, "SELECT * FROM grade WHERE id=?", new Object[]{exam.getGradeid()});
				//查询科目
				Course course = (Course) getObject(Course.class, "SELECT * FROM course WHERE id=?", new Object[]{exam.getCourseid()});
				//添加
				exam.setClazz(clazz);
				exam.setGrade(grade);
				exam.setCourse(course);
				//添加到集合
				list.add(exam);
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
