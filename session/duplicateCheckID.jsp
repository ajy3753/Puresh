<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<title>Puresh</title>
	<!-- 웹폰트 연결 (앨리스 디지털 배움체) -->
	<link href="https://font.elice.io/css?family=Elice+Digital+Baeum" rel="stylesheet">
	<!-- jQuery 라이브러리 연결 -->
	<script src="https://code.jquery.com/jquery-3.6.3.js"></script>
	<script src="css/jQuery.js"></script>
	<!-- 외부CSS 파일 연결 -->
	<link rel="stylesheet" type="text/css" href="../css/main.css?after">
</head>
<body>
 <!-- jsp -->
 <%
	request.setCharacterEncoding("UTF-8");
	
	// DB 연결
	String DB_URL = "jdbc:mysql://localhost:3306/pureshDB";
	String DB_ID = "pureshManager";
	String DB_PASSWORD = "1234";
	Class.forName("org.gjt.mm.mysql.Driver");
	Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

	// 넘겨받은 checkID 값
	String checkID = (String)request.getParameter("checkID");

	String duplicateCheckID = "SELECT count(userID) FROM userTBL WHERE userID = ?";
	PreparedStatement pstmt = con.prepareStatement(duplicateCheckID);
	pstmt.setString(1, checkID);
	ResultSet rs = pstmt.executeQuery();
	rs.next();

	int count = rs.getInt("count(userID)");

	rs.close();
	pstmt.close();
%>
<script>
	$(document).ready(function(){
		var checkID = "<%=checkID%>";
		var count = "<%=count%>";
		if(count > 0) {
			$("div.checkNO").css("display", "flex");
			$("button").click(function () {
				window.close();
			});
		}
		else {
			$("div.checkOK").css("display", "flex");
			$("button").click(function () {
				var URL = "../sign.jsp?checkID=" + checkID;
				window.opener.parent.location = URL;
				window.close();
			});
		}
	});
</script>

<article class="duplicateCheck">
	<!-- 검사 통과 -->
	<div class="checkOK">
		<h1><%=checkID%></h1>
		<p>사용 가능한 아이디입니다.</p>
		<button>확인</button>
	</div>

	<!-- 검사 미통과 -->
	<div class="checkNO">
		<h1><%=checkID%></h1>
		<p>중복된 아이디입니다.</p>
		<button>닫기</button>
	</div>
</article>

<%
	con.close();
%>
</body>
</html>