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

	// prodList 변수
	String prodID;
	String prodName;
	String priceComma;
	String prodImg;
	int prodStock;
	String prodStatus;
	String prodEvent;
	String prodDate;

	// 전체 상품 카운트
	String prodCount = "SELECT COUNT(*) FROM V_prodList";
	PreparedStatement pstmtCount = conSub.prepareStatement(prodCount);
	ResultSet rsCount = pstmtCount.executeQuery();
	rsCount.next();

	int listCount = rsCount.getInt("COUNT(*)");

	rsCount.close();
	pstmtCount.close();

	// prodList 불러오기
	String prodList = "SELECT * FROM V_prodList";
	PreparedStatement pstmtSub = conSub.prepareStatement(prodList);
	ResultSet rsSub = pstmtSub.executeQuery();
%>
<script>
	$(document).ready(function(){
		// #btnUpdate (상품 수정)
		$("#prodList button#btnUpdate").click(function () {
			var prodID = $(this).attr("value");
			location.href = "pureshManager.jsp?ctg=prod_updateProd_?prodID=" + prodID;
		});

		// #btnDelete (상품 삭제)
		$("#prodList button#btnDelete").click(function () {
			var prodID = $(this).attr("value");
			let CQ = confirm("현재 상품을 삭제하시겠습니까?\n(※삭제 후에는 복구가 불가능합니다.)");
			if(CQ == true) {
				location.href = "session/deleteProd.jsp?sendID=" + prodID;
			}
		});
	});
</script>

<h1 class="mainHeader">상품 관리</h1>

<!-- 소분류 탭 -->
<aside>
	<ul>
		<li id="prodList" class="On"><a href="pureshManager.jsp?ctg=prod_prodList">전체 상품 목록</a></li>
		<li id="addProd"><a href="pureshManager.jsp?ctg=prod_addProd">신규 상품 등록</a></li>
	</ul>
</aside>

<!-- prodList -->
<article>
	<table class="listTBL" id="prodList">
		<tr class="tableHeader">
			<th>No</th>
			<th colspan="2">상품ID</th>
			<th>상품명</th>
			<th>판매 가격</th>
			<th>재고</th>
			<th>판매 상태</th>
			<th>이벤트</th>
			<th>등록일</th>
			<th>수정/삭제</th>
		</tr>
		<%
			while(rsSub.next()) {
				prodID = rsSub.getString("prodID");
				prodName = rsSub.getString("prodName");
				priceComma = rsSub.getString("priceComma");
				prodImg = rsSub.getString("prodImg");
				prodStock = rsSub.getInt("prodStock");
				prodStatus = rsSub.getString("prodStatus");
				prodEvent = rsSub.getString("Event");
				prodDate = rsSub.getString("Date");
		%>
		<tr>
			<td class="small"><%=listCount%></td>
			<td><img src="<%=prodImg%>"></td>
			<td><%=prodID%></td>
			<td class="prodImg"><%=prodName%>
			</td>
			<td><%=priceComma%>원</td>
			<td><%=prodStock%></td>
			<%
				if (prodStatus.equals("품절")) {
			%>
			<td style="font-weight: bold; color: #C81C21;"><%=prodStatus%></td>
			<%
				}
				else if(prodStatus.equals("재입고 예정")) {
			%>
			<td style="font-weight: bold; color: #FF6653;"><%=prodStatus%></td>
			<%
				}
				else {
			%>
			<td><%=prodStatus%></td>
			<%
				}	
			%>
			<td><%=prodEvent%></td>
			<td><%=prodDate%></td>
			<td>
				<button id="btnUpdate" value="<%=prodID%>">수정</button>
				<button id="btnDelete" value="<%=prodID%>">삭제</button>
			</td>
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