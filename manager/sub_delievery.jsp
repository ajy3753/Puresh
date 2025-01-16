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
	String orderName;
	String receiver;
	String receiverPhone;
	String deliveryNumber;
	String orderStatus;
	String orderStart;

	// 전체 주문 카운트
	String orderCount = "SELECT COUNT(*) FROM V_delivery";
	PreparedStatement pstmtCount = conSub.prepareStatement(orderCount);
	ResultSet rsCount = pstmtCount.executeQuery();
	rsCount.next();

	int listCount = rsCount.getInt("COUNT(*)");

	rsCount.close();
	pstmtCount.close();

	// orderList 불러오기
	String orderList = "SELECT * FROM V_delivery";
	PreparedStatement pstmtSub = conSub.prepareStatement(orderList);
	ResultSet rsSub = pstmtSub.executeQuery();
%>
<script>
	$(document).ready(function(){
	});
</script>

<h1 class="mainHeader">주문 관리</h1>

<!-- 소분류 탭 -->
<aside>
	<ul>
		<li  id="orderList"><a href="pureshManager.jsp?ctg=order_orderList">전체 주문 목록</a></li>
		<li id="delievery" class="On"><a href="pureshManager.jsp?ctg=order_delievery">배송 상황</a></li>
	</ul>
</aside>

<!-- orderList -->
<article>
	<table class="listTBL" id="orderList">
		<tr class="tableHeader">
			<th>No</th>
			<th>주문고유번호</th>
			<th>주문명</th>
			<th>받는 이</th>
			<th>연락처</th>
			<th>배송상태</th>
			<th>운송장 번호</th>
			<th>주문일</th>
		</tr>
		<%
			while(rsSub.next()) {
				orderID = rsSub.getString("orderID");
				orderName = rsSub.getString("orderName");
				receiver = rsSub.getString("RPAD_receiver");
				receiverPhone = rsSub.getString("receiverPhone");
				orderStatus = rsSub.getString("orderStatus");
				deliveryNumber = rsSub.getString("deliveryNumber");
				orderStart = rsSub.getString("orderStart");
		%>
		<tr>
			<td class="small"><%=listCount%></td>
			<td><%=orderID%></td>
			<td><%=orderName%></td>
			<td><%=receiver%></td>
			<td><%=receiverPhone%></td>
			<td><%=orderStatus%></td>
			<td><%=deliveryNumber%></td>
			<td><%=orderStart%></td>
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