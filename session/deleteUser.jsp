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

	// 비밀번호 확인
	String loadPWD = "SELECT * FROM V_loadUser WHERE userID = ?";
	PreparedStatement pstmtLoad = con.prepareStatement(loadPWD);
	pstmtLoad.setString(1, id);
	ResultSet rsLoad = pstmtLoad.executeQuery();
	rsLoad.next();

	String password = rsLoad.getString("userPassword");

	rsLoad.close();
	pstmtLoad.close();
%>
<script>
	$(document).ready(function(){
		// 취소 버튼
		$("button#Back").click(function () {
			location.href = "../mypage.jsp?ctg=user";
		});
	});
</script>

<article class="deleteUser">
	<h1><%=id%></h1>
	<h3>회원 탈퇴</h3>
	<form action="deleteUserOK.jsp">
		<input type="password" id="PWD" name="pwd" placeholder="회원 탈퇴를 진행 하시려면 비밀번호를 입력해주세요">
		<span>
			<button type="button" id="Back">&lharu; 취소</button>
			<button type="submit" id="Delete">&#9888; 탈퇴</button>
		</span>
	</form>
</article>


<%
	con.close();
%>
</body>
</html>