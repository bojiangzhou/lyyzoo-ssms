package com.lizhou.bean;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 考试类
 * 
 * 考试分为年级统考和平时考试两种
 * 年级统考由管理员添加一次考试
 * 平时考试由科任老师添加考试
 * @author bojiangzhou
 *
 */
public class Exam {
	
	/**
	 * 考试类型：年级统考
	 */
	public static final int EXAM_GRADE_TYPE = 1;
	
	/**
	 * 考试类型：平时考试
	 */
	public static final int EXAM_NORMAL_TYPE = 2;
	
	private int id; //ID
	
	private String name; //考试名称
	
	private Date time; //考试时间
	
	private String etime; //考试时间
	
	private String remark; //备注
	
	private Grade grade; //考试年级
	
	private int gradeid; //年级ID
	
	private Clazz clazz; //考试的班级: 平时考试涉及到某个班级，统考则为所有班级
	
	private int clazzid; //班级ID
	
	private Course course; //考试科目：单科情况
	
	private int courseid; //考试科目ID
	
	private int type = EXAM_GRADE_TYPE; //考试类型:默认为1,1为年级统考，2为平时考试

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Date getTime() {
		return time;
	}

	public void setTime(Date time) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy 年  MM 月  dd 日");
		this.etime = sdf.format(time);
		this.time = time;
	}
	
	public String getEtime() {
		return etime;
	}

	public void setEtime(String etime) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		try {
			this.time = sdf.parse(etime);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		this.etime = etime;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public Grade getGrade() {
		return grade;
	}

	public void setGrade(Grade grade) {
		this.grade = grade;
	}

	public int getGradeid() {
		return gradeid;
	}

	public void setGradeid(int gradeid) {
		Grade grade = new Grade();
		grade.setId(gradeid);
		this.grade = grade;
		this.gradeid = gradeid;
	}

	public Clazz getClazz() {
		return clazz;
	}

	public void setClazz(Clazz clazz) {
		this.clazz = clazz;
	}

	public int getClazzid() {
		return clazzid;
	}

	public void setClazzid(int clazzid) {
		Clazz clazz = new Clazz();
		clazz.setId(clazzid);
		this.clazz = clazz;
		this.clazzid = clazzid;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public Course getCourse() {
		return course;
	}

	public void setCourse(Course course) {
		this.course = course;
	}

	public int getCourseid() {
		return courseid;
	}

	public void setCourseid(int courseid) {
		Course course = new Course();
		course.setId(courseid);
		this.course = course;
		this.courseid = courseid;
	}

}
