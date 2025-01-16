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
	Connection conReview = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

	// userID
	String id = (String)session.getAttribute("sid");

	// order 변수
	String orderID;
	String orderName;
	int orderStock;
	String prodID;
	String prodName;
	String prodCtg;
	String prodImg;
	String orderStatus;
	String orderEnd;

	// listCount
	String orderNN = "SELECT COUNT(prodID) FROM V_orderList WHERE userID = ? AND orderStatus = '구매 확정'";
	PreparedStatement pstmtNN = conReview.prepareStatement(orderNN);
	pstmtNN.setString(1, id);
	ResultSet rsNN = pstmtNN.executeQuery();
	rsNN.next();

	int listCount = rsNN.getInt("COUNT(prodID)");

	rsNN.close();
	pstmtNN.close();
%>
<script>
	$(document).ready(function(){
		// listCount 값이 0 일때
		var count = "<%=listCount%>";
		if(count == 0) {
			$(".mypageSub #listNN").css("display", "none");
			$(".mypageSub #listNot").css("display", "flex");
		}

		// #deliveryInquiry (배송 조회)
		$("button#deliveryInquiry").click(function () {
			var sendData = $(this).attr("value");
			var URL = "session/inquiryDelivery.jsp?sendData=" + sendData;
			window.open(URL, "배송 조회", "width=800, height=500, top=100, left=300");
		});

		// #orderComplete (구매 확정하기)
		$("button#orderComplete").click(function () {
			var sendData = "orderComplete_" + $(this).attr("value");
			let CQ = confirm("구매 확정하시겠습니까?\n(※확정 후에는 교환 및 반품이 불가능합니다.)");
			if(CQ == true) {
				location.href = "session/updateOrder.jsp?sendData=" + sendData;
			}
		});

		// #reviewWrite (리뷰 작성)
		$("button#reviewWrite").click(function () {
			var sendData = $(this).attr("value");
			var URL = "sub/mypage_reviewWrite.jsp?sendData=" + sendData;
			window.open(URL, "리뷰 작성", "width=500, height=600, top=0, left=0");
		});
	});
</script>

<h1>작성 가능한 리뷰</h1>
<div class="mypageSub">
	<!-- 구매 확정 리스트 -->
	<table id="listNN" class="reviewTBL">
		<tr>
			<th>주문번호</th>
			<th colspan="2">주문상품</th>
			<th>구매 확정일</th>
			<th colspan="2">리뷰 작성</th>
		</tr>

		<!-- 주문 목록 -->
		<%
			String writeList = "SELECT * FROM V_orderDetail WHERE userID = ? AND orderStatus = '구매 확정'";
			PreparedStatement pstmtList = conReview.prepareStatement(writeList);
			pstmtList.setString(1, id);
			ResultSet rsList = pstmtList.executeQuery();

			while(rsList.next()) {
				orderID = rsList.getString("orderID");
				orderName = rsList.getString("orderName");
				orderStock = rsList.getInt("orderStock");
				prodID = rsList.getString("prodID");
				prodName = rsList.getString("prodName");
				prodImg = rsList.getString("prodImg");
				orderEnd = rsList.getString("DATE_FORMAT(orderEnd, '%Y-%m-%d')");
		%>
		<tr id="listNN">
			<!-- 주문번호 -->
			<td class="orderStart">
				<a href="sub/mypage_orderDetail.jsp?orderName=<%=orderName%>"><%=orderName%></a>
			</td>

			<!-- 상품 이미지 -->
			<td>
				<a href="prodDetail.jsp?prodID=<%=prodID%>"><img src="<%=prodImg%>"></a>
			</td>

			<!-- 주문 상품 -->
			<td>
				<p style="font-weight: bold;"><a href="prodDetail.jsp?prodID=<%=prodID%>"><%=prodName%></a></p>
				<p>주문 수량 : <%=orderStock%>개</p>
			</td>
			
			<!-- 구매 확정 일자 -->
			<td><%=orderEnd%></td>

			<!-- 리뷰 작성 -->
			<td><button id="reviewWrite" value="<%=prodID%>_<%=orderID%>">리뷰 작성하기</button></td>
		</tr>
		<%
			}
			rsList.close();
			pstmtList.close();
		%>
	</table>

	<!-- 작성 가능 리뷰 없음 -->
	<div id="listNot" class="reviewTBL">
		<table>
			<tr>
				<th>주문번호</th>
				<th colspan="2">주문상품</th>
				<th>주문수량</th>
				<th>주문상태</th>
				<th colspan="2">구매확정 / 배송조회</th>
			</tr>

			<!-- 주문 목록 (배송 중, 배송 완료) -->
			<%
				String orderList = "SELECT * FROM V_orderList WHERE userID = ? AND orderStatus IN ('배송 중', '배송 완료')";
				PreparedStatement pstmtOrder = conReview.prepareStatement(orderList);
				pstmtOrder.setString(1, id);
				ResultSet rsOrder = pstmtOrder.executeQuery();

				while(rsOrder.next()) {
					orderID = rsOrder.getString("orderID");
					orderName = rsOrder.getString("orderName");
					orderStock = rsOrder.getInt("orderStock");
					orderStatus = rsOrder.getString("orderStatus");
					prodID = rsOrder.getString("prodID");
					prodName = rsOrder.getString("prodName");
					prodCtg = rsOrder.getString("prodCtg");
					prodImg = rsOrder.getString("prodImg");
			%>
			<tr>
				<!-- 주문번호 -->
				<td class="orderStart">
					<a href="sub/mypage_orderDetail.jsp?orderName=<%=orderName%>"><%=orderName%></a>
				</td>

				<!-- 상품 이미지 -->
				<td>
					<a href="prodDetail.jsp?prodID=<%=prodID%>"><img src="<%=prodImg%>"></a>
				</td>

				<!-- 주문 상품 -->
				<td>
					<p><a style="color: #D6684C;" href="prodList.jsp?ctg=<%=prodCtg%>"><%=prodCtg%></a></p>
					<p style="font-weight: bold;"><a href="prodDetail.jsp?prodID=<%=prodID%>"><%=prodName%></a></p>
				</td>

				<!-- 주문 수량, 주문 상태 -->
				<td><%=orderStock%></td>
				<td><%=orderStatus%></td>

				<!-- 리뷰 작성 -->
				<td>
					<button class="light" id="orderComplete" value="<%=orderID%>">구매 확정</button>
					<button id="deliveryInquiry" value="<%=orderName%>">배송 조회</button>
				</td>
			</tr>
			<%
				}
				rsOrder.close();
				pstmtOrder.close();
			%>
		</table>
	</div>
</div>

<%
	conReview.close();
%>
</body>
</html>