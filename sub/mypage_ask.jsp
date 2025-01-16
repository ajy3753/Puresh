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
	Connection conAsk = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

	// userID
	String id = (String)session.getAttribute("sid");

	// ask용 변수
	String askID;
	String askCtg;
	String askName;
	String askStatus;
	String askDate;
%>
<script>
	$(document).ready(function(){
		// #inquiryAsk (문의 열람)
		$("button#inquiryAsk").click(function () {
			var sendID = $(this).attr("value");
			var URL = "session/inquiryAsk.jsp?sendID=" + sendID;
			window.open(URL, "문의 열람", "width=600, height=700, top=0, left=0");
		});

		// #deleteAsk (문의 삭제)
		$("button#deleteAsk").click(function () {
			var sendData = "mypage_" + $(this).attr("value");
			let CQ = confirm("문의를 삭제하시겠습니까?\n(※삭제 후엔 복구가 불가능하며, 답변도 받을 수 없습니다.)");
			if(CQ == true) {
				location.href = "session/deleteAsk.jsp?sendData=" + sendData;
			}
		});
	});
</script>

<h1>1:1 문의 내역</h1>
<div class="mypageSub">
	<table class="askTBL">
		<tr>
			<th colspan="2">제목</th>
			<th>분류</th>
			<th>문의일</th>
			<th>상태</th>
			<th>열람/삭제</th>
		</tr>
		<%
			String askList = "SELECT * FROM V_askList WHERE userID = ?";
			PreparedStatement pstmtLoad = conAsk.prepareStatement(askList);
			pstmtLoad.setString(1, id);
			ResultSet rsLoad = pstmtLoad.executeQuery();
			
			while (rsLoad.next()) {
				askID = rsLoad.getString("askID");
				askName = rsLoad.getString("askName");
				askCtg = rsLoad.getString("askCtg");
				askDate = rsLoad.getString("Date");
				askStatus = rsLoad.getString("askStatus");
		%>
		<tr>
			<td class="askName" colspan="2"><%=askName%></td>
			<td><%=askCtg%></td>
			<td><%=askDate%></td>
			<td><%=askStatus%></td>
			<td>
				<button id="inquiryAsk" value="<%=askID%>">보기</button>
				<button id="deleteAsk" value="<%=askID%>">&#10006; 삭제</button>
			</td>
		</tr>
		<%
			}
			rsLoad.close();
			pstmtLoad.close();
		%>
	</table>
</div>

 <%
	conAsk.close();
%>
</body>
</html>