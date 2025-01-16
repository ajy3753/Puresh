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

	// eventID 및 분류
	String[] receiveArray = (request.getParameter("eventID")).split("_");
	String eventID = receiveArray[0];
	String ctg = receiveArray[1];

	// eventDetail 불러오기
	String eventDetail = "SELECT * FROM V_eventDetail WHERE eventID = ?";
	PreparedStatement pstmtED = con.prepareStatement(eventDetail);
	pstmtED.setString(1, eventID);
	ResultSet rsED = pstmtED.executeQuery();
	rsED.next();

	String eventName = rsED.getString("eventName");
	String eventInfo = rsED.getString("eventInfo");
	int Dday = rsED.getInt("TIMESTAMPDIFF(DAY, CURDATE( ), eventEnd)");
	int prizeDday = rsED.getInt("IFNULL(TIMESTAMPDIFF(DAY, CURDATE( ), prizeDate), 1)");

	rsED.close();
	pstmtED.close();

	String prizeDetail = "SELECT * FROM V_prizeDetail WHERE eventID = ?";
	String prizeImg = "";

	if(prizeDday <= 0) {
		PreparedStatement pstmtPD = con.prepareStatement(prizeDetail);
		pstmtPD.setString(1, eventID);
		ResultSet rsPD = pstmtPD.executeQuery();
		rsPD.next();

		prizeImg = rsPD.getString("prizeImg");

		rsPD.close();
		pstmtPD.close();
	}
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

		// 이벤트 탭
		var prizeDate = "<%=prizeDday%>";
		if(prizeDate > 0) {
			$("aside ul li#prize").click(function () {
				alert("당첨자 발표 기간이 아닙니다.");
			});
		}
		else {
			var ctg = "#" + "<%=ctg%>"
			$("aside ul li" + ctg).addClass("On").siblings().removeClass("On");
			$("article" + ctg).addClass("On").siblings().removeClass("On");

			$("aside ul li").click(function () {
				var contNum = $(this).index();
				$(this).addClass("On").siblings().removeClass("On");
				$(".eventDetailMain section article").eq(contNum).addClass("On").siblings().removeClass("On");
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

<main class="eventDetailMain">
	<section>
		<!-- 이벤트 제목 -->
		<span>
			<h1 alt="<%=eventName%>">Event &ensp;|&ensp; <%=eventName%></h1>
			<%
				if(Dday < 0) {
			%>
			<h2>이벤트 종료</h2>
			<%
				}
				else {
			%>
			<h2>( D - <%=Dday%> )</h2>
			<%
				}	
			%>
		</span>

		<!-- 탭버튼 -->
		<aside>
			<ul>
				<li id="info" class="On">이벤트 상세</li>
				<li id="prize">당첨자 발표</li>
			</ul>
		</aside>

		<!-- 이벤트 상세 -->
		<article id="info" class="On">
			<img src="<%=eventInfo%>">
			<h3>유의사항</h3>
			<p>
				&#10004; 퓨레시 회원에 한해 응모 및 참여가 가능합니다.<br>
				&#10004; 중복 당첨은 불가합니다.<br>
				&#10004; 경품 종류에 따라 추가 개인정보를 요구할 수 있으며, 외부 업체에 제공될 수 있습니다.<br>
				&#10004; 유의사항을 숙지하지 않아 발생한 문제는 퓨레시에서 책임지지 않습니다.<br>
				&#10004; 본 이벤트는 내부 사정에 따라 예고없이 조기 종료 될 수 있습니다.<br>
			</p>
		</article>

		<!-- 당첨자 발표 -->
		<article id="prize">
			<img src="<%=prizeImg%>">
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