package com.lizhou.dao.inter;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

/**
 * 基础dao
 * @author bojiangzhou
 *
 */
@SuppressWarnings("rawtypes")
public interface BaseDaoInter {
	
	/**
	 * 获取数据集合
	 * @param type 返回对象的class
	 * @param sql 要执行的sql语句
	 * @return
	 */
	List<Object> getList(Class type, String sql);
	
	/**
	 * 获取数据集合
	 * @param type 返回对象的class
	 * @param sql 执行的sql语句
	 * @param param Object[] 数组参数
	 * @return
	 */
	List<Object> getList(Class type, String sql, Object[] param);
	
	/**
	 * 获取数据集合
	 * @param type 返回对象的class
	 * @param sql 执行的sql语句
	 * @param param List<Object>集合参数
	 * @return
	 */
	List<Object> getList(Class type, String sql, List<Object> param);
	
	/**
	 * 获取数据集合
	 * @param conn 数据库连接
	 * @param type
	 * @param sql
	 * @return
	 */
	List<Object> getList(Connection conn, Class type, String sql);
	
	/**
	 * 获取数据集合
	 * @param conn
	 * @param type
	 * @param sql
	 * @param param 将参数封装到数组对象中
	 * @return
	 */
	List<Object> getList(Connection conn, Class type, String sql, Object[] param);
	
	/**
	 * 获取数据集合
	 * @param conn
	 * @param type
	 * @param sql
	 * @param param 将参数封装到集合对象中
	 * @return
	 */
	List<Object> getList(Connection conn, Class type, String sql, List<Object> param);
	
	/**
	 * 获取一个对象
	 * @param type
	 * @param sql
	 * @param param
	 * @return
	 */
	Object getObject(Class type, String sql, Object[] param);
	
	/**
	 * 获取一个对象
	 * @param conn 数据库连接
	 * @param type
	 * @param sql
	 * @param param
	 * @return
	 */
	Object getObject(Connection conn, Class type, String sql, Object[] param);
	
	/**
	 * 获取记录数
	 * @param sql
	 * @return
	 */
	Long count(String sql);
	
	/**
	 * 获取记录数
	 * @param sql
	 * @param param
	 * @return
	 */
	Long count(String sql, Object[] param);
	
	/**
	 * 获取记录数
	 * @param sql
	 * @param param
	 * @return
	 */
	Long count(String sql, List<Object> param);
	
	
	/**
	 * 插入或更新一条数据
	 * @param sql
	 * @param param
	 */
	void update(String sql, Object[] param);
	
	/**
	 * 插入或更新一条数据
	 * @param sql
	 * @param param
	 */
	void update(String sql, List<Object> param);
	
	/**
	 * 插入或更新数据
	 * @param conn
	 * @param sql
	 * @param param
	 * @throws SQLException 
	 */
	void updateTransaction(Connection conn, String sql, Object[] param) throws SQLException;
	
	/**
	 * 批量更新
	 * @param sql
	 * @param param
	 */
	void updateBatch(String sql, Object[][] param);
	
	/**
	 * 插入一条数据
	 * @param sql
	 * @param param
	 */
	void insert(String sql, Object[] param);
	
	/**
	 * 插入数据
	 * 开启事务
	 * @param conn
	 * @param sql
	 * @param param
	 * @throws SQLException 
	 */
	void insertTransaction(Connection conn, String sql, Object[] param) throws SQLException;
	
	/**
	 * 插入数据 返回主键
	 * @param sql
	 * @param param
	 * @return 返回主键
	 */
	int insertReturnKeys(String sql, Object[] param);
	
	/**
	 * 插入一条数据
	 * 开启事务
	 * @param conn 数据库连接
	 * @param sql
	 * @param param
	 * @return 返回插入数据的主键
	 * @throws SQLException
	 */
	int insertReturnKeysTransaction(Connection conn, String sql, Object[] param) throws SQLException;
	
	
	/**
	 * 批量插入数据
	 * @param sql
	 * @param param Object[][] 
	 */
	void insertBatch(String sql, Object[][] param);
	
	/**
	 * 批量插入
	 * 开启事务
	 * @param conn
	 * @param sql
	 * @param param
	 * @throws SQLException
	 */
	void insertBatchTransaction(Connection conn, String sql, Object[][] param) throws SQLException;
	
	
	
	/**
	 * 删除
	 * @param sql
	 * @param param
	 */
	void delete(String sql, Object[] param);
	
	/**
	 * 删除数据
	 * 开启事务
	 * @param conn
	 * @param sql
	 * @param param
	 * @throws SQLException 
	 */
	void deleteTransaction(Connection conn, String sql, Object[] param) throws SQLException;
	
	/**
	 * 删除数据
	 * @param conn
	 * @param sql
	 * @param param
	 * @throws SQLException 
	 */
	void deleteTransaction(Connection conn, String sql, List<Object> param) throws SQLException;
	
	/**
	 * 批量删除
	 * @param conn
	 * @param sql
	 * @param param
	 */
	void deleteBatchTransaction(Connection conn, String sql, Object[][] param);
	
	/**
	 * 获取数据表某列的所有值
	 * @param sql
	 * @param params 参数
	 * @return
	 */
	List<String> getColumn(String sql, Object[] param);
	
}
