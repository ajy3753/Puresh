<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@page import="java.text.*"%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<title>Puresh</title>
	<!-- 웹폰트 연결 (앨리스 디지털 배움체) -->
	<link href="https://font.elice.io/css?family=Elice+Digital+Baeum" rel="stylesheet">
	<!-- jQuery 라이브러리 연결 -->
	<script src="https://code.jquery.com/jquery-3.6.3.js"></script>
	<script src="css/jQuery.js"></script>
	<!-- 외부CSS 파일 연결 -->
	<link rel="stylesheet" type="text/css" href="css/main.css?after">
	<link rel="stylesheet" type="text/css" href="css/page.css?after">
</head>
<body>
<!-- jsp -->
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

	// prodID, cartStock 설정, 반복
	String receiveData = request.getParameter("sendData");
	String[] dataArray = receiveData.split("_");
	int L = dataArray.length;
	int errorCode = 0;

	for(int index = 0; index < L; index = index+=2) {
		String prodID = dataArray[index];
		int cartStock = Integer.parseInt(dataArray[index + 1]);

		// 중복 검사
		String checkCart = "SELECT count(prodID) FROM cartTBL WHERE userID = ? AND prodID = ?";
		PreparedStatement pstmtC = con.prepareStatement(checkCart);
		pstmtC.setString(1, id);
		pstmtC.setString(2, prodID);
		ResultSet rsC = pstmtC.executeQuery();
		rsC.next();

		int duplication = rsC.getInt("count(prodID)");

		rsC.close();
		pstmtC.close();

		if(duplication > 0) {
			errorCode = 1;
			break;
		}
		else {
			// 가장 최근 cartID 불러오기
			String setCart = "SELECT * FROM V_setCart";
			PreparedStatement pstmtSet = con.prepareStatement(setCart);
			ResultSet rsSet = pstmtSet.executeQuery();
			rsSet.next();

			String cartID = rsSet.getString("cartID");

			rsSet.close();
			pstmtSet.close();

			// 새 cartID 만들기용 변수
			char[] cartArray = cartID.toCharArray();
			char sort = cartArray[9];
			String place = "";
			int num;

			// 현재 시간 불러오기
			Timestamp now = new Timestamp(System.currentTimeMillis());
			SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
			String date = format.format(now);

			// 마지막 cartID에 기록된 날짜 비교
			String lastDate = "";
			for(int i = 1; i < 9; i++) {
				lastDate += Character.toString(cartArray[i]);
			}

			int last = Integer.parseInt(lastDate);
			int today = Integer.parseInt(date);

			// 날짜가 지나면 001로 시작, 안 지났으면 +1
			if(last < today ) {
				sort = 'A';
				place = "001";
			}
			else {
				for(int i = 10; i < cartArray.length; i++) {
					place += Character.toString(cartArray[i]);
				}
				num = Integer.parseInt(place) + 1;
				if(num > 999) {
					int i = sort + 1;
					sort = (char)i;
					num = 1;
				}
				place = Integer.toString(num);
				char[] numArray = place.toCharArray();
				if(numArray.length == 1) {
					place = "00" + num;
				}
				if(numArray.length == 2) {
					place = "0" + num;
				}
			}

			// 새 cartID 설정
			cartID = "C" + date + sort + place;

			// wish 등록
			String addCart = "INSERT INTO cartTBL VALUES (?, ?, ?, ?, ?)";
			PreparedStatement pstmt = con.prepareStatement(addCart);
			pstmt.setString(1, cartID);
			pstmt.setString(2, id);
			pstmt.setString(3, prodID);
			pstmt.setInt(4, cartStock);
			pstmt.setTimestamp(5, now);

			pstmt.executeUpdate();
			pstmt.close();
		}
	}
%>
<script>
	$(document).ready(function(){
		var message = "<%=errorCode%>"
		switch (message) {
			case '1':
				alert("이미 장바구니에 담긴 상품입니다.");
				history.back();
				break;
			default:
				let addSuccess = confirm("장바구니에 담겼습니다.\n장바구니로 이동하시겠습니까?");
				if(addSuccess == true) {
					location.href = "../mypage.jsp?ctg=cart";
				}
				else {
					history.back();
				}
				break;
		}
	});
</script>

<%
	con.close();
%>
</body>
</html>