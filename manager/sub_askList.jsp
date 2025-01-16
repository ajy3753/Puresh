<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!-- sub jsp -->
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

	// askList 변수
	String askID;
	String RPAD_userID;
	String askCtg;
	String askName;
	String askStatus;
	String askDate;

	// 전체 상품 카운트
	String askCount = "SELECT COUNT(*) FROM V_askListSub";
	PreparedStatement pstmtCount = conSub.prepareStatement(askCount);
	ResultSet rsCount = pstmtCount.executeQuery();
	rsCount.next();

	int listCount = rsCount.getInt("COUNT(*)");

	rsCount.close();
	pstmtCount.close();

	// askList 불러오기
	String askList = "SELECT * FROM V_askListSub";
	PreparedStatement pstmtSub = conSub.prepareStatement(askList);
	ResultSet rsSub = pstmtSub.executeQuery();
%>
<script>
	$(document).ready(function(){
		// #btnAnswer (문의 상세 보기/답변)
		$("#askList button#btnAnswer").click(function () {
			var sendID = $(this).attr("value");
			location.href = "pureshManager.jsp?ctg=support_updateAsk_?askID=" + sendID;
		});
	});
</script>

<h1 class="mainHeader">문의 관리</h1>

<!-- ask -->
<article id="askList">
	<table class="listTBL">
		<tr class="tableHeader">
			<th>No</th>
			<th>분류</th>
			<th>제목</th>
			<th>아이디</th>
			<th>문의일</th>
			<th>상태</th>
			<th>상세 열람</th>
		</tr>
		<%
			while(rsSub.next()) {
				askID = rsSub.getString("askID");
				RPAD_userID = rsSub.getString("RPAD_userID");
				askCtg = rsSub.getString("askCtg");
				askName = rsSub.getString("askName");
				askStatus = rsSub.getString("askStatus");
				askDate = rsSub.getString("askDate");
		%>
		<tr>
			<td class="small"><%=listCount%></td>
			<td><%=askCtg%></td>
			<td><%=askName%></td>
			<td><%=RPAD_userID%></td>
			<td><%=askDate%></td>
			<%
				if (askStatus.equals("접수")) {
			%>
			<td style="font-weight: bold; color: #39AE86;"><%=askStatus%></td>
			<%
				}
				else {
			%>
			<td><%=askStatus%></td>
			<%
				}	
			%>
			<td><button id="btnAnswer" value="<%=askID%>">보기</button></td>
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