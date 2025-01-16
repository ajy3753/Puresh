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

	// 전달 받은 cartID 목록
	String receiveID = request.getParameter("sendID");
	String[] idArray = receiveID.split("_");
	int L = idArray.length;

	// 장바구니에서 삭제
	String deleteCart = "DELETE FROM cartTBL WHERE cartID = ?";
	for(int index = 0; index < L; index++) {
		PreparedStatement pstmtDel = con.prepareStatement(deleteCart);
		pstmtDel.setString(1, idArray[index]);

		pstmtDel.executeUpdate();
		pstmtDel.close();
	}

	con.close();

	response.sendRedirect("../mypage.jsp?ctg=cart");
%>