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

	// userID, prodID 설정
	String id = (String)session.getAttribute("sid"); 
	String prodID = request.getParameter("prodID");

	// 중복 판별
	int errorCode = 0;
	String checkWish = "SELECT count(prodID) FROM wishTBL WHERE userID = ? AND prodID = ?";
	PreparedStatement pstmtC = con.prepareStatement(checkWish);
	pstmtC.setString(1, id);
	pstmtC.setString(2, prodID);
	ResultSet rsC = pstmtC.executeQuery();
	rsC.next();

	int duplication = rsC.getInt("count(prodID)");

	rsC.close();
	pstmtC.close();

	if(duplication > 0) {
		errorCode = 1;
	}
	else {
		// 가장 최근 wishID 불러오기
		String setWish = "SELECT * FROM V_setWish";
		PreparedStatement pstmtSet = con.prepareStatement(setWish);
		ResultSet rsSet = pstmtSet.executeQuery();
		rsSet.next();

		String wishID = rsSet.getString("wishID");

		rsSet.close();
		pstmtSet.close();

		// 새 wishID 만들기
		char[] wishArray = wishID.toCharArray();
		char sort = wishArray[9];
		String place = "";
		int num;

		// 현재 시간 불러오기
		Timestamp now = new Timestamp(System.currentTimeMillis());
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
		String date = format.format(now);

		String lastDate = "";
		for(int i = 1; i < 9; i++) {
			lastDate += Character.toString(wishArray[i]);
		}
		int last = Integer.parseInt(lastDate);
		int today = Integer.parseInt(date);
		if(last < today ) {
			sort = 'A';
			place = "001";
		}
		else {
			for(int i = 10; i < wishArray.length; i++) {
				place += Character.toString(wishArray[i]);
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

		// wishID 설정
		wishID = "W" + date + sort + place;

		// wish 등록
		String addWish = "INSERT INTO wishTBL VALUES (?, ?, ?, ?)";
		PreparedStatement pstmtAdd = con.prepareStatement(addWish);
		pstmtAdd.setString(1, wishID);
		pstmtAdd.setString(2, id);
		pstmtAdd.setString(3, prodID);
		pstmtAdd.setTimestamp(4, now);
		pstmtAdd.executeUpdate();
		pstmtAdd.close();
	}
%>
<script>
	$(document).ready(function(){
		var message = "<%=errorCode%>"
		switch (message) {
			case '1':
				alert("이미 관심상품에 추가된 상품입니다.");
				history.back();
				break;
			default:
				let addSuccess = confirm("관심상품에 추가되었습니다.\n관심상품 목록으로 이동하시겠습니까?");
				if(addSuccess == true) {
					location.href = "../mypage.jsp?ctg=wish";
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