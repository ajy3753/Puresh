<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<title>Puresh  - 리뷰 작성</title>
	<!-- 웹폰트 연결 (앨리스 디지털 배움체) -->
	<link href="https://font.elice.io/css?family=Elice+Digital+Baeum" rel="stylesheet">
	<!-- jQuery 라이브러리 연결 -->
	<script src="https://code.jquery.com/jquery-3.6.3.js"></script>
	<script src="../css/jQuery.js"></script>
	<!-- 외부CSS 파일 연결 -->
	<link rel="stylesheet" type="text/css" href="../css/main.css?after">
	<link rel="stylesheet" type="text/css" href="../css/sub.css?after">
	<style>
		body {
			width: 100%;
			height: 100%;
		}
	</style>
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

	// userID
	String id = (String)session.getAttribute("sid");
	if(id == null) {
		response.sendRedirect("login.jsp");
	}

	// sendData
	String sendData = request.getParameter("sendData");
	String[] dataArray = sendData.split("_");
	String prodID = dataArray[0];
	String orderID = dataArray[1];

	// review 변수
	String reviewID = "";
	int ratingScore = 5;
	String reviewContent = "";


	// 중복 검사
	String checkDouble = "SELECT COUNT(*) FROM V_reviewList WHERE orderID = ?";
	PreparedStatement pstmtCheck = con.prepareStatement(checkDouble);
	pstmtCheck.setString(1, orderID);
	ResultSet rsCheck = pstmtCheck.executeQuery();
	rsCheck.next();

	int checkCount = rsCheck.getInt("COUNT(*)");

	rsCheck.close();
	pstmtCheck.close();

	if(checkCount > 0) {
		String loadReview = "SELECT * FROM V_reviewList WHERE orderID = ?";
		PreparedStatement pstmtReview = con.prepareStatement(loadReview);
		pstmtReview.setString(1, orderID);
		ResultSet rsReview = pstmtReview.executeQuery();
		rsReview.next();

		reviewID = rsReview.getString("reviewID");
		ratingScore = rsReview.getInt("ratingScore");
		reviewContent = rsReview.getString("reviewContent");

		rsReview.close();
		pstmtReview.close();
	}
%>
<script>
	$(document).ready(function(){
		// 중복 시 수정으로 변경
		var count = "<%=checkCount%>";
		var URL = "../session/updateReview.jsp";
		if(count > 0) {
			$(".reviewWrite aside table tr th").text("리뷰 열람 · 수정");
			$(".reviewWrite article h3").text("리뷰 수정하기");
			$(".reviewWrite article form").attr("action", URL);
			$(".reviewWrite article form input[type='submit']").val("수정하기");

			var star = "<%=ratingScore%>" - 1;
			$(".reviewWrite article form span button").css("color", "#F4E9E3");
			for(let index = 0; index <= star; index++) {
				$(".reviewWrite article form span button").eq(index).css("color", "#FF6653");
			}

			$(".reviewWrite form span button").click(function () {
				$(".reviewWrite article form input[type='submit']").removeAttr("disabled");
			});
		}

		// 별점
		$(".reviewWrite form span button").click(function () {
			var star = $(this).index();
			let score = star + 1;
			$(".reviewWrite form input#ratingScore").val(score);
			for(let index = 0; index <= 5; index++) {
				if(index <= star) {
					$(".reviewWrite form span button").eq(index).css("color", "#FF6653");
				}
				else {
					$(".reviewWrite form span button").eq(index).css("color", "#F4E9E3");
				}
			}
		});

		// 리뷰 등록
		$(".reviewWrite article form textarea").on("input", function() {
			var content = $(this).val();
			if(content.length < 10) {
				$(".reviewWrite article form input[type='submit']").attr("disabled", "disabled");
			}
			else {
				$(".reviewWrite article form input[type='submit']").removeAttr("disabled");
			}
		});
		$(".reviewWrite article form textarea").on("change", function() {
			var content = $(this).val();
			if(content.length < 10) {
				$(".reviewWrite article form input[type='submit']").attr("disabled", "disabled");
			}
			else {
				$(".reviewWrite article form input[type='submit']").removeAttr("disabled");
			}
		});
	});
</script>

<section class="reviewWrite">
	<!-- 리뷰 상품 상세 -->
	<aside>
		<table>
			<tr>
				<th colspan="3">리뷰 작성</th>
			</tr>
			<%
				String loadOrder = "SELECT * FROM V_orderDetail WHERE userID = ? AND prodID = ? AND orderID = ?";
				PreparedStatement pstmtLoad = con.prepareStatement(loadOrder);
				pstmtLoad.setString(1, id);
				pstmtLoad.setString(2, prodID);
				pstmtLoad.setString(3, orderID);
				ResultSet rsLoad = pstmtLoad.executeQuery();
				rsLoad.next();

				String prodName = rsLoad.getString("prodName");
				String prodImg = rsLoad.getString("prodImg");
				int orderStock = rsLoad.getInt("orderStock");
				String orderEnd = rsLoad.getString("DATE_FORMAT(orderStart, '%Y-%m-%d %H:%i')");

				rsLoad.close();
				pstmtLoad.close();
			%>
			<tr>
				<td><a href="../prodDetail.jsp?prodID=<%=prodID%>" target="parent"><img src="../<%=prodImg%>"></a></td>
				<td>
					<p><font color="#C81C21"><%=orderID%></font></p>
					<p class="Name"><b><%=prodName%></b></p>
					<p>주문 수량 : <%=orderStock%>개</p>
					<p class="End">구매 확정일 : <%=orderEnd%></p>
				</td>
				<td></td>
			</tr>
		</table>
	</aside>

	<!-- 리뷰 작성 -->
	<article>
		<h3>리뷰 남기기</h3>
		<form action="../session/addReview.jsp">
			<input type="hidden" name="reviewID" value="<%=reviewID%>">
			<input type="hidden" name="prodID" value="<%=prodID%>">
			<input type="hidden" name="orderID" value="<%=orderID%>">
			<input type="hidden" name="orderStock" value="<%=orderStock%>">
			<input type="hidden" id="ratingScore" name="ratingScore" value="<%=ratingScore%>">
			<span>
				<button type="button">&#9733;</button>
				<button type="button">&#9733;</button>
				<button type="button">&#9733;</button>
				<button type="button">&#9733;</button>
				<button type="button">&#9733;</button>
			</span>
			<textarea name="reviewContent" wrap="physical" maxlength="500" placeholder="리뷰 본문 작성 ( 최소 10자, 최대 500자)"><%=reviewContent%></textarea>
			<input type="submit" value="등록하기" disabled>
		</form>
	</article>
</section>

<%
	con.close();
%>
</body>
</html>