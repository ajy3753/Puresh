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

	// prodBox용 변수
	String prodID;
	String prodName;
	String priceComma;
	String prodCtg;
	String prodType;
	String prodImg;
	String prodStatus;
	String prodDate;
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
		}
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

<!-- 메인 페이지 본문 -->
<main class="indexMain">

	<!-- 배너 -->
	<section class="indexBanner">
		<a href="prodList.jsp"><img src="images/Banner_indexBanner.png"></a>
	</section>

	<!-- 베스트 상품 -->
	<section class="indexBest">
		<h1>Weekly  Best</h1>
		<!-- 베스트 상품 목록 (4개까지) -->
		<article>
			<%
				String sqlBest = "SELECT * FROM V_bestWeekly LIMIT 4";
				PreparedStatement pstmtB = con.prepareStatement(sqlBest);
				ResultSet rsB = pstmtB.executeQuery();
			
				while(rsB.next()){ 
					prodID = rsB.getString("prodID"); 
					prodName = rsB.getString("prodName"); 
					priceComma = rsB.getString("priceComma");
					prodImg = rsB.getString("prodImg");
					prodCtg = rsB.getString("prodCtg");
			%>
			<!-- 상품 박스 (원본) -->
			<div class="prodBox">
				<div class="BoxImg">
					<a  href="prodDetail.jsp?prodID=<%=prodID%>"><img src="<%=prodImg%>"></a>
				</div>
				<div class="BoxCont">
					<span class="info">
						<p class="ctg"><a href="prodList.jsp?ctg=<%=prodCtg%>"><%=prodCtg%></a></p>
						<a  href="prodDetail.jsp?prodID=<%=prodID%>">
							<h3><%=prodName%></h3>
							<h3><%=priceComma%>원</h3>
						</a>
					</span>
					<span class="btn">
						<a href="session/addWish.jsp?prodID=<%=prodID%>"><img src="images/Icon/Icon_heart.png"></a>
						<a href="session/addCart.jsp?sendData=<%=prodID%>_1"><img src="images/Icon/Icon_cart.png"></a>
					</span>
				</div>
			</div>
			<%
				}
				rsB.close();
				pstmtB.close();
			%>
		</article>
		<aside>
			<hr><a href="prodList.jsp"><p>전체보기 &#10148;</p></a>
		</aside>
	</section>

	<!-- 신상품 -->
	<section class="indexNew">
		<!-- 신상품 테마 이미지 -->
		<article class="left">
			<img src="images/New/NewWatermelom_Main.png">
		</article>
		<article class="right">
			<!-- 신상품 테마 소개 -->
			<a href="new.jsp"><h1>NEW 촉촉하게 Watermelon Line &#10095;</h1></a>
			<h5>
				촉촉한 수박으로 수분 보충<br>
				오랜시간 지속 가능한 수분 가득 수박으로 피부도 시원하게!
			</h5>
			<!-- 신상품 목록 (2개까지) -->
			<aside>
				<%
					String sqlEvt = "SELECT * FROM V_prdEvent WHERE prodEvent = 'New Watermelon' LIMIT 2";
					PreparedStatement pstmtE = con.prepareStatement(sqlEvt);
					ResultSet rsE = pstmtE.executeQuery();
				
					while(rsE.next()){ 
						prodID = rsE.getString("prodID"); 
						prodName = rsE.getString("prodName"); 
						priceComma = rsE.getString("FORMAT(prodPrice, 0)");
						prodImg = rsE.getString("prodImg");
						prodCtg = rsE.getString("prodCtg");
				%>
				<div class="prodBox">
					<div class="BoxImg">
						<a  href="prodDetail.jsp?prodID=<%=prodID%>"><img src="<%=prodImg%>"></a>
					</div>
					<div class="BoxCont">
						<span class="info">
							<p class="ctg"><a href="prodList.jsp?ctg=<%=prodCtg%>"><%=prodCtg%></a></p>
							<a  href="prodDetail.jsp?prodID=<%=prodID%>">
								<h3><%=prodName%></h3>
								<h3><%=priceComma%>원</h3>
							</a>
						</span>
						<span class="btn">
							<a href="session/addWish.jsp?prodID=<%=prodID%>"><img src="images/Icon/Icon_heart.png"></a>
							<a href="session/addCart.jsp?sendData=<%=prodID%>_1"><img src="images/Icon/Icon_cart.png"></a>
						</span>
					</div>
				</div>
				<%
					}
					rsE.close();
					pstmtE.close();
				%>
			</aside>
		</article>
	</section>

	<!-- 피부타입테스트 -->
	<section class="indexTest">
		<article class="top">
			<h2><mark>아직도 자신의 피부에 대해<br>잘 모르고 계신가요?</mark></h2>
			<img src="images/M_skintest1.png">
		</article>
		<article class="bottom">
			<img src="images/M_skintest2.png">
			<h2><mark>그렇다면 Puresh와 함께<br>나의 피부에 대해 알아보세요</mark></h2>
		</article>
		<article class="test">
			<h1>TYPE TEST</h1>
			<h4>망고, 블루베리, 아보카도, 수박... 나는 과연 어떤 타입?</h4>
			<a href="typeTest.jsp">테스트 하러가기</a>
		</article>
	</section>

	<!-- 광고 -->
	<section class="indexAd">
		<img src="images/Banner_indexAd.png">
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