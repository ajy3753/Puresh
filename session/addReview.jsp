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
	<link rel="stylesheet" type="text/css" href="../css/main.css?after">
</head>
<body>
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

	// 건네받은 값
	String prodID = request.getParameter("prodID");
	String orderID = request.getParameter("orderID");
	int orderStock = Integer.parseInt(request.getParameter("orderStock"));
	int ratingScore = Integer.parseInt(request.getParameter("ratingScore"));
	String reviewContent = request.getParameter("reviewContent");

	// 가장 최근 reviewID 불러오기
	String setReview = "SELECT * FROM V_setReview";
	PreparedStatement pstmtSet = con.prepareStatement(setReview);
	ResultSet rsSet = pstmtSet.executeQuery();
	rsSet.next();

	String reviewID = rsSet.getString("reviewID");

	rsSet.close();
	pstmtSet.close();

	// 새 reviewID 만들기용 변수
	char[] reviewArray = reviewID.toCharArray();
	char sort = reviewArray[9];
	String place = "";
	int num;

	// 현재 시간 불러오기
	Timestamp now = new Timestamp(System.currentTimeMillis());
	SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
	String date = format.format(now);

	// 마지막 reviewID에 기록된 날짜 비교
	String lastDate = "";
	for(int i = 1; i < 9; i++) {
		lastDate += Character.toString(reviewArray[i]);
	}

	int last = Integer.parseInt(lastDate);
	int today = Integer.parseInt(date);

	// 날짜가 지나면 001로 시작, 안 지났으면 +1
	if(last < today ) {
		sort = 'A';
		place = "001";
	}
	else {
		for(int i = 10; i < reviewArray.length; i++) {
			place += Character.toString(reviewArray[i]);
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

	// 새 reviewID 설정
	reviewID = "R" + date + sort + place;

	// 리뷰 업로드
	String addReview = "INSERT INTO reviewTBL(reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
	PreparedStatement pstmtAdd = con.prepareStatement(addReview);
	pstmtAdd.setString(1, reviewID);
	pstmtAdd.setString(2, prodID);
	pstmtAdd.setString(3, id);
	pstmtAdd.setString(4, orderID);
	pstmtAdd.setInt(5, orderStock);
	pstmtAdd.setInt(6, ratingScore);
	pstmtAdd.setString(7, reviewContent);
	pstmtAdd.setTimestamp(8, now);

	pstmtAdd.executeUpdate();
	pstmtAdd.close();

	// orderStatus 변경
%>
<script>
	$(document).ready(function(){
		alert("성공적으로 등록되었습니다.");
		var URL = "../session/updateOrder.jsp?sendData=reviewComplete_" + "<%=orderID%>";
		window.opener.parent.location = URL;
		window.close();
	});
</script>
<%
	con.close();
%>
</body>
</html>