<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<title>Puresh Manager</title>
	<!-- 웹폰트 연결 (앨리스 디지털 배움체) -->
	<link href="https://font.elice.io/css?family=Elice+Digital+Baeum" rel="stylesheet">
	<!-- jQuery 라이브러리 연결 -->
	<script src="https://code.jquery.com/jquery-3.6.3.js"></script>
	<script src="css/jQuery.js"></script>
	<!-- 외부CSS 파일 연결 -->
	<link rel="stylesheet" type="text/css" href="css/main.css?after">
	<link rel="stylesheet" type="text/css" href="css/manager.css?after">
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

	// 로그인 여부
	String managerID = (String)session.getAttribute("managerSID");

	// 사이드 탭
	String ctg = request.getParameter("ctg");
	if(ctg == null) {
		ctg = "user_userList";
	}
	String[] ctgArray = ctg.split("_");
	String action = "manager/sub_" + ctgArray[1] + ".jsp";
	if(ctgArray.length > 2) {
		action = action + ctgArray[2];
	}
%>
<script>
	// 세션 만료 시간 계산
	const access = new Date();
	const expiration = new Date();
	expiration.setMinutes(access.getMinutes() + 10);

	function updateTimer() {
		const now = new Date();
		const diff = expiration - now;

		const days = Math.floor(diff / (1000 * 60 * 60 * 24));
		const hours = Math.floor(diff / (1000 * 60 * 60));
		const mins = Math.floor(diff / (1000 * 60));
		const secs = Math.floor(diff / 1000);

		const m = mins - hours * 60;
		const s = secs - mins * 60;

		if(m == 0 && s == 0) {
			clearInterval(count);
		}

		document.getElementById("timer").innerHTML = m + '&nbsp;:&nbsp;' + s;
	}

	var count = setInterval(updateTimer, 1000);

	// 제이쿼리
	$(document).ready(function(){
		// 사이트 탭 변경
		var mainClass = "<%=ctgArray[0]%>"
		var subClass = "<%=ctgArray[1]%>"

		$("nav ul li").removeClass("On");
		$("nav ul li#" + mainClass).addClass("On");
		$("nav ul li#" + mainClass + " ol").addClass("On");
		$("nav ol li#" + subClass).addClass("On");
		
		$("nav ul li").mouseover(function () {
			$(this).children().addClass("On");
		});
		$("nav ul li").mouseleave(function () {
			$(this).children().removeClass("On");
			$("nav ul li#" + mainClass).addClass("On");
			$("nav ul li#" + mainClass + " ol").addClass("On");
			$("nav ol li#" + subClass).addClass("On");
		});
	});
</script>

<!-- 사이드바 -->
<nav>
	<!-- 상단 -->
	<div class="upper">
		<a href="index.jsp"><img src="images/logo.png"></a>
		<span>
			<p>세션 만료</p>
			<div id="timer">9 : 59</div>
			<button id="btnTimeReset">연장</button>
		</span>
	</div>

	<!-- 메뉴 카테고리 -->
	<ul class="mainMenu">
		<li id="user">
			<a>고객 관리</a>
			<ol class="subMenu">
				<li  id="userList" class="On"><a href="pureshManager.jsp?ctg=user_userList">전체 회원 목록</a></li>
				<li id="sendEmail"><a href="pureshManager.jsp?ctg=user_sendEmail">이메일 발신</a></li>
				<li id="grade"><a href="pureshManager.jsp?ctg=user_grade">회원 등급</a></li>
			</ol>
		</li>
		<li id="prod">
			<a>상품 관리</a>
			<ol class="subMenu">
				<li  id="prodList"><a href="pureshManager.jsp?ctg=prod_prodList">전체 상품 목록</a></li>
				<li id="newRegistration"><a href="pureshManager.jsp?ctg=prod_addProd">신규 상품 등록</a></li>
			</ol>
		</li>
		<li id="order">
			<a>주문 관리</a>
			<ol class="subMenu">
				<li  id="orderList"><a href="pureshManager.jsp?ctg=order_orderList">전체 주문 목록</a></li>
				<li id="delievery"><a href="pureshManager.jsp?ctg=order_delievery">배송 상황</a></li>
			</ol>
		</li>
		<li id="review">
			<a>리뷰 관리</a>
			<ol class="subMenu">
				<li  id="reviewChart"><a href="pureshManager.jsp?ctg=review_reviewChart">리뷰 통계</a></li>
				<li id="reviewList"><a href="pureshManager.jsp?ctg=review_reviewList">전체 리뷰 목록</a></li>
			</ol>
		</li>
		<li id="support">
			<a>문의 관리</a>
			<ol class="subMenu">
				<li  id="ask"><a href="pureshManager.jsp?ctg=support_askList">1:1 문의 내역</a></li>
			</ol>
		</li>
	</ul>

	<!-- 하단 -->
	<div class="bottom">
		<button><img src="images/Icon/Icon_settings.png"></button>
		<button><img src="images/Icon/Icon_logout.png"></button>
	</div>
</nav>

<section>
	<jsp:include page="<%=action%>" />
</section>

<%
	con.close();
%>
</body>
</html>