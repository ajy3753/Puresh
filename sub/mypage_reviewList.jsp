<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
 <!-- sub jsp -->
 <%
	request.setCharacterEncoding("UTF-8");
	
	// DB 연결
	String DB_URL = "jdbc:mysql://localhost:3306/pureshDB";
	String DB_ID = "pureshManager";
	String DB_PASSWORD = "1234";
	Class.forName("org.gjt.mm.mysql.Driver");
	Connection conReview = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

	// userID
	String id = (String)session.getAttribute("sid");

	// review 변수
	String prodID;
	String prodName;
	String prodImg;
	String orderID;
	int orderStock;
	String star;
	int ratingScore;
	String reviewDate;

	// listCount
	String orderNN = "SELECT COUNT(*) FROM V_reviewList WHERE userID = ?";
	PreparedStatement pstmtNN = conReview.prepareStatement(orderNN);
	pstmtNN.setString(1, id);
	ResultSet rsNN = pstmtNN.executeQuery();
	rsNN.next();

	int listCount = rsNN.getInt("COUNT(*)");

	rsNN.close();
	pstmtNN.close();
%>
<script>
	$(document).ready(function(){
		// listCount 값이 0 일때
		var count = "<%=listCount%>";
		if(count == 0) {
			$(".mypageSub #listNN").css("display", "none");
			$(".mypageSub #listNot").css("display", "flex");
		}

		// #reviewWrite (리뷰 열람/수정)
		$("button#reviewWrite").click(function () {
			var sendData = $(this).attr("value");
			var URL = "sub/mypage_reviewWrite.jsp?sendData=" + sendData;
			window.open(URL, "리뷰 작성", "width=500, height=600, top=0, left=0");
		});

		// #reviewDelete (리뷰/삭제)
		$("button#reviewDelete").click(function () {
			var sendData = "reviewDelete_" + $(this).attr("value");
			let CQ = confirm("리뷰를 삭제하시겠습니까?\n(※삭제 후엔 복구가 불가능합니다.)");
			if(CQ == true) {
				location.href = "session/updateOrder.jsp?sendData=" + sendData;
			}
		});
	});
</script>

<h1>내가 쓴 리뷰</h1>
<div class="mypageSub">
	<!-- 리뷰 리스트 -->
	<table id="listNN" class="reviewTBL">
		<tr>
			<th>리뷰 작성일</th>
			<th colspan="2">주문상품</th>
			<th>평점</th>
			<th colspan="2">리뷰 관리</th>
		</tr>

		<!-- 주문 목록 -->
		<%
			String reviewList = "SELECT * FROM (SELECT *, ROW_NUMBER() OVER(PARTITION BY prodID ORDER BY reviewID DESC) AS 'ROW_NUM' FROM V_reviewList WHERE userID = ?) AS NUM WHERE NUM.ROW_NUM = 1";
			PreparedStatement pstmtList = conReview.prepareStatement(reviewList);
			pstmtList.setString(1, id);
			ResultSet rsList = pstmtList.executeQuery();

			while(rsList.next()) {
				prodID = rsList.getString("prodID");
				prodName = rsList.getString("prodName");
				prodImg = rsList.getString("prodImg");
				orderID = rsList.getString("orderID");
				orderStock = rsList.getInt("orderStock");
				ratingScore = rsList.getInt("ratingScore");
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
		<tr id="listNN">
			<!-- 작성일 -->
			<td class="orderStart"><%=reviewDate%></td>

			<!-- 상품 이미지 -->
			<td><a href="prodDetail.jsp?prodID=<%=prodID%>"><img src="<%=prodImg%>"></a></td>

			<!-- 주문 정보 -->
			<td>
				<p style="font-weight: bold;"><a href="prodDetail.jsp?prodID=<%=prodID%>"><%=prodName%></a></p>
				<p>주문 수량 : <%=orderStock%>개</p>
			</td>

			<!-- 평점 -->
			<td><b><%=star%></b></td>

			<!-- 리뷰 관리 -->
			<td class="myOrderBtn">
				<button id="reviewWrite" value="<%=prodID%>_<%=orderID%>">리뷰 열람/수정</button>
				<button id="reviewDelete" value="<%=orderID%>">&#10006; 리뷰 삭제</button>
			</td>
		</tr>
		<%
			}
			rsList.close();
			pstmtList.close();
		%>
	</table>

	<div id="listNot">
		<p>
			작성한 리뷰가 없습니다.
			<a href="mypage.jsp?ctg=reviewWriteable" style="font-weight: bold; color: #C81C21;">리뷰 작성하기</a>
		</p>
	</div>
</div>


<%
	conReview.close();
%>
</body>
</html>