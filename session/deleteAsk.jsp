<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
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

	// sendData
	String sendData = request.getParameter("sendData");
	String[] dataArray = sendData.split("_");
	String askID = dataArray[1];

	// URL
	String URL = "";
	switch (dataArray[0]) {
		case "mypage" :
			URL = "../mypage.jsp?ctg=ask";
			break;
		case "manager" :
			URL = "../pureshManager.jsp?ctg=support_askList";
			break;
		default :
			break;
	}

	// ask 삭제
	String deleteAsk = "DELETE FROM askTBL WHERE askID = ?";
	PreparedStatement pstmtDel = con.prepareStatement(deleteAsk);
	pstmtDel.setString(1, askID);
	pstmtDel.executeUpdate();
	pstmtDel.close();

	con.close();

	response.sendRedirect(URL);
%>