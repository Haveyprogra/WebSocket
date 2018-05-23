<%@ page language="java" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	String SERVER_PATH = request.getServerName() + ":"
			+ request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
<meta name="description" content="">
<meta name="author" content="">
<link rel="icon" href="../../favicon.ico">
<link rel="stylesheet" type="text/css" href="../resources/css/font_Icon/iconfont.css">
<link rel="stylesheet" type="text/css" href="../resources/css/chat.css">
<link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/images/favicon.ico">
<title>消息列表</title>
<!-- Bootstrap core CSS -->
<link href="//cdn.bootcss.com/bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet">
<script type="text/javascript">
	var isShine;
	var SERVER_PATH = '<%=SERVER_PATH%>';
	//alert(SERVER_PATH);
	var userId = Math.floor(Math.random() * 10000000000);

	/**用户上线*/
	function openOnline() {
		socket.send(_USER_ONLINE + _SEPARATOR + userId);
		//alert("用户上线");
	}
	/**用户上线*/
	function syspromptMsg(msg) {
		if(msg=="当前没有客服在线！"){
			alert(msg+'请稍后再联系客服');
			window.close();
		}
		$("#opposite").empty().append("对话已经建立完成，客服"+msg+"正在与您对话");
		//alert(msg2);
		$("#CustomerId").val(msg);
		
	}
	
	/**用户离线*/
	function closeOffline(evt) {
		socket.send(_USER_OFFLINE + _SEPARATOR + userId);
		alert("用户离线");
		window.close();
	}

	function customerOffLine(msg){
		alert("客服 "+msg+" 离线");
		window.close();
	}
	
	/**发送消息*/
	function sendMsg() {
		if ($("#chat-fasong").attr("type") == "0") {
			var msgText =$(".div-textarea").html().replace(/[\n\r]/g, '<br>');
			$(".div-textarea").val("");
			var CustomerId = $("#CustomerId").val();
				socket.send(_TEXT_MSG + _SEPARATOR + _TOSERVER + _SEPARATOR + userId + _SEPARATOR + msgText);
				
		} else {
			ajaxFileUploads();
		}
	}

	/**显示文本消息*/
	function showTextMsg(msg, userId) {
		$("#chatAudio").remove();
		$('<audio id="chatAudio">'
		+'<source src="${pageContext.request.contextPath }/resources/images/message.mp3" type="audio/mpeg">'
		+'</audio>').appendTo('body');//载入声音文件
		
		
		var html = '<a href="javascript:;" class="list-group-item text-left">';
		html += '<img width="40" src="${pageContext.request.contextPath }/resources/images/default-head.png" class="img-circle margin_right_10 img_width_40">';
		html += msg + '</a>';
		$("#chatDiv .list-group").append(html);
		$('#chatAudio')[0].play();
		isShine = true;
	}

	/**显示图片消息*/
	function showImgMsg(msg, userId) {
		var html = '<a href="javascript:;" class="list-group-item text-left">';
		html += '<img width="40" src="${pageContext.request.contextPath }/resources/images/default-head.png" class="img-circle margin_right_10 img_width_40">';
		html += '<img src="'+msg+'"/></a>';
		$("#chatDiv .list-group").append(html);
	}
</script>
<script type="text/javascript"
	src="${pageContext.request.contextPath }/resources/js/websocket/sockjs.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath }/resources/js/websocket/websocket.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath }/resources/js/jquery-1.8.2.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath }/resources/js/ajaxfileupload.js"></script>
<style type="text/css">
.margin_right_10 {
	margin-right: 10px;
}

.margin_left_10 {
	margin-left: 10px;
}

.img_width_40 {
	width: 40px;
}
#TheTextArea{
	width: 100%;
	height: 80px;
	display: flex;
}
.chatBox-send{
	    height: 150px;
}
.div-textarea{
	height: 80px;
	width: 90%;
	flex: 1;
	padding: 1%;
}
#functionalZone{
    width: 100%; 
    margin-bottom: 16px;
}
.biaoqing-photo{
	left: 6px;
}
.biaoqing-photo::before{
	right: 173px;
}
.biaoqing-photo::after{
	right: 173px;
}
#chatBox-content-demo{
	max-height: 352px;
}
</style>
</head>
<!-- //onbeforeunload="return '真的要关闭此窗口吗?'" -->
<body >
	<input id="CustomerId" type="hidden"></input>
	<div id="chatDiv">
		<a href="#" class="list-group-item active" id="opposite" style="text-align: center;"></a>
<!-- 		<div class="form-group navbar-fixed-bottom">
			<div class="panel panel-default" style="margin-bottom: 0px;">
				<input type="file" capture="camera" accept="image/*" id="file"
					name="file" onchange="changeFile();" style="display: none;" />
				<div class="panel-body" style="text-align: center;">
					<span class="glyphicon glyphicon-picture" aria-hidden="true"
						onclick="$('#file').click()"> </span>
				</div>
			</div>
			<div class="input-group">
				<input type="text" class="form-control" id="msgText"
					placeholder="输入消息">
				<div class="input-group-addon btn-info" onclick="sendMsg(this)"
					id="sendDiv" type="0">发送</div>
			</div>
		</div> -->
		
                <div class="chatBox-content">
                    <div class="chatBox-content-demo" id="chatBox-content-demo" >
                    </div>
                </div>           	
		        <div class="chatBox-send" style=" position: fixed; bottom: 0px; ">
                    <div id="functionalZone">
                        <button id="chat-biaoqing" class="btn-default-styles">
                            <i class="iconfont icon-biaoqing"></i>
                        </button>
                        <label id="chat-tuxiang" title="发送图片" for="inputImage" class="btn-default-styles">
                            <input type="file" onchange="selectImg(this)" accept="image/jpg,image/jpeg,image/png"
                                   name="file" id="inputImage" class="hidden"><input type="hidden" id="userId" />
                            <i class="iconfont icon-tuxiang"></i>
                        </label>
                    </div>
                    <div id="TheTextArea">
	                    <div class="div-textarea" contenteditable="true"></div>
	                    <button style=" width: 66px; " id="chat-fasong" class="btn-default-styles" onclick="sendMsg(this)"  type="0" ><div class="iconfont icon-fasong" ></div>
	                    </button>
                    </div>
                    <div class="biaoqing-photo">
                        <ul>
                            <li><span class="emoji-picker-image" style="background-position: -9px -18px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -40px -18px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -71px -18px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -102px -18px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -133px -18px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -164px -18px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -9px -52px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -40px -52px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -71px -52px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -102px -52px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -133px -52px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -164px -52px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -9px -86px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -40px -86px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -71px -86px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -102px -86px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -133px -86px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -164px -86px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -9px -120px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -40px -120px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -71px -120px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -102px -120px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -133px -120px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -164px -120px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -9px -154px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -40px -154px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -71px -154px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -102px -154px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -133px -154px;"></span></li>
                            <li><span class="emoji-picker-image" style="background-position: -164px -154px;"></span></li>
                        </ul>
                    </div>
                   
                </div>
	</div>
	<script type="text/javascript">
	$(window).resize(function(){//获取调整浏览器窗口大小事件 
    	var browserHeight = $(window).height(); //浏览器可视界面高度
        var headHeight = $('#opposite').outerHeight(true); //获取#opposite元素 的高度 
        var bottomHeight = $('.chatBox-send').outerHeight(true); //获取.chatBox-send元素 的高度 
        var contentHeight = browserHeight-headHeight-bottomHeight;// 计算 聊天内容区域最高高度
        $(".chatBox-content-demo").css("max-height",contentHeight+"px");//设置 聊天内容区域最高高度 
        //聊天框默认最底部
        $(document).ready(function () {
            $("#chatBox-content-demo").scrollTop($("#chatBox-content-demo")[0].scrollHeight);
        });        
	});	
	//发送信息
    $("#chat-fasong").click(function () {
        var textContent = $(".div-textarea").html().replace(/[\n\r]/g, '<br>')
        var myDate = new Date();
        var Month = myDate.getMonth()+1;
        if(Month<10){
        	Month = "0"+ Month;
        }
        var time = myDate.getFullYear()+'-'+ Month +'-'+ myDate.getDate()+' '+myDate.getHours()+':'+myDate.getMinutes() +':'+myDate.getSeconds();
        if (textContent != "") {
            $(".chatBox-content-demo").append("<div class=\"clearfloat\">" +
                "<div class=\"author-name\"><small class=\"chat-date\">"+time+"</small> </div> " +
                "<div class=\"right\"> <div class=\"chat-message\"> " + textContent + " </div> " +
                "<div class=\"chat-avatars\"><img src=\"../resources/images/icon01.png\" alt=\"头像\" /></div> </div> </div>");
            //发送后清空输入框
            $(".div-textarea").html("");
            //聊天框默认最底部
            $(document).ready(function () {
                $("#chatBox-content-demo").scrollTop($("#chatBox-content-demo")[0].scrollHeight);
            });
        }
    });
	
	//      发送表情
    $("#chat-biaoqing").click(function () {
        $(".biaoqing-photo").toggle();
    });
    $(document).click(function () {
        $(".biaoqing-photo").css("display", "none");
    });
    $("#chat-biaoqing").click(function (event) {
        event.stopPropagation();//阻止事件
    });

    $(".emoji-picker-image").each(function () {
        $(this).click(function () {
            var msgText = $(this).parent().html();
            $(".chatBox-content-demo").append("<div class=\"clearfloat\">" +
                "<div class=\"author-name\"><small class=\"chat-date\">2017-12-02 14:26:58</small> </div> " +
                "<div class=\"right\"> <div class=\"chat-message\"> " + msgText + " </div> " +
                "<div class=\"chat-avatars\"><img src=\"../resources/images/icon01.png\" alt=\"头像\" /></div> </div> </div>");
            //发送后关闭表情框
            $(".biaoqing-photo").toggle();
			var userId = $("#userId").val();
			socket.send(_TEXT_MSG + _SEPARATOR + _TOCLIENT + _SEPARATOR
					+ userId + _SEPARATOR + msgText);
            //聊天框默认最底部
            $(document).ready(function () {
                $("#chatBox-content-demo").scrollTop($("#chatBox-content-demo")[0].scrollHeight);
            });
        })
    });
	
	
	
/* 	$(document).ready(function() { 
		$(document).bind("keydown",function(e){ 
		e=window.event||e; 
		if(e.keyCode==116){ 
		e.keyCode = 0; 
		return false; 
		} 
		}); 
		}); 
	$(document).ready(function() { 
		$(document).bind("contextmenu",function(e) { 
		return false; 
		}); 
		});  */
	
	
	setInterval(function() {
	    var title = document.title;
	    if (isShine == true) {
	        if (/新/.test(title) == false) {
	            document.title = '【你有新消息】';    
	        } else {
	            document.title = '【　　　　　】';
	        }
	    } else {
	        document.title = '消息列表';
	    }
	}, 500);	
	//file值发生变化
		function changeFile() {
			var file_value = $("#file").val();
			if (file_value != null && file_value != undefined) {
				var index = file_value.lastIndexOf("\\");
				file_value = file_value.substring(index + 1, file_value.length);
				if (file_value.length > 20) {
					file_value = file_value.substring(0, 20) + "...";
				}
				$("#msgText").val(file_value);
				//type值为1 表示文本消息发送
				$("#sendDiv").attr("type", "1");
			}
		}

		/** 上传图片 */
		function ajaxFileUploads() {
			var file_value = $("#file").val();
			if (file_value == '' || file_value == null
					|| file_value == undefined) {
				alert("请先选择图片!");
				return;
			}
			var houzui = file_value.substring(file_value.lastIndexOf(".") + 1,
					file_value.length);
			if (houzui == '' || houzui == null || houzui == undefined) {
				alert("请选择正确图片格式!");
			}
			houzui = houzui.toLowerCase()
			if (houzui == 'jpg' || houzui == 'gif' || houzui == 'png'
					|| houzui == 'bmp' || houzui == 'swf') {
				//图片等待处理

				//上传图片
				$
						.ajaxFileUpload({
							url : '${pageContext.request.contextPath}/upload/uploadimg',
							secureuri : false,
							fileElementId : 'file',
							dataType : 'json',
							success : function(data, status) {
								if (data.result == "0") {
									var html = '<a href="javascript:;" class="list-group-item text-right"><img src="'+data.remoteurl+'">';
									html += '<img width="40" src="${pageContext.request.contextPath }/resources/images/default-head.png" class="img-circle margin_left_10 img_width_40">';
									html += '</a>';
									$("#chatDiv .list-group").append(html);
									socket.send(_IMG_MSG + _SEPARATOR + _TOSERVER + _SEPARATOR + userId
											+ _SEPARATOR + data.remoteurl);
								} else if (data.result == "1") {
									alert("请先选择图片！");
								} else {
									alert("上传出现异常！");
								}
							},
							error : function(data, status, e) { //相当于java中catch语句块的用法
								alert("发生异常,上传失败!");
								$("#10001").remove();
							}
						});
			} else {
				alert("图片格式不正确!当前只支持jpg/gif/png/bmp/swf格式.");
			}
		}
	</script>
</body>
</html>
