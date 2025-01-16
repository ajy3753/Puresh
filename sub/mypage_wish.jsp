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
	Connection conWish = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

	// userID
	String id = (String)session.getAttribute("sid");

	// wish 변수
	String wishID;
	String prodID;
	String wishDate;

	String prodName; 
	String priceComma;
	int prodStock;
	String prodCtg;
	String prodImg;
	String prodStatus;

	// 정렬 세션
	String orderby = request.getParameter("orderby");
	if(orderby == null) {
		orderby = "new";
	}

	// listCount
	String wishNN = "SELECT COUNT(wishID) FROM V_wishList WHERE userID = ?";
	PreparedStatement pstmtNN = conWish.prepareStatement(wishNN);
	pstmtNN.setString(1, id);
	ResultSet rsNN = pstmtNN.executeQuery();
	rsNN.next();

	int listCount = rsNN.getInt("COUNT(wishID)");

	rsNN.close();
	pstmtNN.close();

	// wish 목록 불러오기
	String wishList = "SELECT * FROM V_wishList WHERE userID = ?";
	if(orderby.equals("last")) {
		wishList = wishList + " ORDER BY wishID ASC";
	}
	PreparedStatement pstmtWish = conWish.prepareStatement(wishList);
	pstmtWish.setString(1, id);
	ResultSet rsWish = pstmtWish.executeQuery();
%>
<script>
	$(document).ready(function(){
		// listCount 값이 0 일때
		var count = "<%=listCount%>";
		if(count == 0) {
			$(".mypageSub #listNN").css("display", "none");
			$(".mypageSub #listNot").css("display", "flex");
		}

		// 정렬
		var order = "<%=orderby%>";
		switch (order) {
			case "last" :
				$(".myWishSelect select option").eq(1).attr("selected", "selected");
				break;
			case "new" :
				$(".myWishSelect select option").eq(0).attr("selected", "selected");
				break;
			default :
				break;
		}

		// 체크박스 전체 선택, 해제
		$("#checkAll").on("change", function () {
			var allChk = $(this).is(":checked");
			if (allChk) {
				$(".cartCheck input").prop("checked", true);
			}
			else {
				$(".cartCheck input").prop("checked", false);
			}
		});

		// 체크박스 전체 자동 선택, 해제
		$(".cartCheck input").on("change", function () {
			const boxLength = $(".cartCheck input").length;
			const checkedLength = $(".cartCheck input:checked").length;
			if(checkedLength < boxLength) {
				$("#checkAll").prop("checked", false);
			}
			else {
				$("#checkAll").prop("checked", true);
			}
		});

		// myWishSelect
		$(".myWishSelect select").on("change", function () {
			var URL;
			var changeOrderby = $(this).children(":selected").val();
			URL = "mypage.jsp?ctg=wish_" + changeOrderby;
			location.href = URL;
		});

		// 관심상품 장바구니 이동, 주문, 삭제
		var URL;
		var sendData = "fromWish_";
		var sendID = "";
		// 선택 장바구니 이동
		$("#btnCheckCart").click(function () {
			var ToCart = 0;
			for(var index = 0; index < count; index++) {
				if($("#listNN .cartCheck").eq(index).children("input").is(":checked") == true) {
					sendData = sendData + $("#listNN .cartCheck").eq(index).closest("tr").children("#prodID").val() + "_1_";
					ToCart++;
				}
			}
			if(ToCart > 0) {
				let moveConfirm = confirm(ToCart + "개의 상품을 장바구니에 담으시겠습니까?");
				if(moveConfirm == true) {
					URL = "session/addCart.jsp?sendData=" + sendData;
					location.href =URL;
				}
				else {
					sendData = "";
				}
			}
			else {
				alert("선택된 상품이 없습니다.");
			}
		});
		// 개별 구매
		$(".myCartBtn #btnBuy").click(function () {
			sendData = sendData + $(this).closest("tr").children("#prodID").val() + "_1";
			URL = "order.jsp?sendData=" + sendData;
			location.href =URL;
		});
		// 선택 삭제
		$("#btnCheckDel").click(function () {
			var chkCount = 0;
			for(var index = 0; index < count; index++) {
				if($("#listNN .cartCheck").eq(index).children("input").is(":checked") == true) {
					sendID = sendID + $("#listNN .cartCheck").eq(index).closest("tr").children("#wishID").val() + "_";
					chkCount++;
				}
			}
			if(chkCount > 0) {
				let delConfirm = confirm(chkCount + "개의 상품을 관심상품에서 삭제 하시겠습니까?");
				if(delConfirm == true) {
					URL = "session/deleteWish.jsp?sendID=" + sendID;
					location.href =URL;
				}
				else {
					sendID = "";
				}
			}
			else {
				alert("선택된 상품이 없습니다.");
			}
		});
		// 개별 삭제
		$(".myCartBtn #btnDel").click(function () {
			sendID = $(this).closest("tr").children("#wishID").val() + "_"
			let delConfirm2 = confirm("상품을 관심상품에서 삭제 하시겠습니까?");
			if(delConfirm2 == true) {
				URL = "session/deleteWish.jsp?sendID=" + sendID;
				location.href =URL;
			}
			else {
				sendID = "";
			}
		});
	});
</script>

<h1>관심상품</h1>
<div class="mypageSub" id="wishTBL">
	<table>
		<tr>
			<th>
				<input type="checkbox" id="checkAll" checked>
				<label for="checkAll">&#10004;</label>
				전체 선택
			</th>
			<th colspan="2">상품정보</th>
			<th class="myWishSelect" colspan="2">
				등록일
				<select>
					<option value="new">최신순</option>
					<option value="last">오래된순</option>
				</select>
			</th>
			<th colspan="2" class="myWishCheck">
				<button id="btnCheckCart" style="width: 60%;">선택 장바구니로 이동</button>
				<button id="btnCheckDel" style="width: 40%;">&#10006;선택 삭제&ensp;</button>
			</th>
		</tr>
		<%
			while(rsWish.next()) {
				wishID = rsWish.getString("wishID");
				prodID = rsWish.getString("prodID");
				wishDate = rsWish.getString("DATE_FORMAT(wishDate, '%Y-%m-%d')");

				String loadPrd = "SELECT * FROM V_detail WHERE prodID = ?";
				PreparedStatement pstmtLoad = conWish.prepareStatement(loadPrd);
				pstmtLoad.setString(1, prodID);
				ResultSet rsLoad = pstmtLoad.executeQuery();
				rsLoad.next();

				prodName = rsLoad.getString("prodName");
				priceComma = rsLoad.getString("priceComma");
				prodCtg = rsLoad.getString("prodCtg");
				prodImg = rsLoad.getString("prodImg");
				prodStatus = rsLoad.getString("prodStatus");

				rsLoad.close();
				pstmtLoad.close();
		%>
		<tr id="listNN">
			<!-- wishID, prodID -->
			<input type="hidden" id="wishID" value="<%=wishID%>">
			<input type="hidden" id="prodID" value="<%=prodID%>">

			<!--체크 박스 -->
			<td class="cartCheck">
				<%
					if(prodStatus.equals("판매중")) {
				%>
				<input type="checkbox" id="checkbox<%=listCount%>" name="checkList" checked>
				<label for="checkbox<%=listCount%>">&#10004;</label>
				<%
					}
					else {
				%>
				<p style="font-weight: bold; color: #C81C21;">SOLD OUT</p>
				<%
					}
				%>
			</td>

			<!-- 상품 이미지 -->
			<td class="cartImg">
				<a href="prodDetail.jsp?prodID=<%=prodID%>"><img src="<%=prodImg%>"></a>
			</td>

			<!-- 상품 정보 -->
			<td class="cartPrd">
				<p><a style="color: #D6684C;" href="prodList.jsp?ctg=<%=prodCtg%>"><%=prodCtg%></a></p>
				<p style="font-weight: bold;"><a href="prodDetail.jsp?prodID=<%=prodID%>"><%=prodName%></a></p>
				<p><%=priceComma%>원</p>
			</td>

			<!-- 관심상품 등록일-->
			<td colspan="2"><%=wishDate%></td>

			<!-- 선택 삭제, 주문 -->
			<td class="myCartBtn">
				<%
					if(prodStatus.equals("판매중")) {
				%>
				<button id="btnBuy">바로 구매하기</button>
				<button id="btnDel">&#10006; 삭제</button>
				<%
					}
					else {
				%>
				<button id="btnDel">&#10006; 삭제</button>
				<%
					}
				%>
			</td>
		</tr>
		<%
				listCount--;
				rsLoad.close();
				pstmtLoad.close();
			}
		%>
	</table>
	<p id="listNot">등록된 상품이 없습니다.</p>
</div>

<%
	rsWish.close();
	pstmtWish.close();
	conWish.close();
%>
</body>
</html>