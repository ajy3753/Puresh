<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!-- sub jsp -->
<%
	request.setCharacterEncoding("UTF-8");
	
	// DB 연결
	String DB_URL = "jdbc:mysql://localhost:3306/pureshDB";
	String DB_ID = "pureshManager";
	String DB_PASSWORD = "1234";
	Class.forName("org.gjt.mm.mysql.Driver");
	Connection conSub = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

	// 로그인 여부
	String managerID = (String)session.getAttribute("managerSID");

	// orderList 변수
	String orderID;
	String userID;
	String RPAD_userID;
	String orderName;
	int orderStock;
	String totalComma;
	String orderStatus;
	String orderStart;

	// 전체 주문 카운트
	String orderCount = "SELECT COUNT(*) FROM V_orderListSub";
	PreparedStatement pstmtCount = conSub.prepareStatement(orderCount);
	ResultSet rsCount = pstmtCount.executeQuery();
	rsCount.next();

	int listCount = rsCount.getInt("COUNT(*)");

	rsCount.close();
	pstmtCount.close();

	// orderList 불러오기
	String orderList = "SELECT * FROM V_orderListSub";
	PreparedStatement pstmtSub = conSub.prepareStatement(orderList);
	ResultSet rsSub = pstmtSub.executeQuery();
%>
<script>
	$(document).ready(function(){
		// #btnUpdate (상품 수정)
		$("#orderList button#btnUpdate").click(function () {
			var sendData = $(this).attr("value");
			location.href = "pureshManager.jsp?ctg=order_orderDetail_?sendData=" + sendData;
		});
	});
</script>

<h1 class="mainHeader">주문 관리</h1>

<!-- 소분류 탭 -->
<aside>
	<ul>
		<li  id="orderList" class="On"><a href="pureshManager.jsp?ctg=order_orderList">전체 주문 목록</a></li>
		<li id="delievery"><a href="pureshManager.jsp?ctg=order_delievery">배송 상황</a></li>
	</ul>
</aside>

<!-- orderList -->
<article>
	<table class="listTBL" id="orderList">
		<tr class="tableHeader">
			<th>No</th>
			<th>주문고유번호</th>
			<th>아이디</th>
			<th>주문수량</th>
			<th>주문금액</th>
			<th>주문상태</th>
			<th>주문일</th>
			<th>상세 열람</th>
		</tr>
		<%
			while(rsSub.next()) {
				orderID = rsSub.getString("orderID");
				userID = rsSub.getString("userID");
				RPAD_userID = rsSub.getString("RPAD_userID");
				orderName = rsSub.getString("orderName");
				orderStock = rsSub.getInt("orderStock");
				totalComma = rsSub.getString("totalComma");
				orderStatus = rsSub.getString("orderStatus");
				orderStart = rsSub.getString("orderStart");
		%>
		<tr>
			<td class="small"><%=listCount%></td>
			<td><%=orderID%></td>
			<td><%=RPAD_userID%></td>
			<td><%=orderStock%>개</td>
			<td><%=totalComma%>원</td>
			<td><%=orderStatus%></td>
			<td><%=orderStart%></td>
			<td><button id="btnUpdate" value="<%=userID%>/<%=orderName%>">보기</button></td>
		</tr>
		<%
				listCount--;
			}
		%>
	</table>
</article>

<%
	rsSub.close();
	pstmtSub.close();
	conSub.close();
%>