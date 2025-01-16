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
 <!-- jsp -->
<%
	request.setCharacterEncoding("UTF-8");
	
	// DB 연결
	String DB_URL = "jdbc:mysql://localhost:3306/pureshDB";
	String DB_ID = "pureshManager";
	String DB_PASSWORD = "1234";
	Class.forName("org.gjt.mm.mysql.Driver");
	Connection conOrderModify = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

	// userID
	String id = (String)session.getAttribute("sid");
	if(id == null) {
		response.sendRedirect("login.jsp");
	}

	// sendData
	String sendData = request.getParameter("sendData");
	String[] dataArray = sendData.split("_");
	String type = dataArray[0];
	String orderName = dataArray[1];

	// pay 정보 불러오기
	String payDetail = "SELECT * FROM V_payDetail WHERE userID = ? AND orderName = ?";
	PreparedStatement pstmtPD = conOrderModify.prepareStatement(payDetail);
	pstmtPD.setString(1, id);
	pstmtPD.setString(2, orderName);
	ResultSet rsPD = pstmtPD.executeQuery();
	rsPD.next();

	String payID = rsPD.getString("payID");
	String receiver = rsPD.getString("receiver");
	String receiverAddr = rsPD.getString("receiverAddr");
	String receiverPhone = rsPD.getString("receiverPhone");
	String payMethod = rsPD.getString("payMethod");

	rsPD.close();
	pstmtPD.close();

	String[] phArray = receiverPhone.split("-");
	String ph1 = phArray[0];
	int ph2 = Integer.parseInt(phArray[1]);
	int ph3 = Integer.parseInt(phArray[2]);

	// 추가 정보
	String payPlus= "SELECT * FROM V_payPlus WHERE userID = ? AND orderName= ?";
	PreparedStatement pstmtPlus = conOrderModify.prepareStatement(payPlus);
	pstmtPlus.setString(1, id);
	pstmtPlus.setString(2, orderName);
	ResultSet rsPlus = pstmtPlus.executeQuery();
	rsPlus.next();

	String methodType = "";
	String refundBank = "";
	String refundAccount = "";
	String refundName = "";

	switch (payMethod) {
		case "무통장 입금" :
			methodType = "NoBankBook";
			refundBank = rsPlus.getString("refundBank");
			refundAccount = rsPlus.getString("refundAccount");
			refundName = rsPlus.getString("refundName");
			break;
		case "카카오페이 송금" :
			methodType = "KakaoPayRemittance";
			refundBank = rsPlus.getString("refundBank");
			refundAccount = rsPlus.getString("refundAccount");
			refundName = rsPlus.getString("refundName");
			break;
		default :
			methodType = "NN";
			break;
	}

	rsPlus.close();
	pstmtPlus.close();
%>
<script>
	$(document).ready(function(){
		// 수정 항목
		var type = "<%=type%>"
		switch (type) {
			case "deliveryChange" :
				$(".orderDetail article").eq(0).css("display", "flex");
				$(".orderDetail article").eq(1).css("display", "none");
				break;
			case "refundChange" :
				$(".orderDetail article").eq(0).css("display", "none");
				$(".orderDetail article").eq(1).css("display", "flex");
				
				var methodType = "<%=methodType%>";
				if(methodType = NN) {
					alert("등록된 환불 계좌 정보가 없습니다.");
					history.back();
				}
				break;
			default:
				break;
		}

		// 전번 채우기
		var ph1 = "<%=ph1%>";
		$(".orderInfo tr.short td select").val(ph1).prop("checked", true);

	});
	// input number 글자수 제한
	function handleOnInput(el, maxlength) {
	  if(el.value.length > maxlength)  {
		el.value 
		  = el.value.substr(0, maxlength);
	  }
	}
</script>

<section class="orderDetail">
	<a class="header" href="mypage_orderDetail.jsp?orderName=<%=orderName%>">&#8592; 주문 상세로 돌아가기</a>

	<!-- 배송지 변경 -->
	<article class="Pay">
		<!-- 기존 배송 정보 -->
		<span><h2>기존 배송 정보</h2></span>
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

		<!-- 수정 정보 -->
		<form action="../session/updatePay.jsp">
			<span><h2>배송 정보 수정</h2></span>
			<input type="hidden" name="type" value="deliveryChange">
			<input type="hidden" name="payID" value="<%=payID%>">

			<table class="orderInfo">
				<!-- 배송 정보 -->
				<tr>
					<th>수령인<font color="#C81C21">*</font></th>
					<td><input type="text" id="receiver" name="receiver" value="<%=receiver%>" maxlength="20" placeholder="최대 20자"></td>
				</tr>
				<tr>
					<th>배송 주소<font color="#C81C21">*</font></th>
					<td><input type="text" name="receiverAddr" value="<%=receiverAddr%>"></td>
				</tr>
				<tr class="short">
					<th>연락처<font color="#C81C21">*</font></th>
					<td colspan="3">
						<select name="receiverPh1">
							<option value="010">010</option>
							<option value="011">011</option>
							<option value="016">016</option>
							<option value="017">017</option>
							<option value="018">018</option>
							<option value="019">019</option>
						</select>
						<b>&ensp;-&ensp;</b>
						<input type="number" name="receiverPh2" value="<%=ph2%>" oninput="handleOnInput(this, 4)" required>
						<b>&ensp;-&ensp;</b>
						<input type="number" name="receiverPh3" value="<%=ph3%>" oninput="handleOnInput(this, 4)" required>
					</td>
				</tr>
			</table>

			<button type="submit">수정 완료</button>
		</form>
	</article>

	<!-- 환불 계좌 수정 -->
	<article class="Pay" id="Refund">
		<!-- 기존 환불 계좌 정보 -->
		<span><h2>기존 환불 계좌 정보</h2></span>
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

		<!-- 수정 정보 -->
		<form action="../session/updatePay.jsp">
			<span><h2>환불 계좌 수정</h2></span>
			<input type="hidden" name="type" value="refundChange">
			<input type="hidden" name="payID" value="<%=payID%>">

			<table class="orderInfo">
				<tr class="short">
					<th>계좌번호<font color="#C81C21">*</font></th>
					<td>
						<select id="Bank" name="refundBank">
							<option value="KB국민은행">KB국민은행</option>
							<option value="NH농협">NH농협</option>
							<option value="MG새마을금고">MG새마을금고</option>
							<option value="KEB하나은행">KEB하나은행</option>
							<option value="IBK기업은행">IBK기업은행</option>
							<option value="신한은행">신한은행</option>
							<option value="우리은행">우리은행</option>
							<option value="카카오뱅크">카카오뱅크</option>
							<option value="케이뱅크">케이뱅크</option>
							<option value="토스뱅크">토스뱅크</option>
						</select>
						<input type="number" name="refundAccount1" oninput="handleOnInput(this, 6)">&nbsp;-&nbsp
						<input type="number" name="refundAccount2" oninput="handleOnInput(this, 6)">&nbsp;-&nbsp
						<input type="number" name="refundAccount3" oninput="handleOnInput(this, 7)">
					</td>
				</tr>
				<tr>
					<th>예금주명<font color="#C81C21">*</font></th>
					<td><input type="text" name="refundName" maxlength="20" placeholder="최대 20자"></td>
				</tr>
			</table>

			<button type="submit">수정 완료</button>
		</form>
	</article>

	<a class="footer" href="#">&#8593; top</a>
</section>

<%
	conOrderModify.close();
%>
</body>
</html>