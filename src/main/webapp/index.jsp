<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>中业网校首页|--</title>
<link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/images/favicon.ico">
<style type="text/css">

.button{
	background-color: #03A9F4;
    display: block;
    width: 150px;
    text-align: center;
    color: white;
    height: 40px;
    line-height: 2.2;
    margin: 0 auto;
    border-radius: 6px;
    cursor: pointer;
    margin-top: 10%;
}
.button:hover{
	background-color: #2196F3;
}
</style>

</head>

<body>
<div class="button">点击我进行聊天</div>
</body>
<script type="text/javascript"src="${pageContext.request.contextPath }/resources/js/jquery-1.8.2.js"></script>
<script type="text/javascript">
$(".button").click(function () {
	window.open('http://192.168.0.102:8080/websocket/chat/client', '_blank', 'left=200,top=200,height=544, width=644,toolbar=no,scrollbars=no,menubar=no,status=no,location=no,resizable=no');
});

</script>
</html>