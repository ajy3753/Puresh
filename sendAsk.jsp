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

<main class="sendAskMain">
	<section>
		<h1>1:1 문의하기</h1>

		<form action="session/addAsk.jsp">
			<table>
				<tr>
					<th>제목</th>
					<td><input type="text" name="askName" maxlength="20" required></td>
				</tr>
				<tr>
					<th>분류</th>
					<td>
						<select name="askCtg">
							<option value="주문 및 결제 관련">주문 및 결제 관련</option>
							<option value="결제 오류/취소">결제 오류/취소</option>
							<option value="배송 문의">배송 문의</option>
							<option value="교환 및 반품 신청">교환 및 반품 신청</option>
							<option value="환불 문의">환불 문의</option>
							<option value="기타 문의">기타 문의</option>
						</select>
					</td>
				</tr>
				<tr>
					<th style="vertical-align: top;">상세 (*필수)</th>
					<td><textarea name="askContent" wrap="physical" maxlength="1000" required></textarea></td>
				</tr>
				<tr>
					<th>이메일 수신</th>
					<td>
						<input type="checkbox" id="agreeEmail" name="agreeEmail" value="YES">
						<label for="agreeEmail">&#10047;</label>
						<p>답변이 오면 이메일 알림을 받겠습니다. (*선택)</p>
					</td>
				</tr>
				<tr>
					<th>개인정보 수집 동의</th>
					<td>
						<input type="checkbox" id="agreePolicy" required>
						<label for="agreePolicy" required>&#10047;</label>
						<p>이메일 주소, 연락처 등의 개인 정보를 수집하는 것에 동의합니다. (*필수)</p>
					</td>
				</tr>
			</table>

			<input type="submit" value="제출">
		</form>
	</section>

	<!-- 맨위로 이동 -->
	<a id="locationUP" href="#">&#8593; top</a>
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