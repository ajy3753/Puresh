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

	// prodID
	String prodID = request.getParameter("prodID");

	// 상품 정보 불러오기
	String sqlDetail = "SELECT * FROM V_detail WHERE prodID = ?";
	PreparedStatement pstmtD = con.prepareStatement(sqlDetail);
	pstmtD.setString(1, prodID);
	ResultSet rsD = pstmtD.executeQuery();
	rsD.next();

	// prodBox용 변수
	String prodName = rsD.getString("prodName"); 
	int prodPrice = rsD.getInt("prodPrice");
	String priceComma = rsD.getString("priceComma");
	int prodStock = rsD.getInt("prodStock");
	String prodCtg = rsD.getString("prodCtg");
	String prodType = rsD.getString("prodType");
	int prodVolume = rsD.getInt("prodVolume");
	String prodImg = rsD.getString("prodImg"); 
	String prodInfo = rsD.getString("prodInfo"); 
	String prodStatus = rsD.getString("prodStatus"); 

	rsD.close();
	pstmtD.close();

	// 포인트 계산, 콤마 적용
	String pointComma = "";
	char[] comma = (Integer.toString((prodPrice / 1000) * 5)).toCharArray();
	for(int index = comma.length, cnt = 0; index > 0; index--) {
		if(cnt % 3 == 0 && cnt != 0) {
			pointComma = Character.toString(comma[index - 1]) + ',' + pointComma;
		}
		else {
			pointComma = Character.toString(comma[index - 1]) + pointComma;
		}
		cnt++;
	}

	// 리뷰 개수
	String reviewCount = "SELECT COUNT(*) FROM (SELECT *, ROW_NUMBER() OVER(PARTITION BY userID ORDER BY reviewID DESC) AS 'ROW_NUM' FROM V_reviewList WHERE prodID = ?) AS NUM WHERE NUM.ROW_NUM = 1";
	PreparedStatement pstmtCount = con.prepareStatement(reviewCount);
	pstmtCount.setString(1, prodID);
	ResultSet rsCount = pstmtCount.executeQuery();
	rsCount.next();

	int listCount = rsCount.getInt("COUNT(*)");
	
	rsCount.close();
	pstmtCount.close();

	int listPage = 0;
	if (listCount > 0) {
		listPage = (listCount/4);
		if(listCount%4 > 0) {
			listPage++;
		}
	}

	// 리뷰 작성 가능 유무
	int searchResult = 0;
	if(id != null) {
		String searchReview = "SELECT COUNT(*) FROM V_orderList WHERE userID = ? AND prodID = ? AND orderStatus = '구매 확정'";
		PreparedStatement pstmtSR = con.prepareStatement(searchReview);
		pstmtSR.setString(1, id);
		pstmtSR.setString(2, prodID);
		ResultSet rsSR = pstmtSR.executeQuery();
		rsSR.next();

		searchResult = rsSR.getInt("COUNT(*)");

		rsSR.close();
		pstmtSR.close();
	}
%>
<!-- jQuery -->
<script>
	$(document).ready(function(){
		// 로그인 여부
		var id = "<%=id%>";
		if (id == "null" || id == "") {
			$(".menuSub li a").attr("href", "login.jsp");
			$(".menuDrop").css("height", "5vw");
			$(".menuDrop li").css("display", "none");
			$(".menuDrop li.Logout").css("display", "block");
			$(".btnOrder button").click(function () {
				alert("로그인이 필요한 기능입니다.");
				location.href = "login.jsp";
			});

			// 리뷰 막기
			$(".reviewWrite span p").text("로그인 후 이용 가능합니다.");
		}
		else {
			// btnOrder 동작
			var sendData = "formProd_" + "<%=prodID%>";
			var sendID = "<%=prodID%>"
			var URL;
			// btnBuy (바로 구매하기)
			$("#btnBuy").click(function () {
				sendData = sendData + "_" + $("#stockResult").text();
				URL = "order.jsp?sendData="  + sendData;
				location.href = URL;
			});
			// btnWish (관심상품 담기)
			$("#btnWish, .btnOrder button.Off").click(function () {
				location.href = "session/addWish.jsp?prodID=<%=prodID%>";
			});
			// btnCart (장바구니 담기)
			$("#btnCart").click(function () {
				sendData = sendID+ "_" + $("#stockResult").text();
				URL = "session/addCart.jsp?sendData=" + sendData;
				location.href = URL;
			});
			// 리뷰 작성 활성화
			let searchResult = "<%=searchResult%>";

			// #reviewWrite (리뷰 작성)
			$(".reviewWrite span button#reviewWrite").click(function () {
				var sendData = $(this).attr("value");
				var URL = "sub/mypage_reviewWrite.jsp?sendData=" + sendData;
				window.open(URL, "리뷰 작성", "width=500, height=600, top=0, left=0");
			});
		}

		// 품절 및 재입고 상품 전용
		var status = $(".Status").text();
		if(status == "품절" || status == "재입고 예정") {
			$(".btnOrder button").css("display", "none");
			$(".Status, .btnOrder button.Off").css("display", "block");
			$(".Status").text("SOLD OUT");
			$("#btnAdd").attr("disabled", "disabled");
		}

		// 상품 수량 조절 버튼
		var price = "<%=prodPrice%>";
		var stock = "<%=prodStock%>";
		// + 버튼
		$("#btnAdd").click(function () {
			let stockCnt = $("#stockResult").text();
			if(stockCnt == stock || stockCnt == 10) {
				$("#btnAdd").addClass("Off");
				alert("최대 수량입니다.");
			}
			else {
				stockCnt = parseInt(stockCnt) + 1;
				if(stockCnt == stock || stockCnt == 10) {
					$("#btnAdd").addClass("Off");
				}
				if(stockCnt > 1) {
					$("#btnSub").removeClass("Off");
				}
			}
			let total = (price * stockCnt);
			const totalComma = total.toLocaleString('ko-KR');
			$("#stockResult").text(stockCnt);
			$("#totalResult").text(totalComma);
		});
		// - 버튼
		$("#btnSub").click(function () {
			let stockCnt = $("#stockResult").text();
			if(stockCnt == 1) {
				$("#btnSub").addClass("Off");
				alert("최소 수량입니다.");
			}
			else {
				stockCnt = parseInt(stockCnt) - 1;
				if(stockCnt == 1) {
					$("#btnSub").addClass("Off");
				}
				if(stockCnt < stock && stockCnt < 10) {
					$("#btnAdd").removeClass("Off");
				}
			}
			let total = (price * stockCnt);
			const totalComma = total.toLocaleString('ko-KR');
			$("#stockResult").text(stockCnt);
			$("#totalResult").text(totalComma);
		});

		// listCount
		var listCount = "<%=listCount%>";
		if(listCount == 0) {
			$(".detailSub .reviewList #listNN").css("display", "none");
			$(".detailSub .reviewList aside").css("display", "none");
			$(".detailSub .reviewList #listNot").css("display", "flex");
		}

		// 리뷰 페이지 넘기기
		var pageTotal = "<%=listPage%>";
		$(".reviewList button#pageDown").click(function () {
			let page = $(".reviewList b#page").text();
			if(page > 1) {
				page = parseInt(page) - 1;
				$(".reviewList b#page").text(page);
				$(".reviewList #listNN span").css("display", "none");
				for(let index = (parseInt(page)*4)-4; index <= parseInt(page)*4; index++) {
					$(".reviewList #listNN span").eq(index).css("display", "flex");
				}
			}
		});
		$(".reviewList button#pageUp").click(function () {
			let page = $(".reviewList b#page").text();
			if(page < pageTotal) {
				page = parseInt(page) + 1;
				$(".reviewList b#page").text(page);
				$(".reviewList #listNN span").css("display", "none");
				for(let index = (parseInt(page)*4)-4; index <= parseInt(page)*4; index++) {
					$(".reviewList #listNN span").eq(index).css("display", "flex");
				}
			}
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
	
<!-- 상품 상세정보 페이지 본문 -->
<main class="detailMain">
	<section class="detailContent">
		<!-- 메인 -->
		<article>
			<!-- 상품 메인 이미지 -->
			<div class="Img"><img src="<%=prodImg%>"></div>
			<!-- 상품 상세 정보 이미지 -->
			<div class="Info" style="flex-direction: column;">
				<img src="<%=prodInfo%>">
			</div>
			<!-- 기타 정보 탭 -->
			<div class="detailTab">
				<!-- 탭버튼 -->
				<ul>
					<li class="On">상품 정보</li>
					<li>상품 설명</li>
					<li>배송 안내</li>
					<li>교환 및 반품 안내</li>
					<li>품질보증기준</li>
				</ul>
				<!-- 상품 정보 -->
				<div class="On">
					<p><b>상품 정보</b></p>
					<p>상품명 : <%=prodName%></p>
					<p>판매가: <%=priceComma%>원</p>
					<p>카테고리 : <%=prodCtg%></p>
					<p>타입 : <%=prodType%></p>
					<p>용량 : <%=prodVolume%>mL</p>
					<p>제조국 : 한국</p>
				</div>
				<!-- 상품 설명 -->
				<div>
					<p><b>사용 방법</b></p>
					<p>
						1. 내용물을 적당량 덜어내 피부에 고르게 펴주세요.<br>
						2. 부드러운 화장솜이나 손으로 둥글게 굴리듯이 마사지하면서 발라주세요.<br>
					</p>
					<p><b>보관 방법 및 사용 기한</b></p>
					<p>
						보관 방법 : 직사광선이 닿지 않는 서늘한 장소 또는 냉장 보관<br>
						사용 기한 : 제조일로부터 35개월 / 개봉 후 12개월 (제품 하단 별도 확인)<br>
						※ 상품 발송일 기준으로 사용 기한이 12개월 이상 남은 상품만을 판매하고 있습니다.
					</p>
					<p><b>주의 사항</b></p>
					<p>
						1. 사용 중 피부에 붉은 반점, 가렵거나 따가움 등의 증상이 나타나면 즉시 사용을 중단하고 의사와 상담하십시오.<br>
						2. 개봉한 제품에서 이물질, 색 변화, 악취 등의 현상이 발견되면 즉시 사용을 중단하십시오.
					</p>
				</div>
				<!-- 배송 안내 -->
				<div>
					<p><b>배송 안내</b></p>
					<p>
						결제 완료 시점에서 영업일 기준 2일 이내에 배송이 시작됩니다. (평균 배송 기간 3 ~ 5일)<br>
						운송장은 <b>'마이페이지 > 주문확인/배송조회'</b>에서 확인 가능합니다.<br>
						(※운송장 등록 후 수하물이 택배사에 전달되기 전까지는 배송 조회가 불가능합니다.)
					</p>
					<p><b>배송 업체</b></p>
					<p>CJ대한통운</p>
					<p>(※ 택배사 사정에 따라 배송 일정이 달라질 수 있습니다.)</p>
				</div>
				<!-- 교환 및 반품 안내 -->
				<div>
					<p><b>교환 및 반품 기준 안내</b></p>
					<p>
						1. 상품에 큰 하자가 있는 경우 ( 패키지 훼손, 내용물 분실)<br>
						2. 내용물에 이상이 있을 경우 ( 악취, 곰팡이, 이물질 )<br>
						3. 주문에 오류가 발생했을 경우<br>
					</p>
					<p>
						'전자상거래에 의한 소비자보호에 관한 법률'에 의거, 반품기간 이내에는 언제든지 판매자(가맹점)에 반품/교환을 요청하실 수 있습니다. (반품운송비 원인제공자가 부담 원칙) 반품을 원하시는 경우 우선 판매자(가맹점)에 직접 연락하여 사유, 배송방법, 운송비를 협의하신 후 상품을 반송하시면 됩니다.
					</p>
					<p><font color="#C81C21">교환 및 반품 요청은 <b>배송 완료 후 7일 이내</b>까지 <b>'마이페이지 > 주문확인/배송조회'</b>에서 가능합니다. 구매 확정 이후에는 교환 및 반품이 불가능합니다.</font></p>
				</div>
				<!-- 품질보증기준 -->
				<div>
					<p>Puresh의 품질보증기준은 식품의약처안전처에서 고시한 <b>'우수화장품 제조 및 품질관리기준'</b>을 따르고 있습니다.</p>
					<p><a href="https://www.law.go.kr/행정규칙/우수화장품 제조 및 품질관리기준/(2020-12,20200225)">우수화장품 제조 및 품질관리기준</a></p>
				</div>
			</div>
		</article>

		<!-- 사이드바 -->
		<aside>
			<!-- 상품 정보 -->
			<ul>
				<!-- 상품 정보 (판매상태, 카테고리, 이름, 가격) -->
				<li style="color: #E1A1A1;"><a href="prodList.jsp?ctg=<%=prodCtg%>">&#10094; <%=prodCtg%></a></li>
				<li class="Status"><%=prodStatus%></li>
				<li><h1><%=prodName%></h1></li>
				<li style="margin-bottom: 3vw;"><h1><%=priceComma%>원</h1></li>
				<!-- 적립금 -->
				<li>
					<span>적립금 (0.5%)</span>
					<span><%=pointComma%>원</span>
				</li>
				<!-- 배송비 -->
				<li>
					<span>배송비 (7만원 이상 구매 시 무료)</span>
					<span>4,000원</span>
				</li>
				<!-- 수량 (btnStock) -->
				<li>
					<span>수량</span>
					<span class="btnStock">
						<button id="btnSub" class="Off">&#8211;</button>
						<p id="stockResult">1</p>
						<button id="btnAdd">&#43;</button>
					</span>
				</li>
				<!-- total -->
				<li>
					<span><h3>TOTAL</h3></span>
					<span>
						<h3 style="color: #C81C21;" id="totalResult"><%=priceComma%></h3>
						<h3>원</h3>
					</span>
				</li>
			</ul>
			<!-- 구매 버튼 -->
			<div class="btnOrder">
				<button id="btnBuy">바로 구매하기</button>
				<span>
					<button id="btnWish">관심상품 담기</button>
					<button id="btnCart">장바구니 담기</button>
				</span>
				<button id="btnWish" class="Off">관심상품 담기</button>
			</div>
		</aside>
	</section>

	<!-- 고객 리뷰 & 문의 -->
	<section class="detailSub">
		<!-- 리뷰 평점 -->
		<article class="reviewStatistics">
			<%
				String scoreAVG = "SELECT * FROM V_scoreAVG WHERE prodID = ?";
				PreparedStatement pstmtAVG = con.prepareStatement(scoreAVG);
				pstmtAVG.setString(1, prodID);
				ResultSet rsAVG = pstmtAVG.executeQuery();
				rsAVG.next();

				double avg = rsAVG.getDouble("ROUND(AVG(ratingScore), 1)");

				rsAVG.close();
				pstmtAVG.close();

				String scoreCount = "SELECT COUNT(ratingScore) FROM V_scoreCount WHERE prodID = ? AND ratingScore = ?";
				int[] countArray = new int[5];
				int zero = 0;
				for(int index = 1; index <= 5; index++) {
					PreparedStatement pstmtCOUNT = con.prepareStatement(scoreCount);
					pstmtCOUNT.setString(1, prodID);
					pstmtCOUNT.setInt(2, index);
					ResultSet rsCOUNT = pstmtCOUNT.executeQuery();
					rsCOUNT.next();

					countArray[index-1] = rsCOUNT.getInt("COUNT(ratingScore)");

					rsCOUNT.close();
					pstmtCOUNT.close();

					if(countArray[index-1] == 0) {
						zero++;
					}
				}

				String scorePercent = "SELECT * FROM V_scorePercent WHERE prodID = ?";
				PreparedStatement pstmtPer = con.prepareStatement(scorePercent);
				pstmtPer.setString(1, prodID);
				ResultSet rsPer = pstmtPer.executeQuery();
				rsPer.next();

				int SUM = rsPer.getInt("COUNT(reviewID)");

				rsPer.close();
				pstmtPer.close();

				int[] percentArray = new int[5];
				for(int index = 0; index <= 4; index++) {
					percentArray[index] = (countArray[index] * 100 / SUM);
					if(percentArray[index] == 0) {
						percentArray[index] = 1;
					}
				}
			%>
			<h1>&#9733; <%=avg%> / 5</h1>
			<table>
				<tr>
					<th>&#9733;5</th>
					<td class="Progress"><div style="width: <%=percentArray[4]%>%;">&nbsp;</div></td>
					<td><%=countArray[4]%></td>
				</tr>
				<tr>
					<th>&#9733;4</th>
					<td class="Progress"><div style="width: <%=percentArray[3]%>%;">&nbsp;</div></td>
					<td><%=countArray[3]%></td>
				</tr>
				<tr>
					<th>&#9733;3</th>
					<td class="Progress"><div style="width: <%=percentArray[2]%>%;">&nbsp;</div></td>
					<td><%=countArray[2]%></td>
				</tr>
				<tr>
					<th>&#9733;2</th>
					<td class="Progress"><div style="width: <%=percentArray[1]%>%;">&nbsp;</div></td>
					<td><%=countArray[1]%></td>
				</tr>
				<tr>
					<th>&#9733;1</th>
					<td class="Progress"><div style="width: <%=percentArray[0]%>%;">&nbsp;</div></td>
					<td><%=countArray[0]%></td>
				</tr>
			</table>
		</article>

		<!-- 리뷰 목록 -->
		<article class="reviewList">
			<aside>
				<h1>리뷰 <font color="#FF6653">(<%=listCount%>)</font></h1>
				<h4>
					<p><b id="page">1</b> / <%=listPage%></p>
					<button id="pageDown">&lt;</button>
					<button id="pageUp">&gt;</button>
				</h4>
			</aside>
			<div id="listNN">
				<%
					String userID;
					int ratingScore;
					String star;
					String reviewContent;
					String reviewDate;

					String reviewList = "SELECT * FROM (SELECT *, ROW_NUMBER() OVER(PARTITION BY userID ORDER BY reviewID DESC) AS 'ROW_NUM' FROM V_reviewList WHERE prodID = ?) AS NUM WHERE NUM.ROW_NUM = 1";
					PreparedStatement pstmtList = con.prepareStatement(reviewList);
					pstmtList.setString(1, prodID);
					ResultSet rsList = pstmtList.executeQuery();

					while(rsList.next()) {
						userID = rsList.getString("RPAD_userID");
						ratingScore = rsList.getInt("ratingScore");
						reviewContent = rsList.getString("reviewContent");
						reviewDate = rsList.getString("Date");

						star = "";
						for(int score = 1; score <= 5; score++) {
							if(score <= ratingScore) {
								star = star + "&#9733;";
							}
							else {
								star = star + "&#10032;";
							}
						}
				%>
				<span>
					<h1><b><%=star%></b><b><%=ratingScore%></b></h1>
					<h5><%=userID%></h5>
					<textarea disabled><%=reviewContent%></textarea>
					<h5><%=reviewDate%></h5>
				</span>
				<%
					}
					rsList.close();
					pstmtList.close();
				%>
			</div>
			<div id="listNot">
				<p>작성된 리뷰가 없습니다</p>
			</div>
		</article>

		<!-- 리뷰 작성/열람 -->
		<article class="reviewWrite">
			<!-- 리뷰 작성 버튼 -->
			<span>
			<%
				if(searchResult > 0) {
					String searchOrder = "SELECT * FROM V_orderList WHERE userID = ? AND prodID = ? AND orderStatus = '구매 확정' LIMIT 1";
					PreparedStatement pstmtSO = con.prepareStatement(searchOrder);
					pstmtSO.setString(1, id);
					pstmtSO.setString(2, prodID);
					ResultSet rsSO = pstmtSO.executeQuery();
					rsSO.next();

					String orderID = rsSO.getString("orderID");

					rsSO.close();
					pstmtSO.close();
			%>
			<p>작성 가능한 리뷰가 <b><%=searchResult%></b>개 있습니다.</p>
			<button id="reviewWrite" value="<%=prodID%>_<%=orderID%>">리뷰 작성</button>
			<%
				}
				else {
			%>
			<p>작성 가능한 리뷰가 없습니다.</p>
			<button id="reviewWrite" disabled>리뷰 작성</button>
			<%
				}
			%>
			</span>
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