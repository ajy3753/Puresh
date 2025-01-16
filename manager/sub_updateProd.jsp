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

	// prodID
	String prodID = request.getParameter("prodID");
	
	// 상품 정보 불러오기
	String loadProd = "SELECT * FROM V_updateProd WHERE prodID = ?";
	PreparedStatement pstmtSub = conSub.prepareStatement(loadProd);
	pstmtSub.setString(1, prodID);
	ResultSet rsSub = pstmtSub.executeQuery();
	rsSub.next();

	String prodName = rsSub.getString("prodName");
	int prodPrice = rsSub.getInt("prodPrice");
	String prodCtg = rsSub.getString("prodCtg");
	String prodType = rsSub.getString("prodType");
	int prodVolume = rsSub.getInt("prodVolume");
	String prodImg = rsSub.getString("prodImg");
	String prodInfo = rsSub.getString("prodInfo");
	int prodStock = rsSub.getInt("prodStock");
	String prodStatus = rsSub.getString("prodStatus");
	String prodEvent = rsSub.getString("Event");
	String prodDate = rsSub.getString("prodDate");

	rsSub.close();
	pstmtSub.close();
%>
<script>
	$(document).ready(function(){
		// 분류 채우기
		var ctg = "<%=prodCtg%>";
		var type = "<%=prodType%>";
		var status = "<%=prodStatus%>"
		$(".formTBL select#prodCtg").val(ctg).prop("checked", true);
		$(".formTBL select#prodType").val(type).prop("checked", true);
		$(".formTBL select#prodStatus").val(status).prop("checked", true);

		// #btnDelete (상품 삭제)
		$(".formTBL button#btnDelete").click(function () {
			var prodID = "<%=prodID%>";
			let CQ = confirm("현재 상품을 삭제하시겠습니까?\n(※삭제 후에는 복구가 불가능합니다.)");
			if(CQ == true) {
				location.href = "session/deleteProd.jsp?sendID=" + prodID;
			}
		});
	});
</script>

<h1 class="mainHeader">상품 정보 수정</h1>
<h2 class="backLink"><a href="pureshManager.jsp?ctg=prod_prodList">&#8672; 상품 목록으로 돌아가기</a></h2>

<!-- updateProd -->
<article>
	<form action="session/updateProd.jsp">
		<table class="formTBL">
			<tr>
				<th>상품 ID</th>
				<td><input type="text" name="prodID" value="<%=prodID%>" readonly></td>
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
				<th>등록일</th>
				<td><input type="datetime-local" value="<%=prodDate%>" readonly></td>
				<th>재고</th>
				<td><input type="number" name="prodStock" value="<%=prodStock%>" min="0" required>&ensp;개</td>
			</tr>
			<tr>
				<th>상품명</th>
				<td><input type="text" name="prodName" value="<%=prodName%>" maxlength="20" required></td>
				<th>이벤트</th>
				<td><input type="text" name="prodEvent" value="<%=prodEvent%>" maxlength="30"></td>
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
				<th>메인 이미지</th>
				<td class="path"><input type="text" name="prodImg" value="<%=prodImg%>" required></td>
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
				<th>상세 이미지</th>
				<td class="path"><input type="text" name="prodInfo" value="<%=prodInfo%>" required></td>
			</tr>
			<tr>
				<th>용량</th>
				<td><input type="number" name="prodVolume" value="<%=prodVolume%>" min="0" required>&ensp;ml</td>
			</tr>
			<tr>
				<th>판매 가격</th>
				<td><input type="number" name="prodPrice" value="<%=prodPrice%>" min="10000" required>&ensp;원</td>
				<td class="button" colspan="2">
					<button type="submit">수정 완료</button>
					<button type="button" id="btnDelete">상품 삭제</button>
				</td>
			</tr>
		</table>
	</form>
</article>

<%
	conSub.close();
%>