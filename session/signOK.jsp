<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
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

	// sign.jsp 에서 넘겨받은 값
	String userID = request.getParameter("id");
	String userPassword = request.getParameter("password");
	String userName = request.getParameter("name");
	String userGender = request.getParameter("gender");
	String userPhone = request.getParameter("ph1") + "-" + request.getParameter("ph2") + "-" + request.getParameter("ph3");
	String userEmail = request.getParameter("email1") + "@" + request.getParameter("email2");
	String agreeEmail = request.getParameter("agreeEmail");
	if(agreeEmail == null) {
		agreeEmail = "NO";
	}
	int userPoint = 1000;
	Timestamp now = new Timestamp(System.currentTimeMillis());

	// user 등록
	String signUp = "INSERT INTO userTBL(userID, userPassword, userName, userGender, userPhone, userEmail, agreeEmail, userPoint, userDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
	PreparedStatement pstmt = con.prepareStatement(signUp);

	pstmt.setString(1, userID);
	pstmt.setString(2, userPassword);
	pstmt.setString(3, userName);
	pstmt.setString(4, userGender);
	pstmt.setString(5, userPhone);
	pstmt.setString(6, userEmail);
	pstmt.setString(7, agreeEmail);
	pstmt.setInt(8, userPoint);
	pstmt.setTimestamp(9, now);

	pstmt.executeUpdate();
	pstmt.close();
%>
<script>
	$(document).ready(function(){
		var userID = "<%=userID%>";
		URL = "../join.jsp?userID=" + userID;
		location.href = URL;
	});
</script>
<%
	con.close();
%>
</body>
</html>