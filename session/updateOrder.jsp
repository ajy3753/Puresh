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
	String sendData = request.getParameter("sendData");
	String[] dataArray = sendData.split("_");
	String type = dataArray[0];
	String order = dataArray[1];

	// 업데이트용 변수
	String updateStatus = "UPDATE orderTBL SET orderStatus = ";
	String URL = "../sub/mypage_orderDetail.jsp?orderName=";
	Timestamp now = new Timestamp(System.currentTimeMillis());

	// orderUpdate
	switch (type) {
		case "depositComplete" :
			updateStatus = updateStatus + "'입금 확인 중' WHERE orderName = ?";

			PreparedStatement pstmtDepositComplete = con.prepareStatement(updateStatus);
			pstmtDepositComplete.setString(1, order);
			pstmtDepositComplete.executeUpdate();
			pstmtDepositComplete.close();

			URL = URL + order;
			response.sendRedirect(URL);
			break;
		case "orderCancel" :
			updateStatus = updateStatus + "'주문 취소' WHERE userID = ? AND orderName = ?";

			PreparedStatement pstmtOrderCancel = con.prepareStatement(updateStatus);
			pstmtOrderCancel.setString(1, id);
			pstmtOrderCancel.setString(2, order);
			pstmtOrderCancel.executeUpdate();
			pstmtOrderCancel.close();

			// 사용 포인트 반환
			String searchPay = "SELECT * FROM payTBL WHERE userID = ? AND orderName = ?";
			PreparedStatement pstmtPay = con.prepareStatement(searchPay);
			pstmtPay.setString(1, id);
			pstmtPay.setString(2, order);
			ResultSet rsPay = pstmtPay.executeQuery();
			rsPay.next();

			String payID = rsPay.getString("payID");
			int payPoint = rsPay.getInt("payPoint");

			rsPay.close();
			pstmtPay.close();

			String updatePoint = "UPDATE userTBL SET userPoint = (userPoint + ?) WHERE userID = ?";
			PreparedStatement pstmtPoint = con.prepareStatement(updatePoint);
			pstmtPoint.setInt(1, payPoint);
			pstmtPoint.setString(2, id);
			pstmtPoint.executeUpdate();
			pstmtPoint.close();

			// 재고 수정
			String loadPrd = "SELECT * FROM orderTBL WHERE userID = ? AND orderName = ?";
			PreparedStatement pstmtLoad = con.prepareStatement(loadPrd);
			pstmtLoad.setString(1, id);
			pstmtLoad.setString(2, order);
			ResultSet rsLoad = pstmtLoad.executeQuery();

			while(rsLoad.next()) {
				String updateStock = "UPDATE prodTBL SET prodStock = (prodStock + ?) WHERE prodID = ?";
				PreparedStatement pstmtStock = con.prepareStatement(updateStock);
				pstmtStock.setInt(1, rsLoad.getInt("orderStock"));
				pstmtStock.setString(2, rsLoad.getString("prodID"));
				pstmtStock.executeUpdate();
				pstmtStock.close();
			}

			rsLoad.close();
			pstmtLoad.close();

			URL = URL + order;
			response.sendRedirect(URL);
			break;
		case "orderComplete" :
			updateStatus = updateStatus + "'구매 확정', orderEnd = ? WHERE userID = ? AND orderID = ?";
	
			PreparedStatement pstmtOrderComplete = con.prepareStatement(updateStatus);
			pstmtOrderComplete.setTimestamp(1, now);
			pstmtOrderComplete.setString(2, id);
			pstmtOrderComplete.setString(3, order);
			pstmtOrderComplete.executeUpdate();
			pstmtOrderComplete.close();

			String searchName = "SELECT orderName FROM orderTBL WHERE orderID = ?";
			PreparedStatement pstmtName = con.prepareStatement(searchName);
			pstmtName.setString(1, order);
			ResultSet rsName = pstmtName.executeQuery();
			rsName.next();

			String orderName = rsName.getString("orderName");

			rsName.close();
			pstmtName.close();

			URL = URL + orderName;
			response.sendRedirect(URL);
			break;
		case "reviewComplete" :
			updateStatus = updateStatus + "'리뷰 완료' WHERE orderID = ?";
	
			PreparedStatement pstmtReviewComplete = con.prepareStatement(updateStatus);
			pstmtReviewComplete.setString(1, order);
			pstmtReviewComplete.executeUpdate();
			pstmtReviewComplete.close();

			URL = "../mypage.jsp?ctg=reviewList";
			response.sendRedirect(URL);
			break;
		case "reviewDelete" :
			updateStatus = updateStatus + "'구매 확정' WHERE orderID = ?";

			PreparedStatement pstmtReviewDelete = con.prepareStatement(updateStatus);
			pstmtReviewDelete.setString(1, order);
			pstmtReviewDelete.executeUpdate();
			pstmtReviewDelete.close();

			String deleteReview = "DELETE FROM reviewTBL WHERE orderID = ?";

			PreparedStatement pstmtDR = con.prepareStatement(deleteReview);
			pstmtDR.setString(1, order);
			pstmtDR.executeUpdate();
			pstmtDR.close();

			URL = "../mypage.jsp?ctg=reviewList";
			response.sendRedirect(URL);
			break;
		default:
			break;
	}
%>

<%
	con.close();
%>