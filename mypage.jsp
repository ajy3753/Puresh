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
	<link rel="stylesheet" type="text/css" href="css/sub.css?after">
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

	// userID
	String id = (String)session.getAttribute("sid");
	if(id == null) {
		response.sendRedirect("login.jsp");
	}
	else {
		// ctg
		String ctg = request.getParameter("ctg");
		if(ctg == null) {
			ctg = "order_";
		}

		String[] ctgArray = ctg.split("_");
		String action = "sub/mypage_" + ctgArray[0] + ".jsp";
		if(ctgArray.length > 1) {
			action = action + "?orderby=" + ctgArray[1];
		}

		// 마이페이지 상단용
		String myHeader = "SELECT * FROM V_myHeader WHERE userID = ?";
		PreparedStatement pstmtH = con.prepareStatement(myHeader);
		pstmtH.setString(1, id);
		ResultSet rsH = pstmtH.executeQuery();
		rsH.next();

		String name = rsH.getString("userName");
		String point = rsH.getString("FORMAT(userPoint, 0)");

		rsH.close();
		pstmtH.close();
%>
<script>
	$(document).ready(function(){
		// 사이드 탭
		var ctgCon = "#" + "<%=ctgArray[0]%>";
		$(ctgCon).addClass("On");
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

<main class="mypageMain">
	<!-- 마이페이지 상단 -->
	<section class="mypageHeader">
		<article class="User">
			<div>
				<img src="images/Icon/Icon_rankA.png">
			</div>
			<div>
				<span>
					<h1><%=name%> 님</h1>
					<h4>(<%=id%>)</h4>
				</span>
				<h3>보유 포인트</h3>
				<span>
					<h3><font color="#C81C21"><%=point%></font></h3>
					<h3>P</h3>
				</span>
			</div>
		</article>
	</section>

	<!-- 마이페이지 본문 -->
	<section class="mypageContent">
		<!-- 사이드바 -->
		<aside>
			<h1>마이페이지</h1>
			<h3>마이 홈</h3>
			<ul>
				<li id="order"><a href="mypage.jsp?ctg=order">주문확인 / 배송조회</a></li>
				<li id="cart"><a href="mypage.jsp?ctg=cart">장바구니</a></li>
				<li id="wish"><a href="mypage.jsp?ctg=wish">관심상품</a></li>
				<li id="pay"><a href="mypage.jsp?ctg=pay">결제 내역</a></li>
			</ul>
			<h3>상품 리뷰</h3>
			<ul>
				<li id="reviewWriteable"><a href="mypage.jsp?ctg=reviewWriteable">작성 가능한 리뷰</a></li>
				<li id="reviewList"><a href="mypage.jsp?ctg=reviewList">내가 쓴 리뷰</a></li>
			</ul>
			<h3>회원 정보</h3>
			<ul>
				<li id="user"><a href="mypage.jsp?ctg=user">내 정보 관리</a></li>
				<li id="ask"><a href="mypage.jsp?ctg=ask">1:1 문의 내역</a></li>
			</ul>
		</aside>

		<!-- 내용-->
		<article>
			<jsp:include page="<%=action%>" />
		</article>
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