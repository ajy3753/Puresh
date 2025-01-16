<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
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

	// 전달받은 type값
	String sendData = request.getParameter("sendData");
	String[] dataArray = sendData.split("_");
	String type = dataArray[0];
	String URL = "../sub/testResult.jsp?type=" + dataArray[1];

	// type 업데이트
	String updateType = "UPDATE userTBL SET userType = ? WHERE userID = ?";
	PreparedStatement pstmtType = con.prepareStatement(updateType);
	pstmtType.setString(1, type);
	pstmtType.setString(2, id);
	pstmtType.executeUpdate();
	pstmtType.close();

	response.sendRedirect(URL);
%>
<%
	con.close();
%>