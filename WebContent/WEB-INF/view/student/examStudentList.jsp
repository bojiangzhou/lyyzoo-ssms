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
	        url:"ExamServlet?method=StudentExamList&t="+new Date().getTime(),
	        idField:'id', 
	        singleSelect: true,//是否单选 
	        pagination: false,//分页控件 
	        rownumbers: true,//行号 
	        remoteSort: false,
	        columns: [[  
				{field:'chk',checkbox: true,width:50},
 		        {field:'name',title:'考试名称',width:200},    
 		        {field:'etime',title:'考试时间',width:150, sortable: true},
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
	 		toolbar: [
	        	{
	        		text: '查看成绩',
	        		iconCls: 'icon-zoom-in',
	        		handler: function(){
	                	var exam = $("#dataList").datagrid("getSelected");
	        	    	
	                	if(exam == null){
	                    	$.messager.alert("消息提醒", "请选择考试查看!", "warning");
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
	        			                
	        			                columns.push(column);
	        			            }); 
	        			            
	        			            if(exam.type == 1){
	        			            	columns.push({field:'total',title:'总分',width:70, sortable: true});
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
	                	
	                	
	                	$("#escoreDialog").dialog("open");
	        		}
	        	}          
	        ]
	    }); 
	  	
	  	//考试成绩窗口
	    $("#escoreDialog").dialog({
	    	title: "考试成绩",
	    	width: 900,
	    	height: 550,
	    	iconCls: "icon-chart_bar",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    });
	  	
	  	//成绩列表
	    $("#escoreList").datagrid({ 
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
   				{field:'number',title:'学号',width:120,resizable: false,sortable: false},    
   				{field:'name',title:'姓名',width:120,resizable: false}	,        
   	        ]],
   	    });
	  	
	});
	</script>
</head>
<body>
	<!-- 数据列表 -->
	<table id="dataList" cellspacing="0" cellpadding="0"> 
	    
	</table> 
	
	<!-- 考试成绩表 -->
	<div id="escoreDialog">
		<table id="escoreList" cellspacing="0" cellpadding="0"> 
	    
		</table> 
	</div>
	
</body>
</html>