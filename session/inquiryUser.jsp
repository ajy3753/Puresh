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
	<script src="../css/jQuery.js"></script>
	<!-- 외부CSS 파일 연결 -->
	<link rel="stylesheet" type="text/css" href="../css/main.css?after">
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

	// 넘겨받은 값
	String type = request.getParameter("type");
	String ID = request.getParameter("ID");
	String name = request.getParameter("name");
	String phone = request.getParameter("ph1") + "-" +  request.getParameter("ph2") + "-" + request.getParameter("ph3");

	// user 변수
	String userID = "";
	String userPassword = "";

	int error = 1;
	int count = 0;

	switch (type) {
		case "findID" :
			String findID = "SELECT COUNT(*) FROM V_loadUser WHERE userName = ? AND userPhone = ?";
			PreparedStatement pstmtFIC = con.prepareStatement(findID);
			pstmtFIC.setString(1, name);
			pstmtFIC.setString(2, phone);
			ResultSet rsFIC = pstmtFIC.executeQuery();
			rsFIC.next();

			count = rsFIC.getInt("COUNT(*)");

			rsFIC.close();
			pstmtFIC.close();

			if(count > 0) {
				error = 0;

				findID = "SELECT * FROM V_loadUser WHERE userName = ? AND userPhone = ?";
				PreparedStatement pstmtFI = con.prepareStatement(findID);
				pstmtFI.setString(1, name);
				pstmtFI.setString(2, phone);
				ResultSet rsFI = pstmtFI.executeQuery();
				rsFI.next();

				userID = rsFI.getString("userID");

				rsFI.close();
				pstmtFI.close();
			}
			break;
		case "findPWD" :
			String findPWD = "SELECT COUNT(*) FROM V_loadUser WHERE userID = ? AND userPhone = ?";
			PreparedStatement pstmtFPC = con.prepareStatement(findPWD);
			pstmtFPC.setString(1, ID);
			pstmtFPC.setString(2, phone);
			ResultSet rsFPC = pstmtFPC.executeQuery();
			rsFPC.next();

			count = rsFPC.getInt("COUNT(*)");

			rsFPC.close();
			pstmtFPC.close();

			if(count > 0) {
				error = 0;
				findPWD = "SELECT * FROM V_loadUser WHERE userID = ? AND userPhone = ?";
				PreparedStatement pstmtFP = con.prepareStatement(findPWD);
				pstmtFP.setString(1, ID);
				pstmtFP.setString(2, phone);
				ResultSet rsFP = pstmtFP.executeQuery();
				rsFP.next();

				userID = ID;
				userPassword = rsFP.getString("userPassword");

				rsFP.close();
				pstmtFP.close();
			}
			break;
		default :
			break;
	}
%>
<script>
	$(document).ready(function(){
		// error
		var errorCode = "<%=error%>";
		if(errorCode > 0) {
			alert("일치하는 회원정보가 없습니다.");
			location.href = "../findUser.jsp";
		}

		// 로그인 여부
		var id = "<%=id%>";
		if (id == "null" || id == "") {
			$(".menuSub li a, .BoxCont span.btn a").attr("href", "../login.jsp");
			$(".menuDrop").css("height", "5vw");
			$(".menuDrop li").css("display", "none");
			$(".menuDrop li.Logout").css("display", "block");
			$(".BoxCont span.btn a").click(function () {
				alert("로그인이 필요한 기능입니다.");
			});
		}

		// type
		var type = "<%=type%>";
		$(".inquiryUser article#" + type).addClass("On");
	});
</script>

<!-- 공통 헤더 (대메뉴) -->
<header>
	<nav>
		<ul class="menuMain">
			<li><a href="../index.jsp"><img src="../images/logo.png"></a></li>
			<li><a href="../new.jsp">NEW</a></li>
			<li><a href="../prodList.jsp">PRODUCTS</a></li>
			<li><a href="../typeTest.jsp"><font color="#FF6653">TYPE TEST</font></a></li>
			<li><a href="../event.jsp">EVENT</a></li>
			<li><a href="../support.jsp">SUPPORT</a></li>
		</ul>
		<ul class="menuSub">
			<li class="searchBar">
				<input type="text" placeholder="제품 검색"></input>
				<button type="submit" class="searchBtn"><img src="../images/Icon_search.png"></button>
			</li>
			<li class="cart"><a href="../mypage.jsp?ctg=cart"><img src="../images/Icon_cart.png"></a></li>
			<li class="mypage">
				<a href="../mypage.jsp"><img src="../images/Icon_mypage.png"></a>
				<!-- 드롭다운 메뉴 -->
				<ul class="menuDrop">
					<li><a href="../mypage.jsp?ctg=order">주문확인 / 배송조회</a></li>
					<li><a href="../mypage.jsp?ctg=wish">관심상품</a></li>
					<li><a href="../mypage.jsp?ctg=user">내 정보 관리</a></li>
					<li><a href="../support.jsp">고객센터</a></li>
					<li><a href="logout.jsp">로그아웃</a></li>
					<li class="Logout" style="display: none;"><a href="../login.jsp">로그인 / 회원가입</a></li>
				</ul>
			</li>
		</ul>
	</nav>
</header>

<main class="inquiryUser">
	<h1>조회 결과</h1>
	<section>
		<!-- 아이디 -->
		<article id="findID">
			<h2>아이디 : <b><%=userID%></b></h2>
			<h4><a href="../login.jsp">&#8636; 로그인 페이지로 돌아가기</a></h4>
			<h5>조회 결과에 오류가 있으신가요?<a href="../support.jsp">고객센터 문의하기</a></h5>
		</article>

		<!-- 비밀번호 -->
		<article id="findPWD">
			<h2>아이디 : <b><%=userID%></b></h2>
			<h2>비밀번호 : <b><%=userPassword%></b></h2>
			<h4><a href="../login.jsp">&#8636; 로그인 페이지로 돌아가기</a></h4>
			<h5>조회 결과에 오류가 있으신가요?<a href="../support.jsp">고객센터 문의하기</a></h5>
		</article>
	</section>
</main>

<!-- footer -->
<footer>
	<span>
		<a href="../service.jsp?ctg=company">회사소개</a>
		<a href="../service.jsp?ctg=policy">개인정보처리방침</a>
		<a href="../service.jsp?ctg=provision">이용약관</a>
		<a href="../service.jsp?ctg=post">게시글수집및이용안내</a>
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
			<a href="https://www.instagram.com" target="_blank"><img src="../images/Icon_instagram.png"></a>
			<a href="https://twitter.com" target="_blank"><img src="../images/Icon_twitter.png"></a>
			<a href="https://www.facebook.com" target="_blank"><img src="../images/Icon_facebook.png"></a>
		</div>
	</address>
</footer>

<%
	con.close();
%>
</body>
</html>