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

	// 테스트 실시 여부
	String typeResult = "";
	if(id != null) {
		String loadResult = "SELECT * FROM V_loadUser WHERE userID = ?";
		PreparedStatement pstmtResult = con.prepareStatement(loadResult);
		pstmtResult.setString(1, id);
		ResultSet rsResult = pstmtResult.executeQuery();
		rsResult.next();

		typeResult = rsResult.getString("typeResult");

		rsResult.close();
		pstmtResult.close();
	}
%>
<script>
	$(document).ready(function() {
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
			$(".testResult").css("display", "none");
		}
		else {
			var type = "<%=typeResult%>";
			if(type != "테스트 결과 없음") {
				$(".btnTestStart").text("⟲ 다시하기");
			}
			switch (type) {
				case "수박 타입" :
					$(".typeResult h1").css("color", "#FF6653");
					$(".typeResult h5").css("color", "rgba(255, 102, 83, 0.8)");
					$(".typeResult img").attr("src", "images/typeTest/result_Watermelon.png");
					$(".testResult aside h1").css("color", "#FF6653");
					break;
				case "아보카도 타입" :
					$(".typeResult h1").css("color", "#39AE86");
					$(".typeResult h5").css("color", "rgba(57, 174, 134, 0.8)");
					$(".typeResult img").attr("src", "images/typeTest/result_Avocado.png");
					$(".testResult aside h1").css("color", "#39AE86");
					break;
				case "망고 타입" :
					$(".typeResult h1").css("color", "#FFB72E");
					$(".typeResult h5").css("color", "rgba(255, 183, 46, 0.8)");
					$(".typeResult img").attr("src", "images/typeTest/result_Mango.png");
					$(".testResult aside h1").css("color", "#FFB72E");
					break;
				case "블루베리 타입" :
					$(".typeResult h1").css("color", "#57368E");
					$(".typeResult h5").css("color", "rgba(87, 54, 142, 08)");
					$(".typeResult img").attr("src", "images/typeTest/result_Blueberry.png");
					$(".testResult aside h1").css("color", "#57368E");
					break;
				default :
					break;
			}
		}

		// 테스트 시작 버튼
		$(".btnTestStart").click(function() {
			location.href = "sub/testLevel_A1.jsp";
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

<main class="testMain">
	<section>
		<!-- 시작 버튼 -->
		<article class="testStart">
			<mark><p>나에게 알맞은 피부 케어를 위해</p></mark>
			<mark><h1>Puresh 피부 타입 테스트</h1></mark>
			<button class="btnTestStart">시작하기</button>
		</article>

		<!-- 지난 테스트 결과 (* 로그인 한정 )-->
		<%
			if (id != null) {
		%>
		<article class="testResult">
			<%
				if(typeResult.equals("테스트 결과 없음")) {
			%>
			<div class="typeResult">
				<p>
					저장 된 테스트 결과가 없습니다.<br>
					테스트 완료 후 <b>결과 저장하기</b>를 눌러 결과를 저장하고 제품을 추천 받아 보세요!
				</p>
			</div>
			<%
				}
				else {
					String result = "";
					String typeIntro = "";
					String typeCatch = "";
					String loadType = "";
					switch (typeResult) {
						case "수박 타입" :
							result = "WaterMelon";
							typeIntro = "촉촉한 수분이 필요한 건성 타입";
							typeCatch = "수박의 촉촉함으로 당신의 피부에 수분 충전!<br>촉촉한 Watermelon Line으로 건조한 피부를 탱탱하게!";
							loadType = "SELECT * FROM V_detail WHERE prodType = '건성'";
							break;
						case "아보카도 타입" :
							result = "Avocado";
							typeIntro = "뛰어난 흡수력이 필요한 지성 타입";
							typeCatch = "아보카도의 흡수력으로 피지를 없애버리자!<br>뛰어난 수분 흡수력을 자랑하는 Avocado Line으로 부드럽고 매끈한 피부로!";
							loadType = "SELECT * FROM V_detail WHERE prodType = '지성'";
							break;
						case "망고 타입" :
							result = "Mango";
							typeIntro = "밸런스가 필요한 복합 타입";
							typeCatch = "어느 쪽도 아닌 애매한 피부? 복합이긴 복합인데 잘 모르겠다? 여기 망고가 있다!<br>영양만점 Mango Line으로 어떤 피부든 자신있게!";
							loadType = "SELECT * FROM V_detail WHERE prodType = '복합'";
							break;
						case "블루베리 타입" :
							result = "Blueberry";
							typeIntro = "확실한 해결책이 필요한 수부지 타입";
							typeCatch = "피지 분비량은 많은데 금방 건조해지는 피부가 고민?<br>탄력있는 Blueberry Line이 해결!";
							loadType = "SELECT * FROM V_detail WHERE prodType = '수부지'";
							break;
						default:
							break;
					}
			%>
			<div class="typeResult">
				<h5>당신의 피부 타입은</h5>
				<h1><%=typeResult%></h1>
				<img src="images/typeTest/result_Watermelon.png">
				<h3><%=typeIntro%></h3>
			</div>
			<!-- 제품 추천 -->
			<aside>
				<h1><%=result%>&nbsp;Line</h1>
				<p><%=typeCatch%></p>
				<span>
					<%
						PreparedStatement pstmtType = con.prepareStatement(loadType);
						ResultSet rsType = pstmtType.executeQuery();
						
						while(rsType.next()){ 
							prodID = rsType.getString("prodID"); 
							prodName = rsType.getString("prodName"); 
							priceComma = rsType.getString("priceComma");
							prodCtg = rsType.getString("prodCtg");
							prodStatus = rsType.getString("prodStatus");
							prodImg = rsType.getString("prodImg");
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
						rsType.close();
						pstmtType.close();
					%>
				</span>
			</aside>
			<%
				}
			%>
		</article>
		<%
			}
		%>

		<!-- 테스트 설명 -->
		<article class="testInfo">
			<h1>피부 타입을 알아야 하는 이유</h1>
			<p>
				자신에게 맞는 피부 관리법을 알고 실천하기 위해선<br>
				먼저 <b>자신의 피부를 아는 것</b>이 중요해요
			</p>
			<h4>
				Puresh에서는 피부 타입을  4가지 유형으로 나누어 소개하고 있습니다.
			</h4>
			<div class="typeImg">
				<span><img src="images/typeTest/testInfo_Watermelon01.png"></span>
				<span><img src="images/typeTest/testInfo_Avocado01.png"></span>
				<span><img src="images/typeTest/testInfo_Mango01.png"></span>
				<span><img src="images/typeTest/testInfo_Blueberry01.png"></span>
			</div>
			<div class="typeInfo">
				<img src="images/typeTest/testInfo_Watermelon02.png">
				<span>
					<h3>건성 피부</h3>
					<h4>수박의 시원한 수분이 필요한 당신!</h4>
					<p>
						피지 분비량과 수분 보유량이 모두 적어 표면이 거칠고 각질과 주름이 잘 생기는 건성 피부<br>
						수박의 시원하고 풍부한 수분으로 속까지 촉촉한 피부에 한 걸음 더 다가가 보아요!
					</p>
				</span>
			</div>
			<div class="typeInfo">
				<img src="images/typeTest/testInfo_Avocado02.png">
				<span>
					<h3>지성 피부</h3>
					<h4>아보카도의 뛰어난 수분 흡수력이 필요한 당신!</h4>
					<p>
						수분 보유량이 많지만 피지 분비량도 많아 피부에 금방 기름기가 올라오는 지성 피부<br>
						아보카도의 뛰어난 수분 흡수력을 이용해 피지 분비량을 줄이고 수분만을 흡수해 부드럽고 매끈한 피부로 나아가 보아요!
					</p>
				</span>
			</div>
			<div class="typeInfo">
				<img src="images/typeTest/testInfo_Mango02.png"></span>
				<span>
					<h3>복합성 피부</h3>
					<h4>망고의 다재다능한 비타민이 필요한 당신!</h4>
					<p>
						지성과 건성의 특징을 모두 가지고 있거나 어느쪽으로 확실하게 치우치지 않은 일반 복합성 피부<br>
						망고의 넘치는 비타민A와 비타민C로 피부를 개선하고 탄력을 유지해 보아요!
					</p>
				</span>
			</div>
			<div class="typeInfo">
				<img src="images/typeTest/testInfo_Blueberry02.png">
				<span>
					<h3>수부지 피부</h3>
					<h4>블루베리의 탱글탱글한 탄력이 필요한 당신!</h4>
					<p>
						피지 분비량은 많지만 수분 보유량이 적어 피지가 많고 피부가 건조하여 속당김이 많은 수분 부족형 지성 피부<br>
						블루베리의 촉촉한 수분과 비타민으로 피부를 건조함으로부터 보호하고 활력을 불어넣어 보아요!
					</p>
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