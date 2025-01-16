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
	Connection conCart = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

	// userID
	String id = (String)session.getAttribute("sid");

	// cart 변수
	String cartID;
	String prodID;
	int cartStock;
	int cartTotal;

	String prodName; 
	int prodPrice;
	int prodStock;
	String prodCtg;
	String prodImg;
	String prodStatus;

	String priceComma = "";
	String cartComma = "";
	char[] comma;

	// listCount
	String cartNN = "SELECT COUNT(cartID) FROM V_cartList WHERE userID = ?";
	PreparedStatement pstmtNN = conCart.prepareStatement(cartNN);
	pstmtNN.setString(1, id);
	ResultSet rsNN = pstmtNN.executeQuery();
	rsNN.next();

	int listCount = rsNN.getInt("COUNT(cartID)");

	rsNN.close();
	pstmtNN.close();

	// cart 목록 불러오기
	String cartList = "SELECT * FROM V_cartList WHERE userID = ?";
	PreparedStatement pstmtCart = conCart.prepareStatement(cartList);
	pstmtCart.setString(1, id);
	ResultSet rsCart = pstmtCart.executeQuery();
%>
<script>
	$(document).ready(function(){
		// listCount 값이 0 일때
		var count = "<%=listCount%>";
		if(count == 0) {
			$(".mypageSub #listNN").css("display", "none");
			$(".mypageSub #listNot").css("display", "flex");
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

		// 상품 수량 조절 버튼
		var URL;
		var Name = "주문 상세";
		var Option = "left=300,width=500,height=100";
		// + 버튼
		$(".cartStock #btnAdd").click(function () {
			URL = "session/updateCart.jsp?updateCtg=" +  $(this).closest("tr").children("#cartID").val() + "_addStock";
			window.open(URL, Name, Option);
		});
		// - 버튼
		$(".cartStock #btnSub").click(function () {
			URL = "session/updateCart.jsp?updateCtg=" +  $(this).closest("tr").children("#cartID").val() + "_subStock";
			window.open(URL, Name, Option);
		});

		// 장바구니 주문, 삭제
		var sendData = "fromCart_";
		var sendID = "";
		var chkCount = 0;
		// 선택 주문
		$("#btnCheckBuy").click(function () {
			chkCount = 0;
			for(var index = 0; index < count; index++) {
				if($("#listNN .cartCheck").eq(index).children("input").is(":checked")) {
					sendData = sendData + $("#listNN .cartCheck").eq(index).closest("tr").children("#cartID").val() + "_";
					chkCount++;
				}
			}
			if(chkCount > 0) {
				URL = "order.jsp?sendData=" + sendData;
				location.href = URL;
			}
			else {
				alert("선택된 상품이 없습니다.");
			}
		});
		// 개별 주문
		$(".myCartBtn #btnBuy").click(function () {
			sendData = sendData + $(this).closest("tr").children("#cartID").val() +"_";
			URL = "order.jsp?sendData=" + sendData;
			location.href = URL;
		});
		// 선택 삭제
		$("#btnCheckDel").click(function () {
			chkCount = 0;
			for(var index = 0; index < count; index++) {
				if($("#listNN .cartCheck").eq(index).children("input").is(":checked") == true) {
					sendID = sendID + $("#listNN .cartCheck").eq(index).closest("tr").children("#cartID").val() + "_";
					chkCount++;
				}
			}
			if(chkCount > 0) {
				let delConfirm = confirm(chkCount + "개의 상품을 장바구니에서 삭제 하시겠습니까?");
				if(delConfirm == true) {
					URL = "session/deleteCart.jsp?sendID=" + sendID;
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
			sendID = $(this).closest("tr").children("#cartID").val() + "_";
			let delConfirm2 = confirm("상품을 장바구니에서 삭제 하시겠습니까?");
			if(delConfirm2 == true) {
				URL = "session/deleteCart.jsp?sendID=" + sendID;
				location.href =URL;
			}
			else {
				sendID = "";
			}
		});
	});
</script>

<h1>장바구니</h1>
<div class="mypageSub">
	<table>
		<tr>
			<th>
				<input type="checkbox" id="checkAll" checked>
				<label for="checkAll">&#10004;</label>
				전체 선택
			</th>
			<th colspan="2">상품정보</th>
			<th>수량</th>
			<th>상품금액</th>
			<th>배송비</th>
			<th colspan="2">
				<button id="btnCheckBuy" style="margin-left: -15%;">선택 주문</button>
				<button id="btnCheckDel">&ensp;&#10006;선택 삭제&ensp;</button>
			</th>
		</tr>
		<!-- 장바구니 목록 -->
		<%
			while(rsCart.next()) {
				cartID = rsCart.getString("cartID");
				prodID = rsCart.getString("prodID");
				cartStock = rsCart.getInt("cartStock");

				String loadPrd = "SELECT * FROM V_detail WHERE prodID = ?";
				PreparedStatement pstmtLoad = conCart.prepareStatement(loadPrd);
				pstmtLoad.setString(1, prodID);
				ResultSet rsLoad = pstmtLoad.executeQuery();
				rsLoad.next();

				prodName = rsLoad.getString("prodName");
				prodPrice = rsLoad.getInt("prodPrice");
				prodStock = rsLoad.getInt("prodStock");
				prodCtg = rsLoad.getString("prodCtg");
				prodImg = rsLoad.getString("prodImg");
				prodStatus = rsLoad.getString("prodStatus");

				cartTotal = (cartStock * prodPrice);

				priceComma = "";
				comma = (Integer.toString(prodPrice)).toCharArray();
				for(int index = comma.length, cnt = 0; index > 0; index--) {
					if(cnt % 3 == 0 && cnt != 0) {
						priceComma = Character.toString(comma[index - 1]) + ',' + priceComma;
					}
					else {
						priceComma = Character.toString(comma[index - 1]) + priceComma;
					}
					cnt++;
				}

				cartComma = "";
				comma = (Integer.toString(cartTotal)).toCharArray();
				for(int index = comma.length, cnt = 0; index > 0; index--) {
					if(cnt % 3 == 0 && cnt != 0) {
						cartComma = Character.toString(comma[index - 1]) + ',' + cartComma;
					}
					else {
						cartComma = Character.toString(comma[index - 1]) + cartComma;
					}
					cnt++;
				}

				rsLoad.close();
				pstmtLoad.close();
		%>
		<tr id="listNN">
			<!-- cartID, prodID, cartStock -->
			<input type="hidden" id="cartID" value="<%=cartID%>">
			<input type="hidden" id="prodID" value="<%=prodID%>">
			<input type="hidden" id="cartStock" value="<%=cartStock%>">

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
				<p style="font-weight: bold; color: #C81C21;">구매 불가</p>
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

			<!-- 수량 -->
			<td class="cartStock">
				<%
					if(prodStatus.equals("판매중")) {
				%>
				<button id="btnSub" value="<%=cartID%>">&#8211;</button>
				<p><%=cartStock%></p>
				<button id="btnAdd" value="<%=cartID%>">&#43;</button>
				<%
					}
					else {
				%>
				<button id="btnSub" value="<%=cartID%>" disabled>&#8211;</button>
				<p><%=cartStock%></p>
				<button id="btnAdd" value="<%=cartID%>" disabled>&#43;</button>
				<%
					}
				%>
			</td>

			<!-- 상품금액, 배송비 -->
			<td><%=cartComma%>원</td>
			<td>4,000원</td>

			<!-- 선택 삭제, 주문 -->
			<td class="myCartBtn">
				<%
					if(prodStatus.equals("판매중")) {
				%>
				<button id="btnBuy">주문하기</button>
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
	<div id="listNot">
		<p>
			장바구니에 담긴 상품이 없습니다.
			<a href="prodList.jsp" style="font-weight: bold; color: #C81C21;">상품 둘러보기</a>
		</p>
	</div>
</div>

<%
	rsCart.close();
	pstmtCart.close();
	conCart.close();
%>