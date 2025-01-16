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

	// userList 변수
	String userID;
	String RPAD_userID;
	int COUNT_orderID;
	int orderTotal;
	String totalComma;
	String Rank;

	int listCount = 0;

	// userList 불러오기
	String userList = "SELECT * FROM V_grade";
	PreparedStatement pstmtUL = conSub.prepareStatement(userList);
	ResultSet rsUL = pstmtUL.executeQuery();
%>
<script>
	$(document).ready(function(){
	});
</script>

<h1 class="mainHeader">고객 관리</h1>

<!-- 소분류 탭 -->
<aside>
	<ul>
		<li  id="userList"><a href="pureshManager.jsp?ctg=user_userList">전체 회원 목록</a></li>
		<li id="sendEmail"><a href="pureshManager.jsp?ctg=user_sendEmail">이메일 발신</a></li>
		<li id="grade" class="On"><a href="pureshManager.jsp?ctg=user_grade">회원 등급</a></li>
	</ul>
</aside>

<!-- grade -->
<article>
	<table class="listTBL" id="userList">
		<tr class="tableHeader">
			<th>No</th>
			<th>아이디</th>
			<th>총 주문수</th>
			<th>주문금액 합계</th>
			<th>등급</th>
		</tr>
		<%
			while(rsUL.next()) {
				userID = rsUL.getString("userID");
				RPAD_userID = rsUL.getString("RPAD_userID");
				COUNT_orderID = rsUL.getInt("COUNT_orderID");
				orderTotal = rsUL.getInt("SUM_orderTotal");
				totalComma = rsUL.getString("SUM_orderTotal");

				if(orderTotal > 500000) {
					Rank = "A";
				}
				else if(orderTotal > 300000) {
					Rank = "B";
				}
				else if(orderTotal > 200000) {
					Rank = "C";
				}
				else if(orderTotal > 100000) {
					Rank = "D";
				}
				else {
					Rank = "E";
				}

				listCount++;
		%>
		<tr>
			<td class="small"><%=listCount%></td>
			<td class="hidden"><%=userID%></td>
			<td class="view"><%=RPAD_userID%></td>
			<td><%=COUNT_orderID%>건</td>
			<td><%=totalComma%>원</td>
			<td><%=Rank%></td>
		</tr>
		<%
			}
		%>
	</table>
</article>

<%
	rsUL.close();
	pstmtUL.close();
	conSub.close();
%>