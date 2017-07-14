<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>个人信息</title>
	<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="easyui/css/demo.css">
	
	<style type="text/css">
		.table th{font-weight:bold}
		.table th,.table td{padding:8px;line-height:20px}
		.table td{text-align:left}
		.table-border{border-top:1px solid #ddd}
		.table-border th,.table-border td{border-bottom:1px solid #ddd}
		.table-bordered{border:1px solid #ddd;border-collapse:separate;*border-collapse:collapse;border-left:0}
		.table-bordered th,.table-bordered td{border-left:1px solid #ddd}
		.table-border.table-bordered{border-bottom:0}
		.table-striped tbody > tr:nth-child(odd) > td,.table-striped tbody > tr:nth-child(odd) > th{background-color:#f9f9f9}
	</style>
	
	<script type="text/javascript" src="easyui/jquery.min.js"></script>
	<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="easyui/js/validateExtends.js"></script>
	<script type="text/javascript">
	$(function() {	
		
		//修改密码窗口
	    $("#passwordDialog").dialog({
	    	title: "修改密码",
	    	width: 500,
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
	  					text:'提交',
	  					iconCls:'icon-user_add',
	  					handler:function(){
	  						var validate = $("#editPassword").form("validate");
	  						if(!validate){
	  							$.messager.alert("消息提醒","请检查你输入的数据!","warning");
	  							return;
	  						} else{
	  							$.ajax({
	  								type: "post",
	  								url: "SystemServlet?method=EditPasswod&t="+new Date().getTime(),
	  								data: $("#editPassword").serialize(),
	  								success: function(msg){
	  									if(msg == "success"){
	  										$.messager.alert("消息提醒","修改成功，将重新登录","info")
	  										setTimeout(function(){
	  											top.location.href = "SystemServlet?method=LoginOut";
	  										}, 1000);
	  									}
	  								}
	  							});
	  						}
	  					}
	  				},
	  				{
	  					text:'重置',
	  					iconCls:'icon-reload',
	  					handler:function(){
	  						//清空表单
	  						$("#old_password").textbox('setValue', "");
	  						$("#new_password").textbox('setValue', "");
	  						$("#re_password").textbox('setValue', "");
	  					}
	  				}
	  			],
	    })
		
		//设置编辑学生窗口
	    $("#editDialog").dialog({
	    	title: "修改密码",
	    	width: 500,
	    	height: 400,
	    	fit: true,
	    	modal: false,
	    	noheader: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: false,
	    	toolbar: [
				{
					text:'重置',
					plain: true,
					iconCls:'icon-reload',
					handler:function(){
						//清空表单
						$("#school_name").textbox('setValue', "");
						$("#forbid_teacher").removeAttr("checked");
						$("#forbid_student").removeAttr("checked");
						$("#notice_teacher").textbox('setValue', "");
						$("#notice_student").textbox('setValue', "");
					}
				},'-',
				{
					text:'修改密码',
					plain: true,
					iconCls:'icon-password',
					handler:function(){
						$("#passwordDialog").dialog("open");
					}
				}
			],
			
	    });
		
		//修改
		$("#systemTable a").each(function(){
			$(this).click(function(){
				var input = $(this).parents("tr").find("input");
				var inputName = $(input).attr("name");
				var name = "";
				var value = "";
				if(inputName == "forbidTeacher" || inputName == "forbidStudent"){
					name = inputName;
					if($(input).attr("checked")){
						value = 1;
					} else{
						value = 0;
					}
				} else{
					var name = $(input).attr("textboxname");
					var value = $(input).textbox("getValue");
				}
				
				//保存
				var data = {'name': name, 'value': value};
				$.ajax({
					type: "post",
					url: "SystemServlet?method=EditSystemInfo&t="+new Date().getTime(),
					data: data,
					success: function(msg){
						if(msg == "success"){
							$.messager.alert("消息提醒","保存成功","info");
						}
					}
				});
			});
		});
		
		
	})
	</script>
</head>
<body>
	
	<div id="editDialog" style="padding: 20px;">
		<div style="width: 650px">
    	<table id="systemTable" class="table table-border table-bordered table-striped" style="width: 650px" cellpadding="8" >
    		<tr>
    			<td width="200">学校名称:</td>
    			<td width="350">
    				<input id="school_name" value="${systemInfo.schoolName}" class="easyui-textbox" style="width: 300px; height: 30px;" type="text" name="schoolName" />
    			</td>
    			<td width="100"><a data-options="iconCls:'icon-save'" class="easyui-linkbutton">保存</a></td>
    		</tr>
    		<tr>
    			<td>禁止教师<br/>登录系统 </td>
    			<td><input id="forbid_teacher" ${systemInfo.forbidTeacher == 1 ? 'checked' : ''} type="checkbox" name="forbidTeacher" /></td>
    			<td><a data-options="iconCls:'icon-save'" class="easyui-linkbutton">保存</a></td>
    		</tr>
    		<tr>
    			<td>禁止学生<br/>登录系统 </td>
    			<td><input id="forbid_student" ${systemInfo.forbidStudent == 1 ? 'checked' : ''} type="checkbox" name="forbidStudent" /></td>
    			<td><a data-options="iconCls:'icon-save'" class="easyui-linkbutton">保存</a></td>
    		</tr>
    		<tr>
    			<td>教师通知:</td>
    			<td><input id="notice_teacher"  value="${systemInfo.noticeTeacher}" style="width: 300px; height: 70px;" data-options="multiline: true" class="easyui-textbox" type="text" name="noticeTeacher" /></td>
    			<td><a data-options="iconCls:'icon-save'" class="easyui-linkbutton">保存</a></td>
    		</tr>
    		<tr>
    			<td>学生通知:</td>
    			<td><input id="notice_student"  value="${systemInfo.noticeStudent}" style="width: 300px; height: 70px;" data-options="multiline: true" class="easyui-textbox" type="text" name="noticeStudent" /></td>
    			<td><a data-options="iconCls:'icon-save'" class="easyui-linkbutton">保存</a></td>
    		</tr>
    	</table>
    	</div>
	</div>
	
	<!-- 修改密码窗口 -->
	<div id="passwordDialog" style="padding: 20px">
    	<form id="editPassword">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td>原密码:</td>
	    			<td>
	    				<input id="old_password" style ="width: 200px; height: 30px;" class="easyui-textbox" type="password" validType="oldPassword[${user.password}]"  data-options="required:true, missingMessage:'请输入原密码'" />
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>新密码:</td>
	    			<td>
	    				<input  type="hidden" name="account" value="${user.account }" />
	    				<input id="new_password" style="width: 200px; height: 30px;" class="easyui-textbox" type="password" validType="password" name="password" data-options="required:true, missingMessage:'请输入新密码'" />
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>新密码:</td>
	    			<td><input id="re_password" style="width: 200px; height: 30px;" class="easyui-textbox" type="password" validType="equals['#new_password']"  data-options="required:true, missingMessage:'再次输入密码'" /></td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
</body>
</html>