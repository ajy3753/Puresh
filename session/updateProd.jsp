<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("UTF-8");
	
	// DB 연결
	String DB_URL = "jdbc:mysql://localhost:3306/pureshDB";
	String DB_ID = "pureshManager";
	String DB_PASSWORD = "1234";
	Class.forName("org.gjt.mm.mysql.Driver");
	Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

	// 건네받은 값
	String prodID = request.getParameter("prodID");
	String prodName = request.getParameter("prodName");
	int prodPrice = Integer.parseInt(request.getParameter("prodPrice"));
	int prodStock = Integer.parseInt(request.getParameter("prodStock"));
	String prodCtg = request.getParameter("prodCtg");
	String prodType = request.getParameter("prodType");
	int prodVolume = Integer.parseInt(request.getParameter("prodVolume"));
	String prodImg = request.getParameter("prodImg");
	String prodInfo = request.getParameter("prodInfo");
	String prodStatus = request.getParameter("prodStatus");
	String prodEvent = request.getParameter("prodEvent");
	if(prodEvent == null) {
		prodEvent = "";
	}

	// prod 업데이트
	String updateProd = "UPDATE prodTBL SET prodName = ?,  prodPrice = ?, prodStock = ?, prodCtg = ?, prodType = ?, prodVolume = ?, prodImg = ?, prodInfo = ?, prodStatus = ?,  prodEvent = ? WHERE prodID = ?";
	PreparedStatement pstmtUP = con.prepareStatement(updateProd);

	pstmtUP.setString(1, prodName);
	pstmtUP.setInt(2, prodPrice);
	pstmtUP.setInt(3,prodStock);
	pstmtUP.setString(4, prodCtg);
	pstmtUP.setString(5, prodType);
	pstmtUP.setInt(6, prodVolume);
	pstmtUP.setString(7, prodImg);
	pstmtUP.setString(8, prodInfo);
	pstmtUP.setString(9, prodStatus);
	pstmtUP.setString(10, prodEvent);
	pstmtUP.setString(11, prodID);

	pstmtUP.executeUpdate();
	pstmtUP.close();

	// null 값 처리
	String updateNull = "UPDATE prodTBL SET prodEvent = NULL WHERE prodEvent IN (NULL, '')";
	PreparedStatement pstmtNull = con.prepareStatement(updateNull);
	pstmtNull.executeUpdate();
	pstmtNull.close();

	response.sendRedirect("../pureshManager.jsp?ctg=prod_prodList");
%>
<%
	con.close();
%>