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
	Connection conOrder = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

	// userID
	String id = (String)session.getAttribute("sid"); 

	// order 변수
	String orderID;
	String prodID;
	String orderName;
	int orderStock;
	String orderStatus;
	String orderStart;

	int idCount = 0;

	String prodName;
	String prodCtg;
	String prodImg;

	// listCount
	String orderNN = "SELECT COUNT(orderName) FROM V_orderList WHERE userID = ?";
	PreparedStatement pstmtNN = conOrder.prepareStatement(orderNN);
	pstmtNN.setString(1, id);
	ResultSet rsNN = pstmtNN.executeQuery();
	rsNN.next();

	int listCount = rsNN.getInt("COUNT(orderName)");

	rsNN.close();
	pstmtNN.close();


	// order 목록 불러오기
	String orderList = "SELECT orderName, COUNT(orderID) FROM V_orderList WHERE userID = ? GROUP BY orderName ORDER BY orderName DESC";
	PreparedStatement pstmtOrder = conOrder.prepareStatement(orderList);
	pstmtOrder.setString(1, id);
	ResultSet rsOrder = pstmtOrder.executeQuery();
%>
<script>
	$(document).ready(function(){
		// listCount 값이 0 일때
		var count = "<%=listCount%>";
		if(count == 0) {
			$(".mypageSub #listNN").css("display", "none");
			$(".mypageSub #listNot").css("display", "flex");
		}

		// orderDetail 이동
		$(".orderStart a").click(function () {
			var URL = "sub/mypage_orderDetail.jsp?orderName=" + $(this).text();
			location.href = URL;
		});

		// #depositComplete (입금 완료 알림)
		$("button#depositComplete").click(function () {
			var sendData = "depositComplete_" + $(this).attr("value");
			let CQ = confirm("입금 완료 처리하시겠습니까?\n(※입금 확인에는 영업일 기준 평균 1~2일이 소요됩니다.)");
			if(CQ == true) {
				location.href = "session/updateOrder.jsp?sendData=" + sendData;
			}
		});

		// #orderCancel (주문 취소)
		$("button#orderCancel").click(function () {
			var sendData = "orderCancel_" + $(this).attr("value");
			let CQ = confirm("주문을 취소하시겠습니까?\n(※함께 주문한 다른 상품도 일괄 취소됩니다.)");
			if(CQ == true) {
				location.href = "session/updateOrder.jsp?sendData=" + sendData;
			}
		});

		// #depositInfo (송금 정보)
		$("button#depositInfo").click(function () {
			var sendData = $(this).attr("value");
			location.href = "orderOK.jsp?sendData=" + sendData;
		});

		// #deliveryInquiry (배송 조회)
		$("button#deliveryInquiry").click(function () {
			var sendData = $(this).attr("value");
			var URL = "session/inquiryDelivery.jsp?sendData=" + sendData;
			window.open(URL, "배송 조회", "width=800, height=500, top=100, left=300");
		});

		// #reviewWrite (리뷰 작성)
		$("button#reviewWrite").click(function () {
			var sendData = $(this).attr("value");
			var URL = "sub/mypage_reviewWrite.jsp?sendData=" + sendData;
			window.open(URL, "리뷰 작성", "width=500, height=600, top=0, left=0");
		});

		// #orderRepurchase (재구매)
		$("button#orderRepurchase").click(function () {
			var sendData = "formProd_" + $(this).attr("value") + "_1";
			location.href = "order.jsp?sendData=" + sendData;
		});

		// #sendAsk (1:1 문의)
		$("button#sendAsk").click(function () {
			location.href = "sendAsk.jsp";
		});
	});
</script>

<h1>주문확인 / 배송조회</h1>
<div class="mypageSub">
	<table>
		<tr>
			<th>주문번호</th>
			<th colspan="2">주문상품</th>
			<th>주문수량</th>
			<th>주문금액</th>
			<th colspan="2">주문상태</th>
		</tr>

		<!-- 주문 내역 -->
		<%
			while(rsOrder.next()) {
				orderName =  rsOrder.getString("orderName");
				idCount = rsOrder.getInt("COUNT(orderID)");

				// orderName 그룹별로 상위 주문 1개만 출력
				String loadOrder = "SELECT * FROM V_orderList WHERE userID = ? AND orderName = ? LIMIT 1";
				PreparedStatement pstmtLoad = conOrder.prepareStatement(loadOrder);
				pstmtLoad.setString(1, id);
				pstmtLoad.setString(2, orderName);
				ResultSet rsLoad = pstmtLoad.executeQuery();
				rsLoad.next();

				orderID = rsLoad.getString("orderID");
				prodID = rsLoad.getString("prodID");
				prodName = rsLoad.getString("prodName");
				prodCtg = rsLoad.getString("prodCtg");
				prodImg = rsLoad.getString("prodImg");
				orderStock = rsLoad.getInt("orderStock");
				orderStatus = rsLoad.getString("orderStatus");
				orderStart = rsLoad.getString("DATE_FORMAT(orderStart, '%Y-%m-%d %H:%i')");

				rsLoad.close();
				pstmtLoad.close();

				// pay 정보 불러오기
				String loadPay = "SELECT * FROM V_payDetail WHERE userID = ? AND orderName = ?";
				PreparedStatement pstmtPay = conOrder.prepareStatement(loadPay);
				pstmtPay.setString(1, id);
				pstmtPay.setString(2, orderName);
				ResultSet rsPay = pstmtPay.executeQuery();
				rsPay.next();

				String payID = rsPay.getString("payID");
				String payMethod = rsPay.getString("payMethod");
				String payTotal = rsPay.getString("FORMAT(payTotal, 0)");

				rsPay.close();
				pstmtPay.close();

				switch (payMethod) {
					case "무통장 입금" :
						payMethod = "NoBankBook";
						break;
					case "카카오페이 송금" :
						payMethod = "KakaoPayRemittance";
						break;
					default :
						break;
				}
		%>
		<tr id="listNN">
			<!-- 주문번호 -->
			<td class="orderStart">
				<a><%=orderName%></a>
				<p><%=orderStart%></p>
			</td>

			<!-- 상품 이미지 -->
			<td>
				<a href="prodDetail.jsp?prodID=<%=prodID%>"><img src="<%=prodImg%>"></a>
			</td>

			<!-- 주문 상품 -->
			<td class="orderOption">
				<p><a style="color: #D6684C;" href="prodList.jsp?ctg=<%=prodCtg%>"><%=prodCtg%></a></p>
				<p style="font-weight: bold;"><a href="prodDetail.jsp?prodID=<%=prodID%>"><%=prodName%></a></p>
				<%
					if(idCount > 1) {
				%>
				<p>포함 <font color="#39AE86">총&nbsp;<%=idCount%>&nbsp;건</font></p>
				<%
					}	
				%>
			</td>

			<!-- 주문수량, 주문금액 -->
			<td><%=orderStock%></td>
			<td><%=payTotal%>원</td>

			<!-- 주문 상태 -->
			<td><%=orderStatus%></td>
			<td class="myOrderBtn">
				<%
					if (orderStatus.equals("입금 대기")) {
				%>
				<button id="depositComplete" value="<%=orderName%>">입금 완료 알림</button>
				<button id="depositInfo" value="<%=payMethod%>_<%=payID%>">송금 정보</button>
				<button id="sendAsk">1:1 문의</button>
				<%
					}
					else if (orderStatus.equals("입금 확인 중") || orderStatus.equals("결제 완료")) {
				%>
				<button id="orderCancel" value="<%=orderName%>">주문 취소</button>
				<button id="sendAsk">1:1 문의</button>
				<%
					}
					else if (orderStatus.equals("배송 준비 중") || orderStatus.equals("배송 중") || orderStatus.equals("배송 완료") || orderStatus.equals("교환/환불 진행 중")) {
				%>
				<button id="deliveryInquiry" value="<%=orderName%>">배송 조회</button>
				<button id="sendAsk">1:1 문의</button>
				<%
					}
					else if(orderStatus.equals("구매 확정")) {
				%>
				<button id="reviewWrite" value="<%=prodID%>_<%=orderID%>">리뷰 작성</button>
				<button id="sendAsk">1:1 문의</button>
				<%
					}
					else {
				%>
				<button class="light" id="orderRepurchase" value="<%=prodID%>">재구매</button>
				<button id="sendAsk">1:1 문의</button>
				<%
					}
				%>
			</td>
		</tr>
		<%
			}
		%>
	</table>
	<p id="listNot">주문 내역이 없습니다.</p>
</div>

<%
	rsOrder.close();
	pstmtOrder.close();
	conOrder.close();
%>
