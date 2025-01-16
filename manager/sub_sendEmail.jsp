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
	String userEmail;
	String agreeEmail;

	int listCount = 0;

	// userList 불러오기
	String userList = "SELECT * FROM V_sendEmail";
	PreparedStatement pstmtUL = conSub.prepareStatement(userList);
	ResultSet rsUL = pstmtUL.executeQuery();
%>
<script>
	$(document).ready(function(){
		// 메일 주소 복사
		$("button#btnCopy").click(function () {
			$("#Copy").attr("type", "text");
			$("#Copy").select();
			var copy = document.execCommand('copy');
			if(copy) {
    			alert("이메일 주소가 복사되었습니다.");
			}
			$("#Copy").attr("type", "hidden");
		});
	});
</script>

<h1 class="mainHeader">고객 관리</h1>

<!-- 소분류 탭 -->
<aside>
	<ul>
		<li  id="userList"><a href="pureshManager.jsp?ctg=user_userList">전체 회원 목록</a></li>
		<li id="sendEmail" class="On"><a href="pureshManager.jsp?ctg=user_sendEmail">이메일 발신</a></li>
		<li id="grade"><a href="pureshManager.jsp?ctg=user_grade">회원 등급</a></li>
	</ul>
</aside>

<!-- sendEmail -->
<article>
	<table class="listTBL">
		<tr class="tableHeader">
			<th>No</th>
			<th>아이디</th>
			<th>이름</th>
			<th>이메일</th>
			<th>이메일 수신 동의 여부</th>
			<th>메일 주소 복사</th>
		</tr>
		<%
			while(rsUL.next()) {
				userID = rsUL.getString("userID");
				RPAD_userID = rsUL.getString("RPAD_userID");
				userName = rsUL.getString("RPAD_userName");
				userEmail = rsUL.getString("userEmail");
				agreeEmail = rsUL.getString("agreeEmail");

				listCount++;
		%>
		<tr>
			<td class="small"><%=listCount%></td>
			<td><%=RPAD_userID%></td>
			<td><%=userName%></td>
			<td><%=userEmail%></td>
			<%
				if(agreeEmail.equals("YES")) {
			%>
			<td style="font-weight: bold; color: #39AE86;"><%=agreeEmail%></td>
			<%
				}
				else {
			%>
			<td style="font-weight: bold; color: #C81C21;"><%=agreeEmail%></td>
			<%
				}	
			%>
			<td>
				<button id="btnCopy">복사</button>
				<input type="hidden" id="Copy" value="<%=userEmail%>">
			</td>
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