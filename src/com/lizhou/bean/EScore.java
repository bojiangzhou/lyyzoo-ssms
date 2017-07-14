package com.lizhou.bean;

/**
 * 考试成绩类
 * @author bojiangzhou
 *
 */
public class EScore {
	
	private int id; //ID
	
	private Exam exam; //考试
	
	private int examid; //考试ID
	
	private Clazz clazz; //考试班级
	
	private int clazzid; //班级ID
	
	private Course course; //考试科目
	
	private int courseid; //科目ID
	
	private Student student; //考试学生
	
	private int studentid; //学生ID
	
	private int score; //考试成绩

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public Exam getExam() {
		return exam;
	}

	public void setExam(Exam exam) {
		this.exam = exam;
	}

	public int getExamid() {
		return examid;
	}

	public void setExamid(int examid) {
		Exam exam = new Exam();
		exam.setId(examid);
		this.exam = exam;
		this.examid = examid;
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

	public Student getStudent() {
		return student;
	}

	public void setStudent(Student student) {
		this.student = student;
	}

	public int getStudentid() {
		return studentid;
	}

	public void setStudentid(int studentid) {
		Student student = new Student();
		student.setId(studentid);
		this.student = student;
		this.studentid = studentid;
	}

	public int getScore() {
		return score;
	}

	public void setScore(int score) {
		this.score = score;
	}

}
