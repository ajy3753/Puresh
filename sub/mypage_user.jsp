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
	Connection conUser = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

	// userID
	String id = (String)session.getAttribute("sid"); 

	// user 정보 불러오기
	String loadUser = "SELECT * FROM V_loadUser WHERE userID = ?";
	PreparedStatement pstmtUser = conUser.prepareStatement(loadUser);
	pstmtUser.setString(1, id);
	ResultSet rsUser = pstmtUser.executeQuery();
	rsUser.next();

	String userName = rsUser.getString("userName");
	String userPassword = rsUser.getString("userPassword");
	String userGender = rsUser.getString("userGender");
	String userPhone = rsUser.getString("userPhone");
	String userEmail = rsUser.getString("userEmail");
	String userAdress = rsUser.getString("userAdress");
	String userType = rsUser.getString("typeResult");

	rsUser.close();
	pstmtUser.close();

	// 데이터 정리
	String[] phArray = userPhone.split("-");
	String ph1 = phArray[0];
	int ph2 = Integer.parseInt(phArray[1]);
	int ph3 = Integer.parseInt(phArray[2]);

	String[] mailArray = userEmail.split("@");
	String email1 = mailArray[0];
	String email2 = mailArray[1];
%>
<script>
	$(document).ready(function(){
		// 자동완성
		var gender = "<%=userGender%>";
		$(".mypageSub form tr td select").val(gender).prop("checked", true);
		var ph1 = "<%=ph1%>";
		$(".mypageSub form tr.short td select").val(ph1).prop("checked", true);

		// 이메일 주소 변경
		$("#emailSelect").on("change", function () {
			var userMail = "<%=email2%>";
			const emailAddr = $(this).children(":selected").val();
			switch (emailAddr) {
				case 'naver':
					$("#emailAddr").val("naver.com");
					break;
				case 'google':
					$("#emailAddr").val("gmail.com");
					break;
				case 'daum':
					$("#emailAddr").val("daum.net");
					break;
				default:
					$("#emailAddr").val(userMail);
					break;
			}
		});

		// 비밀번호 검사
		$("input#PWD").on("change", function() {
			var PWD = $("input#PWD").val();
			var repeatPWD = $("input#PWD.repeatPWD").val();
			if(PWD != repeatPWD) {
				$("tr.warning#repeatPWD").css("display", "table-row");
				$("button[type='submit']").attr("disabled", "disabled");
			}
			else {
				$("tr.warning#repeatPWD").css("display", "none");
				$("button[type='submit']").removeAttr("disabled");
			}
		});

		// 회원 탈퇴
		$("#outUser").click(function () {
			let CQ = confirm("회원 탈퇴를 진행하시겠습니까?");
			if(CQ == true) {
				location.href = "session/deleteUser.jsp?userID=" + "<%=id%>";
			}
		});
	});
	// input number 글자수 제한
	function handleOnInput(el, maxlength) {
	  if(el.value.length > maxlength)  {
		el.value 
		  = el.value.substr(0, maxlength);
	  }
	}
</script>

<h1>내 정보 관리</h1>
<div class="mypageSub">
	<form>
		<table>
			<!-- 아이디 -->
			<tr>
				<th>아이디</th>
				<td><input type="text" value="<%=id%>" readonly></td>
				<td class="notice">&#33; 아이디는 변경할 수 없습니다</td>
			</tr>

			<!-- 비밀번호 -->
			<tr>
				<th>비밀번호</th>
				<td colspan="2"><input type="password" id="PWD" value="<%=userPassword%>" readonly></td>
			</tr>
			<tr>
				<th>비밀번호 확인<font color="#C81C21">*</font></th>
				<td colspan="2"><input type="password" id="PWD" class="repeatPWD" maxlength="20" placeholder="비밀번호 재입력" required></td>
			</tr>
			<tr class="warning" id="repeatPWD">
				<th>&#33;</th>
				<td colspan="3">비밀번호가 틀립니다.</td>
			</tr>

			<!-- 이름 -->
			<tr>
				<th>이름</th>
				<td><input type="text" name="name" value="<%=userName%>" maxlength="15" placeholder="최대 15자" required></td>
			</tr>

			<!-- 성별 -->
			<tr>
				<th>성별</th>
				<td>
					<select name="gender">
						<option value="미선택">미선택</option>
						<option value="남성">남성</option>
						<option value="여성">여성</option>
						<option value="기타">기타</option>
						<option value="비공개">비공개</option>
					</select>
				</td>
			</tr>

			<!-- 휴대폰 연락처 -->
			<tr class="short">
				<th>연락처</th>
				<td colspan="3">
					<select name="ph1">
						<option value="010">010</option>
						<option value="011">011</option>
						<option value="016">016</option>
						<option value="017">017</option>
						<option value="018">018</option>
						<option value="019">019</option>
					</select>
					<b>&ensp;-&ensp;</b>
					<input type="number" name="ph2" value="<%=ph2%>" oninput="handleOnInput(this, 4)" required>
					<b>&ensp;-&ensp;</b>
					<input type="number" name="ph3" value="<%=ph3%>" oninput="handleOnInput(this, 4)" required>
				</td>
			</tr>

			<!-- 이메일 -->
			<tr class="short">
				<th>이메일</th>
				<td colspan="3">
					<input type="text" name="email1" value="<%=email1%>" maxlength="15" required>
					<b>@</b>
					<input type="text"  id="emailAddr" name="email2" value="<%=email2%>" maxlength="10" required>
					<select id="emailSelect">
						<option value="none" selected>직접입력</option>
						<option value="naver">네이버</option>
						<option value="google">구글</option>
						<option value="daum">다음</option>
					</select>
				</td>
			</tr>
		</table>

		<button type="submit" disabled>수정</button>

		<!-- 회원 탈퇴 버튼 -->
		<a id="outUser">회원 탈퇴</a>
	</form>
</div>

<%
	conUser.close();
%>
</body>
</html>