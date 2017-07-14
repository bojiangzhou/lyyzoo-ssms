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
	        url:"StudentServlet?method=StudentClazzList&t="+new Date().getTime(),
	        idField:'id', 
	        singleSelect: true,//是否单选 
	        pagination: true,//分页控件 
	        rownumbers: true,//行号 
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
	 		toolbar: [
	        	{
	        		text: '查看',
	        		iconCls: 'icon-zoom-in',
	        		handler: function(){
	        			var selectRow = $("#dataList").datagrid("getSelected");
	                	if(selectRow == null){
	                    	$.messager.alert("消息提醒", "请选择一个学生", "warning");
	                    } else{
		        			$("#editDialog").dialog("open");
	                    }
	        		}
	        	}          
	        ]
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
	    
	  	
	  	
	  	//设置显示学生窗口
	    $("#editDialog").dialog({
	    	title: "学生信息",
	    	width: 650,
	    	height: 460,
	    	iconCls: "icon-man",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
			onBeforeOpen: function(){
				var selectRow = $("#dataList").datagrid("getSelected");
				//设置值
				$("#edit_number").textbox('setValue', selectRow.number);
				$("#edit_name").textbox('setValue', selectRow.name);
				$("#edit_sex").textbox('setValue', selectRow.sex);
				$("#edit_phone").textbox('setValue', selectRow.phone);
				$("#edit_qq").textbox('setValue', selectRow.qq);
				$("#edit_grade").textbox('setValue', selectRow.grade.name);
				$("#edit_clazz").textbox('setValue', selectRow.clazz.name);
				$("#edit_photo").attr("src", "PhotoServlet?method=GetPhoto&type=2&number="+selectRow.number);
			}
	    });
	   
	});
	</script>
</head>
<body>
	<!-- 学生列表 -->
	<table id="dataList" cellspacing="0" cellpadding="0"> 
	    
	</table> 
	
	<!-- 显示学生信息窗口 -->
	<div id="editDialog" style="padding: 10px">
		<div style="float: right; margin: 20px 20px 0 0; width: 200px; border: 1px solid #EBF3FF">
	    	<img id="edit_photo" alt="照片" style="max-width: 200px; max-height: 400px;" title="照片" src=""/>
	    </div>   
    	<form id="editForm" method="post">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td>学号:</td>
	    			<td>
	    				<input id="edit_number" data-options="readonly: true" class="easyui-textbox" style="width: 200px; height: 30px;" type="text" name="number" data-options="readonly:true" />
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>姓名:</td>
	    			<td><input id="edit_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="readonly:true" /></td>
	    		</tr>
	    		<tr>
	    			<td>性别:</td>
	    			<td><select id="edit_sex" class="easyui-combobox" data-options="editable: false, readonly:true, panelHeight: 50, width: 60, height: 30" name="sex"><option value="男">男</option><option value="女">女</option></select></td>
	    		</tr>
	    		<tr>
	    			<td>电话:</td>
	    			<td><input id="edit_phone" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="phone" data-options="readonly:true" /></td>
	    		</tr>
	    		<tr>
	    			<td>QQ:</td>
	    			<td><input id="edit_qq" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="qq" data-options="readonly:true" /></td>
	    		</tr>
	    		<tr>
	    			<td>年级:</td>
	    			<td><input id="edit_grade" style="width: 200px; height: 30px;" class="easyui-textbox" data-options="readonly:true" name="gradeid" /></td>
	    		</tr>
	    		<tr>
	    			<td>班级:</td>
	    			<td><input id="edit_clazz" style="width: 200px; height: 30px;" class="easyui-textbox" data-options="readonly:true" name="clazzid" /></td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
</body>
</html>