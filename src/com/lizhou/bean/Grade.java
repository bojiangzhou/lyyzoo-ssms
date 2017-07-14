package com.lizhou.bean;

import java.util.LinkedList;
import java.util.List;

/**
 * 年级类
 * @author bojiangzhou
 *
 */
public class Grade {
	
	private int id; //ID
	
	private String name; //名称
	
	private List<Clazz> clazzList = new LinkedList<>(); //年级下的班级列表
	
	private List<Course> courseList = new LinkedList<>(); //本年级的课程
	
	private List<Student> studentList = new LinkedList<>(); //年级下的学

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

	public List<Clazz> getClazzList() {
		return clazzList;
	}

	public void setClazzList(List<Clazz> clazzList) {
		this.clazzList = clazzList;
	}

	public List<Course> getCourseList() {
		return courseList;
	}

	public void setCourseList(List<Course> courseList) {
		this.courseList = courseList;
	}

	public List<Student> getStudentList() {
		return studentList;
	}

	public void setStudentList(List<Student> studentList) {
		this.studentList = studentList;
	}
	
}
