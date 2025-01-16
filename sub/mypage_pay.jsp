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
	Connection conPay = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

	// userID
	String id = (String)session.getAttribute("sid"); 

	// pay 변수
	String payID;
	String orderName;
	String orderer;
	String payMethod;
	int payTotal;
	String payDate;

	int orderCount;
	String prodID;
	String prodName;

	String payComma = "";
	char[] comma;

	// listCount
	String payNN = "SELECT COUNT(payID) FROM payTBL WHERE userID = ?";
	PreparedStatement pstmtNN = conPay.prepareStatement(payNN);
	pstmtNN.setString(1, id);
	ResultSet rsNN = pstmtNN.executeQuery();
	rsNN.next();

	int listCount = rsNN.getInt("COUNT(payID)");

	rsNN.close();
	pstmtNN.close();

	// pay 목록 불러오기
	String payList = "SELECT * FROM V_payDetail WHERE userID = ?";
	PreparedStatement pstmtPay = conPay.prepareStatement(payList);
	pstmtPay.setString(1, id);
	ResultSet rsPay = pstmtPay.executeQuery();
%>
<script>
	$(document).ready(function(){
		// listCount 값이 0 일때
		var count = "<%=listCount%>";
		if(count == 0) {
			$(".mypageSub #listNN").css("display", "none");
			$(".mypageSub #listNot").css("display", "flex");
		}
	});
</script>

<h1>결제 내역</h1>
<div class="mypageSub">
	<table>
		<tr>
			<th>결제일</th>
			<th>주문번호</th>
			<th colspan="2">주문 내역</th>
			<th>결제 수단</th>
			<th>결제 금액</th>
		</tr>

		<!-- 주문 내역 -->
		<%
			while(rsPay.next()) {
				payID = rsPay.getString("payID");
				orderName = rsPay.getString("orderName");
				payMethod = rsPay.getString("payMethod");
				payComma = rsPay.getString("FORMAT(payTotal, 0)");
				payDate = rsPay.getString("DATE_FORMAT(payDate, '%Y-%m-%d %H:%i')");

				// orderName 별 주문 개수
				String loadStock = "SELECT COUNT(orderID) FROM V_orderDetail WHERE userID = ? AND orderName = ?";
				PreparedStatement pstmtLS = conPay.prepareStatement(loadStock);
				pstmtLS.setString(1, id);
				pstmtLS.setString(2, orderName);
				ResultSet rsLS = pstmtLS.executeQuery();
				rsLS.next();

				orderCount = rsLS.getInt("COUNT(orderID)");

				rsLS.close();
				pstmtLS.close();

				// orderName 그룹별로 상위 주문 1개만 출력
				String loadOrderID = "SELECT * FROM V_orderList WHERE userID = ? AND orderName = ? LIMIT 1";
				PreparedStatement pstmtID = conPay.prepareStatement(loadOrderID);
				pstmtID.setString(1, id);
				pstmtID.setString(2, orderName);
				ResultSet rsID = pstmtID.executeQuery();
				rsID.next();

				prodID = rsID.getString("prodID");

				rsID.close();
				pstmtID.close();

				// 상품 정보 불러오기
				String loadPrd = "SELECT * FROM V_detail WHERE prodID = ?";
				PreparedStatement pstmtLoad = conPay.prepareStatement(loadPrd);
				pstmtLoad.setString(1, prodID);
				ResultSet rsLoad = pstmtLoad.executeQuery();
				rsLoad.next();

				prodName = rsLoad.getString("prodName");

				rsLoad.close();
				pstmtLoad.close();
		%>
		<tr id="listNN">
			<td><%=payDate%></td>
			<td><%=orderName%></td>
			<td colspan="2">
				<%=prodName%>
				<%
					if(orderCount > 1) {
				%>
				&nbsp;포함&ensp;
				<font color="#39AE86">총&nbsp;<%=orderCount%>&nbsp;건</font>
				<%
					}
				%>
			</td>
			<td><%=payMethod%></td>
			<td><%=payComma%>원</td>
			<td class="orderLink"><a href="sub/mypage_orderDetail.jsp?orderName=<%=orderName%>">상세 조회</a></td>
		</tr>
		<%
			}
		%>
	</table>
	<p id="listNot">결제 내역이 없습니다.</p>
</div>

<%
		rsPay.close();
		pstmtPay.close();
		conPay.close();
%>
</body>
</html>