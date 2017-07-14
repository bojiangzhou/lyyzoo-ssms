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
		//datagrid初始化 
	    $('#dataList').datagrid({ 
	        title:'年级列表', 
	        iconCls:'icon-more',//图标 
	        border: true, 
	        collapsible: false,//是否可折叠的 
	        fit: true,//自动大小 
	        method: "post",
	        url:"GradeServlet?method=GradeList&course=course&t="+new Date().getTime(),
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
 		        {field:'name',title:'年级名称',width:200},
 		        {field:'courseList',title:'年级课程',width:650, 
 		        	formatter: function(value,row,index){
 						if (row.courseList){
 							var cl = "   |   ";
 							var list = row.courseList;
 							for(var i=0;i < list.length;i++){
 								cl += list[i].name+"   |   ";
 							}
 							return cl;
 						} else {
 							return value;
 						}
 					}	
 		        },
	 		]], 
	        toolbar: "#toolbar"
	    }); 
	   
	    //设置工具类按钮
	    $("#add").click(function(){
	    	$("#addDialog").dialog("open");
	    });
	    //删除
	    $("#delete").click(function(){
	    	var selectRow = $("#dataList").datagrid("getSelected");
        	if(selectRow == null){
            	$.messager.alert("消息提醒", "请选择数据进行删除!", "warning");
            } else{
            	var gradeid = selectRow.id;
            	$.messager.confirm("消息提醒", "将删除与年级相关的所有数据(包括班级,学生)，确认继续？", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "GradeServlet?method=DeleteGrade",
							data: {gradeid: gradeid},
							success: function(msg){
								if(msg == "success"){
									$.messager.alert("消息提醒","删除成功!","info");
									//刷新表格
									$("#dataList").datagrid("reload");
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
	    
	  	//课程下拉框
	  	$("#add_courseList").combobox({
	  		valueField: "id",
	  		textField: "name",
	  		multiple: true, //可多选
	  		editable: false, //不可编辑
	  		method: "post",
	  		url: "CourseServlet?method=CourseList&t="+new Date().getTime(),
	  	});
	    
	  	//设置添加学生窗口
	    $("#addDialog").dialog({
	    	title: "添加年级",
	    	width: 500,
	    	height: 400,
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
					iconCls:'icon-world-add',
					handler:function(){
						var validate = $("#addForm").form("validate");
						if(!validate){
							$.messager.alert("消息提醒","请检查你输入的数据!","warning");
							return;
						} else{
							$.ajax({
								type: "post",
								url: "GradeServlet?method=AddGrade",
								data: $("#addForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("消息提醒","添加成功!","info");
										//关闭窗口
										$("#addDialog").dialog("close");
										//清空原表格数据
										$("#add_name").textbox('setValue', "");
							  			$("#add_courseList").combobox("clear");
										
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
					iconCls:'icon-world-reset',
					handler:function(){
						$("#add_name").textbox('setValue', "");
						$("#add_courseList").combobox("clear");
					}
				},
			]
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
		<div><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">删除</a></div>
	</div>
	
	<!-- 添加数据窗口 -->
	<div id="addDialog" style="padding: 10px">  
    	<form id="addForm" method="post">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td>年级名称:</td>
	    			<td><input id="add_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="required:true, validType:'repeat_grade', missingMessage:'不能为空'" /></td>
	    		</tr>
	    		<tr>
	    			<td>选择课程:</td>
	    			<td><select id="add_courseList" style="width: 200px; height: 30px;" name="clazzid" data-options="required:true, missingMessage:'请选择课程'" ></select></td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
</body>
</html>