package com.lizhou.dao.inter;

import java.util.List;

import com.lizhou.bean.Page;
import com.lizhou.bean.Student;

/**
 * 操作学生的数据层接口
 * @author bojiangzhou
 *
 */
public interface StudentDaoInter extends BaseDaoInter {
	
	/**
	 * 获取学生信息，这里需要将学生的班级，年级等信息封装进去
	 * @param sql 要执行的sql语句
	 * @param param 参数
	 * @return
	 */
	public List<Student> getStudentList(String sql, List<Object> param);
	
}
