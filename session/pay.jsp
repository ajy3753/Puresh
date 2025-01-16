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

	// userID
	String id = (String)session.getAttribute("sid");

	// 상품 정보
	String[] cartID = request.getParameterValues("cartID");
	String[] prodID = request.getParameterValues("prodID");
	String[] orderStock = request.getParameterValues("orderStock");
	String[] orderPrice = request.getParameterValues("orderPrice");
	String[] orderTotal = request.getParameterValues("orderTotal");

	// 주문 정보
	String orderer = request.getParameter("orderer");
	String receiver = request.getParameter("receiver");
	String receiverAddr = request.getParameter("receiverAddr");
	String receiverPhone = request.getParameter("receiverPh1") + "-" + request.getParameter("receiverPh2") + "-" + request.getParameter("receiverPh3");

	// 결제수단, 주문 상태
	String payMethod = request.getParameter("payMethod");
	String orderStatus = "";
	String URL = "../orderOK.jsp?sendData";

	switch (payMethod) {
		case "NoBankBook" :
			payMethod = "무통장 입금";
			orderStatus = "입금 대기";
			URL = URL + "=NoBankBook_";
			break;
		case "KakaoPayRemittance" :
			payMethod = "카카오페이 송금";
			orderStatus = "입금 대기";
			URL = URL + "=KakaoPayRemittance_";
			break;
		default :
			break;
	}

	// 배송비
	int deliveryCharge = Integer.parseInt(request.getParameter("deliveryCharge"));

	// 포인트 사용
	int payPoint = Integer.parseInt(request.getParameter("payPoint"));

	// 최종 결제 금액
	int payPrice = Integer.parseInt(request.getParameter("payPrice"));
	int payTotal = Integer.parseInt(request.getParameter("payTotal"));

	// 현재 시간
	Timestamp now = new Timestamp(System.currentTimeMillis());
	SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
	String date = format.format(now);
	int today = Integer.parseInt(date);

	// orderName 생성
	String countOrderName = "SELECT COUNT(orderName) FROM V_setOrder WHERE userID = ?";
	PreparedStatement pstmtNN = con.prepareStatement(countOrderName);
	pstmtNN.setString(1, id);
	ResultSet rsNN = pstmtNN.executeQuery();
	rsNN.next();

	int countName = rsNN.getInt("COUNT(orderName)");

	rsNN.close();
	pstmtNN.close();

	String orderName = "P00000000A";
	if(countName > 0) {
		String setName = "SELECT * FROM V_setOrder WHERE userID = ? LIMIT 1";
		PreparedStatement pstmtName = con.prepareStatement(setName);
		pstmtName.setString(1, id);
		ResultSet rsName = pstmtName.executeQuery();
		rsName.next();

		orderName = rsName.getString("orderName");

		rsName.close();
		pstmtName.close();	
	}

	char[] nameArray = orderName.toCharArray();
	char nameSort = nameArray[9];

	String lastDateName = "";
	for(int i = 1; i < 9; i++) {
		lastDateName += Character.toString(nameArray[i]);
	}

	int lastName = Integer.parseInt(lastDateName);
	if(lastName < today ) {
		nameSort = 'A';
	}
	else {
		int a = nameSort + 1;
		nameSort = (char)a;
	}

	orderName = "P" + date + nameSort;

	// orderTBL 업데이트
	int L = cartID.length;
	for(int index = 0; index < L; index++) {
		// orderID 생성
		String setOrder = "SELECT * FROM V_setOrder LIMIT 1";
		PreparedStatement pstmtSet = con.prepareStatement(setOrder);
		ResultSet rsSet = pstmtSet.executeQuery();
		rsSet.next();

		String orderID = rsSet.getString("orderID");

		rsSet.close();
		pstmtSet.close();

		char[] orderArray = orderID.toCharArray();
		char orderSort = orderArray[9];
		String orderPlace = "";
		int orderNum;

		String lastDateOrder = "";
		for(int i = 1; i < 9; i++) {
			lastDateOrder += Character.toString(orderArray[i]);
		}

		int lastOrder = Integer.parseInt(lastDateOrder);

		if(lastOrder < today ) {
			orderSort = 'A';
			orderPlace = "001";
		}
		else {
			for(int i = 10; i < orderArray.length; i++) {
				orderPlace += Character.toString(orderArray[i]);
			}

			orderNum = Integer.parseInt(orderPlace) + 1;
			if(orderNum > 999) {
				int i = orderSort + 1;
				orderSort = (char)i;
				orderNum = 1;
			}

			orderPlace = Integer.toString(orderNum);
			char[] orderNumArray = orderPlace.toCharArray();
			if(orderNumArray.length == 1) {
				orderPlace = "00" + orderNum;
			}
			if(orderNumArray.length == 2) {
				orderPlace = "0" + orderNum;
			}
		}

		orderID = "O" + date + orderSort + orderPlace;

		// INSERT orderTBL
		String insertOrder = "INSERT INTO orderTBL(orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, orderStart) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)";
		PreparedStatement pstmtOrder = con.prepareStatement(insertOrder);

		pstmtOrder.setString(1, orderID);
		pstmtOrder.setString(2, id);
		pstmtOrder.setString(3, prodID[index]);
		pstmtOrder.setString(4, orderName);
		pstmtOrder.setInt(5, Integer.parseInt(orderPrice[index]));
		pstmtOrder.setInt(6,Integer.parseInt(orderStock[index]));
		pstmtOrder.setInt(7, Integer.parseInt(orderTotal[index]));
		pstmtOrder.setString(8, orderStatus);
		pstmtOrder.setTimestamp(9, now);

		pstmtOrder.executeUpdate();
		pstmtOrder.close();

		// 상품 재고 수정
		int updateStock = Integer.parseInt(orderStock[index]);

		String updateProdStock = "UPDATE prodTBL SET prodStock = (prodStock - ?) WHERE prodID = ?";
		PreparedStatement pstmtUPS = con.prepareStatement(updateProdStock);
		pstmtUPS.setInt(1, updateStock);
		pstmtUPS.setString(2, prodID[index]);
		pstmtUPS.executeUpdate();
		pstmtUPS.close();
	}

	// payID 생성
	String setPay = "SELECT * FROM V_setPay";
	PreparedStatement pstmtSet2 = con.prepareStatement(setPay);
	ResultSet rsSet2 = pstmtSet2.executeQuery();
	rsSet2.next();

	String payID = rsSet2.getString("payID");

	rsSet2.close();
	pstmtSet2.close();

	char[] payArray = payID.toCharArray();
	char paySort = payArray[9];
	String payPlace = "";
	int payNum;

	String lastDatePay = "";
	for(int i = 1; i < 9; i++) {
			lastDatePay += Character.toString(payArray[i]);
	}

	int lastPay = Integer.parseInt(lastDatePay);
	if(lastPay < today ) {
		paySort = 'A';
		payPlace = "001";
	}
	else {
		for(int i = 10; i < payArray.length; i++) {
			payPlace += Character.toString(payArray[i]);
		}

		payNum = Integer.parseInt(payPlace) + 1;
		if(payNum > 999) {
			int i = paySort + 1;
			paySort = (char)i;
			payNum = 1;
		}

		payPlace = Integer.toString(payNum);
		char[] payNumArray = payPlace.toCharArray();
		if(payNumArray.length == 1) {
			payPlace = "00" + payNum;
		}
		if(payNumArray.length == 2) {
			payPlace = "0" + payNum;
		}
	}

	payID = "P" + date + paySort + payPlace;
	URL = URL + payID;

	// insert payTBL (필수 정보)
	String insertPay = "INSERT INTO payTBL(payID, userID, orderName, orderer, receiver, receiverAddr, receiverPhone, payMethod, orderTotal, deliveryCharge, payPoint, payTotal, payDate) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	PreparedStatement pstmtPay = con.prepareStatement(insertPay);

	pstmtPay.setString(1, payID);
	pstmtPay.setString(2, id);
	pstmtPay.setString(3, orderName);
	pstmtPay.setString(4, orderer);
	pstmtPay.setString(5, receiver);
	pstmtPay.setString(6, receiverAddr);
	pstmtPay.setString(7, receiverPhone);
	pstmtPay.setString(8, payMethod);
	pstmtPay.setInt(9, payPrice);
	pstmtPay.setInt(10, deliveryCharge);
	pstmtPay.setInt(11, payPoint);
	pstmtPay.setInt(12, payTotal);
	pstmtPay.setTimestamp(13, now);

	pstmtPay.executeUpdate();
	pstmtPay.close();

	// insertPayPlus (추가 정보)
	String insertPayPlus = "";

	String methodBank;
	String methodAccount;
	String methodName;
	String methodDate;
	
	String refundBank;
	String refundAccount;
	String refundName;

	switch (payMethod) {
		case "무통장 입금" :
			methodBank = request.getParameter("methodBank");
			if(methodBank.equals("NH농협") || methodBank.equals("IBK기업은행")) {
				methodAccount = request.getParameter("methodAccount1") + "-" + request.getParameter("methodAccount2") + "-" + request.getParameter("methodAccount3") + "-" + request.getParameter("methodAccount4");
			}
			else {
				methodAccount = request.getParameter("methodAccount1") + "-" + request.getParameter("methodAccount2") + "-" + request.getParameter("methodAccount3");
			}
			methodName = request.getParameter("methodName");

			refundBank = request.getParameter("refundBank");
			if(refundBank.equals("NH농협") || refundBank.equals("IBK기업은행")) {
				refundAccount = request.getParameter("refundAccount1") + "-" + request.getParameter("refundAccount2") + "-" + request.getParameter("refundAccount3") + "-" + request.getParameter("refundAccount4");
			}
			else {
				refundAccount = request.getParameter("refundAccount1") + "-" + request.getParameter("refundAccount2") + "-" + request.getParameter("refundAccount3");
			}
			refundName = request.getParameter("refundName");

			insertPayPlus = "UPDATE payTBL SET methodBank = ?, methodAccount = ?, methodName = ?, refundBank = ?, refundAccount = ?, refundName = ? WHERE payID = ?";
			PreparedStatement pstmtPlus = con.prepareStatement(insertPayPlus);

			pstmtPlus.setString(1, methodBank);
			pstmtPlus.setString(2, methodAccount);
			pstmtPlus.setString(3, methodName);
			pstmtPlus.setString(4, refundBank);
			pstmtPlus.setString(5, refundAccount);
			pstmtPlus.setString(6, refundName);
			pstmtPlus.setString(7, payID);

			pstmtPlus.executeUpdate();
			pstmtPlus.close();
			break;
		case "카카오페이 송금" :
			methodName = request.getParameter("methodName");
			methodDate = request.getParameter("methodDate");

			refundBank = request.getParameter("refundBank");
			if(refundBank.equals("NH농협") || refundBank.equals("IBK기업은행")) {
				refundAccount = request.getParameter("refundAccount1") + "-" + request.getParameter("refundAccount2") + "-" + request.getParameter("refundAccount3") + "-" + request.getParameter("refundAccount4");
			}
			else {
				refundAccount = request.getParameter("refundAccount1") + "-" + request.getParameter("refundAccount2") + "-" + request.getParameter("refundAccount3");
			}
			refundName = request.getParameter("refundName");

			insertPayPlus = "UPDATE payTBL SET methodName = ?, methodDate = ?, refundBank = ?, refundAccount = ?, refundName = ? WHERE payID = ?";
			PreparedStatement pstmtPlus2 = con.prepareStatement(insertPayPlus);

			pstmtPlus2.setString(1, methodName);
			pstmtPlus2.setString(2, methodDate);
			pstmtPlus2.setString(3, refundBank);
			pstmtPlus2.setString(4, refundAccount);
			pstmtPlus2.setString(5, refundName);
			pstmtPlus2.setString(6, payID);

			pstmtPlus2.executeUpdate();
			pstmtPlus2.close();
			break;
		default :
			break;
	}

	// 포인트 갱신
	String updatePoint = "UPDATE userTBL SET userPoint = (userPoint - ?) WHERE userID = ?";
	PreparedStatement pstmtUP = con.prepareStatement(updatePoint);
	pstmtUP.setInt(1, payPoint);
	pstmtUP.setString(2, id);
	pstmtUP.executeUpdate();
	pstmtUP.close();

	// deleteCart
	String deleteCart = "DELETE FROM cartTBL WHERE cartID = ?";
	for(int index = 0; index < L; index++) {
		if(cartID[index].equals("C00000000A001")) {
			continue;
		}
		else {
			PreparedStatement pstmtDel = con.prepareStatement(deleteCart);
			pstmtDel.setString(1, cartID[index]);
			pstmtDel.executeUpdate();
			pstmtDel.close();
		}
	}

	con.close();
	response.sendRedirect(URL);
%>