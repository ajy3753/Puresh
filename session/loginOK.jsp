<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<title>Puresh</title>
	<!-- 웹폰트 연결 (앨리스 디지털 배움체) -->
	<link href="https://font.elice.io/css?family=Elice+Digital+Baeum" rel="stylesheet">
	<!-- jQuery 라이브러리 연결 -->
	<script src="https://code.jquery.com/jquery-3.6.3.js"></script>
	<script src="css/jQuery.js"></script>
	<!-- 외부CSS 파일 연결 -->
	<link rel="stylesheet" type="text/css" href="../css/main.css?after">
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
	String url = request.getParameter("url");
	int errorCode = 0;

	String searchUser = "SELECT * FROM userTBL WHERE userID = ?";
	PreparedStatement pstmt = con.prepareStatement(searchUser);
	pstmt.setString(1, id);
	ResultSet rs = pstmt.executeQuery();

	if(rs.next()){
		if(password.equals(rs.getString("userPassword"))) {
			session.setAttribute("sid", id);
			session.setMaxInactiveInterval(60*60);
		}
		else {
			errorCode = 2;
		}
	}
	else {
		errorCode = 1;
	}
%>
<script>
	$(document).ready(function(){
		var message = "<%=errorCode%>";
		switch (message) {
			case '1':
				alert("존재하지 않는 아이디입니다.")
				history.back();
				break;
			case '2':
				alert("아이디 또는 비밀번호가 일치하지 않습니다.");
				history.back();
				break;
			default:
				location.href = "<%=url%>"
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