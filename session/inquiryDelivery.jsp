<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<title>Puresh - 배송 조회</title>
	<!-- 웹폰트 연결 (앨리스 디지털 배움체) -->
	<link href="https://font.elice.io/css?family=Elice+Digital+Baeum" rel="stylesheet">
	<!-- jQuery 라이브러리 연결 -->
	<script src="https://code.jquery.com/jquery-3.6.3.js"></script>
	<script src="../css/jQuery.js"></script>
	<!-- 외부CSS 파일 연결 -->
	<link rel="stylesheet" type="text/css" href="../css/main.css?after">
	<link rel="stylesheet" type="text/css" href="../css/sub.css?after">
	<style>
		body {
			width: 100%;
			height: 100%;
		}
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

	// 로그인 여부 및 유저 아이디 값
	String id = (String)session.getAttribute("sid");

	// orderName
	String orderName = (String)request.getParameter("sendData");

	// order 변수
	int orderStock;
	String deliveryNumber;

	String prodID;
	String prodName;
	String prodImg;
%>
<script>
	$(document).ready(function(){
		// 배송 조회 버튼
		$("button#btnNumber").click(function () {
			var number = $(this).attr("value");
			if(number == "NN") {
				alert("등록된 운송장 번호가 없습니다.")
			}
			else {
				var URL = "https://trace.cjlogistics.com/web/detail.jsp?slipno=" + number;
				$("aside").css("display", "flex");
				$("iframe").attr("src", URL);
			}
		});
	});
</script>

<section class="inquiryDelivery">
	<h1>
		주문번호&nbsp;
		<font color="#C81C21"><%=orderName%></font>
		&nbsp;배송 조회
	</h1>

	<!-- 주문 내역 -->
	<article>
		<table>
			<%
				String loadOrder = "SELECT * FROM V_orderList WHERE userID = ? AND orderName = ?";
				PreparedStatement pstmtLoad = con.prepareStatement(loadOrder);
				pstmtLoad.setString(1, id);
				pstmtLoad.setString(2, orderName);
				ResultSet rsLoad = pstmtLoad.executeQuery();
				while(rsLoad.next()) {
					prodID = rsLoad.getString("prodID");
					prodName = rsLoad.getString("prodName");
					prodImg = rsLoad.getString("prodImg");
					orderStock = rsLoad.getInt("orderStock");
					deliveryNumber = rsLoad.getString("IFNULL(deliveryNumber, '운송장 미등록')");
			%>
			<tr>
				<th rowspan="3"><a href="../prodDetail.jsp?prodID=<%=prodID%>"><img src="../<%=prodImg%>"></a></th>
				<td><b><%=prodName%></b></td>
			</tr>
			<tr>
				<td>주문 수량 : <%=orderStock%>개</td>
			</tr>
			<%
					if(deliveryNumber.equals("운송장 미등록")) {
			%>
			<tr>
				<td><%=deliveryNumber%></td>
				<td><button id="btnNumber" value="NN">조회</button></td>
			</tr>
			<%
					}
					else {
			%>
			<tr>
				<td>CJ대한통운 <%=deliveryNumber%></td>
				<td><button id="btnNumber" value="<%=deliveryNumber%>">조회</button></td>
			</tr>
			<%
					}
				}	
			%>
		</table>
	</article>
	
	<!-- 배송 조회 내역-->
	<aside>
		<iframe src="https://trace.cjlogistics.com/web/detail.jsp?slipno="></iframe>
	</aside>
</section>

<%
	con.close();
%>
</body>
</html>