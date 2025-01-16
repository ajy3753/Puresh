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

	// reviewList 변수
	String prodID;
	String prodName;
	String prodImg;
	int reviewCount;
	int scoreAVG;
	String star;

	int listCount = 1;

	// reviewList 불러오기
	String reviewList = "SELECT * FROM V_reivewChart";
	PreparedStatement pstmtSub = conSub.prepareStatement(reviewList);
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
		<li  id="reviewChart" class="On"><a href="pureshManager.jsp?ctg=review_reviewChart">리뷰 통계</a></li>
		<li id="reviewList"><a href="pureshManager.jsp?ctg=review_reviewList">전체 리뷰 목록</a></li>
	</ul>
</aside>

<!-- reviewChart -->
<article>
	<table class="listTBL" id="reviewChart">
		<tr class="tableHeader">
			<th>No</th>
			<th colspan="2">상품ID</th>
			<th>상품명</th>
			<th>리뷰 수</th>
			<th colspan="2">평점</th>
			<th>리뷰 목록</th>
		</tr>
		<%
			while(rsSub.next()) {
				prodID = rsSub.getString("prodID");
				prodName = rsSub.getString("prodName");
				prodImg = rsSub.getString("prodImg");
				reviewCount = rsSub.getInt("reviewCount");
				scoreAVG = rsSub.getInt("scoreAVG");

				star = "";
				for(int score = 1; score <= 5; score++) {
					if(score <= scoreAVG) {
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
			<td><%=prodID%></td>
			<td><%=prodName%></td>
			<td><%=reviewCount%></td>
			<td colspan="2"><b><%=star%>&ensp;<%=scoreAVG%></b></td>
			<td><a href="pureshManager.jsp?ctg=review_reivewClass_?prodID=<%=prodID%>">상품별 리뷰 보기 &#8227;</a></td>
		</tr>
		<%
				listCount++;
			}
		%>
	</table>
</article>

<%
	rsSub.close();
	pstmtSub.close();
	conSub.close();
%>