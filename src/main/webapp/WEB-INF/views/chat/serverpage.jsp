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
<title>好友列表</title>

<!-- Bootstrap core CSS -->
<link href="//cdn.bootcss.com/bootstrap/3.3.5/css/bootstrap.min.css"
	rel="stylesheet">
<script type="text/javascript">
	var SERVER_PATH = '<%=SERVER_PATH%>';
	var customerId = "cus"+Math.floor(Math.random() * 1000);
	

	/**客服上线*/
	function openOnline() {
		socket.send(_CUSTOMER_ONLINE + _SEPARATOR + customerId);
		//alert("客服上线");
		$("#state").empty().append("客服已上线");
	}

	/**客服离线*/
	function closeOffline(evt) {
		//alert("客服离线");
		$("#state").empty().append("客服已下线");
	}

	/**用户上线*/
	function userOnline(userId) {
		var html ='<div class="chat-list-people" id="'+userId+'">'
	                 +'<div><img src="${pageContext.request.contextPath }/resources/images/icon01.png" alt="头像"/></div>'
	                 +'<div class="chat-name">'
	                    +'<p>用户:'+userId+'</p>'
	                 +'</div>'
	              +'</div>'
		$(".chatBox-info .chatBox-list").append(html);
	    $(".chat-list-people").each(function () {
	        $(this).click(function () {
	            var n = $(this).index();
	            $(".chatBox-head-one").toggle();
	            $(".chatBox-head-two").toggle();
	            $(".chatBox-list").fadeToggle();
	            $(".chatBox-kuang").fadeToggle();
	            $("#userId").val(userId);

	            //传名字
	            $(".ChatInfoName").text($(this).children(".chat-name").children("p").eq(0).html());

	            //传头像
	            $(".ChatInfoHead>img").attr("src", $(this).children().eq(0).children("img").attr("src"));

	            //聊天框默认最底部
	            $(document).ready(function () {
	                $("#chatBox-content-demo").scrollTop($("#chatBox-content-demo")[0].scrollHeight);
	            });
	        })
	    });	
	}
	/**发送消息*/
	function sendMsg() {
		if ($("#chat-fasong").attr("type") == "0") {
			var msgText =$(".div-textarea").html().replace(/[\n\r]/g, '<br>');
			$(".div-textarea").val("");
			var userId = $("#userId").val();
				socket.send(_TEXT_MSG + _SEPARATOR + _TOCLIENT + _SEPARATOR
						+ userId + _SEPARATOR + msgText);
		} else {
			ajaxFileUploads();
		}
	}

	/**显示文本消息*/
	function showTextMsg(msg, userId) {
        var myDate = new Date();
        var Month = myDate.getMonth()+1;
        if(Month<10){
        	Month = "0"+ Month;
        }
        var time = myDate.getFullYear()+'-'+ Month +'-'+ myDate.getDate()+' '+myDate.getHours()+':'+myDate.getMinutes() +':'+myDate.getSeconds();
		var html = '<div class="clearfloat">'
	                   +'<div class="author-name">'
	                      +' <small class="chat-date">'+time+'</small>'
	                   +' </div>'
	                   +'<div class="left">'
	                      +'<div class="chat-avatars"><img src="../resources/images/icon01.png" alt="头像"/></div>'
	                      +'<div class="chat-message">'
	                         +msg
	                      +'</div>'
	                   +'</div>'
	                +'</div>';
        $(".chatBox-content-demo").append(html);
        $(document).ready(function () {
            $("#chatBox-content-demo").scrollTop($("#chatBox-content-demo")[0].scrollHeight);
        });
	}
	
	/**显示图片消息*/
	function showImgMsg(msg,userId){
		var html = '<a href="javascript:;" class="list-group-item text-left">';
		html+='<img width="40" src="${pageContext.request.contextPath }/resources/images/icon01.png" class="img-circle margin_right_10 img_width_40">';
		html+='<img src="'+msg+'"/></a>';
		$("#chatDiv .list-group").append(html);
        //聊天框默认最底部

	}

	/**用户掉线*/
	function userOffLine(userId) {
		$("#" + userId).remove();
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

</head>

<body>
	<div class="chatContainer">
    <div class="chatBtn">
        <i class="iconfont icon-xiaoxi1"></i>
    </div>
    <div class="chat-message-num"></div>
    <div class="chatBox" ref="chatBox">
        <div class="chatBox-head">
            <div class="chatBox-head-one">
                <span id="serviceName">Conversations</span>
                <div class="chat-close" style="margin: 10px 10px 0 0;font-size: 14px">关闭</div>
            </div>
            <div class="chatBox-head-two">
                <div class="chat-return">返回</div>
                <div class="chat-people">
                    <div class="ChatInfoHead">
                        <img src="" alt="头像"/>
                    </div>
                    <div class="ChatInfoName"></div>
                </div>
                <div class="chat-close">关闭</div>
            </div>
        </div>
        <div class="chatBox-info">
            <div class="chatBox-list" ref="chatBoxlist">
            </div>
            <div class="chatBox-kuang" ref="chatBoxkuang">
                <div class="chatBox-content">
                    <div class="chatBox-content-demo" id="chatBox-content-demo">
                    </div>
                </div>
                <div class="chatBox-send">
                    <div class="div-textarea" contenteditable="true"></div>
                    <div>
                        <button id="chat-biaoqing" class="btn-default-styles">
                            <i class="iconfont icon-biaoqing"></i>
                        </button>
                        <label id="chat-tuxiang" title="发送图片" for="inputImage" class="btn-default-styles">
                            <input type="file" onchange="selectImg(this)" accept="image/jpg,image/jpeg,image/png"
                                   name="file" id="inputImage" class="hidden"><input type="hidden" id="userId" />
                            <i class="iconfont icon-tuxiang"></i>
                        </label>
                        <button id="chat-fasong" class="btn-default-styles" onclick="sendMsg(this)"  type="0" ><div class="iconfont icon-fasong" ></div>
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
        </div>
    </div>
</div>
<script type="text/javascript">
screenFuc();
function screenFuc() {
    var topHeight = $(".chatBox-head").innerHeight();//聊天头部高度
    //屏幕小于768px时候,布局change
    var winWidth = $(window).innerWidth();
    if (winWidth <= 768) {
        var totalHeight = $(window).height(); //页面整体高度
        $(".chatBox-info").css("height", totalHeight - topHeight);
        var infoHeight = $(".chatBox-info").innerHeight();//聊天头部以下高度
        //中间内容高度
        $(".chatBox-content").css("height", infoHeight - 46);
        $(".chatBox-content-demo").css("height", infoHeight - 46);

        $(".chatBox-list").css("height", totalHeight - topHeight);
        $(".chatBox-kuang").css("height", totalHeight - topHeight);
        $(".div-textarea").css("width", winWidth - 106);
    } else {
        $(".chatBox-info").css("height", 495);
        $(".chatBox-content").css("height", 448);
        $(".chatBox-content-demo").css("height", 448);
        $(".chatBox-list").css("height", 495);
        $(".chatBox-kuang").css("height", 495);
        $(".div-textarea").css("width", 260);
    }
}
(window.onresize = function () {
    screenFuc();
})();




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
	
	
	$("#serviceName").empty().append(customerId);
    //未读信息数量为空时
    var totalNum = $(".chat-message-num").html();
    if (totalNum == "" || totalNum ==0) {
        $(".chat-message-num").css("padding", 0);
    }
    $(".message-num").each(function () {
        var wdNum = $(this).html();
        if (wdNum == "") {
            $(this).css("padding", 0);
        }
    });
    
    //返回列表
    $(".chat-return").click(function () {
        $(".chatBox-head-one").toggle(1);
        $(".chatBox-head-two").toggle(1);
        $(".chatBox-list").fadeToggle(1);
        $(".chatBox-kuang").fadeToggle(1);
    });
    
    //打开/关闭聊天框
    $(".chatBtn").click(function () {
        $(".chatBox").toggle(20);
    })
    $(".chat-close").click(function () {
        $(".chatBox").toggle(20);
    })
	
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
									var userId = $("#userId").val();
									var html = '<a href="javascript:;" class="list-group-item text-right"><img src="'+data.remoteurl+'">';
									html += '<img width="40" src="${pageContext.request.contextPath }/resources/images/icon01.png" class="img-circle margin_left_10 img_width_40">';
									html += '</a>';
									$("#chatDiv .list-group").append(html);
									socket.send(_IMG_MSG + _SEPARATOR
											+ _TOCLIENT + _SEPARATOR + userId
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
