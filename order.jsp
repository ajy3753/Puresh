<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@page import="java.text.*"%>
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

	// userID, 주문자 정보 불러오기
	String id = (String)session.getAttribute("sid");
	if(id == null) {
		response.sendRedirect("login.jsp");
	}
	else {
		String orderUser = "SELECT * FROM V_orderUser WHERE userID = ?";
		PreparedStatement pstmtUser = con.prepareStatement(orderUser);
		pstmtUser.setString(1, id);
		ResultSet rsUser = pstmtUser.executeQuery();
		rsUser.next();

		String userName = rsUser.getString("userName");
		String userPhone = rsUser.getString("userPhone");
		String[] phArray = userPhone.split("-");
		String ph1 = phArray[0];
		int ph2 = Integer.parseInt(phArray[1]);
		int ph3 = Integer.parseInt(phArray[2]);
		String userAdress = rsUser.getString("userAdress");
		int userPoint = rsUser.getInt("userPoint");

		rsUser.close();
		pstmtUser.close();

		// 현재 시간
		Timestamp now = new Timestamp(System.currentTimeMillis());
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		String date = format.format(now);

		// 전달 받은 prodID 또는 cartID 값
		String receiveData = request.getParameter("sendData");
		String[] receiveArray = receiveData.split("_");
		int L = receiveArray.length;

		// 판별 및 데이터 정리
		String[] dataArray = new String[(L-1)*3];
		if(receiveArray[0].equals("fromCart")) {
			int countCD = 0;
			String cartDetail = "SELECT * FROM cartTBL WHERE userID = ? AND cartID = ?";
			for(int index = 1; index < L; index++) {
				PreparedStatement pstmtCD = con.prepareStatement(cartDetail);
				pstmtCD.setString(1, id);
				pstmtCD.setString(2, receiveArray[index]);
				ResultSet rsCD = pstmtCD.executeQuery();
				rsCD.next();

				dataArray[countCD] = receiveArray[index];
				dataArray[countCD+1] = rsCD.getString("prodID");
				dataArray[countCD+2] = rsCD.getString("cartStock");

				countCD+=3;

				rsCD.close();
				pstmtCD.close();
			}
		}
		else {
			dataArray = new String[L];
			dataArray[0] = "C00000000A001";
			dataArray[1] = receiveArray[1];
			dataArray[2] = receiveArray[2];
		}

		// prod 변수
		String prodName;
		int prodPrice;
		String prodCtg;
		String prodImg;

		String priceComma;
		String orderComma;
		String payComma;
		char[] comma;

		// order 변수
		int orderTotal;
		int payTotal = 0;

		String pointComma = "";
		comma = (Integer.toString(userPoint)).toCharArray();
		for(int iComma = comma.length, cnt = 0; iComma > 0; iComma--) {
			if(cnt % 3 == 0 && cnt != 0) {
				pointComma = Character.toString(comma[iComma - 1]) + ',' + pointComma;
			}
			else {
				pointComma = Character.toString(comma[iComma - 1]) + pointComma;
			}
			cnt++;
		}
%>
<script>
	$(document).ready(function(){
		// 받는 이 채우기
		$("#btnName").click(function () {
			if($(this).is(":checked")) {
				var name = $("#orderer").val();
				$("#receiver").val(name);
			}
			else {
				$("#receiver").val("");
			}
		});
		$("#receiver").on("change", function () {
			var name = $("#orderer").val();
			var receiverName = $(this).val();
			if(name != receiverName) {
				$("#btnName").prop("checked", false);
			}
		});

		// 전번 채우기
		var ph1 = "<%=ph1%>";
		$(".orderInfo tr.short td select").val(ph1).prop("checked", true);

		// 입금일 날짜 금일로 설정
		var today = "<%=date%>"
		$(".payMethod #methodDate").val(today);

		// 배송비
		let prdTotal = $("#orderTotal input").val();
		var total = 0;
		var totalComma = "";
		if(prdTotal < 70000) {
			total = parseInt(prdTotal) + 4000;
			totalComma = total.toLocaleString('ko-KR');
			$("#payTotal input").val(total);
			$("#payTotal h2 font").text(totalComma);
		}
		else {
			total = prdTotal;
			$("#deliveryCharge input").val("0");
			$("#deliveryCharge h2").text("0원");
		}

		// 포인트 사용
		var totalPoint = "<%=userPoint%>";
		var pointComma = "";
		var sum = 0;
		$("#payPoint").on("change", function() {
			var point = $(this).val();
			if(point > 10000) {
				point = 10000;
				sum = parseInt(total) - parseInt(point);
				pointComma = parseInt(point).toLocaleString('ko-KR');
				totalComma = sum.toLocaleString('ko-KR');
				$("#payPoint").val(point);
				$("#payPointResult h2").text(pointComma + "원");
				$("#payTotal input").val(totalPoint);
				$("#payTotal h2 font").text(totalComma);
				if(totalPoint > 1000) {
					$("#btnPoint").prop("checked", false);
				}
				else {
					$("#btnPoint").prop("checked", true);
				}
			}
			else {
				if (parseInt(point) > parseInt(totalPoint) || point == totalPoint) {
					sum = parseInt(total) - parseInt(totalPoint);
					pointComma = parseInt(point).toLocaleString('ko-KR');
					totalComma = sum.toLocaleString('ko-KR');
					$("#payPoint").val(totalPoint);
					$("#btnPoint").prop("checked", true);
					$("#payPointResult h2").text(pointComma + "원");
					$("#payTotal input").val(totalPoint);
					$("#payTotal h2 font").text(totalComma);
				}
				else {
					sum =  parseInt(total) - parseInt(point);
					pointComma = parseInt(point).toLocaleString('ko-KR');
					totalComma = sum.toLocaleString('ko-KR');
					$("#btnPoint").prop("checked", false);
					$("#payPointResult h2").text(pointComma + "원");
					$("#payTotal input").val(sum);
					$("#payTotal h2 font").text(totalComma);
				}
			}
		});

		// 포인트 전액 사용 버튼
		$("#btnPoint").click(function () {
			if(totalPoint > 10000) {
				totalPoint = 10000;
			}
			if($(this).is(":checked")) {
				sum = parseInt(total) - parseInt(totalPoint);
				pointComma = parseInt(totalPoint).toLocaleString('ko-KR');
				totalComma = sum.toLocaleString('ko-KR');
				$("#payPoint, #payPoint input").val(totalPoint);
				$("#payPointResult h2").text(pointComma + "원");
				$("#payTotal input").val(sum);
				$("#payTotal h2 font").text(totalComma);
			}
			else {
				totalComma = total.toLocaleString('ko-KR');
				$("#payPoint, #payPoint input").val("0");
				$("#payPointResult h2").text("0원");
				$("#payTotal input").val(totalComma);
				$("#payTotal h2 font").text(totalComma);
			}
		});
	});
	// input number 글자수 제한
	function handleOnInput(el, maxlength) {
	  if(el.value.length > maxlength)  {
		el.value 
		  = el.value.substr(0, maxlength);
	  }
	}
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

<main class="orderMain">
	<section>
		<form action="session/pay.jsp">

			<!-- 상품 주문 내역-->
			<article class="orderPrd">
				<h1>상품 주문 내역</h1>
				<table>
					<tr>
						<th colspan="2">상품정보</th>
						<th>수량</th>
						<th>상품금액</th>
						<th>합계</th>
					</tr>
					<%
						// 상품 정보 불러오기
						String loadPrd = "SELECT * FROM V_detail WHERE prodID = ?";
						for(int index = 0; index < dataArray.length; index+=3) {
							PreparedStatement pstmtLoad = con.prepareStatement(loadPrd);
							pstmtLoad.setString(1, dataArray[index+1]);
							ResultSet rsLoad = pstmtLoad.executeQuery();
							rsLoad.next();

							prodName = rsLoad.getString("prodName");
							prodPrice = rsLoad.getInt("prodPrice");
							prodCtg = rsLoad.getString("prodCtg");
							prodImg = rsLoad.getString("prodImg");

							orderTotal =  Integer.parseInt(dataArray[index+2]) * prodPrice;
							payTotal = payTotal + orderTotal;

							// 콤마 적용
							priceComma = "";
							comma = (Integer.toString(prodPrice)).toCharArray();
							for(int iComma = comma.length, cnt = 0; iComma > 0; iComma--) {
								if(cnt % 3 == 0 && cnt != 0) {
									priceComma = Character.toString(comma[iComma - 1]) + ',' + priceComma;
								}
								else {
									priceComma = Character.toString(comma[iComma - 1]) + priceComma;
								}
								cnt++;
							}

							orderComma = "";
							comma = (Integer.toString(orderTotal)).toCharArray();
							for(int iComma = comma.length, cnt = 0; iComma > 0; iComma--) {
								if(cnt % 3 == 0 && cnt != 0) {
									orderComma = Character.toString(comma[iComma - 1]) + ',' + orderComma;
								}
								else {
									orderComma = Character.toString(comma[iComma - 1]) + orderComma;
								}
								cnt++;
							}
					%>
					<tr>
						<!-- cartID, prodID -->
						<input type="hidden" name="cartID" value="<%=dataArray[index]%>">
						<input type="hidden" name="prodID" value="<%=dataArray[index+1]%>">

						<!-- 상품 이미지 -->
						<td><img src="<%=prodImg%>"></td>

						<!-- 상품 정보-->
						<td class="prodInfo">
							<p style="color: #D6684C;"><%=prodCtg%></p>
							<p style="font-weight: bold;"><%=prodName%></p>
						</td>

						<!-- 수량, 상품금액, 합계 -->
						<td><input type="hidden" name="orderStock" value="<%=dataArray[index+2]%>"><%=dataArray[index+2]%></td>
						<td><input type="hidden" name="orderPrice" value="<%=prodPrice%>"><%=priceComma%>원</td>
						<td><input type="hidden" name="orderTotal" value="<%=orderTotal%>"><%=orderComma%>원</td>
					</tr>
					<%
							rsLoad.close();
							pstmtLoad.close();
						}

						payComma = "";
						comma = (Integer.toString(payTotal)).toCharArray();
						for(int iComma = comma.length, cnt = 0; iComma > 0; iComma--) {
							if(cnt % 3 == 0 && cnt != 0) {
								payComma = Character.toString(comma[iComma - 1]) + ',' + payComma;
							}
							else {
								payComma = Character.toString(comma[iComma - 1]) + payComma;
							}
							cnt++;
						}
					%>
					<tr>
						<td colspan="5" class="payPrice">총 합계&ensp;<%=payComma%>원</td>
					</tr>
				</table>
			</article>

			<!-- 주문 정보-->
			<article>
				<h1>주문 정보</h1>
				<table class="orderInfo">
					<tr>
						<th>주문자명<font color="#C81C21">*</font></th>
						<td><input type="text" id="orderer" name="orderer" value="<%=userName%>" maxlength="20" placeholder="최대 20자" required></td>
					</tr>
					<!-- 배송 정보 -->
					<tr>
						<th>받는 이<font color="#C81C21">*</font></th>
						<td><input type="text" id="receiver" name="receiver" value="" maxlength="20" placeholder="최대 20자" required></td>
					</tr>
					<tr>
						<td class="userName" colspan="2">
							<input type="checkbox" id="btnName">
							<label for="btnName">&#10004;</label>
							<p>주문자명과 동일</p>
						</td>
					</tr>
					<tr>
						<th>배송 주소<font color="#C81C21">*</font></th>
						<td><input type="text" name="receiverAddr" value="<%=userAdress%>" maxlength="50" required></td>
					</tr>
					<tr class="short">
						<th>연락처<font color="#C81C21">*</font></th>
						<td>
							<select name="receiverPh1">
								<option value="010">010</option>
								<option value="011">011</option>
								<option value="016">016</option>
								<option value="017">017</option>
								<option value="018">018</option>
								<option value="019">019</option>
							</select>
							<b>&ensp;-&ensp;</b>
							<input type="number" name="receiverPh2" value="<%=ph2%>" oninput="handleOnInput(this, 4)" required>
							<b>&ensp;-&ensp;</b>
							<input type="number" name="receiverPh3" value="<%=ph3%>" oninput="handleOnInput(this, 4)" required>
						</td>
					</tr>
				</table>
			</article>

			<!-- 포인트 사용 -->
			<article>
				<h1>포인트</h1>
				<table class="orderInfo">
					<tr>
						<th>포인트 사용</th>
						<td class="orderPoint">
							<input type="number" id="payPoint" name="payPoint" value="0" max="<%=userPoint%>" min="0" required>P
						</td>
					</tr>
					<tr>
						<td class="userPoint" colspan="2">
							<p>보유 포인트&ensp; <b><%=pointComma%>P</b></P>
							<input type="checkbox" id="btnPoint">
							<label for="btnPoint">&#10047;</label>
							<p>전액 사용 (최대 1만원)</p>
						</td>
					</tr>
				</table>
			</article>

			<!-- 결제 수단 -->
			<article>
				<!-- 결제 방식 선택 -->
				<h1>결제 수단</h1>
				<table class="orderInfo">
					<tr>
						<th>결제 방식</th>
						<td class="selectMethod">
							<!-- 무통장 입금 -->
							<input type="radio" id="NoBankBook" name="payMethod" value="NoBankBook" checked>
							<label for="NoBankBook">&#10047;</label>
							<p>무통장 입금</p>
							<!-- 카카오페이 송금 --->
							<input type="radio" id="KakaoPayRemittance" name="payMethod" value="KakaoPayRemittance">
							<label for="KakaoPayRemittance">&#10047;</label>
							<p><img src="images/btn_send_tiny.png"></p>
						</td>
					</tr>
				</table>

				<!-- 무통장 입금 -->
				<div class="payMethod On" id="NoBankBook">
					<table class="orderInfo">
						<tr>
							<th>계좌번호<font color="#C81C21">*</font></th>
							<td>
								<select id="Bank" name="methodBank">
									<option value="KB국민은행">KB국민은행</option>
									<option value="NH농협">NH농협</option>
									<option value="MG새마을금고">MG새마을금고</option>
									<option value="KEB하나은행">KEB하나은행</option>
									<option value="IBK기업은행">IBK기업은행</option>
									<option value="신한은행">신한은행</option>
									<option value="우리은행">우리은행</option>
									<option value="카카오뱅크">카카오뱅크</option>
									<option value="케이뱅크">케이뱅크</option>
									<option value="토스뱅크">토스뱅크</option>
								</select>
								<input type="number" name="methodAccount1" oninput="handleOnInput(this, 6)" required>
								<b>&nbsp;-&nbsp</b>
								<input type="number" name="methodAccount2" oninput="handleOnInput(this, 2)" required>
								<b>&nbsp;-&nbsp</b>
								<input type="number" name="methodAccount3" oninput="handleOnInput(this, 6)" required>
							</td>
						</tr>
						<tr>
							<th>입금자명<font color="#C81C21">*</font></th>
							<td><input type="text" name="methodName" maxlength="20" placeholder="최대 20자" required></td>
						</tr>
					</table>
					<p>
						*계좌정보와 입금자명을 정확히 입력해주세요.<br>
						&ensp;기입한 정보와 실제 입금 내역에 차이가 발생할 시 입금 확인이 어려울 수 있습니다.<br>
						*입금 확인에는 입금 완료로부터 영업일 기준 최대 1일이 소요됩니다.
					</p>
				</div>
				
				<!-- 카카오페이 송금 -->
				<div class="payMethod" id="KakaoPayRemittance">
					<table class="orderInfo">
						<tr>
							<th>입금자명<font color="#C81C21">*</font></th>
							<td><input type="text" name="methodName" maxlength="20" placeholder="최대 20자"></td>
						</tr>
						<tr>
							<th>입금일<font color="#C81C21">*</font></th>
							<td><input type="date" id="methodDate" name="methodDate"></td>
						</tr>
					</table>
					<p>
						*입금자명을 정확히 입력해주세요.<br>
						&ensp;기입한 정보와 실제 입금 내역에 차이가 발생할 시 입금 확인이 어려울 수 있습니다.<br>
						&ensp;동명이인 방지를 위해 실명 + 전화번호 뒷자리 숫자 4개를 쓰는 방식을 추천드립니다.<br>
						&ensp;(예. 홍길동1618)<br>
						*입금일이 지나고 나서도 입금확인이 되지 않는 주문은 취소됩니다.<br>
						*입금 확인에는 설정하신 입금일로부터 영업일 기준 최대 1일이 소요됩니다.
					</p>
				</div>

				<!--환불 계좌 -->
				<div class="payRefund On">
					<h1>환불 계좌</h1>
					<table class="orderInfo">
						<tr>
							<th>계좌번호<font color="#C81C21">*</font></th>
							<td>
								<select id="Bank" name="refundBank">
									<option value="KB국민은행">KB국민은행</option>
									<option value="NH농협">NH농협</option>
									<option value="MG새마을금고">MG새마을금고</option>
									<option value="KEB하나은행">KEB하나은행</option>
									<option value="IBK기업은행">IBK기업은행</option>
									<option value="신한은행">신한은행</option>
									<option value="우리은행">우리은행</option>
									<option value="카카오뱅크">카카오뱅크</option>
									<option value="케이뱅크">케이뱅크</option>
									<option value="토스뱅크">토스뱅크</option>
								</select>
								<input type="number" name="refundAccount1" oninput="handleOnInput(this, 6)" required>
								<b>&nbsp;-&nbsp</b>
								<input type="number" name="refundAccount2" oninput="handleOnInput(this, 2)" required>
								<b>&nbsp;-&nbsp</b>
								<input type="number" name="refundAccount3" oninput="handleOnInput(this, 6)" required>
							</td>
						</tr>
						<tr>
							<th>예금주명<font color="#C81C21">*</font></th>
							<td><input type="text" name="refundName" maxlength="20" placeholder="최대 20자" required></td>
						</tr>
					</table>
					<p>
						*주문 취소, 반품 등이 발생 시 환불 받으실 계좌 정보를 입력해주세요.<br>
						&ensp;정보를 정확히 기입하지 않아 생기는 피해는 당사에서 책임지지 않습니다.<br>
						*환불은 영업일 기준 5 ~ 7일 소요됩니다.
					</p>
				</div>
			</article>

			<!-- 최종 결제 금액 -->
			<article>
				<h1>최종 결제 금액</h1>
				<div class="lastTotal">
					<!-- 총 상품금액 -->
					<span id="orderTotal">
						<input type="hidden" name="payPrice" value="<%=payTotal%>">
						<h2><%=payComma%>원</h2>
						<p>총 상품금액</p>
					</span>
					<!-- 할인 금액 -->
					<p>-</p>
					<span id="payPointResult">
						<h2>0원</h2>
						<p>포인트 사용</p>
					</span>
					<!-- 배송비 -->
					<p>+</p>
					<span id="deliveryCharge">
						<input type="hidden" name ="deliveryCharge" value="4000">
						<h2>4,000원</h2>
						<p>배송비</p>
					</span>
					<!-- 최종 결제 금액 -->
					<p>=</p>
					<span id="payTotal">
						<input type="hidden" name="payTotal" value="<%=payTotal%>">
						<h2><font color="#C81C21"><%=payComma%></font>원</h2>
						<p>최종 결제 금액</p>
					</span>
				</div>
			</article>

			<button type="submit">결제하기</button>
		</form>

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
	}
	con.close();
%>
</body>
</html>