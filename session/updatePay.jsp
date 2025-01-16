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

	// sendData
	String type = request.getParameter("type");
	String payID = request.getParameter("payID");

	// orderName 불러오기
	String searchName = "SELECT orderName FROM payTBL WHERE payID = ?";
	PreparedStatement pstmtName = con.prepareStatement(searchName);
	pstmtName.setString(1, payID);
	ResultSet rsName = pstmtName.executeQuery();
	rsName.next();

	String orderName = rsName.getString("orderName");

	rsName.close();
	pstmtName.close();

	// 업데이트용 변수
	String URL = "../sub/mypage_orderDetail.jsp?orderName=" + orderName;

	// 분류
	switch (type) {
		case "deliveryChange" :
			String receiver = request.getParameter("receiver");
			String receiverAddr = request.getParameter("receiverAddr");
			String receiverPhone = request.getParameter("receiverPh1") + "-" + request.getParameter("receiverPh2") + "-" + request.getParameter("receiverPh3");

			String updateDelivery = "UPDATE payTBL SET receiver =?, receiverAddr = ?, receiverPhone = ? WHERE payID = ?";
			PreparedStatement pstmtUD = con.prepareStatement(updateDelivery);
			pstmtUD.setString(1, receiver);
			pstmtUD.setString(2, receiverAddr);
			pstmtUD.setString(3, receiverPhone);
			pstmtUD.setString(4, payID);
			pstmtUD.executeUpdate();
			pstmtUD.close();

			response.sendRedirect(URL);
			break;
		case "refundChange" :
			String refundBank = request.getParameter("refundBank");
			String refundAccount =  request.getParameter("refundAccount1") + "-" + request.getParameter("refundAccount2") + "-" + request.getParameter("refundAccount3");
			String refundName = request.getParameter("refundName");

			String updateRefund = "UPDATE payTBL SET refundBank =?, refundAccount = ?, refundName = ? WHERE payID = ?";
			PreparedStatement pstmtUR = con.prepareStatement(updateRefund);
			pstmtUR.setString(1, refundBank);
			pstmtUR.setString(2, refundAccount);
			pstmtUR.setString(3, refundName);
			pstmtUR.setString(4, payID);
			pstmtUR.executeUpdate();
			pstmtUR.close();

			response.sendRedirect(URL);
			break;
		default :
			break;
	}
%>
<%
	con.close();
%>