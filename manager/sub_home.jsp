<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!-- sub jsp -->
<%
	request.setCharacterEncoding("UTF-8");
	
	// DB 연결
	String DB_URL = "jdbc:mysql://localhost:3306/pureshDB";
	String DB_ID = "pureshManager";
	String DB_PASSWORD = "1234";
	Class.forName("org.gjt.mm.mysql.Driver");
	Connection conSub = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

	// 로그인 여부
	String managerID = (String)session.getAttribute("managerSID");

	// userList 변수
	String userID;
	String RPAD_userID;
	String userName;
	String userGender;
	String userPhone;
	String userEmail;
	String userDate;
%>
<script>
	$(document).ready(function(){
	});
</script>

<h1 class="mainHeader">관리자 홈</h1>


<%
	conSub.close();
%>