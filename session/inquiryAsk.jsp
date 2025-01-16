<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<title>Puresh - 1:1 문의 내역</title>
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
			height: 100%;
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

	// 로그인 여부 및 유저 아이디 값
	String id = (String)session.getAttribute("sid");

	// askID
	String askID = request.getParameter("sendID");

	// 문의 정보
	String loadAsk = "SELECT * FROM V_askList WHERE askID = ?";
	PreparedStatement pstmtLoad = con.prepareStatement(loadAsk);
	pstmtLoad.setString(1, askID);
	ResultSet rsLoad = pstmtLoad.executeQuery();
	rsLoad.next();

	String askCtg = rsLoad.getString("askCtg");
	String askName = rsLoad.getString("askName");
	String askContent = rsLoad.getString("askContent");
	String askStatus = rsLoad.getString("askStatus");
	String agreeEmail = rsLoad.getString("agreeEmail");
	String askDate = rsLoad.getString("Date");

	rsLoad.close();
	pstmtLoad.close();

	String answer = "아직 등록된 답변이 없습니다.";
	String answerDate = "답변 미등록";

	if(askStatus.equals("답변 완료")) {
		PreparedStatement pstmtAnswer = con.prepareStatement(loadAsk);
		pstmtAnswer.setString(1, askID);
		ResultSet rsAnswer = pstmtAnswer.executeQuery();
		rsAnswer.next();

		answer = rsAnswer.getString("answer");
		answerDate = rsAnswer.getString("answerDate");

		rsAnswer.close();
		pstmtAnswer.close();
	}
%>
<script>
	$(document).ready(function(){
		// #close (확인 버튼)
		$("button#close").click(function () {
			window.close();
		});
	});
</script>

<section class="inquiryAsk">
	<h1>1:1 문의 내역</h1>
	<table>
		<tr>
			<th>제목</th>
			<td><input type="text" value="<%=askName%>" readonly></td>
		</tr>
		<tr>
			<th>분류</th>
			<td><input type="text" value="<%=askCtg%>" readonly></td>
		</tr>
		<tr>
			<th>문의일</th>
			<td><input type="text" value="<%=askDate%>" readonly></td>
		</tr>
		<tr>
			<th>상태</th>
			<td><input type="text" value="<%=askStatus%>" readonly></td>
		</tr>
		<tr>
			<th style="vertical-align: top;">상세</th>
			<td><textarea readonly><%=askContent%></textarea></td>
		</tr>
		<tr>
			<th style="vertical-align: top;">답변</th>
			<td><textarea readonly><%=answer%></textarea></td>
		</tr>
		<tr>
			<th>답변일</th>
			<td><input type="text" value="<%=answerDate%>" readonly></td>
		</tr>
	</table>

	<button id="close">확인</button>

	<!-- 맨위로 이동 -->
	<a id="locationUP" href="#">&#8593; top</a>
</section>

<%
	con.close();
%>
</body>
</html>