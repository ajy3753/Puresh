$(document).ready(function(){

	// 랜덤 배경
	let randNum = Math.floor(Math.random() * 100) + 1;
	let imgNum = (randNum % 4) + 1;
	var BGI = "images/BGI/BGI_Main" + imgNum + ".png";
	var urlBGI = "url('" + BGI + "')";

	$(".listMain, .eventMain, .eventDetailMain, .loginMain, .findUserMain, .signMain, .joinMain, .orderMain, .orderOKMain, mypageMain, .searchMain, .supportMain").css("background-image", urlBGI );

	// 아이디, 비밀번호 입력 제한
	$("input#ID").on("input", function() {
		var inputData = $(this).val();
		inputData = inputData.replace(/\s/g, '');
		inputData = inputData.replace(/,/ig, '');
		inputData = inputData.replace(/[^A-Za-z][^0-9.]/ig, '');
		inputData = inputData.toLowerCase();
		$(this).val(inputData);
	});
	$("input#PWD").on("input", function() {
		var inputData = $(this).val();
		inputData = inputData.replace(/\s/g, '');
		inputData = inputData.replace(/,/ig, '');
		inputData = inputData.replace(/[^A-Za-z][^0-9.]/ig, '');
		inputData = inputData.toLowerCase();
		$(this).val(inputData);
	});

	// 은행별 계좌번호 자릿수 설정
	$("select#Bank").on("change", function () {
		var method = $(this).children(":selected").attr("name");
		const bank = $(this).children(":selected").val();
		switch (bank) {
			case "KB국민은행" :
				$(this).parent("td").children("input").eq(2).nextAll().remove();
				$(this).parent("td").children("input").eq(0).attr("oninput", "handleOnInput(this, 6)");
				$(this).parent("td").children("input").eq(1).attr("oninput", "handleOnInput(this, 2)");
				$(this).parent("td").children("input").eq(2).attr("oninput", "handleOnInput(this, 6)");
				break;
			case "NH농협" :
				$(this).parent("td").children("input").eq(2).nextAll().remove();
				$(this).parent("td").children("input").eq(0).attr("oninput", "handleOnInput(this, 3)");
				$(this).parent("td").children("input").eq(1).attr("oninput", "handleOnInput(this, 4)");
				$(this).parent("td").children("input").eq(2).attr("oninput", "handleOnInput(this, 4)");
				if(method == "methodBank") {
					$(this).parent("td").children("input").eq(2).after("<b>&nbsp;-&nbsp</b><input type='number' name='methodAccount4' oninput='handleOnInput(this, 2)'>")
				}
				else {
					$(this).parent("td").children("input").eq(2).after("<b>&nbsp;-&nbsp</b><input type='number' name='refundAccount4' oninput='handleOnInput(this, 2)'>")	
				}
				break;
			case "MG새마을금고" :
				$(this).parent("td").children("input").eq(2).nextAll().remove();
				$(this).parent("td").children("input").eq(0).attr("oninput", "handleOnInput(this, 6)");
				$(this).parent("td").children("input").eq(1).attr("oninput", "handleOnInput(this, 6)");
				$(this).parent("td").children("input").eq(2).attr("oninput", "handleOnInput(this, 6)");
				break;
			case "KEB하나은행" :
				$(this).parent("td").children("input").eq(2).nextAll().remove();
				$(this).parent("td").children("input").eq(0).attr("oninput", "handleOnInput(this, 3)");
				$(this).parent("td").children("input").eq(1).attr("oninput", "handleOnInput(this, 6)");
				$(this).parent("td").children("input").eq(2).attr("oninput", "handleOnInput(this, 5)");
				break;
			case "IBK기업은행" :
				$(this).parent("td").children("input").eq(2).nextAll().remove();
				$(this).parent("td").children("input").eq(0).attr("oninput", "handleOnInput(this, 3)");
				$(this).parent("td").children("input").eq(1).attr("oninput", "handleOnInput(this, 6)");
				$(this).parent("td").children("input").eq(2).attr("oninput", "handleOnInput(this, 2)");
				if(method == "methodBank") {
					$(this).parent("td").children("input").eq(2).after("<b>&nbsp;-&nbsp</b><input type='number' name='methodAccount4' oninput='handleOnInput(this, 3)'>")
				}
				else {
					$(this).parent("td").children("input").eq(2).after("<b>&nbsp;-&nbsp</b><input type='number' name='refundAccount4' oninput='handleOnInput(this, 3)'>")
				}
				break;
			case "신한은행" :
				$(this).parent("td").children("input").eq(2).nextAll().remove();
				$(this).parent("td").children("input").eq(0).attr("oninput", "handleOnInput(this, 3)");
				$(this).parent("td").children("input").eq(1).attr("oninput", "handleOnInput(this, 3)");
				$(this).parent("td").children("input").eq(2).attr("oninput", "handleOnInput(this, 6)");
				break;
			case "우리은행" :
				$(this).parent("td").children("input").eq(2).nextAll().remove();
				$(this).parent("td").children("input").eq(0).attr("oninput", "handleOnInput(this, 4)");
				$(this).parent("td").children("input").eq(1).attr("oninput", "handleOnInput(this, 3)");
				$(this).parent("td").children("input").eq(2).attr("oninput", "handleOnInput(this, 6)");
				break;
			case "카카오뱅크" :
				$(this).parent("td").children("input").eq(2).nextAll().remove();
				$(this).parent("td").children("input").eq(0).attr("oninput", "handleOnInput(this, 4)");
				$(this).parent("td").children("input").eq(1).attr("oninput", "handleOnInput(this, 2)");
				$(this).parent("td").children("input").eq(2).attr("oninput", "handleOnInput(this, 7)");
				break;
			case "토스뱅크" :
				$(this).parent("td").children("input").eq(2).nextAll().remove();
				$(this).parent("td").children("input").eq(0).attr("oninput", "handleOnInput(this, 4)");
				$(this).parent("td").children("input").eq(1).attr("oninput", "handleOnInput(this, 4)");
				$(this).parent("td").children("input").eq(2).attr("oninput", "handleOnInput(this, 4)");
				break;
			default:
				break;
			}
		});

	// 검색바
	$(".searchBtn").click(function () {
		var search = $(".searchBar input:text").val();
		if (search == null || search == "") {
			alert("검색어를 입력해주세요.");
		}
		else {
			var keyword = search;
			location.href = "prodSearch.jsp?keyword=" + keyword;
		}
	});
	$(".searchBar input").keypress(function(e){
		if(e.keyCode && e.keyCode == 13){
			$(".searchBtn").trigger("click");
			return false;
		}
	});

	// 품절 상품
	$(".prodBox a#SOLDOUT").click(function () {
		alert("품절된 상품은 장바구니에 담을 수 없습니다.");
	});

	// 마이페이지 드롭다운
	$(".mypage").mouseover(function () {
		$(".menuDrop").css("display", "flex");
	});
	$(".mypage" && ".menuDrop").mouseleave(function () {
		$(".menuDrop").css("display", "none");
	});

	// prodList 정렬 탭
	$(".listArray ul li").click(function () {
		var contNum = $(this).index();
		$(this).addClass("On").siblings().removeClass("On");
		$(".listCont").eq(contNum).addClass("On").siblings().removeClass("On");
	});

	// prodDetail 상품 정보 탭
	$(".detailTab li").click(function () {
		var contNum = $(this).index();
		$(this).addClass("On").siblings().removeClass("On");
		$(".detailTab div").eq(contNum).addClass("On").siblings().removeClass("On");
	});

	// event 탭
	$(".eventContent li").click(function () {
		var contNum = $(this).index();
		$(this).addClass("On").siblings().removeClass("On");
		$(".eventContent article").eq(contNum).addClass("On").siblings().removeClass("On");
	});

	// suporrt 자주 묻는 질문 탭
	$(".FAQ li").click(function () {
		var contNum = $(this).index();
		$(this).addClass("On").siblings().removeClass("On");
		switch (contNum) {
			case 1:
				$(".FAQ div").css("display", "none");
				$(".FAQ div#account").css("display", "flex");
				break;
			case 2:
				$(".FAQ div").css("display", "none");
				$(".FAQ div#orderPay").css("display", "flex");
				break;
			case 3:
				$(".FAQ div").css("display", "none");
				$(".FAQ div#delivery").css("display", "flex");
				break;
			case 4:
				$(".FAQ div").css("display", "none");
				$(".FAQ div#exchangeRefund").css("display", "flex");
				break;
			default:
				$(".FAQ div").css("display", "flex");
				break;
		}
	});

	// FAQ 드롭다운
	$(".FAQ div span").click(function () {
		var drop = $(this).parent().attr("value");
		if(drop == "down") {
			$(this).parent().removeClass("On").attr("value", "up");
			$(this).children("img").attr("src", "images/Icon/Icon_dropdown.png");
		}
		else {
			$(this).parent().addClass("On").attr("value", "down").siblings().removeClass("On").attr("value", "up");
			$(".FAQ div span img").attr("src", "images/Icon/Icon_dropdown.png");
			$(this).children("img").attr("src", "images/Icon/Icon_dropup.png");
		}
	});

	// order 결제 수단 방식 변경
	$(".selectMethod input").on("change", function () {
		var method = $("input:checked").val();
		switch (method) {
			case "NoBankBook" :
				$(".payMethod").removeClass("On");
				$(".payMethod input").attr("disabled", "disabled");

				$(".payMethod#NoBankBook").addClass("On");
				$(".payMethod#NoBankBook input").removeAttr("disabled");
				$(".payMethod#NoBankBook input").attr("required", "true");
				$(".payRefund").addClass("On");
				break;
			case "KakaoPayRemittance" :
				$(".payMethod").removeClass("On");
				$(".payMethod input").attr("disabled", "disabled");

				$(".payMethod#KakaoPayRemittance").addClass("On");
				$(".payMethod#KakaoPayRemittance input").removeAttr("disabled");
				$(".payMethod#KakaoPayRemittance input").attr("required", "true");
				$(".payRefund").addClass("On");
				break;
			default :
				$(".payRefund").siblings().removeClass("On");
				break;
			}
	});
});