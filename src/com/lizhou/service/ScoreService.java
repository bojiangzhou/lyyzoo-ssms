package com.lizhou.service;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.servlet.http.HttpServletResponse;

import com.lizhou.bean.Course;
import com.lizhou.bean.CourseItem;
import com.lizhou.bean.Exam;
import com.lizhou.bean.Page;
import com.lizhou.bean.Student;
import com.lizhou.bean.Teacher;
import com.lizhou.bean.User;
import com.lizhou.dao.impl.BaseDaoImpl;
import com.lizhou.dao.impl.ExamDaoImpl;
import com.lizhou.dao.impl.ScoreDaoImpl;
import com.lizhou.dao.impl.StudentDaoImpl;
import com.lizhou.dao.impl.TeacherDaoImpl;
import com.lizhou.dao.inter.BaseDaoInter;
import com.lizhou.dao.inter.ExamDaoInter;
import com.lizhou.dao.inter.ScoreDaoInter;
import com.lizhou.dao.inter.StudentDaoInter;
import com.lizhou.dao.inter.TeacherDaoInter;
import com.lizhou.tools.ExcelTool;
import com.lizhou.tools.MysqlTool;
import com.lizhou.tools.StringTool;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 成绩类服务层
 * @author bojiangzhou
 *
 */
public class ScoreService {
	
	private ScoreDaoInter dao;
	
	public ScoreService(){
		dao = new ScoreDaoImpl();
	}
	
	/**
	 * 获取成绩列表
	 * @param exam 参数
	 * @return
	 */
	public String getScoreList(Exam exam) {
		
		List<Map<String, Object>> list = dao.getScoreList(exam);
        //格式化Map,以json格式返回数据
        String result = JSONArray.fromObject(list).toString();
        //返回
		return result;
	}
	
	/**
	 * 获取记录数
	 * @param exam
	 * @return
	 */
	private long getCount(Exam exam){
		//sql语句
		StringBuffer sb = new StringBuffer("SELECT COUNT(*) FROM exam ");
		//参数
		List<Object> param = new LinkedList<>();
		//判断条件
		if(exam != null){ 
			if(exam.getGrade() != null){//条件：年级
				int gradeid = exam.getGradeid();
				param.add(gradeid);
				sb.append("AND gradeid=? ");
			}
			if(exam.getClazz() != null){
				int clazzid = exam.getClazzid();
				param.add(clazzid);
				sb.append("AND clazzid=? ");
			}
		}
		String sql = sb.toString().replaceFirst("AND", "WHERE");
		
		long count = dao.count(sql, param).intValue();
		
		return count;
	}
	
	/**
	 * 添加考试
	 * @param exam
	 * @throws Exception
	 */
	public void addExam(Exam exam) throws Exception {
		Connection conn = MysqlTool.getConnection();
		try {
			//开启事务
			MysqlTool.startTransaction();
			
			//添加考试信息
			int examid = dao.insertReturnKeysTransaction(conn, 
					"INSERT INTO exam(name, time, remark, type, gradeid, clazzid) value(?,?,?,?,?,?)", 
					new Object[]{
						exam.getName(), 
						exam.getTime(),
						exam.getRemark(),
						exam.getType(),
						exam.getGradeid(),
						exam.getClazzid()
					});
			
			//添加学生成绩表
			String sql = "INSERT INTO escore(examid,clazzid,studentid,gradeid,courseid) value(?,?,?,?,?)";
			
			if(exam.getType() == Exam.EXAM_GRADE_TYPE){ //年级统考
				
				//查询该年级的课程
				List<Object> couObjList = dao.getList(Course.class, 
						"SELECT courseid id FROM grade_course WHERE gradeid=?", 
						new Object[]{exam.getGradeid()});
				
				//查询该年级下的学生
				List<Object> stuList = dao.getList(Student.class, 
						"SELECT id, clazzid FROM student WHERE gradeid=?",
						new Object[]{exam.getGradeid()});
				
				//转换类型
				List<Course> couList = new LinkedList<>();
				for(Object obj : couObjList){
					Course course = (Course) obj;
					couList.add(course);
				}
				//批量参数
				Object[][] param = new Object[stuList.size()*couList.size()][5];
				int index = 0;
				for(int i = 0;i < stuList.size();i++){
					Student student = (Student) stuList.get(i);
					for(int j = 0;j < couList.size();j++){
						param[index][0] = examid;
						param[index][1] = student.getClazzid();
						param[index][2] = student.getId();
						param[index][3] = exam.getGradeid();
						param[index][4] = couList.get(j).getId();
						
						index++;
					}
				}
				//批量添加学生考试表
				dao.insertBatchTransaction(conn, sql, param);
				
			} else{  //平时考试
				
				//查询该班级下的学生
				List<Object> stuList = dao.getList(Student.class, 
						"SELECT id FROM student WHERE clazzid=?",
						new Object[]{exam.getClazzid()});
				
				//批量参数
				Object[][] param = new Object[stuList.size()][5];
				for(int i = 0;i < stuList.size();i++){
					Student student = (Student) stuList.get(i);
					param[i][0] = examid;
					param[i][1] = exam.getClazzid();
					param[i][2] = student.getId();
					param[i][3] = exam.getGradeid();
					param[i][4] = exam.getCourseid();
				}
				//批量添加学生考试表
				dao.insertBatchTransaction(conn, sql, param);
			}
			
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

	/**
	 * 获取数据栏的列名
	 * @param exam
	 * @return
	 */
	public String columnList(Exam exam) {
		List<Object> list = getColumn(exam);
		
		return JSONArray.fromObject(list).toString();
	}
	
	private List<Object> getColumn(Exam exam){
		List<Object> list = null;
		if(exam.getType() == Exam.EXAM_GRADE_TYPE){ //年级考试
			//获取考试的科目
			list = dao.getList(Course.class, 
					"SELECT c.id id, c.name name FROM course c, grade_course gc WHERE c.id=gc.courseid AND gc.gradeid=?", 
					new Object[]{exam.getGradeid()});
		} else{
			//获取某科
			list =  dao.getList(Course.class, 
					"SELECT * FROM course WHERE id=?", new Object[]{exam.getCourseid()});
			
		}
		return list;
	}
	

	/**
	 * 导出成绩列表
	 * @param response
	 * @param exam
	 */
	public void exportScore(HttpServletResponse response, Exam exam) {
		//获取需要导出的数据
		List<Map<String, Object>> list = dao.getScoreList(exam);
		//获取考试信息
		Exam em = (Exam) dao.getObject(Exam.class, "SELECT name, time FROM exam WHERE id=?", new Object[]{exam.getId()});
		//设置文件名
		String fileName = em.getName()+".xls";
		//定义输出类型
		response.setContentType("application/msexcel;charset=utf-8");
		//设定输出文件头
		try {
			response.setHeader("Content-Disposition", "attachment; filename="+URLEncoder.encode(fileName, "UTF-8"));
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
		
		//获取导出的课程
		List<Object> courseList = getColumn(exam);
		
		//表头长度
		int len = 2 + courseList.size();
		if(exam.getType() == Exam.EXAM_GRADE_TYPE){
			len += 1;
		}
		//设置excel的列名
		String[] headers = new String[len];
		headers[0] = "姓名";
		headers[1] = "学号";
		
		int index = 2;
		for(Object obj : courseList){
			Course course = (Course) obj;
			headers[index++] = course.getName();
		}
		
		if(exam.getType() == Exam.EXAM_GRADE_TYPE){
			headers[len-1] = "总分";
		}
		
		ExcelTool et = new ExcelTool<>();
		//导出
		try {
			et.exportMapExcel(headers, list, response.getOutputStream());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 设置成绩
	 * @param score id_score 形式
	 */
	public void setScore(String[] score) {
		Object[][] param = new Object[score.length][2];
		
		for(int i = 0;i < score.length;i++){
			String[] id_score = score[i].split("_");
			int id = Integer.parseInt(id_score[0]);
			param[i][1] = id;
			if(id_score.length == 1){
				param[i][0] = 0;
			} else {
				int sco = Integer.parseInt(id_score[1]);
				param[i][0] = sco;
			}
		}
		
		dao.updateBatch("UPDATE escore SET score=? WHERE id=?", param);
		
	}
	
}
