<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@page import="java.text.*"%>
<%
	request.setCharacterEncoding("UTF-8");
	
	// DB 연결
	String DB_URL = "jdbc:mysql://localhost:3306/pureshDB";
	String DB_ID = "pureshManager";
	String DB_PASSWORD = "1234";
	Class.forName("org.gjt.mm.mysql.Driver");
	Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

	// 건네받은 값
	String askID = request.getParameter("askID");
	String answer = request.getParameter("answer");

	// 현재 시간 불러오기
	Timestamp now = new Timestamp(System.currentTimeMillis());
	SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
	String date = format.format(now);

	// 답변 업로드
	String updateAsk = "UPDATE askTBL SET answer = ?, answerDate = ?, askStatus = ? WHERE askID = ?";
	PreparedStatement pstmtUP = con.prepareStatement(updateAsk);
	pstmtUP.setString(1, answer);
	pstmtUP.setTimestamp(2, now);
	pstmtUP.setString(3, "답변 완료");
	pstmtUP.setString(4, askID);
	pstmtUP.executeUpdate();
	pstmtUP.close();

	response.sendRedirect("../pureshManager.jsp?ctg=support_askList");
%>
<%
	con.close();
%>