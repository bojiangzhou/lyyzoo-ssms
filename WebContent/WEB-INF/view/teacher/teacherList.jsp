<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>教师列表</title>
	<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="easyui/css/demo.css">
	<script type="text/javascript" src="easyui/jquery.min.js"></script>
	<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="easyui/js/validateExtends.js"></script>
	<script type="text/javascript">
	$(function() {	
		var table;
		
		//datagrid初始化 
	    $('#dataList').datagrid({ 
	        title:'教师列表', 
	        iconCls:'icon-more',//图标 
	        border: true, 
	        collapsible:false,//是否可折叠的 
	        fit: true,//自动大小 
	        method: "post",
	        url:"TeacherServlet?method=TeacherList&t="+new Date().getTime(),
	        idField:'id', 
	        singleSelect:false,//是否单选 
	        pagination:true,//分页控件 
	        rownumbers:true,//行号 
	        sortName:'id',
	        sortOrder:'DESC', 
	        remoteSort: false,
	        columns: [[  
				{field:'chk',checkbox: true,width:50},
 		        {field:'id',title:'ID',width:50, sortable: true},    
 		        {field:'number',title:'工号',width:150, sortable: true},    
 		        {field:'name',title:'姓名',width:150},
 		        {field:'sex',title:'性别',width:100},
 		        {field:'phone',title:'电话',width:150},
 		        {field:'qq',title:'QQ',width:150},
 		        {field:'courseList',title:'课程',width:500, 
 		        	formatter: function(value,row,index){
 						if (row.courseList){
 							var courseList = row.courseList;
 							var course = "";
 							for(var i = 0;i < courseList.length;i++){
 								var gradeName = courseList[i].grade.name;
 								var clazzName = courseList[i].clazz.name;
 								var courseName = courseList[i].course.name;
 								course += "[" + gradeName + " " + clazzName + " " + courseName + "] &nbsp;&nbsp;&nbsp;";
 							}
 							return course;
 						} else {
 							return value;
 						}
 					}	
 		        }
	 		]], 
	        toolbar: "#toolbar"
	    }); 
	    //设置分页控件 
	    var p = $('#dataList').datagrid('getPager'); 
	    $(p).pagination({ 
	        pageSize: 10,//每页显示的记录条数，默认为10 
	        pageList: [10,20,30,50,100],//可以设置每页记录条数的列表 
	        beforePageText: '第',//页数文本框前显示的汉字 
	        afterPageText: '页    共 {pages} 页', 
	        displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录', 
	    }); 
	    //设置工具类按钮
	    $("#add").click(function(){
	    	table = $("#addTable");
	    	$("#addDialog").dialog("open");
	    });
	    //修改
	    $("#edit").click(function(){
	    	table = $("#editTable");
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	if(selectRows.length != 1){
            	$.messager.alert("消息提醒", "请选择一条数据进行操作!", "warning");
            } else{
		    	$("#editDialog").dialog("open");
            }
	    });
	    //删除
	    $("#delete").click(function(){
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	var selectLength = selectRows.length;
        	if(selectLength == 0){
            	$.messager.alert("消息提醒", "请选择数据进行删除!", "warning");
            } else{
            	var ids = [];
            	$(selectRows).each(function(i, row){
            		ids[i] = row.id;
            	});
            	var numbers = [];
            	$(selectRows).each(function(i, row){
            		numbers[i] = row.number;
            	});
            	$.messager.confirm("消息提醒", "将删除与教师相关的所有数据，确认继续？", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "TeacherServlet?method=DeleteTeacher",
							data: {ids: ids,numbers:numbers},
							success: function(msg){
								if(msg == "success"){
									$.messager.alert("消息提醒","删除成功!","info");
									//刷新表格
									$("#dataList").datagrid("reload");
									$("#dataList").datagrid("uncheckAll");
								} else{
									$.messager.alert("消息提醒","删除失败!","warning");
									return;
								}
							}
						});
            		}
            	});
            }
	    });
	    
	  	//设置添加窗口
	    $("#addDialog").dialog({
	    	title: "添加教师",
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
					text:'设置课程',
					plain: true,
					iconCls:'icon-book-add',
					handler:function(){
						$("#chooseCourseDialog").dialog("open");
					}
				},
	    		{
					text:'添加',
					plain: true,
					iconCls:'icon-user_add',
					handler:function(){
						var validate = $("#addForm").form("validate");
						if(!validate){
							$.messager.alert("消息提醒","请检查你输入的数据!","warning");
							return;
						} else{
							var chooseCourse = [];
							$(table).find(".chooseTr").each(function(){
								var gradeid = $(this).find("input[textboxname='gradeid']").attr("gradeId");
								var clazzid = $(this).find("input[textboxname='clazzid']").attr("clazzId");
								var courseid = $(this).find("input[textboxname='courseid']").attr("courseId");
								var course = gradeid+"_"+clazzid+"_"+courseid;
								chooseCourse.push(course);
							});
							var number = $("#add_number").textbox("getText");
							var name = $("#add_name").textbox("getText");
							var sex = $("#add_sex").textbox("getText");
							var phone = $("#add_phone").textbox("getText");
							var qq = $("#add_qq").textbox("getText");
							var data = {number:number, name:name,sex:sex,phone:phone,qq:qq,course:chooseCourse};
							
							$.ajax({
								type: "post",
								url: "TeacherServlet?method=AddTeacher",
								data: data,
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("消息提醒","添加成功!","info");
										//关闭窗口
										$("#addDialog").dialog("close");
										//清空原表格数据
										$("#add_number").textbox('setValue', "");
										$("#add_name").textbox('setValue', "");
										$("#add_sex").textbox('setValue', "男");
										$("#add_phone").textbox('setValue', "");
										$("#add_qq").textbox('setValue', "");
										$(table).find(".chooseTr").remove();
										
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
						$("#add_number").textbox('setValue', "");
						$("#add_name").textbox('setValue', "");
						$("#add_phone").textbox('setValue', "");
						$("#add_qq").textbox('setValue', "");
						
						$(table).find(".chooseTr").remove();
						
					}
				},
			],
			onClose: function(){
				$("#add_number").textbox('setValue', "");
				$("#add_name").textbox('setValue', "");
				$("#add_phone").textbox('setValue', "");
				$("#add_qq").textbox('setValue', "");
				
				$(table).find(".chooseTr").remove();
			}
	    });
	  	
	  	//设置课程窗口
	    $("#chooseCourseDialog").dialog({
	    	title: "设置课程",
	    	width: 400,
	    	height: 300,
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
					iconCls:'icon-book-add',
					handler:function(){
			    		//添加之前先判断是否已选择该课程
						var chooseCourse = [];
						$(table).find(".chooseTr").each(function(){
							var gradeid = $(this).find("input[textboxname='gradeid']").attr("gradeId");
							var clazzid = $(this).find("input[textboxname='clazzid']").attr("clazzId");
							var courseid = $(this).find("input[textboxname='courseid']").attr("courseId");
							var course = gradeid+"_"+clazzid+"_"+courseid;
							chooseCourse.push(course);
						});
						//获取新选择的课程
			    		var gradeId = $("#add_gradeList").combobox("getValue");
			    		var clazzId = $("#add_clazzList").combobox("getValue");
			    		var courseId = $("#add_courseList").combobox("getValue");
						var newChoose = gradeId+"_"+clazzId+"_"+courseId;
						for(var i = 0;i < chooseCourse.length;i++){
							if(newChoose == chooseCourse[i]){
								$.messager.alert("消息提醒","已选择该门课程!","info");
								return;
							}
						}
						
						//添加到表格显示
						var tr = $("<tr class='chooseTr'><td>课程:</td></tr>");
						
			    		var gradeName = $("#add_gradeList").combobox("getText");
			    		var gradeTd = $("<td></td>");
			    		var gradeInput = $("<input style='width: 200px; height: 30px;' data-options='readonly: true' class='easyui-textbox' name='gradeid' />").val(gradeName).attr("gradeId", gradeId);
			    		$(gradeInput).appendTo(gradeTd);
			    		$(gradeTd).appendTo(tr);
			    		
			    		var clazzName = $("#add_clazzList").combobox("getText");
			    		var clazzTd = $("<td></td>");
			    		var clazzInput = $("<input style='width: 200px; height: 30px;' data-options='readonly: true' class='easyui-textbox' name='clazzid' />").val(clazzName).attr("clazzId", clazzId);
			    		$(clazzInput).appendTo(clazzTd);
			    		$(clazzTd).appendTo(tr);
			    		
			    		var courseName = $("#add_courseList").combobox("getText");
			    		var courseTd = $("<td></td>");
			    		var courseInput = $("<input style='width: 200px; height: 30px;' data-options='readonly: true' class='easyui-textbox' name='courseid' />").val(courseName).attr("courseId", courseId);
			    		$(courseInput).appendTo(courseTd);
			    		$(courseTd).appendTo(tr);
			    		
			    		var removeTd = $("<td></td>");
			    		var removeA = $("<a href='javascript:;' class='easyui-linkbutton removeBtn'></a>").attr("data-options", "iconCls:'icon-remove'");
			    		$(removeA).appendTo(removeTd);
			    		$(removeTd).appendTo(tr);
			    		
			    		$(tr).appendTo(table);
			    		
			    		//解析
			    		$.parser.parse($(table).find(".chooseTr :last"));
			    		//关闭窗口
			    		$("#chooseCourseDialog").dialog("close");
					}
				}
			]
	    });
	  	
	  //下拉框通用属性
	  	$("#add_gradeList, #add_clazzList, #add_courseList").combobox({
	  		width: "200",
	  		height: "30",
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false, //不可多选
	  		editable: false, //不可编辑
	  		method: "post",
	  	});
	  	
	  	$("#add_gradeList").combobox({
	  		url: "GradeServlet?method=GradeList&t="+new Date().getTime(),
	  		onChange: function(newValue, oldValue){
	  			//加载该年级下的班级
	  			$("#add_clazzList").combobox("clear");
	  			$("#add_clazzList").combobox("options").queryParams = {gradeid: newValue};
	  			$("#add_clazzList").combobox("reload");
	  			
	  			//加载该年级下的课程
	  			$("#add_courseList").combobox("clear");
	  			$("#add_courseList").combobox("options").queryParams = {gradeid: newValue};
	  			$("#add_courseList").combobox("reload");
	  		},
			onLoadSuccess: function(){
				//默认选择第一条数据
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	  	$("#add_clazzList").combobox({
	  		url: "ClazzServlet?method=ClazzList&t="+new Date().getTime(),
	  		onLoadSuccess: function(){
				//默认选择第一条数据
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	  	$("#add_courseList").combobox({
	  		url: "CourseServlet?method=CourseList&t="+new Date().getTime(),
	  		onLoadSuccess: function(){
		  		//默认选择第一条数据
				var data = $(this).combobox("getData");;
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	  	//编辑教师信息
	  	$("#editDialog").dialog({
	  		title: "修改教师信息",
	    	width: 850,
	    	height: 550,
	    	iconCls: "icon-edit",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
				{
					text:'设置课程',
					plain: true,
					iconCls:'icon-book-add',
					handler:function(){
						$("#chooseCourseDialog").dialog("open");
					}
				},
	    		{
					text:'提交',
					plain: true,
					iconCls:'icon-user_add',
					handler:function(){
						var validate = $("#editForm").form("validate");
						if(!validate){
							$.messager.alert("消息提醒","请检查你输入的数据!","warning");
							return;
						} else{
							var chooseCourse = [];
							$(table).find(".chooseTr").each(function(){
								var gradeid = $(this).find("input[textboxname='gradeid']").attr("gradeId");
								var clazzid = $(this).find("input[textboxname='clazzid']").attr("clazzId");
								var courseid = $(this).find("input[textboxname='courseid']").attr("courseId");
								var course = gradeid+"_"+clazzid+"_"+courseid;
								chooseCourse.push(course);
							});
							var id = $("#dataList").datagrid("getSelected").id;
							var number = $("#edit_number").textbox("getText");
							var name = $("#edit_name").textbox("getText");
							var sex = $("#edit_sex").textbox("getText");
							var phone = $("#edit_phone").textbox("getText");
							var qq = $("#edit_qq").textbox("getText");
							var data = {id:id, number:number, name:name,sex:sex,phone:phone,qq:qq,course:chooseCourse};
							
							$.ajax({
								type: "post",
								url: "TeacherServlet?method=EditTeacher",
								data: data,
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("消息提醒","修改成功!","info");
										//关闭窗口
										$("#editDialog").dialog("close");
										//清空原表格数据
										$("#edit_number").textbox('setValue', "");
										$("#edit_name").textbox('setValue', "");
										$("#edit_sex").textbox('setValue', "男");
										$("#edit_phone").textbox('setValue', "");
										$("#edit_qq").textbox('setValue', "");
										$(table).find(".chooseTr").remove();
										
										//重新刷新页面数据
							  			$('#dataList').datagrid("reload");
							  			$('#dataList').datagrid("uncheckAll");
										
									} else{
										$.messager.alert("消息提醒","修改失败!","warning");
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
						$("#edit_name").textbox('setValue', "");
						$("#edit_phone").textbox('setValue', "");
						$("#edit_qq").textbox('setValue', "");
						
						$(table).find(".chooseTr").remove();
						
					}
				},
			],
			onBeforeOpen: function(){
				var selectRow = $("#dataList").datagrid("getSelected");
				//设置值
				$("#edit_number").textbox('setValue', selectRow.number);
				$("#edit_name").textbox('setValue', selectRow.name);
				$("#edit_sex").textbox('setValue', selectRow.sex);
				$("#edit_phone").textbox('setValue', selectRow.phone);
				$("#edit_qq").textbox('setValue', selectRow.qq);
				$("#edit_photo").attr("src", "PhotoServlet?method=GetPhoto&type=3&number="+selectRow.number);
				
				var courseList = selectRow.courseList;
				
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
		    		
		    		var removeTd = $("<td></td>");
		    		var removeA = $("<a href='javascript:;' class='easyui-linkbutton removeBtn'></a>").attr("data-options", "iconCls:'icon-remove'");
		    		$(removeA).appendTo(removeTd);
		    		$(removeTd).appendTo(tr);
		    		
		    		$(tr).appendTo(table);
		    		
		    		//解析
		    		$.parser.parse($(table).find(".chooseTr :last"));
					
				}
				
			},
			onClose: function(){
				$("#edit_name").textbox('setValue', "");
				$("#edit_phone").textbox('setValue', "");
				$("#edit_qq").textbox('setValue', "");
				
				$(table).find(".chooseTr").remove();
			}
	    });
	   	
	  	// 一行选择课程
	  	$(".removeBtn").live("click", function(){
	  		$(this).parents(".chooseTr").remove();
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
		<div style="float: left;"><a id="edit" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">修改</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		<div><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">删除</a></div>
	</div>
	
	<!-- 添加窗口 -->
	<div id="addDialog" style="padding: 10px;">  
   		<div style=" position: absolute; margin-left: 560px; width: 250px; height: 300px; border: 1px solid #EEF4FF" id="photo">
    		<img alt="照片" style="max-width: 250px; max-height: 300px;" title="照片" src="photo/teacher.jpg" />
	    </div> 
   		<form id="addForm" method="post">
	    	<table id="addTable" border=0 style="width:800px; table-layout:fixed;" cellpadding="6" >
	    		<tr>
	    			<td style="width:40px">学号:</td>
	    			<td colspan="3">
	    				<input id="add_number"  class="easyui-textbox" style="width: 200px; height: 30px;" type="text" name="number" data-options="required:true, validType:'repeat', missingMessage:'请输入工号'" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td>姓名:</td>
	    			<td colspan="4"><input id="add_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="required:true, missingMessage:'请填写姓名'" /></td>
	    		</tr>
	    		<tr>
	    			<td>性别:</td>
	    			<td colspan="4"><select id="add_sex" class="easyui-combobox" data-options="editable: false, panelHeight: 50, width: 60, height: 30" name="sex"><option value="男">男</option><option value="女">女</option></select></td>
	    		</tr>
	    		<tr>
	    			<td>电话:</td>
	    			<td colspan="4"><input id="add_phone" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="phone" validType="mobile" /></td>
	    		</tr>
	    		<tr>
	    			<td>QQ:</td>
	    			<td colspan="4"><input id="add_qq" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="qq" validType="number" /></td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
	<!-- 设置课程 -->
	<div id="chooseCourseDialog" style="padding: 10px">
	   	<table cellpadding="8" >
	   		<tr>
	   			<td>年级：</td>
	   			<td><input id="add_gradeList" style="width: 200px; height: 30px;" class="easyui-combobox" name="gradeid" /></td>
	   		</tr>
	   		<tr>
	   			<td>班级：</td>
	   			<td><input id="add_clazzList" style="width: 200px; height: 30px;" class="easyui-combobox" name="clazzid" /></td>
	   		</tr>
	   		<tr>
	   			<td>课程：</td>
	   			<td><input id="add_courseList" style="width: 200px; height: 30px;" class="easyui-combobox" name="courseid" /></td>
	   		</tr>
	   	</table>
	</div>
	
	<!-- 修改窗口 -->
	<div id="editDialog" style="padding: 10px">
		<div style=" position: absolute; margin-left: 560px; width: 250px; height: 300px; border: 1px solid #EEF4FF">
	    	<img id="edit_photo" alt="照片" style="max-width: 200px; max-height: 400px;" title="照片" src="" />
	    </div>   
    	<form id="editForm" method="post">
	    	<table id="editTable" border=0 style="width:800px; table-layout:fixed;" cellpadding="6" >
	    		<tr>
	    			<td style="width:40px">工号:</td>
	    			<td colspan="3"><input id="edit_number" data-options="readonly: true" class="easyui-textbox" style="width: 200px; height: 30px;" type="text" name="number" data-options="required:true, validType:'repeat', missingMessage:'请输入工号'" /></td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td>姓名:</td>
	    			<td><input id="edit_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="required:true, missingMessage:'请填写姓名'" /></td>
	    		</tr>
	    		<tr>
	    			<td>性别:</td>
	    			<td><select id="edit_sex" class="easyui-combobox" data-options="editable: false, panelHeight: 50, width: 60, height: 30" name="sex"><option value="男">男</option><option value="女">女</option></select></td>
	    		</tr>
	    		<tr>
	    			<td>电话:</td>
	    			<td><input id="edit_phone" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="phone" validType="mobile" /></td>
	    		</tr>
	    		<tr>
	    			<td>QQ:</td>
	    			<td colspan="4"><input id="edit_qq" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="qq" validType="number" /></td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
	
</body>
</html>