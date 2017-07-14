<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>学生列表</title>
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
	        title:'学生列表', 
	        iconCls:'icon-more',//图标 
	        border: true, 
	        collapsible:false,//是否可折叠的 
	        fit: true,//自动大小 
	        method: "post",
	        url:"StudentServlet?method=StudentList&t="+new Date().getTime(),
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
 		        {field:'number',title:'学号',width:200, sortable: true},    
 		        {field:'name',title:'姓名',width:200},
 		        {field:'sex',title:'性别',width:100},
 		        {field:'phone',title:'电话',width:150},
 		        {field:'qq',title:'QQ',width:150},
 		        {field:'clazz',title:'班级',width:150, 
 		        	formatter: function(value,row,index){
 						if (row.clazz){
 							return row.clazz.name;
 						} else {
 							return value;
 						}
 					}
				},
 		        {field:'grade',title:'年级',width:150, 
					formatter: function(value,row,index){
 						if (row.grade){
 							return row.grade.name;
 						} else {
 							return value;
 						}
 					}	
 		       	},
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
	    	$("#addDialog").dialog("open");
	    });
	    //修改
	    $("#edit").click(function(){
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
            	var numbers = [];
            	$(selectRows).each(function(i, row){
            		numbers[i] = row.number;
            	});
            	var ids = [];
            	$(selectRows).each(function(i, row){
            		ids[i] = row.id;
            	});
            	$.messager.confirm("消息提醒", "将删除与学生相关的所有数据(包括成绩)，确认继续？", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "StudentServlet?method=DeleteStudent",
							data: {numbers: numbers, ids: ids},
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
	    
	  	//年级下拉框
	  	$("#gradeList").combobox({
	  		width: "150",
	  		height: "25",
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false, //可多选
	  		editable: false, //不可编辑
	  		method: "post",
	  		url: "GradeServlet?method=GradeList&t="+new Date().getTime(),
	  		onChange: function(newValue, oldValue){
	  			//加载该年级下的学生
	  			$('#dataList').datagrid("options").queryParams = {gradeid: newValue};
	  			$('#dataList').datagrid("reload");
	  			
	  			//加载该年级下的班级
	  			$("#clazzList").combobox("clear");
	  			$("#clazzList").combobox("options").queryParams = {gradeid: newValue};
	  			$("#clazzList").combobox("reload")
	  		}
	  	});
	  	//班级下拉框
	  	$("#clazzList").combobox({
	  		width: "150",
	  		height: "25",
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false, //可多选
	  		editable: false, //不可编辑
	  		method: "post",
	  		url: "ClazzServlet?method=ClazzList&t="+new Date().getTime(),
	  		onChange: function(newValue, oldValue){
	  			//加载班级下的学生
	  			$('#dataList').datagrid("options").queryParams = {clazzid: newValue};
	  			$('#dataList').datagrid("reload");
	  		}
	  	});
	  	
	  	//下拉框通用属性
	  	$("#add_gradeList, #edit_gradeList, #add_clazzList, #edit_clazzList").combobox({
	  		width: "200",
	  		height: "30",
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false, //可多选
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
				var data = $(this).combobox("getData");;
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	  	$("#edit_gradeList").combobox({
	  		url: "GradeServlet?method=GradeList&t="+new Date().getTime(),
	  		onChange: function(newValue, oldValue){
	  			//加载该年级下的班级
	  			$("#edit_clazzList").combobox("clear");
	  			$("#edit_clazzList").combobox("options").queryParams = {gradeid: newValue};
	  			$("#edit_clazzList").combobox("reload");
	  		},
			onLoadSuccess: function(){
				//默认选择第一条数据
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	  	$("#edit_clazzList").combobox({
	  		url: "ClazzServlet?method=ClazzList&t="+new Date().getTime(),
			onLoadSuccess: function(){
				//默认选择第一条数据
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	  	//设置添加学生窗口
	    $("#addDialog").dialog({
	    	title: "添加学生",
	    	width: 650,
	    	height: 460,
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
					iconCls:'icon-user_add',
					handler:function(){
						var validate = $("#addForm").form("validate");
						if(!validate){
							$.messager.alert("消息提醒","请检查你输入的数据!","warning");
							return;
						} else{
							var gradeid = $("#add_gradeList").combobox("getValue");
							var clazzid = $("#add_clazzList").combobox("getValue");
							$.ajax({
								type: "post",
								url: "StudentServlet?method=AddStudent",
								data: $("#addForm").serialize(),
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
										
										//重新刷新页面数据
										$('#dataList').datagrid("options").queryParams = {clazzid: clazzid};
							  			$('#dataList').datagrid("reload");
							  			$("#gradeList").combobox('setValue', gradeid);
							  			setTimeout(function(){
											$("#clazzList").combobox('setValue', clazzid);
										}, 100);
										
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
						//重新加载年级
						$("#add_gradeList").combobox("clear");
						$("#add_gradeList").combobox("reload");
					}
				},
			]
	    });
	  	
	  	//设置编辑学生窗口
	    $("#editDialog").dialog({
	    	title: "修改学生信息",
	    	width: 650,
	    	height: 460,
	    	iconCls: "icon-edit",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'提交',
					plain: true,
					iconCls:'icon-user_add',
					handler:function(){
						var validate = $("#editForm").form("validate");
						var gradeid = $("#edit_gradeList").combobox("getValue");
						var clazzid = $("#edit_clazzList").combobox("getValue");
						if(!validate){
							$.messager.alert("消息提醒","请检查你输入的数据!","warning");
							return;
						} else{
							$.ajax({
								type: "post",
								url: "StudentServlet?method=EditStudent&t="+new Date().getTime(),
								data: $("#editForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("消息提醒","更新成功!","info");
										//关闭窗口
										$("#editDialog").dialog("close");
										//刷新表格
										$('#dataList').datagrid("options").queryParams = {clazzid: clazzid};
										$("#dataList").datagrid("reload");
										$("#dataList").datagrid("uncheckAll");
										
										$("#gradeList").combobox('setValue', gradeid);
							  			setTimeout(function(){
											$("#clazzList").combobox('setValue', clazzid);
										}, 100);
							  			
									} else{
										$.messager.alert("消息提醒","更新失败!","warning");
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
						//清空表单
						$("#edit_name").textbox('setValue', "");
						$("#edit_sex").textbox('setValue', "男");
						$("#edit_phone").textbox('setValue', "");
						$("#edit_qq").textbox('setValue', "");
						$("#edit_gradeList").combobox("clear");
						$("#edit_gradeList").combobox("reload");
					}
				}
			],
			onBeforeOpen: function(){
				var selectRow = $("#dataList").datagrid("getSelected");
				//设置值
				$("#edit_number").textbox('setValue', selectRow.number);
				$("#edit_name").textbox('setValue', selectRow.name);
				$("#edit_sex").textbox('setValue', selectRow.sex);
				$("#edit_phone").textbox('setValue', selectRow.phone);
				$("#edit_qq").textbox('setValue', selectRow.qq);
				$("#edit_photo").attr("src", "PhotoServlet?method=GetPhoto&type=2&number="+selectRow.number);
				var gradeid = selectRow.gradeid;
				var clazzid = selectRow.clazzid;
				$("#edit_gradeList").combobox('setValue', gradeid);
				setTimeout(function(){
					$("#edit_clazzList").combobox('setValue', clazzid);
				}, 100);
				
			}
	    });
	   
	});
	</script>
</head>
<body>
	<!-- 学生列表 -->
	<table id="dataList" cellspacing="0" cellpadding="0"> 
	    
	</table> 
	<!-- 工具栏 -->
	<div id="toolbar">
		<div style="float: left;"><a id="add" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">添加</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="float: left;"><a id="edit" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">修改</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="float: left;"><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">删除</a></div>
		
		<div style="float: left; margin: 0 10px 0 10px">年级：<input id="gradeList" class="easyui-textbox" name="grade" /></div>
		<div style="margin-left: 10px;">班级：<input id="clazzList" class="easyui-textbox" name="clazz" /></div>
	
	</div>
	
	<!-- 添加学生窗口 -->
	<div id="addDialog" style="padding: 10px">  
		<div style="float: right; margin: 20px 20px 0 0; width: 200px; border: 1px solid #EBF3FF" id="photo">
	    	<img alt="照片" style="max-width: 200px; max-height: 400px;" title="照片" src="photo/student.jpg" />
	    </div> 
    	<form id="addForm" method="post">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td>学号:</td>
	    			<td>
	    				<input id="add_number"  class="easyui-textbox" style="width: 200px; height: 30px;" type="text" name="number" data-options="required:true, validType:'repeat', missingMessage:'请输入学号'" />
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>姓名:</td>
	    			<td><input id="add_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="required:true, missingMessage:'请填写姓名'" /></td>
	    		</tr>
	    		<tr>
	    			<td>性别:</td>
	    			<td><select id="add_sex" class="easyui-combobox" data-options="editable: false, panelHeight: 50, width: 60, height: 30" name="sex"><option value="男">男</option><option value="女">女</option></select></td>
	    		</tr>
	    		<tr>
	    			<td>电话:</td>
	    			<td><input id="add_phone" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="phone" validType="mobile" /></td>
	    		</tr>
	    		<tr>
	    			<td>QQ:</td>
	    			<td><input id="add_qq" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="qq" validType="number" /></td>
	    		</tr>
	    		<tr>
	    			<td>年级:</td>
	    			<td><input id="add_gradeList" style="width: 200px; height: 30px;" class="easyui-textbox" name="gradeid" /></td>
	    		</tr>
	    		<tr>
	    			<td>班级:</td>
	    			<td><input id="add_clazzList" style="width: 200px; height: 30px;" class="easyui-textbox" name="clazzid" /></td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
	<!-- 修改学生窗口 -->
	<div id="editDialog" style="padding: 10px">
		<div style="float: right; margin: 20px 20px 0 0; width: 200px; border: 1px solid #EBF3FF">
	    	<img id="edit_photo" alt="照片" style="max-width: 200px; max-height: 400px;" title="照片" src="" />
	    </div>   
    	<form id="editForm" method="post">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td>学号:</td>
	    			<td>
	    				<input id="edit_number" data-options="readonly: true" class="easyui-textbox" style="width: 200px; height: 30px;" type="text" name="number" data-options="required:true, validType:'repeat', missingMessage:'请输入学号'" />
	    			</td>
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
	    			<td><input id="edit_qq" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="qq" validType="number" /></td>
	    		</tr>
	    		<tr>
	    			<td>年级:</td>
	    			<td><input id="edit_gradeList" style="width: 200px; height: 30px;" class="easyui-textbox" name="gradeid" /></td>
	    		</tr>
	    		<tr>
	    			<td>班级:</td>
	    			<td><input id="edit_clazzList" style="width: 200px; height: 30px;" class="easyui-textbox" name="clazzid" /></td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
</body>
</html>