package com.lizhou.dao.inter;

import java.util.List;

import com.lizhou.bean.Exam;

/**
 * 操作学生的数据层接口
 * @author bojiangzhou
 *
 */
public interface ExamDaoInter extends BaseDaoInter {
	
	/**
	 * 获取考试信息
	 * @param sql 要执行的sql语句
	 * @param param 参数
	 * @return
	 */
	public List<Exam> getExamList(String sql, List<Object> param);
	
}
