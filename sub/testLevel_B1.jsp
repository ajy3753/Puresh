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
	<!-- 외부CSS 파일 연결 -->
	<link rel="stylesheet" type="text/css" href="../css/main.css?after">
	<link rel="stylesheet" type="text/css" href="../css/page.css?after">
	<link rel="stylesheet" type="text/css" href="../css/sub.css?after">
	<style>
		body {
			background-image: url("../images/BGI/BGI_Main1.png");
			background-position: cover;
		}
	</style>
</head>
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
	$(document).ready(function() {
		// 랜덤 배경
		let randNum = Math.floor(Math.random() * 100) + 1;
		let imgNum = (randNum % 4) + 1;
		var BGI = "../images/BGI/BGI_Main" + imgNum + ".png";
		var urlBGI = "url('" + BGI + "')";

		$("body").css("background-image", urlBGI );

		// 로그인 여부 sub Ver.
		var id = "<%=id%>";
		if (id == "null" || id == "") {
			$(".menuSub li a, .BoxCont span.btn a").attr("href", "../login.jsp");
			$(".menuDrop").css("height", "5vw");
			$(".menuDrop li").css("display", "none");
			$(".menuDrop li.Logout").css("display", "block");
			$(".BoxCont span.btn a").click(function () {
				alert("로그인이 필요한 기능입니다.");
			});
		}

		// 마이페이지 드롭다운 sub Ver.
		$(".mypage").mouseover(function () {
			$(".menuDrop").css("display", "flex");
		});
		$(".mypage" && ".menuDrop").mouseleave(function () {
			$(".menuDrop").css("display", "none");
		});

		// 검색바 sub Ver.
		$(".searchBtn").click(function () {
		var search = $(".searchBar input:text").val();
			if (search == null || search == "") {
				alert("검색어를 입력해주세요.");
			}
			else {
				var keyword = search;
				location.href = "../prodSearch.jsp?keyword=" + keyword;
			}
		});

		// 이전 질문으로 돌아가기
		$(".btnBack").click(function() {
			history.back();
		});
	});
</script>

<!-- 공통 헤더 (대메뉴) sub Ver. -->
<header>
	<nav>
		<ul class="menuMain">
			<li><a href="../index.jsp"><img src="../images/logo.png"></a></li>
			<li><a href="../new.jsp">NEW</a></li>
			<li><a href="../prodList.jsp">PRODUCTS</a></li>
			<li><a href="../typeTest.jsp">TYPE TEST</a></li>
			<li><a href="../event.jsp">EVENT</a></li>
			<li><a href="../support.jsp">SUPPORT</a></li>
		</ul>
		<ul class="menuSub">
			<li class="searchBar">
				<input type="text" placeholder="제품 검색"></input>
				<button type="submit" class="searchBtn"><img src="../images/Icon_search.png"></button>
			</li>
			<li class="cart"><a href="../mypage.jsp?ctg=cart"><img src="../images/Icon_cart.png"></a></li>
			<li class="mypage">
				<a href="../mypage.jsp"><img src="../images/Icon_mypage.png"></a>
				<!-- 드롭다운 메뉴 -->
				<ul class="menuDrop">
					<li><a href="../mypage.jsp?ctg=order">주문확인 / 배송조회</a></li>
					<li><a href="../mypage.jsp?ctg=wish">관심상품</a></li>
					<li><a href="../mypage.jsp?ctg=user">내 정보 관리</a></li>
					<li><a href="../supportCenter.jsp">고객센터</a></li>
					<li><a href="../session/logout.jsp">로그아웃</a></li>
					<li class="Logout" style="display: none;"><a href="../login.jsp">로그인 / 회원가입</a></li>
				</ul>
			</li>
		</ul>
	</nav>
</header>

<main class="levelMain">
	<section>
		<h6>Skin Type Test</h6>
		<h1>피부 타입 테스트</h1>

		<!-- 선택지 -->
		<article>
			<img src="../images/typeTest/progress_A.png">
			<h2>Q. 내 피부 타입은 이거라고 알고있다</h2>
			<div>
				<a href="testResult.jsp">
					<img src="../images/typeTest/icon-watermelon.png">건성<img src="../images/typeTest/icon-watermelon.png">
				</a>
				<a href="testResult.jsp">
					<img src="../images/typeTest/icon-avocado.png">지성<img src="../images/typeTest/icon-avocado.png">
				</a>
				<a href="testResult.jsp">
					<img src="../images/typeTest/icon-mango.png">수분 부족형 지성<img src="../images/typeTest/icon-mango.png">
				</a>
				<a href="testResult.jsp">
					<img src="../images/typeTest/icon-blueberry.png">복합<img src="../images/typeTest/icon-blueberry.png">
				</a>
			</div>
		</article>
		<a class="btnBack">&#8636; 이전 질문</a>
	</section>

</main>

<!-- footer sub Ver. -->
<footer>
	<span>
		<a href="../service.jsp?ctg=company">회사소개</a>
		<a href="../service.jsp?ctg=policy">개인정보처리방침</a>
		<a href="../service.jsp?ctg=provision">이용약관</a>
		<a href="../service.jsp?ctg=post">게시글수집및이용안내</a>
	</span>
	<address>
		<table>
			<tr>
				<td>회사명</td>
				<th>(주)퓨레시</th>
				<td>메일</td>
				<th>puresh@puresh.com</th>
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
			<a href="https://www.instagram.com" target="_blank"><img src="../images/Icon_instagram.png"></a>
			<a href="https://twitter.com" target="_blank"><img src="../images/Icon_twitter.png"></a>
			<a href="https://www.facebook.com" target="_blank"><img src="../images/Icon_facebook.png"></a>
		</div>
	</address>
</footer>

<%
	con.close();
%>
</body>
</html>