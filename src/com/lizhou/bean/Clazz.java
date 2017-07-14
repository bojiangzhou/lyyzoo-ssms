package com.lizhou.bean;

import java.util.LinkedList;
import java.util.List;

/**
 * 班级类
 * @author bojiangzhou
 *
 */
public class Clazz {
	
	private int id; //ID
	
	private String name; //名称
	
	private Grade grade; //班级所属年级
	
	private int gradeid; //年级ID
	
	private List<Student> studentList = new LinkedList<>();
	
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

	public List<Student> getStudentList() {
		return studentList;
	}

	public void setStudentList(List<Student> studentList) {
		this.studentList = studentList;
	}
	
}
