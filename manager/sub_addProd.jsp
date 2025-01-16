<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@page import="java.text.*"%>
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

	// 현재 시간
	Timestamp now = new Timestamp(System.currentTimeMillis());
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String date = format.format(now);
%>
<script>
	$(document).ready(function(){
	});
</script>

<h1 class="mainHeader">상품 관리</h1>

<!-- 소분류 탭 -->
<aside>
	<ul>
		<li  id="prodList"><a href="pureshManager.jsp?ctg=prod_prodList">전체 상품 목록</a></li>
		<li id="addProd" class="On"><a href="pureshManager.jsp?ctg=prod_addProd">신규 상품 등록</a></li>
	</ul>
</aside>

<!-- prodList -->
<article>
	<form action="session/addProd.jsp">
		<table class="formTBL">
			<tr>
				<th>상품 ID</th>
				<td><input type="text" name="prodID" maxlength="10" required></td>
				<th>판매 상태</th>
				<td>
					<select id="prodStatus" name="prodStatus">
						<option value="판매중">판매중</option>
						<option value="품절">품절</option>
						<option value="재입고 예정">재입고 예정</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>상품명</th>
				<td><input type="text" name="prodName" maxlength="20" required></td>
				<th>재고</th>
				<td><input type="number" name="prodStock" required>&ensp;개</td>
			</tr>
			<tr>
				<th>상품 분류</th>
				<td>
					<select id="prodCtg" name="prodCtg">
						<option value="토너">토너</option>
						<option value="세럼">세럼</option>
						<option value="로션">로션</option>
						<option value="크림">크림</option>
					</select>
				</td>
				<th>이벤트</th>
				<td><input type="text" name="prodEvent" maxlength="30"></td>
			</tr>
			<tr>
				<th>상품 타입</th>
				<td>
					<select id="prodType" name="prodType">
						<option value="건성">건성</option>
						<option value="지성">지성</option>
						<option value="복합">복합</option>
						<option value="수부지">수부지</option>
					</select>
				</td>
				<th>메인 이미지</th>
				<td class="path"><input type="text" name="prodImg" required></td>
			</tr>
			<tr>
				<th>용량</th>
				<td><input type="number" name="prodVolume" min="0" required>&ensp;ml</td>
				<th>상세 이미지</th>
				<td class="path"><input type="text" name="prodInfo" required></td>
			</tr>
			<tr>
				<th>판매 가격</th>
				<td><input type="number" name="prodPrice" min="10000" required>&ensp;원</td>
				<td class="button" colspan="2">
					<button type="submit">상품 등록</button>
					<button type="reset">초기화</button>
				</td>
			</tr>
		</table>
	</form>
</article>