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

	// eventBox용 변수
	String eventID;
	String eventName;
	String eventImg;
	String eventStart;
	String eventEnd;
	int Dday = 0;
	String prizeImg;
	String prizeDate;
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
			$(".menuSub li a, .BoxCont span.btn a").click(function () {
				alert("로그인이 필요한 기능입니다.");
			});
		}
	})
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

<!-- 이벤트 페이지 본문 -->
<main class="eventMain">
	<!-- 이벤트 배너 -->
	<section class="eventBanner">
		<img src="images/CAT_main.png">
	</section>

	<!-- 이벤트 탭 -->
	<section class="eventContent">
		<!-- 탭 버튼 -->
		<ul>
			<li class="On">진행 중</li>
			<li>종료</li>
			<li>당첨자 발표</li>
		</ul>

		<!-- 진행중 -->
		<article class="eventList On">
			<%
				String progressEvent = "SELECT * FROM V_eventList WHERE eventEnd >= CURDATE( )";
				PreparedStatement pstmtPE = con.prepareStatement(progressEvent);
				ResultSet rsPE = pstmtPE.executeQuery();

				while(rsPE.next()){
					eventID = rsPE.getString("eventID");
					eventName = rsPE.getString("eventName");
					eventImg = rsPE.getString("eventImg");
					eventStart = rsPE.getString("startDate");
					eventEnd = rsPE.getString("endDate");
					Dday = rsPE.getInt("Dday");
			%>
			<!-- 이벤트 박스 -->
			<a class="eventBox" href="eventDetail.jsp?eventID=<%=eventID%>_info">
				<img src="<%=eventImg%>">
				<h1><%=eventName%></h1>
				<hr>
				<p>
					<span><%=eventStart%> ~ <%=eventEnd%></span>
					<span>D - <%=Dday%></span>
				</p>
			</a>
			<%
				}
				rsPE.close();
				pstmtPE.close();
			%>
		</article>

		<!-- 종료 -->
		<article class="eventList">
			<%
				String endedEvent = "SELECT * FROM V_eventList WHERE eventEnd < CURDATE( )";
				PreparedStatement pstmtEE = con.prepareStatement(endedEvent);
				ResultSet rsEE = pstmtEE.executeQuery();

				while(rsEE.next()){
					eventID = rsEE.getString("eventID");
					eventName = rsEE.getString("eventName");
					eventImg = rsEE.getString("eventImg");
					eventStart = rsEE.getString("startDate");
					eventEnd = rsEE.getString("endDate");
					Dday = rsEE.getInt("Dday");
			%>
			<a class="eventBox" id="Ended" href="eventDetail.jsp?eventID=<%=eventID%>_info">
				<img src="<%=eventImg%>">
				<h1><%=eventName%></h1>
				<hr>
				<p>
					<span><%=eventStart%> ~ <%=eventEnd%></span>
					<span>종료</span>
				</p>
			</a>
			<%
				}
				rsEE.close();
				pstmtEE.close();
			%>
		</article>

		<!-- 당첨자 발표 -->
		<article class="prizeList">
			<%
				String announcePrize = "SELECT * FROM V_eventList WHERE prizeDate < CURDATE( )";
				PreparedStatement pstmtAP = con.prepareStatement(announcePrize);
				ResultSet rsAP = pstmtAP.executeQuery();

				while(rsAP.next()){
					eventID = rsAP.getString("eventID");
					eventName = rsAP.getString("eventName");
					prizeImg = rsAP.getString("prizeImg");
					eventStart = rsAP.getString("startDate");
					eventEnd = rsAP.getString("endDate");
					prizeDate = rsAP.getString("prizeDay");
			%>
			<a class="eventBox" href="eventDetail.jsp?eventID=<%=eventID%>_prize">
				<img src="<%=prizeImg%>">
				<div>
					<h1><%=eventName%></h1>
					<hr>
					<p>
						<span>이벤트 기간</span>
						<span><%=eventStart%> ~ <%=eventEnd%></span>
					</p>
					<p>
						<span>당첨자 발표</span>
						<span><%=prizeDate%></span>
					</p>
				</div>
			</a>
			<%
				}
				rsAP.close();
				pstmtAP.close();
			%>
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
	con.close();
%>
</body>
</html>