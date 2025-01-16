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

	// prodID
	String prodID = request.getParameter("sendID");

	// prod 삭제
	String deleteProd = "DELETE FROM prodTBL WHERE prodID = ?";
	PreparedStatement pstmtDel = con.prepareStatement(deleteProd);
	pstmtDel.setString(1, prodID);
	pstmtDel.executeUpdate();
	pstmtDel.close();

	con.close();

	response.sendRedirect("../pureshManager.jsp?ctg=prod_prodList");
%>