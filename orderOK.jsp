<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@page import="java.text.*"%>
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
	<script src="css/jQuery.js"></script>
	<!-- 외부CSS 파일 연결 -->
	<link rel="stylesheet" type="text/css" href="css/main.css?after">
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

	// userID, 주문자 정보 불러오기
	String id = (String)session.getAttribute("sid");
	if(id == null) {
		response.sendRedirect("login.jsp");
	}
	else {
		String sendData = request.getParameter("sendData");
		String[] dataArray = sendData.split("_");
		String type = dataArray[0];
		String payID = dataArray[1];

		// 기본 pay 정보
		String payDetail = "SELECT * FROM V_payDetail WHERE payID = ?";
		PreparedStatement pstmtPay = con.prepareStatement(payDetail);
		pstmtPay.setString(1, payID);
		ResultSet rsPay = pstmtPay.executeQuery();
		rsPay.next();

		String orderName = rsPay.getString("orderName");
		String orderer = rsPay.getString("orderer");
		String orderTotal = rsPay.getString("FORMAT(orderTotal, 0)");
		String deliveryCharge = rsPay.getString("FORMAT(deliveryCharge, 0)");
		String payPoint = rsPay.getString("FORMAT(payPoint, 0)");
		String payTotal = rsPay.getString("FORMAT(payTotal, 0)");
		String payDate = rsPay.getString("DATE_FORMAT(payDate, '%Y-%m-%d %H:%i')");

		rsPay.close();
		pstmtPay.close();

		// 추가 정보
		String methodBank = "";
		String methodAccount = "";
		String methodName = "";
		String methodDate = "";

		String payPlus = "SELECT * FROM V_payPlus WHERE payID = ?";
		PreparedStatement pstmtPlus = con.prepareStatement(payPlus);
		pstmtPlus.setString(1, payID);
		ResultSet rsPlus = pstmtPlus.executeQuery();
		rsPlus.next();

		switch (type) {
			case "NoBankBook" :
				methodBank = rsPlus.getString("methodBank");
				methodAccount = rsPlus.getString("methodAccount");
				methodName = rsPlus.getString("methodName");
				break;
			case "KakaoPayRemittance" :
				methodName = rsPlus.getString("methodName");
				methodDate = rsPlus.getString("methodDate");
				break;
			default :
				break;
		}

		rsPlus.close();
		pstmtPlus.close();
%>
<script>
	$(document).ready(function(){
		// 분류
		var type = "<%=type%>";
		switch (type){
			case "NoBankBook" :
				$("article#NoBankBook").addClass("On");
				break;
			case "KakaoPayRemittance" :
				$("article#KakaoPayRemittance").addClass("On");
				break;
			default :
				break;
		}

		// 계좌번호 복사
		$("#btnCopy").click(function () {
			$("#Copy").attr("type", "text");
			$("#Copy").select();
			var copy = document.execCommand('copy');
			if(copy) {
    			alert("계좌번호가 복사되었습니다.");
			}
			$("#Copy").attr("type", "hidden");
		});
	});
</script>

<!-- 공통 헤더 (대메뉴) -->
<header>
	<nav>
		<ul class="menuMain">
			<li><a href="index.jsp"><img src="images/logo.png"></a></li>
			<li><a href="new.jsp">NEW</a></li>
			<li><a href="prodList.jsp">PRODUCTS</a></li>
			<li><a href="typeTest.jsp"><font color="#FF6653">TYPE TEST</font></a></li>
			<li><a href="event.jsp">EVENT</a></li>
			<li><a href="support.jsp">SUPPORT</a></li>
		</ul>
		<ul class="menuSub">
			<li class="searchBar">
				<input type="text" placeholder="제품 검색"></input>
				<button type="submit" class="searchBtn"><img src="images/Icon/Icon_search.png"></button>
			</li>
			<li class="cart"><a href="mypage.jsp?ctg=cart"><img src="images/Icon/Icon_cart.png"></a></li>
			<li class="mypage">
				<a href="mypage.jsp"><img src="images/Icon/Icon_mypage.png"></a>
				<!-- 드롭다운 메뉴 -->
				<ul class="menuDrop">
					<li><a href="mypage.jsp?ctg=order">주문확인 / 배송조회</a></li>
					<li><a href="mypage.jsp?ctg=wish">관심상품</a></li>
					<li><a href="mypage.jsp?ctg=user">내 정보 관리</a></li>
					<li><a href="support.jsp">고객센터</a></li>
					<li><a href="session/logout.jsp">로그아웃</a></li>
					<li class="Logout" style="display: none;"><a href="login.jsp">로그인 / 회원가입</a></li>
				</ul>
			</li>
		</ul>
	</nav>
</header>

<main class="orderOKMain">
	<section>
		<span>
			<a href="mypage.jsp?ctg=order">&#8636;주문 목록</a>
			<h1>주문번호 <%=orderName%></h1>
			<a href="sub/mypage_orderDetail.jsp?orderName=<%=orderName%>">주문 상세&#8640;</a>
		</span>

		<!-- 무통장 입금 -->
		<article id="NoBankBook">
			<!-- 송금 정보 -->
			<h2>결제 정보</h2>
			<table class="sendMoney">
				<tr>
					<th>송금 계좌</th>
					<td>IBK기업은행&ensp;|&ensp;277-051864-01-090</td>
					<td><button id="btnCopy">계좌번호 복사</button></td>
					<input type="hidden" id="Copy" value="IBK기업은행 277-051864-01-090">
				</tr>
				<tr>
					<th>입금액</th>
					<td><%=payTotal%>원</td>
				</tr>
			</table>

			<!-- 결제 수단 정보 -->
			<h2>입금 정보 (결제 수단)</h2>
			<table>
				<tr>
					<th>결제수단</th>
					<td>무통장 입금</td>
				</tr>
				<tr>
					<th>입금 계좌</th>
					<td><%=methodBank%>&ensp;|&ensp;<%=methodAccount%></td>
				</tr>
				<tr>
					<th>입금명</th>
					<td><%=methodName%></td>
				</tr>
			</table>

			<!-- 주의 사항 -->
			<p>
				&#10047; 상기의 <b>결제 정보와 입금 정보(결제 수단)</b>을 반드시 확인 후 입금해주세요. 잘못된 계좌로 입금했을 경우, <b>퓨레시 측에서 도와드릴 수 없습니다.</b><br>
				&#10047; 현재 페이지를 벗어나더라도 언제든지 <b>'마이페이지 > 주문확인/배송조회'</b>에서 <b>'송금 정보 확인'</b>을 통해 송금 정보 및 결제 정보를 확인하실 수 있습니다.<br>
				&#10047; <b>입금명</b> 혹은 <b>입금액</b>에 착오가 발생했을 경우, 입금 확인이 어렵습니다.<br>
				&ensp;&ensp;(※ 해당 경우는 고객센터에 입금 내역 증명서와 함께 문의해주시길 바랍니다.)<br>
				&#10047; 입금 확인에는 영업일 기준 평균 1~2일이 소요됩니다.<br>
				&#10047; 빠른 확인을 원하실 때는 <b>입금 완료</b> 후, <b>'마이페이지 > 주문확인/배송조회'</b>에서<br> 해당 주문의 <b>'입금 완료 알림'</b>을 눌러주세요.<br>
				&ensp;&ensp;(※ 영업사정에 따라 빠른 확인이 어려울 수도 있습니다.)<br>
			</p>
		</article>

		<!-- 카카오페이 송금 -->
		<article id="KakaoPayRemittance">
			<!-- QR코드 -->
			<img src="images/QRcode.jpg">

			<!-- 결제 수단 정보 -->
			<table>
				<tr>
					<th>결제수단</th>
					<td>카카오페이 송금</td>
				</tr>
				<tr>
					<th>입금명</th>
					<td><%=methodName%></td>
				</tr>
				<tr>
					<th>입금일</th>
					<td><%=methodDate%></td>
				</tr>
				<tr style="font-weight: bold;">
					<th>입금액</th>
					<td><%=payTotal%>원</td>
				</tr>
			</table>

			<!-- 주의 사항 -->
			<p>
				&#10047; 상기의 <b>QR코드</b>를 통해 송금이 가능합니다.<br>
				&#10047; 현재 페이지를 벗어나더라도 언제든지 <b>'마이페이지 > 주문확인/배송조회'</b>에서 <b>'송금 정보 확인'</b>을 통해 QR코드를 발급 받으실 수 있습니다.<br>
				&#10047; 입금 시, <b>입금명</b>과 <b>입금일</b>, <b>입금액</b>에 착오가 없도록 반드시 확인해 주시길 바랍니다.<br>
				&#10047; 입금 확인에는 <b>입금일</b>로부터 영업일 기준 최대 1일이 소모됩니다.<br>
				&#10047; <b>입금명</b>, <b>입금액</b>, <b>입금일</b>에 착오가 발생했을 경우, 입금 확인이 어렵습니다.<br>
				&ensp;&ensp;(※ 해당 경우는 고객센터에 입금 내역 증명서와 함께 문의해주시길 바랍니다.)<br>
				&#10047; <b>입금일</b>이 지난 후에도 <b>입금이 확인되지 않은 주문</b>의 경우, 사전고지 없이 <b>주문 취소</b> 처리됩니다.<br>
				&#10047; 카카오페이 송금은 <b>'입금 확인 완료'</b> 눌러 <b>'입금 완료'</b>가 상태가 되더라도 <b>입금일</b>이 되기까지 입금 확인이 이루어지지 않습니다.<br>
			</p>
		</article>

		<!-- 맨위로 이동 -->
		<a id="locationUP" href="#">&#8593; top</a>
	</section>
</main>

<!-- footer -->
<footer>
	<span>
		<a href="service.jsp?ctg=company">회사소개</a>
		<a href="service.jsp?ctg=policy">개인정보처리방침</a>
		<a href="service.jsp?ctg=provision">이용약관</a>
		<a href="service.jsp?ctg=post">게시글수집및이용안내</a>
	</span>
	<address>
		<table>
			<tr>
				<td>회사명</td>
				<th>(주)퓨레시</th>
				<td>메일</td>
				<th>puresh2024@gmail.com</th>
			</tr>
			<tr>
				<td>대표자명</td>
				<th>봄파랑</th>
				<td>사업자등록번호</td>
				<th>041-580-2000</th>
			</tr>
			<tr>
				<td>대표번호</td>
				<th>2110-0229</th>
				<td>통신판매신고번호</td>
				<th>제2024-천안성환-L209호</th>
			</tr>
			<tr>
				<td>주소</td>
				<th>충청남도 천안시 서북구 성환읍 대학로 91</th>
				<td>호스팅서비스제공자</td>
				<th>(주)퓨레시</th>
			</tr>
		</table>
		<!-- sns 아이콘-->
		<div>
			<a href="https://www.instagram.com" target="_blank"><img src="images/Icon/Icon_instagram.png"></a>
			<a href="https://twitter.com" target="_blank"><img src="images/Icon/Icon_twitter.png"></a>
			<a href="https://www.facebook.com" target="_blank"><img src="images/Icon/Icon_facebook.png"></a>
		</div>
	</address>
</footer>

<%
	}
	con.close();
%>
</body>
</html>