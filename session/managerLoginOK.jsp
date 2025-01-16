<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<title>Puresh Manager</title>
	<!-- 웹폰트 연결 (앨리스 디지털 배움체) -->
	<link href="https://font.elice.io/css?family=Elice+Digital+Baeum" rel="stylesheet">
	<!-- jQuery 라이브러리 연결 -->
	<script src="https://code.jquery.com/jquery-3.6.3.js"></script>
	<script src="css/jQuery.js"></script>
	<!-- 외부CSS 파일 연결 -->
	<link rel="stylesheet" type="text/css" href="css/main.css?after">
	<link rel="stylesheet" type="text/css" href="css/manager.css?after">
</head>
<body>
 <!-- jsp -->
 <%
	request.setCharacterEncoding("UTF-8");
	
	// DB 연결
	String DB_URL = "jdbc:mysql://localhost:3306/pureshDB";
	String DB_ID = "pureshManager";
	String DB_PASSWORD = "1234";
	Class.forName("org.gjt.mm.mysql.Driver");
	Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

	// login.jsp 에서 넘겨받은 값
	String id = request.getParameter("id");
	String password = request.getParameter("password");

	int errorCode = 0;

	String checkManager = "SELECT * FROM V_pureshManager";
	PreparedStatement pstmt = con.prepareStatement(checkManager);
	ResultSet rs = pstmt.executeQuery();

	if(rs.next()){
		if(id.equals(rs.getString("userID"))) {
			if(password.equals(rs.getString("userPassword")) {
				session.setAttribute("managerSID", id);
				session.setMaxInactiveInterval(600);
			}
			else {
				errorCode = 1;
			}
		}
		else {
			errorCode = 1;
		}
	}
%>

<script>
	$(document).ready(function(){
		var message = "<%=errorCode%>";
		switch (message) {
			case '1':
				alert("아이디 또는 비밀번호가 일치하지 않습니다.");
				history.back();
				break;
			default:
				location.href = "../pureshManager.jsp"
				break;
		}
	});
</script>

<%
	rs.close();
	pstmt.close();
	con.close();
%>
</body>
</html>