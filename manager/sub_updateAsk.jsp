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

	// askID
	String askID = request.getParameter("askID");

	// 문의 내용 불러오기
	String updateAsk = "SELECT * FROM V_updateAsk WHERE askID = ?";
	PreparedStatement pstmtSub = conSub.prepareStatement(updateAsk);
	pstmtSub.setString(1, askID);
	ResultSet rsSub = pstmtSub.executeQuery();
	rsSub.next();

	String userID = rsSub.getString("userID");
	String askCtg = rsSub.getString("askCtg");
	String askName = rsSub.getString("askName");
	String askContent = rsSub.getString("askContent");
	String askStatus = rsSub.getString("askStatus");
	String agreeEmail = rsSub.getString("agreeEmail");
	String askDate = rsSub.getString("askDate");
	String answer = "";
	String answerDate = "";

	if(askStatus.equals("답변 완료")) {
		answer = rsSub.getString("answer");
		answerDate = rsSub.getString("answerDate");
	}

	rsSub.close();
	pstmtSub.close();
%>
<script>
	$(document).ready(function(){
		// #btnDelete (문의 삭제)
		$("#updateAsk button#btnDelete").click(function () {
			var sendData = "manager_" + "<%=askID%>"
			let CQ = confirm("현재 문의를 삭제하시겠습니까?\n(※삭제 후에는 복구가 불가능합니다.)");
			if(CQ == true) {
				location.href = "session/deleteAsk.jsp?sendData=" + sendData;
			}
		});
	});
</script>

<h1 class="mainHeader">문의 상세 열람</h1>
<h2 class="backLink"><a href="pureshManager.jsp?ctg=support_askList">&#8672; 문의 내역으로 돌아가기</a></h2>

<!-- ask -->
<article>
	<form action="session/updateAsk.jsp">
		<table class="formTBL" id="updateAsk">
			<input type="hidden" name="askID" value="<%=askID%>">
			<tr>
				<th>제목</th>
				<td><input type="text" value="<%=askName%>" readonly></td>
				<%
						if (askStatus.equals("답변 완료")) {
				%>
				<th>답변일</th>
				<%
					}
					else {
				%>
				<th rowspan="2">답변 작성</th>
				<%
					}	
				%>
			</tr>
			<tr>
				<th>문의자</th>
				<td><input type="text" value="<%=userID%>" readonly></td>
				<%
						if (askStatus.equals("답변 완료")) {
				%>
				<td><input type="datetime-local" value="<%=answerDate%>" readonly></td>
				<%
					}	
				%>
			</tr>
			<tr>
				<th>상세</th>
				<td><textarea readonly><%=askContent%></textarea></td>
				<%
						if (askStatus.equals("답변 완료")) {
				%>
				<td rowspan+colspan="2"><textarea disabled><%=answer%></textarea></td>
				<%
					}
					else {
				%>
				<td rowspan+colspan="2"><textarea name="answer" wrap="physical" maxlength="1000" placeholder="(최대 1000자)" required></textarea></td>
				<%
					}	
				%>
			</tr>
			<tr>
				<th>문의일</th>
				<td><input type="datetime-local" value="<%=askDate%>" readonly></td>
				<td style="font-weight: normal;">(※ 전송 후에는 수정이 불가능합니다)</td>
			</tr>
			<tr>
				<th class="button" colspan="3">
					<%
						if (askStatus.equals("답변 완료")) {
					%>
					<button type="submit" disabled>답변 전송</button>
					<%
						}
						else {
					%>
					<button type="submit">답변 전송</button>
					<%
						}	
					%>
					<button type="button" id="btnDelete">문의 삭제</button>
				</th>
			</tr>
		</table>
	</form>
</article>

<%
	conSub.close();
%>