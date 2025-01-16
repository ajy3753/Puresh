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
	<link rel="stylesheet" type="text/css" href="../css/sub.css?after">
</head>
<body>
 <!-- sub jsp -->
 <%
	request.setCharacterEncoding("UTF-8");
	
	// DB 연결
	String DB_URL = "jdbc:mysql://localhost:3306/pureshDB";
	String DB_ID = "pureshManager";
	String DB_PASSWORD = "1234";
	Class.forName("org.gjt.mm.mysql.Driver");
	Connection conOrderDetail = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

	// userID, orderName
	String id = (String)session.getAttribute("sid");
	if(id == null) {
		response.sendRedirect("login.jsp");
	}

	String orderName = request.getParameter("orderName");

	// orderDetail 변수
	String orderID;
	String prodID;
	String prodName;
	String prodImg;
	int orderStock;
	String orderComma;
	String orderStatus;
	String orderStart;
	String orderEnd;

	

	String payID;
	String orderer;
	String receiver;
	String receiverAddr;
	String receiverPhone;
	String payMethod;

	String methodBank = "";
	String methodAccount = "";
	String methodName = "";
	String methodDate = "";

	String refundBank = "";
	String refundAccount = "";
	String refundName = "";

	String payPrice;
	String deliveryCharge;
	String payPoint;
	String payTotal;
	String payDate;

	// pay 불러오기
	String payDetail= "SELECT * FROM V_payDetail WHERE userID = ? AND orderName= ?";
	PreparedStatement pstmtPD = conOrderDetail.prepareStatement(payDetail);
	pstmtPD.setString(1, id);
	pstmtPD.setString(2, orderName);
	ResultSet rsPD = pstmtPD.executeQuery();
	rsPD.next();

	payID = rsPD.getString("payID");

	// 배송 정보
	receiver = rsPD.getString("receiver");
	receiverAddr = rsPD.getString("receiverAddr");
	receiverPhone = rsPD.getString("receiverPhone");

	// 결제 정보 (필수)
	orderer = rsPD.getString("orderer");
	payMethod = rsPD.getString("payMethod");
	payPrice = rsPD.getString("FORMAT(orderTotal, 0)");
	deliveryCharge = rsPD.getString("FORMAT(deliveryCharge, 0)");
	payPoint = rsPD.getString("FORMAT(payPoint, 0)");
	payTotal = rsPD.getString("FORMAT(payTotal, 0)");

	rsPD.close();
	pstmtPD.close();

	// 추가 정보
	String payPlus= "SELECT * FROM V_payPlus WHERE userID = ? AND orderName= ?";
	PreparedStatement pstmtPlus = conOrderDetail.prepareStatement(payPlus);
	pstmtPlus.setString(1, id);
	pstmtPlus.setString(2, orderName);
	ResultSet rsPlus = pstmtPlus.executeQuery();
	rsPlus.next();

	String methodType = "";
	switch (payMethod) {
		case "무통장 입금" :
			methodType = "NoBankBook";
			methodBank = rsPlus.getString("methodBank");
			methodAccount  = rsPlus.getString("methodAccount");
			methodName  = rsPlus.getString("methodName");

			refundBank = rsPlus.getString("refundBank");
			refundAccount = rsPlus.getString("refundAccount");
			refundName = rsPlus.getString("refundName");
			break;
		case "카카오페이 송금" :
			methodType = "KakaoPayRemittance";
			methodName  = rsPlus.getString("methodName");
			methodDate = rsPlus.getString("methodDate");

			refundBank = rsPlus.getString("refundBank");
			refundAccount = rsPlus.getString("refundAccount");
			refundName = rsPlus.getString("refundName");
			break;
		default :
			break;
	}

	rsPlus.close();
	pstmtPlus.close();

	// order 불러오기
	String orderDetail = "SELECT * FROM V_orderDetail WHERE userID = ? AND orderName= ?";
	PreparedStatement pstmtOD = conOrderDetail.prepareStatement(orderDetail);
	pstmtOD.setString(1, id);
	pstmtOD.setString(2, orderName);
	ResultSet rsOD = pstmtOD.executeQuery();
%>
<script>
	$(document).ready(function(){
		var methodType = "<%=methodType%>";
		switch (methodType) {
			case "NoBankBook" :
				$("tr.methodType#" + methodType).css("display", "table-row");
				$("article#Refund").css("display", "flex");
				break;
			case "KakaoPayRemittance" :
				$("tr.methodType#" + methodType).css("display", "table-row");
				$("article#Refund").css("display", "flex");
				break;
			default :
				break;
		}		

		// updateOrder
		// #depositComplete (입금 완료 알림)
		$("button#depositComplete").click(function () {
			var sendData = "depositComplete_" + $(this).attr("value");
			let CQ = confirm("입금 완료 처리하시겠습니까?\n(※입금 확인에는 영업일 기준 평균 1~2일이 소요됩니다.)");
			if(CQ == true) {
				location.href = "../session/updateOrder.jsp?sendData=" + sendData;
			}
		});
		// #orderCancel (주문 취소)
		$("button#orderCancel").click(function () {
			var sendData = "orderCancel_" + $(this).attr("value");
			let CQ = confirm("주문을 취소하시겠습니까?\n(※함께 주문한 다른 상품도 일괄 취소됩니다.)");
			if(CQ == true) {
				location.href = "../session/updateOrder.jsp?sendData=" + sendData;
			}
		});
		// #orderComplete (구매 확정하기)
		$("button#orderComplete").click(function () {
			var sendData = "orderComplete_" + $(this).attr("value");
			let CQ = confirm("구매 확정하시겠습니까?\n(※확정 후에는 교환 및 반품이 불가능합니다.)");
			if(CQ == true) {
				location.href = "../session/updateOrder.jsp?sendData=" + sendData;
			}
		});

		// updatePay
		// #deliveryChange (배송지 변경)
		$("button#deliveryChange").click(function () {
			var sendData = "deliveryChange_" + $(this).attr("value");
			location.href = "mypage_orderModify.jsp?sendData=" + sendData;
		});
		// #refundChange (환불 계좌 변경)
		$("button#refundChange").click(function () {
			var sendData = "refundChange_" + $(this).attr("value");
			location.href = "mypage_orderModify.jsp?sendData=" + sendData;
		});

		// 그외
		// #depositInfo (송금 정보 확인)
		$("button#depositInfo").click(function () {
			var sendData = $(this).attr("value");
			location.href = "../orderOK.jsp?sendData=" + sendData;
		});
		// #deliveryInquiry (배송 조회)
		$("button#deliveryInquiry").click(function () {
			var sendData = $(this).attr("value");
			var URL = "../session/inquiryDelivery.jsp?sendData=" + sendData;
			window.open(URL, "배송 조회", "width=800, height=500, top=100, left=300");
		});
		// #reviewWrite (리뷰 작성/수정)
		$("button#reviewWrite").click(function () {
			var sendData = $(this).attr("value");
			var URL = "../sub/mypage_reviewWrite.jsp?sendData=" + sendData;
			window.open(URL, "리뷰 작성", "width=500, height=600, top=0, left=0");
		});
		// #orderRepurchase (재구매)
		$("button#orderRepurchase").click(function () {
			var sendData = "formProd_" + $(this).attr("value") + "_1";
			location.href = "../order.jsp?sendData=" + sendData;
		});

		// #orderRequest (교환/반품 신청)
		$("button#orderRequest").click(function () {
			location.href = "../sendAsk.jsp";
		});

		// #sendAsk (1:1 문의)
		$("button#sendAsk").click(function () {
			location.href = "../sendAsk.jsp";
		});
	});
</script>

<section class="orderDetail">
	<a class="header" href="../mypage.jsp?ctg=order">&#8592; 목록으로 돌아가기</a>
	<h1>
		주문번호&nbsp;
		<font color="#C81C21"><%=orderName%></font>
	</h1>
	
	<!-- 상품 주문 목록 -->
	<article class="Order">
		<%
			while(rsOD.next()) {
				orderID = rsOD.getString("orderID");
				prodID = rsOD.getString("prodID");
				prodName = rsOD.getString("prodName");
				prodImg = "../" + rsOD.getString("prodImg");
				orderStock = rsOD.getInt("orderStock");
				orderComma = rsOD.getString("FORMAT(orderTotal, 0)");
				orderStatus = rsOD.getString("orderStatus");
				orderStart = rsOD.getString("orderStart");
				orderEnd = rsOD.getString("DATE_FORMAT(orderEnd, '%Y-%m-%d')");
		%>
		<!-- 주문 상태, 주문번호 -->
		<span>
			<h2><%=orderStatus%></h2>
			<p><%=orderID%></p>
		</span>

		<!-- 상품 정보 -->
		<span>
			<a href="../prodDetail.jsp?prodID=<%=prodID%>"><img src="<%=prodImg%>"></a>
			<div>
				<ul>
					<li class="Start"><%=orderStart%></li>
					<li class="prdBold"><a href="../prodDetail.jsp?prodID=<%=prodID%>"><%=prodName%></a></li>
					<li class="prdBold"><%=orderComma%>원</li>
					<li>주문 수량 : <%=orderStock%>개</li>
					<%
						if (orderStatus.equals("입금 대기")) {
					%>
					<li class="btnOD">
						<button id="depositComplete" value="<%=orderName%>">입금 완료 알림</button>
						<button id="depositInfo" value="<%=methodType%>_<%=payID%>">송금 정보 확인</button>
						<button id="deliveryChange" value="<%=orderName%>">배송지 변경</button>
						<button id="orderCancel" value="<%=orderName%>">주문 취소</button>
						<button id="sendAsk" value="<%=orderID%>">문의하기</button>
					</li>
					<%
						}
						else if (orderStatus.equals("입금 확인 중") || orderStatus.equals("결제 완료")) {
					%>
					<li class="btnOD">
						<button id="deliveryChange" value="<%=orderName%>">배송지 변경</button>
						<button id="orderCancel" value="<%=orderName%>">주문 취소</button>
						<button id="sendAsk" value="<%=orderID%>">문의하기</button>
					</li>
					<%
						}
						else if (orderStatus.equals("배송 준비 중") || orderStatus.equals("배송 중") || orderStatus.equals("배송 완료")) {
					%>
					<li class="btnOD">
						<button class="light" id="orderComplete" value="<%=orderID%>">구매 확정하기</button>
						<button id="deliveryInquiry" value="<%=orderName%>">배송 조회</button>
						<button id="orderRequest" value="<%=orderID%>">교환/반품 신청</button>
						<button id="sendAsk" value="<%=orderID%>">문의하기</button>
					</li>
					<%
						}
						else if(orderStatus.equals("교환/반품 신청")) {
					%>
					<li class="btnOD">
						<button id="deliveryInquiry" value="<%=orderName%>">배송 조회</button>
						<button id="deliveryChange" value="<%=orderName%>">배송지 변경</button>
						<button id="refundChange" value="<%=orderName%>">환불 계좌 변경</button>
						<button id="sendAsk" value="<%=orderID%>">1:1 문의</button>
					</li>
					<%
						}
						else if(orderStatus.equals("구매 확정")) {
					%>
					<li class="End">구매 확정일 : <%=orderEnd%></li>
					<li class="btnOD">
						<button class="light" id="orderRepurchase" value="<%=prodID%>">재구매</button>
						<button id="deliveryInquiry" value="<%=orderName%>">배송 조회</button>
						<button id="reviewWrite" value="<%=prodID%>_<%=orderID%>">리뷰 작성</button>
						<button id="sendAsk" value="<%=orderID%>">문의하기</button>
					</li>
					<%
						}
						else if(orderStatus.equals("리뷰 완료")) {
					%>
					<li class="End">구매 확정일 : <%=orderEnd%></li>
					<li class="btnOD">
						<button class="light" id="orderRepurchase" value="<%=prodID%>">재구매</button>
						<button id="deliveryInquiry" value="<%=orderName%>">배송 조회</button>
						<button id="reviewWrite" value="<%=prodID%>_<%=orderID%>">리뷰 열람/수정</button>
						<button id="sendAsk" value="<%=orderID%>">문의하기</button>
					</li>
					<%
						}
						else {
					%>
					<li class="btnOD">
						<button class="light" id="orderRepurchase" value="<%=prodID%>">재구매</button>
						<button id="sendAsk" value="<%=orderID%>">문의하기</button>
					</li>
					<%
						}
					%>
				</ul>
			</div>
		</span>
		<hr>
		<%
			}
			rsOD.close();
			pstmtOD.close();
		%>
	</article>
	
	<!-- 배송 정보 -->
	<article class="Pay">
		<span><h2>배송 정보</h2></span>
		<div>
			<table>
				<tr>
					<th>수령인</th>
					<td><%=receiver%></td>
				</tr>
				<tr>
					<th>주소</th>
					<td><%=receiverAddr%></td>
				</tr>
				<tr>
					<th>연락처</th>
					<td><%=receiverPhone%></td>
				</tr>
			</table>
		</div>
	</article>

	<!-- 주문금액 -->
	<article class="Pay">
		<span>
			<h2>최종 결제금액</h2>
			<h3><%=payTotal%>원</h3>
		</span>
		<div>
			<table class="payTable">
				<tr>
					<th>상품 금액</th>
					<td><%=payPrice%></td>
				</tr>
				<tr>
					<th>배송비</th>
					<td>+ <%=deliveryCharge%></td>
				</tr>
				<tr>
					<th>포인트 사용</th>
					<td>- <%=payPoint%></td>
				</tr>
			</table>
		</div>
	</article>

	<!-- 결제 정보 -->
	<article class="Pay">
		<span><h2>결제 정보</h2></span>
		<div>
			<table>
				<tr>
					<th>결제수단</th>
					<td><%=payMethod%></td>
				</tr>
				<tr class="methodType" id="NoBankBook">
					<th>입금 계좌</th>
					<td><%=methodBank%>&ensp;|&ensp;<%=methodAccount%></td>
				</tr>
				<tr class="methodType" id="NoBankBook">
					<th>입금명</th>
					<td><%=methodName%></td>
				</tr>
				<tr class="methodType" id="KakaoPayRemittance">
					<th>입금명</th>
					<td><%=methodName%></td>
				</tr>
				<tr class="methodType" id="KakaoPayRemittance">
					<th>입금일</th>
					<td><%=methodDate%></td>
				</tr>
			</table>
		</div>
	</article>

	<!-- 환불 계좌 정보 -->
	<article class="Pay" id="Refund">
		<span><h2>환불 계좌 정보</h2></span>
		<div>
			<table>
				<tr>
					<th>계좌번호</th>
					<td><%=refundBank%>&ensp;|&ensp;<%=refundAccount%></td>
				</tr>
				<tr>
					<th>예금주명</th>
					<td><%=refundName%></td>
				</tr>
			</table>
		</div>
	</article>

	<!-- 이쯤에 푸터대용으로 뭔가의 버튼 같은걸 추가합시다. -->
	<a class="footer" href="#">&#8593; top</a>
</section>

<%
	conOrderDetail.close();
%>
</body>
</html>