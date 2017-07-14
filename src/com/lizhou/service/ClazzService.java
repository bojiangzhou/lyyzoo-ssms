package com.lizhou.service;

import java.sql.Connection;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import com.lizhou.bean.Clazz;
import com.lizhou.bean.Grade;
import com.lizhou.bean.Page;
import com.lizhou.bean.Student;
import com.lizhou.dao.impl.BaseDaoImpl;
import com.lizhou.dao.impl.ClazzDaoImpl;
import com.lizhou.dao.inter.BaseDaoInter;
import com.lizhou.dao.inter.ClazzDaoInter;
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
public class ClazzService {
	
	ClazzDaoInter dao = new ClazzDaoImpl();
	
	/**
	 * 获取指定年级下的班级
	 * @param gid 年级ID
	 * @return JSON格式的班级
	 */
	public String getClazzList(String gradeid){
		int id = Integer.parseInt(gradeid);
		//获取数据
		List<Object> list = dao.getList(Clazz.class, "SELECT * FROM clazz WHERE gradeid=?", new Object[]{id});
		//json化
		JsonConfig config = new JsonConfig();
		config.setExcludes(new String[]{"grade", "studentList"});
        String result = JSONArray.fromObject(list, config).toString();
        
        return result;
	}
	
	/**
	 * 获取班级详细信息
	 * @param gradeid
	 * @param page
	 * @return
	 */
	public String getClazzDetailList(String gradeid, Page page) {
		//获取数据
		List<Clazz> list = dao.getClazzDetailList(gradeid, page);
		//获取总记录数
		long total = 0;
		if(!StringTool.isEmpty(gradeid)){
			int gid = Integer.parseInt(gradeid);
			total = dao.count("SELECT COUNT(*) FROM clazz WHERE gradeid=?", new Object[]{gid});
		} else {
			total = dao.count("SELECT COUNT(*) FROM clazz", new Object[]{});
		}
		//定义Map
		Map<String, Object> jsonMap = new HashMap<String, Object>();  
		//total键 存放总记录数，必须的
        jsonMap.put("total", total);
        //rows键 存放每页记录 list 
        jsonMap.put("rows", list); 
        //格式化Map,以json格式返回数据
        String result = JSONObject.fromObject(jsonMap).toString();
        
        return result;
	}

	/**
	 * 添加班级
	 * @param name
	 * @param gradeid
	 */
	public void addClazz(String name, String gradeid) {
		int gid = Integer.parseInt(gradeid);
		dao.insert("INSERT INTO clazz(name, gradeid) value(?,?)", new Object[]{name, gid});
	}
	
	/**
	 * 删除班级
	 * @param clazzid
	 * @throws Exception 
	 */
	public void deleteClazz(int clazzid) throws Exception {
		//获取连接
		Connection conn = MysqlTool.getConnection();
		try {
			//开启事务
			MysqlTool.startTransaction();
			//删除成绩表
			dao.deleteTransaction(conn, "DELETE FROM escore WHERE clazzid=?", new Object[]{clazzid});
			//删除考试记录
			dao.deleteTransaction(conn, "DELETE FROM exam WHERE clazzid=?", new Object[]{clazzid});
			//删除用户
			List<Object> list = dao.getList(Student.class, "SELECT number FROM student WHERE clazzid=?",  new Object[]{clazzid});
			if(list.size() > 0){
				Object[] param = new Object[list.size()];
				for(int i = 0;i < list.size();i++){
					Student stu = (Student) list.get(i);
					param[i] = stu.getNumber();
				}
				String sql = "DELETE FROM user WHERE account IN ("+StringTool.getMark(list.size())+")";
				dao.deleteTransaction(conn, sql, param);
				//删除学生
				dao.deleteTransaction(conn, "DELETE FROM student WHERE clazzid=?", new Object[]{clazzid});
			}
			//删除班级的课程和老师的关联
			dao.deleteTransaction(conn, "DELETE FROM clazz_course_teacher WHERE clazzid=?", new Object[]{clazzid});
			//最后删除班级
			dao.deleteTransaction(conn, "DELETE FROM clazz WHERE id=?",  new Object[]{clazzid});
			
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
