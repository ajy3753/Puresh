<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
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
	<link rel="stylesheet" type="text/css" href="../css/page.css?after">
	</style>
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

	// ctg 분리
	String ctg = request.getParameter("updateCtg");
	String[] ctgArray = ctg.split("_");
	String cartID = ctgArray[0];
	String type = ctgArray[1];

	// cartTBL 에 저장된 정보 불러오기
	String loadCart = "SELECT * FROM cartTBL WHERE cartID = ?";
	PreparedStatement pstmtLoad = con.prepareStatement(loadCart);
	pstmtLoad.setString(1, cartID);
	ResultSet rsLoad = pstmtLoad.executeQuery();
	rsLoad.next();

	String prodID = rsLoad.getString("prodID");
	int cartStock = rsLoad.getInt("cartStock");

	rsLoad.close();
	pstmtLoad.close();

	// 상품 정보 불러오기
	String loadPrd = "SELECT * FROM V_detail WHERE prodID = ?";
	PreparedStatement pstmtLoad2 = con.prepareStatement(loadPrd);
	pstmtLoad2.setString(1, prodID);
	ResultSet rsLoad2 = pstmtLoad2.executeQuery();
	rsLoad2.next();

	int prodStock = rsLoad2.getInt("prodStock");

	rsLoad2.close();
	pstmtLoad2.close();

	// 업데이트 판별
	String updateCart = "";
	String errorCode = "0";
	int stock;
	switch (type){
		case "addStock" :
			if(cartStock == 10 || prodStock <= cartStock) {
				errorCode = "MAX";
			}
			else {
				stock = (cartStock + 1);
				updateCart = "UPDATE cartTBL SET cartStock = ? WHERE cartID = ?";

				PreparedStatement pstmtAdd = con.prepareStatement(updateCart);
				pstmtAdd.setInt(1, stock);
				pstmtAdd.setString(2, cartID);

				pstmtAdd.executeUpdate();
				pstmtAdd.close();
			}
			break;
		case "subStock" :
			if(cartStock == 1) {
				errorCode = "MIN";
			}
			else {
				stock = (cartStock - 1);
				updateCart = "UPDATE cartTBL SET cartStock = ? WHERE (cartID = ?)";

				PreparedStatement pstmtSub = con.prepareStatement(updateCart);
				pstmtSub.setInt(1, stock);
				pstmtSub.setString(2, cartID);

				pstmtSub.executeUpdate();
				pstmtSub.close();
			}
			break;
		default:
			break;
	}
%>
<script>
	$(document).ready(function(){
		var message = "<%=errorCode%>";
		switch (message) {
			case "MAX" :
				alert("최대 수량입니다.");
				break;
			case "MIN" :
				alert("최소 수량입니다.");
				break;
			default : 
				break;
		}

		window.opener.parent.location.reload();
		window.close();
	});
</script>

<%
	con.close();
%>
</body>
</html>