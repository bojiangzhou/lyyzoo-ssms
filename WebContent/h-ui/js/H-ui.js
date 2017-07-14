/*H-ui.js v2.3 date:9:53 2015-07-17 by:guojunhui*/
if (navigator.userAgent.match(/IEMobile\/10\.0/)) {
  var msViewportStyle = document.createElement("style")
  msViewportStyle.appendChild(
    document.createTextNode(
      "@-ms-viewport{width:auto!important}"
    )
  )
  document.getElementsByTagName("head")[0].appendChild(msViewportStyle);
}


/*添加收藏
<a title="收藏本站" href="javascript:;" onClick="addFavoritepage('H-ui前端框架','http://www.h-ui.net/');">收藏本站</a>
*/
/*收藏主站*/
function addFavorite(name,site){
	try{window.external.addFavorite(site,name);}
	catch(e){
		try{window.sidebar.addPanel(name,site,"");}
			catch(e){alert("加入收藏失败，请使用Ctrl+D进行添加");}
	}
}
/*收藏页面
<a title="收藏本页" href="javascript:addFavoritepage(0);">收藏本页</a>
*/
function addFavoritepage(){var sURL=window.location.href;var sTitle=document.title;try{window.external.addFavorite(sURL,sTitle);}catch(e){try{window.sidebar.addPanel(sTitle,sURL,"");}catch(e){alert("加入收藏失败，请使用Ctrl+D进行添加");}}}

/*设为首页*/
function setHome(obj){
  try{obj.style.behavior="url(#default#homepage)";obj.setHomePage(webSite);}
  catch(e){if(window.netscape){
	  try {netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");}
	  catch(e){alert("此操作被浏览器拒绝！\n请在浏览器地址栏输入\"about:config\"并回车\n然后将 [signed.applets.codebase_principal_support]的值设置为'true',双击即可。");}
	  var prefs = Components.classes['@mozilla.org/preferences-service;1'].getService(Components.interfaces.nsIPrefBranch);
	  prefs.setCharPref('browser.startup.homepage',url);}}
}
/*滚动*/
function marquee(height,speed,delay){
	var scrollT;
	var pause = false;
	var ScrollBox = document.getElementById("marquee");
	if(document.getElementById("holder").offsetHeight <= height) return;
	var _tmp = ScrollBox.innerHTML.replace('holder', 'holder2')
	ScrollBox.innerHTML += _tmp;
	ScrollBox.onmouseover = function(){pause = true}
	ScrollBox.onmouseout = function(){pause = false}
	ScrollBox.scrollTop = 0;
	function start(){
	    scrollT = setInterval(scrolling,speed);
	    if(!pause) ScrollBox.scrollTop += 2;
	}
	function scrolling(){
	    if(ScrollBox.scrollTop % height != 0){
	        ScrollBox.scrollTop += 2;
	        if(ScrollBox.scrollTop >= ScrollBox.scrollHeight/2) ScrollBox.scrollTop = 0;
	    }
		else{
	        clearInterval(scrollT);
	        setTimeout(start,delay);
	    }
	}
	setTimeout(start,delay);
}

/*隐藏显示密码*/
(function ( $ ) {
    $.fn.togglePassword = function( options ) {
        var s = $.extend( $.fn.togglePassword.defaults, options ),
        input = $( this );

        $( s.el ).on( s.ev, function() {
            "password" == $( input ).attr( "type" ) ?
                $( input ).attr( "type", "text" ) :
                $( input ).attr( "type", "password" );
        });
    };

    $.fn.togglePassword.defaults = {
        ev: "click"
    };
}( jQuery ));
!function ($) {
	"use strict";
	$(function () {
		$.support.transition = (function () {
			var transitionEnd = (function () {
				var el = document.createElement('bootstrap'),
				transEndEventNames = {
					'WebkitTransition' : 'webkitTransitionEnd',
					'MozTransition'    : 'transitionend',
					'OTransition'      : 'oTransitionEnd otransitionend',
					'transition'       : 'transitionend'
				},
				name
				for (name in transEndEventNames){
					if (el.style[name] !== undefined) {
						return transEndEventNames[name]
					}
				}
			}())
			return transitionEnd && {
				end: transitionEnd
			}
		})()
	});
}(window.jQuery);

/*左侧菜单-隐藏显示*/
function displaynavbar(obj){
	if($(obj).hasClass("open")){
		$(obj).removeClass("open");
		$("body").removeClass("big-page");
	}else{
		$(obj).addClass("open");
		$("body").addClass("big-page");
					
	}
}

/*模拟下拉菜单*/
jQuery.Huiselect = function(divselectid,inputselectid) {
	var inputselect = $(inputselectid);
	$(divselectid+" cite").click(function(){
		var ul = $(divselectid+" ul");
		ul.slideToggle();
	});
	$(divselectid+" ul li a").click(function(){
		var txt = $(this).text();
		$(divselectid+" cite").html(txt);
		var value = $(this).attr("selectid");
		inputselect.val(value);
		$(divselectid+" ul").hide();
	});
	$(document).click(function(){$(divselectid+" ul").hide();});
};

/*hover*/
jQuery.Huihover =function(obj) {
	$(obj).hover(function(){$(this).addClass("hover");},function(){$(this).removeClass("hover");});
};
/*得到失去焦点*/
jQuery.Huifocusblur = function(obj) {
	$(obj).focus(function() {$(this).addClass("focus").removeClass("inputError");});
	$(obj).blur(function() {$(this).removeClass("focus");});
};
/*tab选项卡*/
jQuery.Huitab =function(tabBar,tabCon,class_name,tabEvent,i){
  	var $tab_menu=$(tabBar);
	// 初始化操作
	$tab_menu.removeClass(class_name);
	$(tabBar).eq(i).addClass(class_name);
	$(tabCon).hide();
	$(tabCon).eq(i).show();
	
	$tab_menu.on(tabEvent,function(){
		$tab_menu.removeClass(class_name);
		$(this).addClass(class_name);
		var index=$tab_menu.index(this);
		$(tabCon).hide();
		$(tabCon).eq(index).show();
	});
}

/*折叠*/
jQuery.Huifold = function(obj,obj_c,speed,obj_type,Event){
	if(obj_type == 2){
		$(obj+":first").find("b").html("-");
		$(obj_c+":first").show();
	}			
	$(obj).on(Event,function(){
		if($(this).next().is(":visible")){
			if(obj_type == 2){
				return false;
			}else{
				$(this).next().slideUp(speed).end().removeClass("selected");
				if($(this).find("b")){
					$(this).find("b").html("+");
				}
			}
		}
		else{
			if(obj_type == 3){
				$(this).next().slideDown(speed).end().addClass("selected");
				if($(this).find("b")){
					$(this).find("b").html("-");
				}
			}else{
				$(obj_c).slideUp(speed);
				$(obj).removeClass("selected");
				if($(this).find("b")){
					$(obj).find("b").html("+");
				}
				$(this).next().slideDown(speed).end().addClass("selected");
				if($(this).find("b")){
					$(this).find("b").html("-");
				}
			}
		}
	});
}
/*返回顶部*/
var $backToTopEle=$('<a href="javascript:void(0)" class="Hui-iconfont toTop" title="返回顶部" alt="返回顶部" style="display:none">&#xf0023;</a>').appendTo($("body")).click(function(){
	$("html, body").animate({ scrollTop: 0 }, 120);
});
var $backToTopFun = function() {
	var st = $(document).scrollTop(), winh = $(window).height();
	(st > 0)? $backToTopEle.show(): $backToTopEle.hide();
	/*IE6下的定位*/
	if(!window.XMLHttpRequest){
		$backToTopEle.css("top", st + winh - 166);
	}
};
/*textarea 字数限制*/
function textarealength(obj,maxlength){
	var v = $(obj).val();
	var l = v.length;
	if( l > maxlength){
		v = v.substring(0,maxlength);
	}
	$(obj).parent().find(".textarea-length").text(v.length);
}
/*Huimodalalert*/
function Huimodal_alert(info,speed){
	$(document.body).append(
	'<div id="modal-alert" class="modal hide modal-alert">'+
	  '<div class="modal-alert-info">'+info+'</div>'+
	'</div>'
	);
	$("#modal-alert").fadeIn();
	
	setTimeout("Huimodal_alert_hide()",speed);
}
function Huimodal_alert_hide() {
	$("#modal-alert").fadeOut("normal",function(){
		$("#modal-alert").remove();
	});
}
/*设置cookie*/
function setCookie(name, value, Days){
	if(Days == null || Days == ''){
		Days = 300;
	}
	var exp  = new Date();
	exp.setTime(exp.getTime() + Days*24*60*60*1000);
	document.cookie = name + "="+ escape (value) + "; path=/;expires=" + exp.toGMTString();
}

/*获取cookie*/
function getCookie(name) {
    var arr,reg=new RegExp("(^| )"+name+"=([^;]*)(;|$)");
    if(arr=document.cookie.match(reg))
        return unescape(arr[2]); 
    else 
        return null; 
}
$(function(){
	/*****表单*****/
    $.Huifocusblur(".input-text,.textarea");
	/*按钮loading*/
	$('.btn-loading').click(function () {
		var $btn = $(this);
		var btnval = $btn.val();
		$btn.addClass("disabled").val("loading").attr("disabled","disabled");
		setTimeout(function(){
			$btn.removeClass("disabled").val(btnval).removeAttr("disabled");
		}, 3000);
	});	
	/**/
	$.Huiselect("#divselect","#inputselect");

	/*全选*/
	$("table thead th input:checkbox").on("click" , function(){
		$(this).closest("table").find("tr > td:first-child input:checkbox").prop("checked",$("table thead th input:checkbox").prop("checked"));
    });
	
    /*上传*/
    $(document).on("change",".input-file",function(){
		var uploadVal=$(this).val();
		$(this).parent().find(".upload-url").val(uploadVal).focus().blur();
	});
	
	/*下拉菜单*/
	$(document).on("mouseenter",".dropDown",function(){
		$(this).addClass("hover");
	});
	$(document).on("mouseleave",".dropDown",function(){
		$(this).removeClass("hover");
	});
	$(document).on("mouseenter",".dropDown_hover",function(){
		$(this).addClass("open");
	});
	$(document).on("mouseleave",".dropDown_hover",function(){
		$(this).removeClass("open");
	});
	$(document).on("click",".dropDown-menu li a",function(){
		$(".dropDown").removeClass('open');
	});
	$(document).on('click', function(event){
		var e_t = $(event.target).parents('.dropDown_click');
		if($(".dropDown_click").hasClass('open')){
			if(e_t.hasClass('open')){
				e_t.removeClass('open');
				return;
			}
			$(".dropDown_click").removeClass('open');
			e_t.toggleClass('open');
		}else{
			e_t.toggleClass('open');
		}
	});

	/*搜索框*/
	$.Huifocusblur('.searchTxt');
	$.Huihover('.ac_results li');
	$(".ac_results li").click(function (event){
		$(".searchTxt").addClass("focus").val($(this).find("p").text());
		$(".ac_results").hide();
		//$(".form-search").submit();/*提交表单*/
		b_onclick();/*临时测试*/
		return false;
	});
	$(".searchTxt").focus(function(){$(".ac_results").show();return false;});
	$(".ac_results").blur(function(){$(this).hide();});
	$("body").click(function(){$(".ac_results").hide();});
	$(".searchTxt").click(function(){$(".ac_results").show();return false;});
	function BindEnter(obj){
    	var searchBtn = $("#searchBtn");
    	if(obj.keyCode == 13){searchBtn.click();obj.returnValue = false;}
	}
	
	/*tag标签*/
	var tags_a = $(".tags a");
	tags_a.each(function(){
		var x = 9;
		var y = 0;
		var rand = parseInt(Math.random() * (x - y + 1) + y);
		$(this).addClass("tags"+rand);
	});
		
	/*对联广告*/
	var dual = $(".dual");
	var dual_close = $("a.dual_close");	
	var screen_w = screen.width;
	if(screen_w>1024){dual.show();}
	$(window).scroll(function(){
		var scrollTop = $(window).scrollTop();
		dual.stop().animate({top:scrollTop+260});
	});
	dual_close.click(function(){
		$(this).parent().hide();
		return false;
	});

	/*顶部展开定时自动关闭广告*/ 
	$("#banner").slideDown("slow");
	
	/*图片预览*/
	$("a.preview").hover(
		function(){
			$(this).addClass("active");
			$("#tooltip-preview").remove();
			var winW=$(window).width();
			var winW5=winW/2;
			this.myTitle = this.title;
			this.title = "";
			var midimg = $(this).attr('data-preview');
			if(midimg ==''){return false;}
			else{
				var imgT=$(this).parents(".imgItem").offset().top;
				var imgL=$(this).parents(".imgItem").offset().left;	
				var imgW=$(this).parents(".imgItem").width();
				var imgH=$(this).parents(".imgItem").height();
				var ww=(imgL+imgW/2);
				if(ww < winW5){
					var tooltipLeft=(imgW+imgL)+"px";	
				}
				else{
					var tooltipRight=(winW-imgL)+"px";
				}
				var tooltip_keleyi_com = "<div id='tooltip-preview' style='top:"+ imgT +"px;right:"+ tooltipRight +";left:"+ tooltipLeft +"'><span id='tooltip-keleyi-div' class='loading' style='width:50px; height:50px'></span></div>";
				$("body").append(tooltip_keleyi_com);
				var midimgW = $(this).attr('data-width');
				var midimgH = $(this).attr('data-height');
				var imgTitle = this.myTitle ? "<br />" + this.myTitle + " 产品预览图" : "";
				/*图片预加载*/
				var image = new Image();/*创建一个Image对象*/
				image.onload = function () {
					if($('a.preview.active').attr('data-preview') == midimg){
						var midingW2 = this.width;
						var midingH2 = this.height;
						$("#tooltip-keleyi-div").css({"width":midingW2+"px","height":midingH2+"px"});
						$('#tooltip-keleyi-div').append(this);	
					}
				};
				image.src = midimg;
			}
		},
		function(){
			$(this).removeClass("active");
			this.title = this.myTitle;
			$("#tooltip-preview").remove();
		}
	);
	
	/*Huialert*/
	$.Huihover('.Huialert i');
	$(".Huialert i").on("click",function(){
		var Huialert = $(this).parents(".Huialert");
		Huialert.fadeOut("normal",function(){
		  Huialert.remove();
		});
	});

	/*tag标签*/
	var time1;
	$(".Hui-tags-lable").show();
	$(".Hui-tags-input").val("");
	$(document).on("blur",".Hui-tags-input",function(){
		time1 = setTimeout(function(){
			$(this).parents(".Hui-tags").find(".Hui-tags-list").slideUp();
		}, 400);
	});
	$(document).on("focus",".Hui-tags-input",function(){
		clearTimeout(time1);
	});
	$(document).on("click",".Hui-tags-input",function(){
		$(this).find(".Hui-tags-input").focus();
		$(this).find(".Hui-tags-list").slideDown();
	});
	function gettagval(obj){
		var str ="";
		var token =$(obj).parents(".Hui-tags").find(".Hui-tags-token");
		//alert(token.length)
		if(token.length<1){
			$(obj).parents(".Hui-tags").find(".Hui-tags-val").val("");
			return false;
		}
		for(var i = 0;i< token.length;i++){
			str += token.eq(i).text() + ",";
			$(obj).parents(".Hui-tags").find(".Hui-tags-val").val(str);
		}
	}
	$(document).on("keydown",".Hui-tags-input",function(event){
		$(this).next().hide();
		var v = $(this).val().replace(/\s+/g, "");
		var reg=/^,|,$/gi;
		v=v.replace(reg,"");
		v=$.trim(v);
		var token =$(this).parents(".Hui-tags").find(".Hui-tags-token");
		if(v!=''){
			if(event.keyCode==13||event.keyCode==108||event.keyCode==32){
				$('<span class="Hui-tags-token">'+v+'</span>').insertBefore($(this).parents(".Hui-tags").find(".Hui-tags-iptwrap"));
				$(this).val("");
				gettagval(this);
			}
		}else{
			if(event.keyCode==8){
				if(token.length>=1){
					$(this).parents(".Hui-tags").find(".Hui-tags-token:last").remove();
					gettagval(this);
				}
				else{
					$(this).parents(".Hui-tags").find(".Hui-tags-lable").show();
					return false;
				}
				
			}
		}	
	});
	
	$(document).on("click",".Hui-tags-has span",function(){
		var taghasV = $(this).text();
		taghasV=taghasV.replace(/(^\s*)|(\s*$)/g,"");
		$('<span class="Hui-tags-token">'+taghasV+'</span>').insertBefore($(this).parents(".Hui-tags").find(".Hui-tags-iptwrap"));
		gettagval(this);
		$(this).parents(".Hui-tags").find(".Hui-tags-input").focus();
	});
	$(document).on("click",".Hui-tags-token",function(){
		var token =$(this).parents(".Hui-tags").find(".Hui-tags-token");
		var it = $(this).parents(".Hui-tags");
		$(this).remove();
		switch(token.length){
			case 1 : it.find(".Hui-tags-lable").show();
			break;
		}
		var str ="";
		var token =it.find(".Hui-tags-token");
		//alert(token.length)
		if(token.length<1){
			it.find(".Hui-tags-val").val("");
			return false;
		}
		for(var i = 0;i< token.length;i++){
			str += token.eq(i).text() + ",";
			it.find(".Hui-tags-val").val(str);
		}		
	});
});

function displayimg(){
	$("#banner").slideUp(1000,function(){
		$("#top").slideDown(1000);
	});
}
setTimeout("displayimg()",4000);
/*placeholder兼容性处理*/
(function(window, document, $) {
	var isInputSupported = 'placeholder' in document.createElement('input');
	var isTextareaSupported = 'placeholder' in document.createElement('textarea');
	var prototype = $.fn;
	var valHooks = $.valHooks;
	var propHooks = $.propHooks;
	var hooks;
	var placeholder;

	if (isInputSupported && isTextareaSupported) {
		placeholder = prototype.placeholder = function() {
			return this;
		};
		placeholder.input = placeholder.textarea = true;
	} else {
		placeholder = prototype.placeholder = function() {
			var $this = this;
			$this
				.filter((isInputSupported ? 'textarea' : ':input') + '[placeholder]')
				.not('.placeholder')
				.bind({
					'focus.placeholder': clearPlaceholder,
					'blur.placeholder': setPlaceholder
				})
				.data('placeholder-enabled', true)
				.trigger('blur.placeholder');
			return $this;
		};
		placeholder.input = isInputSupported;
		placeholder.textarea = isTextareaSupported;
		hooks = {
			'get': function(element) {
				var $element = $(element);
				var $passwordInput = $element.data('placeholder-password');
				if ($passwordInput) {
					return $passwordInput[0].value;
				}
				return $element.data('placeholder-enabled') && $element.hasClass('placeholder') ? '' : element.value;
			},
			'set': function(element, value) {
				var $element = $(element);
				var $passwordInput = $element.data('placeholder-password');
				if ($passwordInput) {
					return $passwordInput[0].value = value;
				}
				if (!$element.data('placeholder-enabled')) {
					return element.value = value;
				}
				if (value == '') {
					element.value = value;
					if (element != safeActiveElement()) {
						setPlaceholder.call(element);
					}
				} else if ($element.hasClass('placeholder')) {
					clearPlaceholder.call(element, true, value) || (element.value = value);
				} else {
					element.value = value;
				}
				return $element;
			}
		};

		if (!isInputSupported) {
			valHooks.input = hooks;
			propHooks.value = hooks;
		}
		if (!isTextareaSupported) {
			valHooks.textarea = hooks;
			propHooks.value = hooks;
		}

		$(function() {
			$(document).delegate('form', 'submit.placeholder', function() {
				var $inputs = $('.placeholder', this).each(clearPlaceholder);
				setTimeout(function() {
					$inputs.each(setPlaceholder);
				}, 10);
			});
		});

		$(window).bind('beforeunload.placeholder', function() {
			$('.placeholder').each(function() {
				this.value = '';
			});
		});
	}

	function args(elem) {
		var newAttrs = {};
		var rinlinejQuery = /^jQuery\d+$/;
		$.each(elem.attributes, function(i, attr) {
			if (attr.specified && !rinlinejQuery.test(attr.name)) {
				newAttrs[attr.name] = attr.value;
			}
		});
		return newAttrs;
	}

	function clearPlaceholder(event, value) {
		var input = this;
		var $input = $(input);
		if (input.value == $input.attr('placeholder') && $input.hasClass('placeholder')) {
			if ($input.data('placeholder-password')) {
				$input = $input.hide().next().show().attr('id', $input.removeAttr('id').data('placeholder-id'));
				if (event === true) {
					return $input[0].value = value;
				}
				$input.focus();
			} else {
				input.value = '';
				$input.removeClass('placeholder');
				input == safeActiveElement() && input.select();
			}
		}
	}

	function setPlaceholder() {
		var $replacement;
		var input = this;
		var $input = $(input);
		var id = this.id;
		if (input.value == '') {
			if (input.type == 'password') {
				if (!$input.data('placeholder-textinput')) {
					try {
						$replacement = $input.clone().prop('type','text');
					} catch(e) {
						$replacement = $('<input>').prop($.extend(args(this), { 'type': 'text' }));
					}
					$replacement
						.removeAttr('name')
						.data({
							'placeholder-password': $input,
							'placeholder-id': id
						})
						.bind('focus.placeholder', clearPlaceholder);
					$input
						.data({
							'placeholder-textinput': $replacement,
							'placeholder-id': id
						})
						.before($replacement);
				}
				$input = $input.removeAttr('id').hide().prev().attr('id', id).show();
			}
			$input.addClass('placeholder');
			$input[0].value = $input.attr('placeholder');
		} else {
			$input.removeClass('placeholder');
		}
	}
	function safeActiveElement() {
		try {
			return document.activeElement;
		} catch (exception) {}
	}
}(this, document, jQuery));