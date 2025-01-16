<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@page import="java.text.*"%>
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

	// 건네받은 값
	String reviewID = request.getParameter("reviewID");
	int ratingScore = Integer.parseInt(request.getParameter("ratingScore"));
	String reviewContent = request.getParameter("reviewContent");

	// 현재 시간 불러오기
	Timestamp now = new Timestamp(System.currentTimeMillis());
	SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
	String date = format.format(now);

	// 리뷰 업로드
	String updateReview = "UPDATE reviewTBL SET ratingScore = ?,  reviewContent = ?, reviewDate = ? WHERE reviewID = ?";
	PreparedStatement pstmtUP = con.prepareStatement(updateReview);
	pstmtUP.setInt(1, ratingScore);
	pstmtUP.setString(2, reviewContent);
	pstmtUP.setTimestamp(3, now);
	pstmtUP.setString(4, reviewID);
	pstmtUP.executeUpdate();
	pstmtUP.close();
%>
<script>
	$(document).ready(function(){
		alert("성공적으로 수정 되었습니다.");
		var URL = "../mypage.jsp?ctg=reviewList";
		window.opener.parent.location = URL;
		window.close();
	});
</script>
<%
	con.close();
%>
</body>
</html>