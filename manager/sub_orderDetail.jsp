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

	// sendData
	String sendData = request.getParameter("sendData");
	String[] dataArray = sendData.split("/");
	String userID = dataArray[0];
	String orderName = dataArray[1];

	// orderList 변수
	String orderID;
	String prodName;
	String priceComma;
	int orderStock;
	String totalComma;
	String orderStatus;
	String orderStart;
	String deliveryNumber;
	String orderEnd;

	int listCount = 1;

	// orderList 불러오기
	String orderList = "SELECT * FROM V_orderDetailSub WHERE userID = ? AND orderName = ?";
	PreparedStatement pstmtSub = conSub.prepareStatement(orderList);
	pstmtSub.setString(1, userID);
	pstmtSub.setString(2, orderName);
	ResultSet rsSub = pstmtSub.executeQuery();
%>
<script>
	$(document).ready(function(){
	});
</script>

<h1 class="mainHeader">주문 관리</h1>
<h2 class="backLink"><a href="pureshManager.jsp?ctg=order_orderList">&#8672; 주문 목록으로 돌아가기</a></h2>

<!-- orderDetail -->
<article id="orderDetail">
	<table class="formTBL">
			<tr class="orderName">
				<th>주문명</th>
				<td><input type="text" value="<%=orderName%>" readonly></td>
				<th>주문 아이디</th>
				<td><input type="text" value="<%=userID%>" readonly></td>
			</tr>
			<%
				while (rsSub.next()) {
					orderID = rsSub.getString("orderID");
					prodName = rsSub.getString("prodName");
					priceComma = rsSub.getString("priceComma");
					orderStock = rsSub.getInt("orderStock");
					totalComma = rsSub.getString("totalComma");
					orderStatus = rsSub.getString("orderStatus");
					orderStart = rsSub.getString("orderStart");
					deliveryNumber = rsSub.getString("deliveryNumber");
					orderEnd = rsSub.getString("orderEnd");
			%>
			<tr class="orderID">
				<th>주문번호</th>
				<td><input type="text" value="<%=listCount%>" readonly></td>
				<th>주문고유번호</th>
				<td><input type="text" value="<%=orderID%>" readonly></td>
			</tr>
			<tr>
				<th>주문 상품</th>
				<td><input type="text" value="<%=prodName%>" readonly></td>
				<th>주문 가격</th>
				<td><input type="text" value="<%=priceComma%>" style="text-align: right;" readonly>&ensp;원</td>
			</tr>
			<tr>
				<th>주문 수량</th>
				<td><input type="text" value="<%=orderStock%>" style="text-align: right;" readonly>&ensp;개</td>
				<th>총 주문 금액</th>
				<td><input type="text" value="<%=totalComma%>" style="text-align: right;" readonly>&ensp;원</td>
			</tr>
			<tr>
				<th>주문 상태</th>
				<td><input type="text" value="<%=orderStatus%>" readonly></td>
				<th>운송장 번호</th>
				<td><input type="text" value="<%=deliveryNumber%>" readonly></td>
			</tr>
			<tr style="border-bottom: 0.1vw dashed #FF6653;">
				<th>주문일</th>
				<td><input type="text" value="<%=orderStart%>" readonly></td>
				<th>구매확정일</th>
				<td><input type="text" value="<%=orderEnd%>" readonly></td>
			</tr>
			<%
					listCount++;
				}
				rsSub.close();
				pstmtSub.close();
			%>
		</table>
	</form>
</article>

<%
	conSub.close();
%>