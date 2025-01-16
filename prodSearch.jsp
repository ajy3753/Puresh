<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
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

	// keyword
	String keyword = request.getParameter("keyword");

	// 검색어 수정
	String search;
	switch(keyword) {
		case "지성" :
		case "지성용" :
		case "지성피부" :
		case "dkqhzkeh" :
		case "아보카ㅗㄷ" :
			search = "아보카도";
			break;
		case "건성" :
		case "건성용" :
		case "건성피부" :
		case "tnqkr" :
		case "슈박" :
			search = "수박";
			break;
		case "복합" :
		case "복합성" :
		case "복합피부" :
		case "akdrh" :
		case "먕고" :
			search = "망고";
			break;
		case "수부지" :
		case "수부지용" :
		case "수분부족지성" :
		case "수지부" :
		case "수분지" :
			search = "블루베리";
			break;
		default:
			search = keyword;
			break;
	}

	// 검색 결과 도출
	String searchPrd = "SELECT COUNT(prodName) FROM V_detail WHERE prodName LIKE ?";
	PreparedStatement pstmt = con.prepareStatement(searchPrd);
	pstmt.setString(1, "%" + search + "%");
	ResultSet rs = pstmt.executeQuery();
	rs.next();

	int searchCount = rs.getInt("COUNT(prodName)");

	rs.close();
	pstmt.close();

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

		// 키워드 검색 결과
		var count = "<%=searchCount%>";
		$(".listArray h1 font").text(count);
		if(count == 0) {
			$(".listCont, .listArray").css("display", "none");
			$("p").css("display", "flex");
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

<main class="searchMain">
	<section>
		<h1>"&ensp;<font color="#C81C21"><%=keyword%></font>&ensp;" 검색 결과</h1>
		<!-- 상품 목록 -->
		<article>
			<!-- 상단 / 정렬 -->
			<span class="listArray">
				<h1>총&nbsp;<font color="#C81C21">N</font>&nbsp;개의 상품</h1>
				<ul>
					<li class="On">인기순</li>
					<li>최신순</li>
					<li>낮은 가격순</li>
					<li style="border: none;">높은 가격순</li>
				</ul>
			</span>
			
			<!-- 인기순 -->
			<span class="listCont On">
				<%
					String sqlBest = "SELECT * FROM V_best WHERE prodName LIKE ?";
					PreparedStatement pstmtB = con.prepareStatement(sqlBest);
					pstmtB.setString(1, "%" + search + "%");
					ResultSet rsB = pstmtB.executeQuery();

					while(rsB.next()){ 
						prodID = rsB.getString("prodID"); 
						prodName = rsB.getString("prodName"); 
						priceComma = rsB.getString("FORMAT(prodPrice, 0)");
						prodCtg = rsB.getString("prodCtg");
						prodType = rsB.getString("prodType");
						prodImg = rsB.getString("prodImg");
						prodStatus = rsB.getString("prodStatus");
						prodDate = rsB.getString("prodDate");
				%>
				<div class="prodBox">
					<div class="BoxImg">
						<%
							if(prodStatus.equals("판매중") != true) {
						%>
						<h3>SOLD OUT</h3>
						<%
							}
						%>
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
							<%
								if(prodStatus.equals("판매중")) {
							%>
							<a href="session/addWish.jsp?prodID=<%=prodID%>"><img src="images/Icon/Icon_heart.png"></a>
							<a href="session/addCart.jsp?sendData=<%=prodID%>_1"><img src="images/Icon/Icon_cart.png"></a>
							<%
								}
								else {
							%>
							<a href="session/addWish.jsp?prodID=<%=prodID%>"><img src="images/Icon/Icon_heart.png"></a>
							<a id="SOLDOUT"><img src="images/Icon/Icon_cart.png"></a>
							<%
								}
							%>
						</span>
					</div>
				</div>
				<%
					}
					rsB.close();
					pstmtB.close();
				%>
			</span>

			<!-- 최신순 -->
			<span class="listCont">
				<%
					String sqlNew = "SELECT * FROM V_new WHERE prodName LIKE ?";
					PreparedStatement pstmtN = con.prepareStatement(sqlNew);
					pstmtN.setString(1, "%" + search + "%");
					ResultSet rsN = pstmtN.executeQuery();

					while(rsN.next()){ 
						prodID = rsN.getString("prodID"); 
						prodName = rsN.getString("prodName"); 
						priceComma = rsN.getString("FORMAT(prodPrice, 0)");
						prodCtg = rsN.getString("prodCtg");
						prodType = rsN.getString("prodType");
						prodImg = rsN.getString("prodImg");
						prodStatus = rsN.getString("prodStatus");
						prodDate = rsN.getString("prodDate");
				%>
				<div class="prodBox">
					<div class="BoxImg">
						<%
							if(prodStatus.equals("판매중") != true) {
						%>
						<h3>SOLD OUT</h3>
						<%
							}
						%>
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
							<%
								if(prodStatus.equals("판매중")) {
							%>
							<a href="session/addWish.jsp?prodID=<%=prodID%>"><img src="images/Icon/Icon_heart.png"></a>
							<a href="session/addCart.jsp?sendData=<%=prodID%>_1"><img src="images/Icon/Icon_cart.png"></a>
							<%
								}
								else {
							%>
							<a href="session/addWish.jsp?prodID=<%=prodID%>"><img src="images/Icon/Icon_heart.png"></a>
							<a id="SOLDOUT"><img src="images/Icon/Icon_cart.png"></a>
							<%
								}
							%>
						</span>
					</div>
				</div>
				<%
					}
					rsN.close();
					pstmtN.close();
				%>
			</span>

			<!-- 낮은 가격순 -->
			<span class="listCont">
				<%
					String sqlLow = "SELECT * FROM V_priceLow WHERE prodName LIKE ?";
					PreparedStatement pstmtL = con.prepareStatement(sqlLow);
					pstmtL.setString(1, "%" + search + "%");
					ResultSet rsL = pstmtL.executeQuery();

					while(rsL.next()){ 
						prodID = rsL.getString("prodID"); 
						prodName = rsL.getString("prodName"); 
						priceComma = rsL.getString("FORMAT(prodPrice, 0)");
						prodCtg = rsL.getString("prodCtg");
						prodType = rsL.getString("prodType");
						prodImg = rsL.getString("prodImg");
						prodStatus = rsL.getString("prodStatus");
						prodDate = rsL.getString("prodDate");
				%>
				<div class="prodBox">
					<div class="BoxImg">
						<%
							if(prodStatus.equals("판매중") != true) {
						%>
						<h3>SOLD OUT</h3>
						<%
							}
						%>
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
							<%
								if(prodStatus.equals("판매중")) {
							%>
							<a href="session/addWish.jsp?prodID=<%=prodID%>"><img src="images/Icon/Icon_heart.png"></a>
							<a href="session/addCart.jsp?sendData=<%=prodID%>_1"><img src="images/Icon/Icon_cart.png"></a>
							<%
								}
								else {
							%>
							<a href="session/addWish.jsp?prodID=<%=prodID%>"><img src="images/Icon/Icon_heart.png"></a>
							<a id="SOLDOUT"><img src="images/Icon/Icon_cart.png"></a>
							<%
								}
							%>
						</span>
					</div>
				</div>
				<%
					}
					rsL.close();
					pstmtL.close();
				%>
			</span>

			<!-- 높은 가격순 -->
			<span class="listCont">
				<%
					String sqlHigh = "SELECT * FROM V_priceHigh WHERE prodName LIKE ?";
					PreparedStatement pstmtH = con.prepareStatement(sqlHigh);
					pstmtH.setString(1, "%" + search + "%");
					ResultSet rsH = pstmtH.executeQuery();

					while(rsH.next()){ 
						prodID = rsH.getString("prodID"); 
						prodName = rsH.getString("prodName"); 
						priceComma = rsH.getString("FORMAT(prodPrice, 0)");
						prodCtg = rsH.getString("prodCtg");
						prodType = rsH.getString("prodType");
						prodImg = rsH.getString("prodImg");
						prodStatus = rsH.getString("prodStatus");
						prodDate = rsH.getString("prodDate");
				%>
				<div class="prodBox">
					<div class="BoxImg">
						<%
							if(prodStatus.equals("판매중") != true) {
						%>
						<h3>SOLD OUT</h3>
						<%
							}
						%>
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
							<%
								if(prodStatus.equals("판매중")) {
							%>
							<a href="session/addWish.jsp?prodID=<%=prodID%>"><img src="images/Icon/Icon_heart.png"></a>
							<a href="session/addCart.jsp?sendData=<%=prodID%>_1"><img src="images/Icon/Icon_cart.png"></a>
							<%
								}
								else {
							%>
							<a href="session/addWish.jsp?prodID=<%=prodID%>"><img src="images/Icon/Icon_heart.png"></a>
							<a id="SOLDOUT"><img src="images/Icon/Icon_cart.png"></a>
							<%
								}
							%>
						</span>
					</div>
				</div>
				<%
					}
					rsH.close();
					pstmtH.close();
				%>
			</span>
		</article>

		<!-- 검색 결과 0건 -->
		<p><b>'<%=keyword%>'</b>의 검색 결과를 찾을 수 없습니다. &#9785;</p>
		<a class="Link" href="prodList.jsp">전체 상품 둘러보기 &#10095;</a>
		<aside>
			<!-- 랜덤 추천 -->
			<h2>이런 제품은 어떠세요?</h2>
			<span>
				<%
					Random random = new Random();
					int num = (random.nextInt(3)) + 1;
					int loadNum = 1;
					int countNum = 0;

					String loadRandom = "SELECT * FROM V_best WHERE prodStatus = '판매중'";
					PreparedStatement pstmtRandom = con.prepareStatement(loadRandom);
					ResultSet rsRandom = pstmtRandom.executeQuery();

					while(rsRandom.next()){
						if(countNum < 4) {
							if(loadNum % num == 0) {
								prodID = rsRandom.getString("prodID"); 
								prodName = rsRandom.getString("prodName"); 
								priceComma = rsRandom.getString("FORMAT(prodPrice, 0)");
								prodCtg = rsRandom.getString("prodCtg");
								prodType = rsRandom.getString("prodType");
								prodImg = rsRandom.getString("prodImg");
								prodStatus = rsRandom.getString("prodStatus");
				%>
				<div class="prodBox">
					<div class="BoxImg">
						<%
							if(prodStatus.equals("판매중") != true) {
						%>
						<h3>SOLD OUT</h3>
						<%
							}
						%>
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
							<%
								if(prodStatus.equals("판매중")) {
							%>
							<a href="session/addWish.jsp?prodID=<%=prodID%>"><img src="images/Icon/Icon_heart.png"></a>
							<a href="session/addCart.jsp?sendData=<%=prodID%>_1"><img src="images/Icon/Icon_cart.png"></a>
							<%
								}
								else {
							%>
							<a href="session/addWish.jsp?prodID=<%=prodID%>"><img src="images/Icon/Icon_heart.png"></a>
							<a id="SOLDOUT"><img src="images/Icon/Icon_cart.png"></a>
							<%
								}
							%>
						</span>
					</div>
				</div>
				<%
								countNum++;
							}
							loadNum++;
						}
						else {
							break;
						}
					}
					rsRandom.close();
					pstmtRandom.close();
				%>
			</span>
		</aside>
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