package com.lizhou.dao.inter;

import java.util.List;

import com.lizhou.bean.Clazz;
import com.lizhou.bean.Grade;
import com.lizhou.bean.Teacher;

/**
 * 操作教师的数据层接口
 * @author bojiangzhou
 *
 */
public interface TeacherDaoInter extends BaseDaoInter {
	
	/**
	 * 获取教师信息，这里需要将教师所选择的课程查询出来
	 * @param sql
	 * @param param
	 * @param grade 年级参数
	 * @param clazz 班级参数
	 * @return
	 */
	public List<Teacher> getTeacherList(String sql, Object[] param, Grade grade, Clazz clazz);
	
}
