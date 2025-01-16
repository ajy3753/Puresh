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
	String userName;
	String RPAD_userName;
	String userGender;
	String userPhone;
	String userDate;

	int listCount = 0;

	// userList 불러오기
	String userList = "SELECT * FROM V_userList";
	PreparedStatement pstmtUL = conSub.prepareStatement(userList);
	ResultSet rsUL = pstmtUL.executeQuery();
%>
<script>
	$(document).ready(function(){
		$("button#view").mouseover(function () {
			var index = $(this).parents("tr").index();
			$(".listTBL tr").eq(index).children("td.view").css("display", "none");
			$(".listTBL tr").eq(index).children("td.hidden").css("display", "table-cell");
		});
		$("button#view").mouseleave(function () {
			var index = $(this).parents("tr").index();
			$(".listTBL tr").eq(index).children("td.view").css("display", "table-cell");
			$(".listTBL tr").eq(index).children("td.hidden").css("display", "none");
		});
	});
</script>

<h1 class="mainHeader">고객 관리</h1>

<!-- 소분류 탭 -->
<aside>
	<ul>
		<li  id="userList" class="On"><a href="pureshManager.jsp?ctg=user_userList">전체 회원 목록</a></li>
		<li id="sendEmail"><a href="pureshManager.jsp?ctg=user_sendEmail">이메일 발신</a></li>
		<li id="grade"><a href="pureshManager.jsp?ctg=user_grade">회원 등급</a></li>
	</ul>
</aside>

<!-- userList -->
<article>
	<table class="listTBL" id="userList">
		<tr class="tableHeader">
			<th>No</th>
			<th>아이디</th>
			<th>이름</th>
			<th>성별</th>
			<th>연락처</th>
			<th>가입일</th>
			<th>보기</th>
		</tr>
		<%
			while(rsUL.next()) {
				userID = rsUL.getString("userID");
				RPAD_userID = rsUL.getString("RPAD_userID");
				userName = rsUL.getString("userName");
				RPAD_userName = rsUL.getString("RPAD_userName");
				userGender = rsUL.getString("userGender");
				userPhone = rsUL.getString("userPhone");
				userDate = rsUL.getString("DATE_FORMAT(userDate, '%Y-%m-%d')");

				listCount++;
		%>
		<tr>
			<td class="small"><%=listCount%></td>
			<td class="hidden"><%=userID%></td>
			<td class="view"><%=RPAD_userID%></td>
			<td class="hidden"><%=userName%></td>
			<td class="view"><%=RPAD_userName%></td>
			<td><%=userGender%></td>
			<td><%=userPhone%></td>
			<td><%=userDate%></td>
			<td><button id="view">&#10022;</button></td>
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