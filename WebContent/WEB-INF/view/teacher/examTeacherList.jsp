<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>考试列表</title>
	<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="easyui/css/demo.css">
	<script type="text/javascript" src="easyui/jquery.min.js"></script>
	<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="easyui/themes/locale/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript">
		//验证只能为数字
		function scoreBlur(score){
			if(!/^[1-9]\d*$/.test($(score).val())){
				$(score).val("");
			}
		}
	$(function() {	
		
		
		var table;
		
		//datagrid初始化 
	    $('#dataList').datagrid({ 
	        title:'考试列表', 
	        iconCls:'icon-more',//图标 
	        border: true, 
	        collapsible: false,//是否可折叠的 
	        fit: true,//自动大小 
	        method: "post",
	        url:"ExamServlet?method=TeacherExamList&t="+new Date().getTime(),
	        idField:'id', 
	        singleSelect: true,//是否单选 
	        pagination: false,//分页控件 
	        rownumbers: true,//行号 
	        sortName:'id',
	        sortOrder:'DESC', 
	        remoteSort: false,
	        columns: [[  
				{field:'chk',checkbox: true,width:50},
 		        {field:'id',title:'ID',width:50, sortable: true},    
 		        {field:'name',title:'考试名称',width:200, sortable: true},    
 		        {field:'etime',title:'考试时间',width:150},
 		        {field:'type',title:'考试类型',width:100, 
 		        	formatter: function(value,row,index){
						if(value == 1){
							return "年级统考"
						} else {
							return "平时考试";
						}
 					}
 		        },
 		        {field:'grade',title:'考试年级',width:100, 
 		        	formatter: function(value,row,index){
 						if (row.grade){
 							return row.grade.name;
 						} else {
 							return value;
 						}
 					}		
 		        },
 		        {field:'clazz',title:'考试班级',width:100, 
 		        	formatter: function(value,row,index){
 						if (row.clazz){
 							return row.clazz.name;
 						} else {
 							return value;
 						}
 					}	
 		        },
 		       {field:'course',title:'考试科目',width:100, 
 		        	formatter: function(value,row,index){
 						if (row.course){
 							return row.course.name;
 						} else {
 							return value;
 						}
 					}	
 		        },
 		       	{field:'remark',title:'备注',width:250}
	 		]], 
	        toolbar: "#toolbar"
	    }); 
	    
	    //设置工具类按钮
	    $("#add").click(function(){
	    	
	    	$.ajax({
				type: "post",
				url: "TeacherServlet?method=GetTeacher&t="+new Date().getTime(),
				dataType: "json",
				success: function(result){
					var courseList = result.courseList;
					if(courseList.length == 0){
						$.messager.alert("消息提醒", "您没有课程", "warning");
					} else{
						table = $("#addTable");
				    	
				    	$("#addDialog").dialog("open");
					}
				}
			});
	    	
	    });
	    
	  	//成绩登记
	    $("#register").click(function(){
	    	
	    	var exam = $("#dataList").datagrid("getSelected");
	    	
        	if(exam == null){
            	$.messager.alert("消息提醒", "请选择考试进行统计!", "warning");
            } else{
            	
            	if(exam.type == 2){
            		$("#regClazzList").combobox("readonly", true);
               		$("#regCourseList").combobox("readonly", true);
               		
               		setTimeout(function(){
                		
                		var data = {id: exam.id, gradeid: exam.gradeid, clazzid:exam.clazzid, courseid:exam.courseid, type: '2'};
                		//动态显示该次考试的科目
    	            	$.ajax({
    	            		type: "post",
    						url: "ScoreServlet?method=ColumnList",
    						data: data,
    						dataType: "json",
    						async: false,
    						success: function(result){
    							var columns = [];  
    				            $.each(result, function(i, course){  
    				                var column={};  
    				                column["field"] = "course"+course.id;    
    				                column["title"] = course.name;  
    				                column["width"] = 150;  
    				                column["align"] = "center";  
    				                column["resizable"] = false;  
    				                column["sortable"] = true;  
    				                var escoreid = "escoreid"+course.id;
    				                column["formatter"] = function(value,row,index){return "<input type='text' maxlength='3' onblur='scoreBlur(this)' id='"+row[escoreid]+"' class='score' value="+value+">"};
    					                    
    				                columns.push(column);  
    				            }); 
    				            
    				            $('#regEscoreList').datagrid({ 
    				    	        columns: [
    									columns
    				    	        ]
    				    	    }); 
    						}
    	            	});
                		//加载数据
    			    	setTimeout(function(){
    				    	$("#regEscoreList").datagrid("options").url = "ScoreServlet?method=ScoreList&t="+new Date().getTime();
    				    	$("#regEscoreList").datagrid("options").queryParams = data;
    				    	$("#regEscoreList").datagrid("reload");
    			    	}, 30)
    			    	
    			    	setTimeout(function(){
    				    	$("#regEscoreDialog").dialog("open");
    			    	}, 80)
    			    	
                	}, 100);
               		
            	} else{
            		$("#regClazzList").combobox("readonly", false);
               		$("#regCourseList").combobox("readonly", false);
               		
	            	$("#regClazzList").combobox("options").queryParams = {gradeid: exam.gradeid};
	            	$("#regClazzList").combobox("options").url = "TeacherServlet?method=GetExamClazz";
	            	$("#regClazzList").combobox("reload");
            	}
            	
	    	}
	    });
	    
	    //成绩统计
	    $("#escore").click(function(){
	    	
	    	var exam = $("#dataList").datagrid("getSelected");
	    	
        	if(exam == null){
            	$.messager.alert("消息提醒", "请选择考试进行统计!", "warning");
            } else{
            	
            	var data = {id: exam.id, gradeid: exam.gradeid, clazzid:exam.clazzid,courseid:exam.courseid, type: exam.type};
            	//动态显示该次考试的科目
            	$.ajax({
            		type: "post",
					url: "ScoreServlet?method=ColumnList",
					data: data,
					dataType: "json",
					async: false,
					success: function(result){
						var columns = [];  
			            $.each(result, function(i, course){  
			                var column={};  
			                column["field"] = "course"+course.id;    
			                column["title"] = course.name;  
			                column["width"] = 80;  
			                column["align"] = "center";
			                column["resizable"] = false;  
			                column["sortable"] = true;  
			                
			                columns.push(column);//当需要formatter的时候自己添加就可以了,原理就是拼接字符串.  
			            }); 
			            
			            if(exam.type == 1){
			            	columns.push({field:'total',title:'总分',width:70, sortable: true});
			            	
			            	$("#escoreClazzList").combobox("readonly", false);
			            	
					    	$("#escoreClazzList").combobox("options").queryParams = {gradeid: exam.gradeid};
					    	$("#escoreClazzList").combobox("reload");
			            } else{
			            	$("#escoreClazzList").combobox("readonly", true);
			            }
			            
			            $('#escoreList').datagrid({ 
			    	        columns: [
								columns
			    	        ]
			    	    }); 
			            
					}
            	});
            	setTimeout(function(){
			    	$("#escoreList").datagrid("options").url = "ScoreServlet?method=ScoreList&t="+new Date().getTime();
			    	$("#escoreList").datagrid("options").queryParams = data;
			    	$("#escoreList").datagrid("reload");
			    	
			    	$("#escoreListDialog").dialog("open");
            	}, 100)
		    	
	    	}
	    });
	    
	  	//设置添加窗口
	    $("#addDialog").dialog({
	    	title: "添加考试",
	    	width: 850,
	    	height: 550,
	    	iconCls: "icon-add",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'添加',
					plain: true,
					iconCls:'icon-add',
					handler:function(){
						
						var validate = $("#addForm").form("validate");
						if(!validate){
							$.messager.alert("消息提醒","请检查你输入的数据!","warning");
							return;
						} else{

							var course = $(table).find("input:checked");
							var gradeid = $(course).attr("gradeid");
							var clazzid = $(course).attr("clazzid");
							var courseid = $(course).attr("courseid");
							var name = $("#add_name").textbox("getValue");
							var etime = $("#add_time").textbox("getValue");
							var remark = $("#add_remark").textbox("getValue");
							
							var data = {gradeid:gradeid,clazzid:clazzid,courseid:courseid,name:name,etime:etime,remark:remark,type:'2'};
							$.ajax({
								type: "post",
								url: "ExamServlet?method=AddExam&t="+new Date().getTime(),
								data: data,
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("消息提醒","添加成功!","info");
										//关闭窗口
										$("#addDialog").dialog("close");
										//清空原表格数据
										$("#add_name").textbox('setValue', "");
										$("#add_time").datebox('setValue', "");
										$("#add_remark").textbox('setValue', "");
										
										//重新刷新页面数据
							  			$('#dataList').datagrid("reload");
										
									} else{
										$.messager.alert("消息提醒","添加失败!","warning");
										return;
									}
								}
							});
						}
					}
				},
				{
					text:'重置',
					plain: true,
					iconCls:'icon-reload',
					handler:function(){
						$("#add_name").textbox('setValue', "");
						$("#add_time").datebox('setValue', "");
						$("#add_remark").textbox('setValue', "");
					}
				},
			],
			onBeforeOpen: function(){
				$.ajax({
					type: "post",
					url: "TeacherServlet?method=GetTeacher&t="+new Date().getTime(),
					dataType: "json",
					success: function(result){
						var courseList = result.courseList;
						console.log(result);
						for(var i = 0;i < courseList.length;i++){
							var gradeId = courseList[i].grade.id;
							var gradeName = courseList[i].grade.name;
							var clazzId = courseList[i].clazz.id;
							var clazzName = courseList[i].clazz.name;
							var courseId = courseList[i].course.id;
							var courseName = courseList[i].course.name;
							//添加到表格显示
							var tr = $("<tr class='chooseTr'><td>课程:</td></tr>");
							
				    		var gradeTd = $("<td></td>");
				    		var gradeInput = $("<input style='width: 200px; height: 30px;' data-options='readonly: true' class='easyui-textbox' name='gradeid' />").val(gradeName).attr("gradeId", gradeId);
				    		$(gradeInput).appendTo(gradeTd);
				    		$(gradeTd).appendTo(tr);
				    		
				    		var clazzTd = $("<td></td>");
				    		var clazzInput = $("<input style='width: 200px; height: 30px;' data-options='readonly: true' class='easyui-textbox' name='clazzid' />").val(clazzName).attr("clazzId", clazzId);
				    		$(clazzInput).appendTo(clazzTd);
				    		$(clazzTd).appendTo(tr);
				    		
				    		var courseTd = $("<td></td>");
				    		var courseInput = $("<input style='width: 200px; height: 30px;' data-options='readonly: true' class='easyui-textbox' name='courseid' />").val(courseName).attr("courseId", courseId);
				    		$(courseInput).appendTo(courseTd);
				    		$(courseTd).appendTo(tr);
				    		
				    		var radioTd = $("<td></td>");
				    		var radioInput = $("<input class='course' type='radio' name='course' />").attr({gradeid:gradeId, clazzid:clazzId, courseid:courseId});
				    		$(radioInput).appendTo(radioTd);
				    		$(radioTd).appendTo(tr);
				    		
				    		$(tr).appendTo(table);
				    		
				    		//解析
				    		$.parser.parse($(table).find(".chooseTr :last"));
						}
						$(table).find(".course :first").attr("checked", "checked");
					}
				});
			},
			onClose: function(){
				$(table).find(".chooseTr").remove();
			}
	    });
	  	
	  	//考试成绩窗口
	    $("#escoreListDialog").dialog({
	    	title: "成绩统计",
	    	width: 850,
	    	height: 550,
	    	iconCls: "icon-chart_bar",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	onClose: function(){
   	        	$("#escoreClazzList").combobox("clear");
   	        }
	    });
	  	//成绩列表
	    $("#escoreList, #regEscoreList").datagrid({ 
   	        border: true, 
   	        collapsible: false,//是否可折叠的 
   	        fit: true,//自动大小 
   	        method: "post",
   	        noheader: true,
   	        singleSelect: true,//是否单选 
   	        rownumbers: true,//行号 
   	        sortOrder:'DESC', 
   	        remoteSort: false,
   	        frozenColumns: [[  
   				{field:'number',title:'学号',width:120,resizable: false},    
   				{field:'name',title:'姓名',width:120,resizable: false}	,        
   	        ]],
   	    });
	  	
	    $("#escoreList").datagrid({ 
   	        toolbar: "#escoreToolbar",
   	    });
	    
	    $("#regEscoreList").datagrid({ 
   	        toolbar: "#regEscoreToolbar",
   	    });
	  	
	  	//考试成绩窗口
	    $("#regEscoreDialog").dialog({
	    	title: "成绩登记",
	    	width: 850,
	    	height: 550,
	    	iconCls: "icon-vcard-edit",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	onClose: function(){
	    		$("#regClazzList").combobox("clear");
        		$("#regCourseList").combobox("clear");
	    	}
	    });
	  	
	  	$("#redo").click(function(){
	  		var exam = $("#dataList").datagrid("getSelected");
	  		var clazzid = exam.clazzid;
	    	if(exam.type == 1){
	    		clazzid = $("#escoreClazzList").combobox("getValue");
	    	}
        	//var data = {id: exam.id, gradeid: exam.gradeid, clazzid:clazzid,courseid:exam.courseid, type: exam.type};
	    	
        	var url = "ScoreServlet?method=ExportScore&id="+exam.id+"&gradeid="+exam.gradeid+"&clazzid="+clazzid+"&courseid="+exam.courseid+"&type="+exam.type;
	    	
	  		window.open(url, "_blank");
	  	});
	  	
	  	$("#escoreClazzList").combobox({
	  		width: "150",
	  		height: "25",
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false, //可多选
	  		editable: false, //不可编辑
	  		method: "post",
	  		url: "ClazzServlet?method=ClazzList&t="+new Date().getTime(),
	  		onChange: function(newValue, oldValue){
	  			var exam = $("#dataList").datagrid("getSelected");
            	var data = {id: exam.id, gradeid: exam.gradeid, clazzid:newValue,courseid:exam.courseid, type: exam.type};
	  			
	  			$("#escoreList").datagrid("options").url = "ScoreServlet?method=ScoreList&t="+new Date().getTime();
		    	$("#escoreList").datagrid("options").queryParams = data;
		    	$("#escoreList").datagrid("reload");
	  		}
	  	});
	  	
	  	$("#regiser").click(function(){
	  		var score = [];
	  		$(".score").each(function(){
	  			var d = $(this).attr("id")+"_"+$(this).val();
	  			score.push(d);
	  		});
	  		console.log(score);
	  		$.ajax({
				type: "post",
				url: "ScoreServlet?method=SetScore&t="+new Date().getTime(),
				data: {score: score},
				success: function(msg){
					if(msg == "success"){
						$.messager.alert("消息提醒","登记成功!","info");
							
						$("#regEscoreDialog").dialog("close");
					}
				}
	  		});
	  		
	  	});
	  	
	  	$("#clear").click(function(){
	  		$.messager.confirm("消息提醒", "确认清空？", function(r){
        		if(r){
        			$(".score").val("");
        		}
        	});
	  	});
	  	
	  	//班级下拉框
	  	$("#regClazzList").combobox({
	  		width: "150",
	  		height: "25",
	  		panelHeight: '100',
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false, //可多选
	  		editable: false, //不可编辑
	  		method: "post",
	  		onChange: function(newValue, oldValue){
	  			var exam = $("#dataList").datagrid("getSelected");
	  			
	  			//加载该年级下的班级
	  			$("#regCourseList").combobox("clear");
	  			$("#regCourseList").combobox("options").queryParams = {gradeid:exam.gradeid, clazzid:newValue};
	  			$("#regCourseList").combobox("options").url = "TeacherServlet?method=GetExamCourse&t="+new Date().getTime();
	  			
	  			setTimeout(function(){
		  			$("#regCourseList").combobox("reload")
	  			}, 14);
	  			
	  		},
	  		onLoadSuccess: function(){
				//默认选择第一条数据
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	//课程下拉框
	  	$("#regCourseList").combobox({
	  		width: "150",
	  		height: "25",
	  		panelHeight: '100',
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false, //可多选
	  		editable: false, //不可编辑
	  		method: "post",
	  		onChange: function(newValue, oldValue){
	  			
	  			var exam = $("#dataList").datagrid("getSelected");
	  			
	  			if(!(newValue == null || newValue == "" || newValue == 0)){
	  				
            	setTimeout(function(){
	            	var clazzid = $("#regClazzList").combobox("getValue");
	            	
            		var data = {id: exam.id, gradeid: exam.gradeid, clazzid:clazzid, courseid:newValue, type: '2'};
            		//动态显示该次考试的科目
	            	$.ajax({
	            		type: "post",
						url: "ScoreServlet?method=ColumnList",
						data: data,
						dataType: "json",
						async: false,
						success: function(result){
							var columns = [];  
				            $.each(result, function(i, course){  
				                var column={};  
				                column["field"] = "course"+course.id;    
				                column["title"] = course.name;  
				                column["width"] = 150;  
				                column["align"] = "center";  
				                column["resizable"] = false;  
				                column["sortable"] = true;  
				                var escoreid = "escoreid"+course.id;
				                column["formatter"] = function(value,row,index){return "<input type='text' maxlength='3' onblur='scoreBlur(this)' id='"+row[escoreid]+"' class='score' value="+value+">"};
					                    
				                columns.push(column);  
				            }); 
				            
				            $('#regEscoreList').datagrid({ 
				    	        columns: [
									columns
				    	        ]
				    	    }); 
				            
						}
	            	});
			    	setTimeout(function(){
				    	$("#regEscoreList").datagrid("options").url = "ScoreServlet?method=ScoreList&t="+new Date().getTime();
				    	$("#regEscoreList").datagrid("options").queryParams = data;
				    	$("#regEscoreList").datagrid("reload");
			    	}, 30)
			    	
			    	setTimeout(function(){
				    	$("#regEscoreDialog").dialog("open");
			    	}, 80)
			    	
            	}, 100);
	  			}
	  		},
	  		onLoadSuccess: function(){
				//默认选择第一条数据
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	  	   
	});
	</script>
</head>
<body>
	<!-- 数据列表 -->
	<table id="dataList" cellspacing="0" cellpadding="0"> 
	    
	</table> 
	
	<!-- 工具栏 -->
	<div id="toolbar">
		<div style="float: left;"><a id="add" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">添加</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="float: left;"><a id="register" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-vcard-edit',plain:true">登记成绩</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		<div><a id="escore" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-chart_bar',plain:true">成绩统计</a></div>
	</div>
	
	<!-- 考试成绩表 -->
	<div id="escoreListDialog">
		<table id="escoreList" cellspacing="0" cellpadding="0"> 
	    
		</table> 
	</div>
	<div id="escoreToolbar">
		<a id="redo" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-redo',plain:true">导出</a>
		<span id="escoreClazzSpan" style="margin-left:10px;">班级：<input id="escoreClazzList" class="easyui-textbox" name="clazz" /></span>
	</div>
	
	<!-- 登记考试成绩 -->
	<div id="regEscoreDialog">
		<table id="regEscoreList" cellspacing="0" cellpadding="0"> 
	    
		</table> 
	</div>
	<div id="regEscoreToolbar">
		<a id="regiser" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-folder-up',plain:true">提交</a>
		<a id="clear" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-clear',plain:true">清空</a>
		<span id="regClazzSpan" style="margin-left:10px;">班级：<input id="regClazzList" class="easyui-textbox" name="clazz" /></span>
		<span id="regCourseSpan" style="margin-left:10px;">课程：<input id="regCourseList" class="easyui-textbox" name="course" /></span>
	</div>
	
	<!-- 添加窗口 -->
	<div id="addDialog" style="padding: 10px">  
    	<form id="addForm" method="post">
	    	<table id="addTable" border=0 style="width:800px; table-layout:fixed;" cellpadding="6"  >
	    		<tr>
	    			<td style="width:40px">名称:</td>
	    			<td colspan="3"><input id="add_name"  class="easyui-textbox" style="width: 200px; height: 30px;" type="text" name="name" data-options="required:true, missingMessage:'请输入名称'" /></td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td>考试<br/>时间:</td>
	    			<td><input id="add_time" style="width: 200px; height: 30px;" class="easyui-datebox" type="text" name="etime" data-options="required:true, missingMessage:'请选择日期', editable:false" /></td>
	    		</tr>
	    		<tr>
	    			<td>考试<br/>类型:</td>
	    			<td>
	    				<input style="width: 200px; height: 30px;" class="easyui-textbox" data-options="readonly: true" type="text" value="平时考试" />
	    				<input type="hidden" name="type"  value="2"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>备注:</td>
	    			<td><input id="add_remark" style="width: 200px; height: 70px;" class="easyui-textbox" data-options="multiline: true," name="remark" /></td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
	
	
	
</body>
</html>