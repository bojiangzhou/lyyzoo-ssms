package com.lizhou.service;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.junit.Test;

import com.lizhou.bean.Clazz;
import com.lizhou.bean.Course;
import com.lizhou.bean.Grade;
import com.lizhou.bean.Student;
import com.lizhou.dao.impl.BaseDaoImpl;
import com.lizhou.dao.inter.BaseDaoInter;
import com.lizhou.tools.MysqlTool;
import com.lizhou.tools.StringTool;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

/**
 * 年级服务层
 * @author bojiangzhou
 *
 */
public class GradeService {
	
	BaseDaoInter dao = new BaseDaoImpl();
	
	/**
	 * 获取所有年级
	 * @param clazz 是否获取年级下课程
	 * @return JSON格式的年级
	 */
	@Test
	public String getGradeList(String course){
		//获取数据
		List<Object> list = dao.getList(Grade.class, "SELECT * FROM grade");
		JsonConfig config = new JsonConfig();
		if(StringTool.isEmpty(course)){ //如果没有传进course参数，则返回年级的id和名称即可
			config.setExcludes(new String[]{"clazzList", "clazzList", "studentList"});
		} else{ //不为空需要再将年级下的班级获取出来
			//获取课程
			for(Object obj : list){
				Grade grade = (Grade) obj;
				List<Object> gradeCourse = dao.getList(Course.class, 
						"SELECT c.* FROM grade_course gc, course c WHERE gc.gradeid=? AND gc.courseid=c.id", 
						new Object[]{grade.getId()});
				
				List<Course> courseList = new LinkedList<>();
				for(Object gc : gradeCourse){
					Course c = (Course) gc;
					courseList.add(c);
				}
				grade.setCourseList(courseList);
			}
			config.setExcludes(new String[]{"clazzList", "studentList"});
		}
		
		//json化
        String result = JSONArray.fromObject(list, config).toString();
        
        return result;
	}

	/**
	 * 添加年级信息
	 * @param name 年级名称
	 * @param clazzids 年级所选课程
	 */
	public void addGrade(String name, String[] clazzids) {
		//先添加年级
		int key = dao.insertReturnKeys("INSERT INTO grade(name) value(?)", new Object[]{name});
		
		String sql = "INSERT INTO grade_course(gradeid, courseid) value(?, ?)";
		//批量设置课程
		Object[][] params = new Object[clazzids.length][2];
		for(int i = 0;i < clazzids.length;i++){
			params[i][0] = key;
			params[i][1] = Integer.parseInt(clazzids[i]);
		}
		dao.insertBatch(sql, params);
	}

	/**
	 * 删除年级
	 * @param gradeid
	 * @throws Exception 
	 */
	public void deleteGrade(int gradeid) throws Exception {
		//获取连接
		Connection conn = MysqlTool.getConnection();
		try {
			//开启事务
			MysqlTool.startTransaction();
			
			//删除成绩表
			dao.deleteTransaction(conn, "DELETE FROM escore WHERE gradeid=?", new Object[]{gradeid});
			//删除考试记录
			dao.deleteTransaction(conn, "DELETE FROM exam WHERE gradeid=?", new Object[]{gradeid});
			//删除班级的课程和老师的关联
			dao.deleteTransaction(conn, "DELETE FROM clazz_course_teacher WHERE gradeid=?", new Object[]{gradeid});
			//删除班级的课程和老师的关联
			dao.deleteTransaction(conn, "DELETE FROM grade_course WHERE gradeid=?", new Object[]{gradeid});
			//删除用户
			List<Object> list = dao.getList(Student.class, "SELECT number FROM student WHERE gradeid=?",  new Object[]{gradeid});
			if(list.size() > 0){
				Object[] param = new Object[list.size()];
				for(int i = 0;i < list.size();i++){
					Student stu = (Student) list.get(i);
					param[i] = stu.getNumber();
				}
				String sql = "DELETE FROM user WHERE account IN ("+StringTool.getMark(list.size())+")";
				dao.deleteTransaction(conn, sql, param);
				//删除学生
				dao.deleteTransaction(conn, "DELETE FROM student WHERE gradeid=?", new Object[]{gradeid});
			}
			//删除班级
			dao.deleteTransaction(conn, "DELETE FROM clazz WHERE gradeid=?",  new Object[]{gradeid});
			//最后删除年级
			dao.deleteTransaction(conn, "DELETE FROM grade WHERE id=?",  new Object[]{gradeid});
			
			//提交事务
			MysqlTool.commit();
		} catch (Exception e) {
			//回滚事务
			MysqlTool.rollback();
			e.printStackTrace();
			throw e;
		} finally {
			MysqlTool.closeConnection();
		}
	}
	
}
