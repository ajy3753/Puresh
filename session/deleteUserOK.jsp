<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<title>Puresh - 회원 탈퇴</title>
	<!-- 웹폰트 연결 (앨리스 디지털 배움체) -->
	<link href="https://font.elice.io/css?family=Elice+Digital+Baeum" rel="stylesheet">
	<!-- jQuery 라이브러리 연결 -->
	<script src="https://code.jquery.com/jquery-3.6.3.js"></script>
	<script src="../css/jQuery.js"></script>
	<!-- 외부CSS 파일 연결 -->
	<link rel="stylesheet" type="text/css" href="../css/main.css?after">
	<link rel="stylesheet" type="text/css" href="../css/sub.css?after">
	<style>
		body {
			width: 100%;
			height: 100vh;
		}
	</style>
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
	
	// userID
	String id = (String)session.getAttribute("sid");

	// 전달 받은 값
	String password = request.getParameter("pwd");

	// 비밀번호 확인
	String loadPWD = "SELECT * FROM V_loadUser WHERE userID = ?";
	PreparedStatement pstmtLoad = con.prepareStatement(loadPWD);
	pstmtLoad.setString(1, id);
	ResultSet rsLoad = pstmtLoad.executeQuery();
	rsLoad.next();

	String userPassword = rsLoad.getString("userPassword");

	rsLoad.close();
	pstmtLoad.close();

	int error = 0;
	if(password.equals(userPassword)) {
		String deleteUser = "DELETE FROM userTBL WHERE userID = ?";
		PreparedStatement pstmtDel = con.prepareStatement(deleteUser);
		pstmtDel.setString(1, id);
		pstmtDel.executeUpdate();
		pstmtDel.close();
	}
	else {
		error = 1;
	}
%>
<script>
	$(document).ready(function(){
		var errorCode = "<%=error%>";
		if(errorCode > 0) {
			alert("비밀번호가 틀립니다.");
			location.href = "deleteUser.jsp";
		}
		else {
			alert("탈퇴가 완료되었습니다.\n계정 복구는 3개월 이내에만 가능하며, 이후로는 완전 삭제 처리되어 복구가 불가능합니다.");
			location.href = "logout.jsp";
		}
	});
</script>
<%
	con.close();
%>
</body>
</html>