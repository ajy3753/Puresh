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

	// orderList 변수
	String orderID;
	String userID;
	String orderName;
	int orderStock;
	String totalComma;
	String orderStatus;
	String orderStart;

	// 전체 주문 카운트
	String orderCount = "SELECT COUNT(*) FROM V_orderListSub";
	PreparedStatement pstmtCount = conSub.prepareStatement(orderCount);
	ResultSet rsCount = pstmtCount.executeQuery();
	rsCount.next();

	int listCount = rsCount.getInt("COUNT(*)");

	rsCount.close();
	pstmtCount.close();

	// orderList 불러오기
	String orderList = "SELECT * FROM V_orderListSub";
	PreparedStatement pstmtSub = conSub.prepareStatement(orderList);
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

<h1 class="mainHeader">주문 관리</h1>

<!-- 소분류 탭 -->
<aside>
	<ul>
		<li  id="orderList"><a href="pureshManager.jsp?ctg=order_orderList">전체 주문 목록</a></li>
		<li id="delievery"><a href="pureshManager.jsp?ctg=order_delievery">배송 상황</a></li>
		<li id="changeOrder" class="On"><a href="pureshManager.jsp?ctg=order_changeOrder">교환/환불 신청</a></li>
	</ul>
</aside>

<!-- orderList -->
<article>

</article>

<%
	rsSub.close();
	pstmtSub.close();
	conSub.close();
%>