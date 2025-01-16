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
	<script src="../css/jQuery.js"></script>
	<!-- 외부CSS 파일 연결 -->
	<link rel="stylesheet" type="text/css" href="../css/main.css?after">
	<link rel="stylesheet" type="text/css" href="../css/manager.css?after">
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

	// sub_addProd에서 넘겨 받은 값
	String  prodID = request.getParameter("prodID");
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

	// 현재 시간 불러오기
	Timestamp now = new Timestamp(System.currentTimeMillis());
	SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
	String date = format.format(now);

	// URL
	String URL = "../pureshManager.jsp?ctg=prod_prodList";

	// prodID 중복 검사
	int error = 0;

	String checkID = "SELECT COUNT(*) FROM V_prodList WHERE prodID = ?";
	PreparedStatement pstmtCheck = con.prepareStatement(checkID);
	pstmtCheck.setString(1, prodID);
	ResultSet rsCheck = pstmtCheck.executeQuery();
	rsCheck.next();

	int count = rsCheck.getInt("COUNT(*)");

	rsCheck.close();
	pstmtCheck.close();

	if (count > 0) {
		error = 1;
	}

	// 상품 추가
	String addProd = "INSERT INTO prodTBL(prodID, prodName, prodPrice, prodStock, prodCtg, prodType, prodVolume, prodImg, prodInfo, prodStatus, prodDate, prodEvent) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	PreparedStatement pstmtAdd = con.prepareStatement(addProd);
	pstmtAdd.setString(1, prodID);
	pstmtAdd.setString(2, prodName);
	pstmtAdd.setInt(3, prodPrice);
	pstmtAdd.setInt(4, prodStock);
	pstmtAdd.setString(5, prodCtg);
	pstmtAdd.setString(6, prodType);
	pstmtAdd.setInt(7, prodVolume);
	pstmtAdd.setString(8, prodImg);
	pstmtAdd.setString(9, prodInfo);
	pstmtAdd.setString(10, prodStatus);
	pstmtAdd.setTimestamp(11, now);
	pstmtAdd.setString(12, prodEvent);

	pstmtAdd.executeUpdate();
	pstmtAdd.close();

%>
<script>
	$(document).ready(function(){
		var message = "<%=error%>";
		switch (message) {
			case '1':
				alert("중복된 상품 ID입니다.")
				history.back();
				break;
			default:
				location.href = "<%=URL%>"
				break;
		}
	});
</script>
<%
	con.close();
%>
</body>
</html>