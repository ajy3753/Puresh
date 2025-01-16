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
	Connection conSub = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

	// 로그인 여부
	String managerID = (String)session.getAttribute("managerSID");

	// prodID
	String prodID = request.getParameter("prodID");

	// reviewList 변수
	String reviewID;
	String prodImg;
	String userID;
	int orderStock;
	String reviewContent;
	int ratingScore;
	String star;
	String reviewDate;

	// 전체 리뷰 카운트
	String reviewCount = "SELECT COUNT(*) FROM V_reivewClass WHERE prodID = ?";
	PreparedStatement pstmtCount = conSub.prepareStatement(reviewCount);
	pstmtCount.setString(1, prodID);
	ResultSet rsCount = pstmtCount.executeQuery();
	rsCount.next();

	int listCount = rsCount.getInt("COUNT(*)");

	rsCount.close();
	pstmtCount.close();

	// reviewList 불러오기
	String reviewList = "SELECT * FROM V_reivewClass WHERE prodID = ?";
	PreparedStatement pstmtSub = conSub.prepareStatement(reviewList);
	pstmtSub.setString(1, prodID);
	ResultSet rsSub = pstmtSub.executeQuery();
%>
<script>
	$(document).ready(function(){
	});
</script>

<h1 class="mainHeader">리뷰 관리</h1>

<!-- 소분류 탭 -->
<aside>
	<ul>
		<li  id="reviewChart"><a href="pureshManager.jsp?ctg=review_reviewChart">리뷰 통계</a></li>
		<li id="reviewList"><a href="pureshManager.jsp?ctg=review_reviewList">전체 리뷰 목록</a></li>
		<li id="reviewClass" class="On"><a href="pureshManager.jsp?ctg=review_reivewClass_?prodID=<%=prodID%>">상품별 리뷰 목록</a></li>
	</ul>
</aside>

<!-- reviewChart -->
<article>
	<table class="listTBL" id="reviewChart">
		<tr class="tableHeader">
			<th>No</th>
			<th>리뷰 상품</th>
			<th>작성자</th>
			<th>주문 상품 수</th>
			<th>리뷰 내용</th>
			<th colspan="2">평점</th>
			<th>작성일</th>
		</tr>
		<%
			while(rsSub.next()) {
				prodID = rsSub.getString("prodID");
				prodImg = rsSub.getString("prodImg");
				userID = rsSub.getString("userID");
				orderStock = rsSub.getInt("orderStock");
				reviewContent = rsSub.getString("reviewContent");
				ratingScore = rsSub.getInt("ratingScore");
				reviewDate = rsSub.getString("reviewDate");

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
		<tr>
			<td class="small"><%=listCount%></td>
			<td><img src="<%=prodImg%>"></td>
			<td><%=userID%></td>
			<td><%=orderStock%></td>
			<td class="content"><%=reviewContent%></td>
			<td colspan="2"><b><%=star%>&ensp;<%=ratingScore%></b></td>
			<td><%=reviewDate%></td>
		</tr>
		<%
				listCount--;
			}
		%>
	</table>
</article>

<%
	rsSub.close();
	pstmtSub.close();
	conSub.close();
%>