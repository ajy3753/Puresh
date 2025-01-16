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
	<script src="css/jQuery.js"></script>
	<!-- 외부CSS 파일 연결 -->
	<link rel="stylesheet" type="text/css" href="css/main.css?after">
	<link rel="stylesheet" type="text/css" href="css/page.css?after">
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
%>
<script>
	$(document).ready(function(){
		// 로그인 여부
		var id = "<%=id%>";
		if (id == "null" || id == "") {
			$(".menuSub li a, .BoxCont span.btn a").attr("href", "login.jsp");
			$(".menuDrop").css("height", "5vw");
			$(".menuDrop li").css("display", "none");
			$(".menuDrop li.Logout").css("display", "block");
			$(".BoxCont span.btn a").click(function () {
				alert("로그인이 필요한 기능입니다.");
			});
			
			$(".QnA span#ask").click(function () {
				alert("로그인이 필요한 기능입니다.");
				location.href="login.jsp";
			});
		}
		else {
			$(".QnA span#ask").click(function () {
				location.href="sendAsk.jsp";
			});
		}

		// 이메일, 전번 복사
		$(".QnA span#email").click(function () {
			$(".QnA span#email input").attr("type", "text");
			$(".QnA span#email input").select();
			var copy = document.execCommand('copy');
			if(copy) {
    			alert("이메일 주소가 복사 되었습니다.");
			}
			$(".QnA span#email input").attr("type", "hidden");
		});
		$(".QnA span#call").click(function () {
			$(".QnA span#call input").attr("type", "text");
			$(".QnA span#call input").select();
			var copy = document.execCommand('copy');
			if(copy) {
    			alert("전화번호가 복사 되었습니다.");
			}
			$(".QnA span#call input").attr("type", "hidden");
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

<main class="supportMain">
	<section>
		<!-- 자주 묻는 질문 -->
		<article class="FAQ">
			<h1>FAQ</h1>
			<h2>자주 묻는 질문</h2>
			
			<!-- 탭 -->
			<ul>
				<li class="On">전체</li>
				<li>계정 관리</li>
				<li>주문·결제</li>
				<li>배송</li>
				<li>교환·환불</li>
			</ul>

			<!-- 계정 관리 -->
			<div id="account" value="up">
				<span>
					<h3>Q. 아이디, 비밀번호를 잊어버렸어요</h3>
					<img src="images/Icon/Icon_dropdown.png">
				</span>
				<p>
					A. 로그인 페이지에서 '아이디/비밀번호 찾기'를 이용해주세요. '아이디/비밀번호 찾기'에서도 계정을 찾으실 수 없으시다면 고객센터로 문의해주시길 바랍니다.<br>
					<a href="findUser.jsp?type=findID">&#8640; 아이디 / 비밀번호 찾기 바로가기</a><br>
				</p>
			</div>
			<div id="account" value="up">
				<span>
					<h3>Q. 퓨레시를 탈퇴하고 싶어요</h3>
					<img src="images/Icon/Icon_dropdown.png">
				</span>
				<p>
					A. <b>'마이페이지 > 내 정보 관리 > 회원 탈퇴'</b>를 통해 회원 탈퇴가 가능합니다.<br>
					탈퇴한 계정의 정보는 탈퇴 시점으로부터 30일까지만 보관하고 영구 삭제됩니다.<br>
				</p>
			</div>
			<div id="account" value="up">
				<span>
					<h3>Q. 전에 회원이었다가 탈퇴했는데 같은 아이디로 재가입할 수 있나요?</h3>
					<img src="images/Icon/Icon_dropdown.png">
				</span>
				<p>
					A. 퓨레시는 탈퇴한 고객님의 아이디와 개인 정보를 탈퇴 시점으로부터 30일까지만 보관하고 영구 삭제 처리하고 있습니다.<br>
					탈퇴하고 30일이 지나지 않았다면 기존 계정으로 재가입이 가능합니다. 30일이 지나셨다면 <b>복구가 불가능하며</b>, 회원가입을 통해 새로 가입하셔야합니다.<br>
					※재가입에는 고객센터 문의 후 본인 확인 절차가 필요합니다.<br>
				</p>
			</div>

			<!-- 주문 / 결제 -->
			<div id="orderPay" value="up">
				<span>
					<h3>Q. 입금을 했는데도 입금 대기 상태라고만 뜨고 확인이 안 돼요</h3>
					<img src="images/Icon/Icon_dropdown.png">
				</span>
				<p>
					A. 입금을 완료했음에도 입금 대기 상태로 뜨는 것은 다음과 같은 이유가 있습니다.<br><br>
					1. 입금 확인에 시간이 소요되는 경우 :<br>
					무통장 입금은 입금으로부터 영업일 기준 최대 1일이 소요됩니다. 입금을 완료하셨다면 <b>'주문 내역 > 주문 상태'</b>에서 <b>'입금 완료 알림'</b>을 눌러주시면 더욱 빠른 확인이 가능합니다.<br><br>
					2.  입금 예정일이 지나지 않은 경우 :<br>
					카카오페이 송금은 주문 시 설정한 <b>'입금일'</b>이 지나야 입금 확인을 진행합니다. 입금 예정일보다 먼저 입금을 완료하신 경우에는 입금 내역 증명서와 함께 고객센터로 문의해주시길 바랍니다.<br><br>
					3. 입금명 혹은 입금 계좌 정보에 착오가 있는 경우 :<br>
					주문 시 설정한 입금명 또는 계좌 정보와 다른 정보로 입금을 하셨을 경우 확인이 되지 않습니다. <b>'주문 내역 > 결제 정보'</b>에서 입력한 정보를 확인 후 고객센터로 문의해주시길 바랍니다.<br><br>
					4. 같은 시간에 동명이인이 입금했을 경우 :<br>
					카카오페이 송금을 이용하신 고객 중에 입금일과 입금명이 겹치는 경우가 있습니다. 이 경우 당사에서 확인이 어렵습니다. 입금 증명내역서와 함께 고객센터로 문의해주시면 감사하겠습니다.<br><br>
					위의 경우에 해당되는 내용이 없음에도 입금 확인이 되지 않으신다면 고객센터로 문의해주시길 바랍니다.<br>
				</p>
			</div>
			<div id="orderPay" value="up">
				<span>
					<h3>Q. 주문서와 입금명을 틀리게 입금했어요</h3>
					<img src="images/Icon/Icon_dropdown.png">
				</span>
				<p>
					A. 주문서에 기입된 결제정보와 틀린 정보로 입금했을 경우, <b>'마이페이지 > 주문내역 > 주문상태'</b>에서 <b>'문의하기'</b>를 통해 입금할 때 사용하신 입금명과 계좌번호, 입금일자를 기입하여 문의를 넣어주시면 확인해 드리고있습니다.<br>
					이때 입금 증명서를 함께 첨부해주시면 더욱 빠르고 정확한 처리가 가능합니다.<br>
				</p>
			</div>

			<!-- 배송 -->
			<div id="delivery" value="up">
				<span>
					<h3>Q. 배송 번호는 어디서 확인하나요?</h3>
				<img src="images/Icon/Icon_dropdown.png">
				</span>
				<p>
					A. <b>'마이페이지 > 주문확인/배송조회'</b>에서 확인 가능합니다.<br>
					제품이 발송 준비 중인 경우 운송장 번호는 등록되어있으나, 배송조회는 되지 않을 수 있습니다.<br>
				</p>
			</div>

			<!-- 교환 / 환불 -->
			<div id="exchangeRefund" value="up">
				<span>
					<h3>Q. 불량 제품이 왔어요</h3>
					<img src="images/Icon/Icon_dropdown.png">
				</span>
				<p>
					A. 주문 번호와 함께 고객센터로 문의해주세요. 절차에 따라 교환 또는 환불을 도와드리겠습니다.<br>
					교환 및 환불 조건에 관해서는 상품 상세 페이지를 참고해주시길 바랍니다.<br>
				</p>
			</div>
		</article>

		<!-- 이메일, 전화상담, 1대1 문의 -->
		<article class="QnA">
			<h1>Q&A</h1>
			<h2>운영시간</h2>
			<p>
				<b>09:00 ~ 17:30</b><br>
				점심시간 12:00 ~ 13:00<br>
				(※주말 및 공휴일 휴무)
			</p>

			<div>
				<span id="email">
					<input type="hidden" value="puresh2024@gmail.com">
					<img src="images/Icon/Icon_email.png">
					<h3>이메일 문의</h3>
					<h4>puresh2024@gmail.com</h4>
				</span>
				<span id="call">
					<input type="hidden" value="041-580-2000">
					<img src="images/Icon/Icon_call.png">
					<h3>퓨레시 콜센터</h3>
					<h4>041) 580-2000</h4>
				</span>
				<span id="ask">
					<img src="images/Icon/Icon_ask.png">
					<h3>1:1 문의</h3>
				</span>
			</div>
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
	con.close();
%>
</body>
</html>