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
	if(id != "" && id != null) {
		response.sendRedirect("mypage.jsp");
	}

	// 아이디 중복검사 값
	String checkID = (String)request.getParameter("checkID");
	if(checkID == null) {
		checkID = "";
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
			$(".BoxCont span.btn a").click(function () {
				alert("로그인이 필요한 기능입니다.");
			});
		}

		// 이메일 주소 변경
		$("#emailSelect").on("change", function () {
			const emailAddr = $(this).children(":selected").val();
			switch (emailAddr) {
				case 'naver':
					$("#emailAddr").val("naver.com");
					break;
				case 'google':
					$("#emailAddr").val("gmail.com");
					break;
				case 'daum':
					$("#emailAddr").val("daum.net");
					break;
				default:
					$("#emailAddr").val("");
					break;
			}
		});

		// 유효성 검사용 변수
		let checkArray = [0, 0];

		// 아이디 검사
		var checkID = "<%=checkID%>";
		if(checkID == "") {
			checkArray[0] = 0;
			$("button[type='button']").attr("readonly", "true");
			$(".signForm article table tr td font").css("display", "none")

			$("input#ID").on("change", function() {
				if($(this).val().length < 4) {
					$("tr.warning#ID").css("display", "table-row");
					$("tr.warning#ID td").text("아이디는 최소 4글자입니다.");
					$("button[type='button']").attr("readonly", "true");
				}
				else {
					$("tr.warning#ID").css("display", "none");
					$("button[type='button']").removeAttr("readonly");
					$("button[type='button']").click(function () {
						var URL = "session/duplicateCheckID.jsp?checkID=" + $("input#ID").val();
						window.open(URL, "아이디 중복 확인", "width=50vw, height=10vw, top=100, left=500");
					});
				}
			});
		}
		else {
			checkArray[0] = 1;
			$("input#ID").val(checkID);
			$("button[type='button']").attr("disabled", "disabled");
			$(".signForm article table tr td font").css("display", "span")

			$("input#ID").on("change", function() {
				if($(this).val().length < 4) {
					checkArray[0] = 0;
					$("tr.warning#ID").css("display", "table-row");
					$("tr.warning#ID td").text("아이디는 최소 4글자입니다.");
					$("button[type='button']").attr("readonly", "true");
					$("button[type='button']").removeAttr("disabled");
					$(".signForm article table tr td font").css("display", "none")
				}
				else {
					checkArray[0] = 0;
					$("tr.warning#ID").css("display", "none");
					$("button[type='button']").removeAttr("readonly");
					$("button[type='button']").removeAttr("disabled");
					$(".signForm article table tr td font").css("display", "none")
					$("button[type='button']").click(function () {
						var URL = "session/duplicateCheckID.jsp?checkID=" + $("input#ID").val();
						window.open(URL, "아이디 중복 확인", "width=50vw, height=10vw, top=100, left=500");
					});
				}
			});

			let checkResult = checkArray.reduce(function add(sum, currValue) {
					return sum + currValue;
				}, 0);
			if(checkResult == 2) {
				$("button[type='submit']").removeAttr("disabled");
			}
			else {
				$("button[type='submit']").attr("disabled", "disabled");
			}
		}

		// 비밀번호 검사
		$("input#PWD").on("change", function() {
			var PWD = $("input#PWD").val();
			var repeatPWD = $("input#PWD.repeatPWD").val();
			if(PWD.length < 8) {
				checkArray[1] = 0;
				$("tr.warning#PWD").css("display", "table-row");
				$("tr.warning#PWD td").text("비밀번호는 최소 8글자 이상이어야합니다.");
			}
			else {
				$("tr.warning#PWD").css("display", "none");
				if(repeatPWD != "") {
					if(PWD != repeatPWD) {
						checkArray[1] = 0;
						$("tr.warning#repeatPWD").css("display", "table-row");
					}
					else {
						checkArray[1] = 1;
						$("tr.warning#repeatPWD").css("display", "none");
					}
				}	
			}

			let checkResult = checkArray.reduce(function add(sum, currValue) {
				return sum + currValue;
			}, 0);
			if(checkResult == 2) {
				$("button[type='submit']").removeAttr("disabled");
			}
			else {
				$("button[type='submit']").attr("disabled", "disabled");
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

<main class="signMain">
	<h1>Join</h1>
	<form action="session/signOK.jsp">
		<section class="signForm">
			<!-- 회원 정보 입력 -->
			<article>
				<table>
					<!-- 아이디 -->
					<tr>
						<th>아이디<font color="#C81C21">*</font></th>
						<td><input type="text" id="ID" name="id" maxlength="10" placeholder="영문소문자/숫자 조합, 4~10자" autofocus required></td>
						<td><button type="button">중복 확인</button><font color="#C81C21">&nbsp; &#10004;완료</font></td>
					</tr>
					<tr class="warning" id="ID">
						<th>&#33;</th>
						<td colspan="3">사용할 수 없는 아이디입니다.</td>
					</tr>

					<!-- 비밀번호 -->
					<tr>
						<th>비밀번호<font color="#C81C21">*</font></th>
						<td colspan="2"><input type="password" id="PWD" name="password" maxlength="20" placeholder="영문 대소문자/숫자/특수문자 중 2가지 이상 조합, 8~20자" required></td>
					</tr>
					<tr class="warning" id="PWD">
						<th>&#33;</th>
						<td colspan="3">사용할 수 없는 비밀번호입니다.</td>
					</tr>
					<tr>
						<th>비밀번호 확인<font color="#C81C21">*</font></th>
						<td colspan="2"><input type="password" id="PWD" class="repeatPWD" maxlength="20" placeholder="비밀번호 재입력" required></td>
					</tr>
					<tr class="warning" id="repeatPWD">
						<th>&#33;</th>
						<td colspan="3">비밀번호가 틀립니다.</td>
					</tr>

					<!-- 이름 -->
					<tr>
						<th>이름<font color="#C81C21">*</font></th>
						<td><input type="text" name="name" maxlength="15" placeholder="최대 15자" required></td>
					</tr>

					<!-- 성별 -->
					<tr>
						<th>성별</th>
						<td>
							<select name="gender">
								<option value="미선택" selected>미선택</option>
								<option value="남성">남성</option>
								<option value="여성">여성</option>
								<option value="기타">기타</option>
								<option value="비공개">비공개</option>
							</select>
						</td>
					</tr>

					<!-- 휴대폰 연락처 -->
					<tr class="short">
						<th>연락처<font color="#C81C21">*</font></th>
						<td colspan="3">
							<select name="ph1">
								<option value="010" selected>010</option>
								<option value="011">011</option>
								<option value="016">016</option>
								<option value="017">017</option>
								<option value="018">018</option>
								<option value="019">019</option>
							</select>
							<b>&ensp;-&ensp;</b>
							<input type="number" name="ph2" oninput="handleOnInput(this, 4)" required>
							<b>&ensp;-&ensp;</b>
							<input type="number" name="ph3" oninput="handleOnInput(this, 4)" required>
						</td>
					</tr>

					<!-- 이메일 -->
					<tr class="short">
						<th>이메일<font color="#C81C21">*</font></th>
						<td colspan="3">
							<input type="text" name="email1" maxlength="15" required>
							<b>@</b>
							<input type="text"  id="emailAddr" name="email2" maxlength="10" required>
							<select id="emailSelect">
								<option value="none">직접입력</option>
								<option value="naver">네이버</option>
								<option value="google">구글</option>
								<option value="daum">다음</option>
							</select>
						</td>
					</tr>

					<!-- 약관 동의 -->
					<tr>
						<th>개인정보 이용 동의<font color="#C81C21">*</font></th>
						<td colspan="3">
							<input type="checkbox" id="agreePolicy" required>
							<label for="agreePolicy">&#10047;</label>
							개인정보 수집 및 이용에 동의합니다.
						</td>
					</tr>
					<tr>
						<th>회원 가입 동의<font color="#C81C21">*</font></th>
						<td colspan="3">
							<input type="checkbox" id="agreeProvision" required>
							<label for="agreeProvision">&#10047;</label>
							이용약관을 모두 이해했으며, 회원 가입에 동의합니다.
						</td>
					</tr>
					<tr>
						<th>이메일 수신 여부</th>
						<td colspan="3">
							<input type="checkbox" id="agreeEmail" name="agreeEmail" value="YES">
							<label for="agreeEmail">&#10047;</label>
							중요한 정보와 알림을 이메일로 받겠습니다.
						</td>
					</tr>
				</table>
			</article>

			<aside>
				<p><font color="#C81C21">*</font>는 필수입력항목입니다.</p>
				<p>
					개인정보처리방침에 관한 자세한 사항은 <a href="service.jsp?ctg=policy">개인정보처리방침</a>을 참고하세요.
					(<a href="service.jsp?ctg=provision">이용약관</a>)
				</p>
			</aside>
		</section>
		<button type="submit" disabled>SIGN UP</button>
	</form>
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