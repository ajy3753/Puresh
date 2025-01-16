$(document).ready(function(){

	// 랜덤 배경
	let randNum = Math.floor(Math.random() * 100) + 1;
	let imgNum = (randNum % 4) + 1;
	var BGI = "../images/BGI/BGI_Main" + imgNum + ".png";
	var urlBGI = "url('" + BGI + "')";
	$("body").css("background-image", urlBGI);
	$("body").css("background-size", "80%");
	
	// 검색바
	$(".searchBtn").click(function () {
		var search = $(".searchBar input:text").val();
		if (search == null || search == "") {
			alert("검색어를 입력해주세요.");
		}
		else {
			var keyword = search;
			location.href = "../prodSearch.jsp?keyword=" + keyword;
		}
	});
	$(".searchBar input").keypress(function(e){
		if(e.keyCode && e.keyCode == 13){
			$(".searchBtn").trigger("click");
			return false;
		}
	});

	// 이전 질문으로 돌아가기 (타입테스트용)
	$(".levelMain a.btnBack").click(function() {
		history.back();
	});

	// 다시하기 (타입테스트용)
	$(".resultMain button#btnReplay").click(function() {
		location.href = "testLevel_A1.jsp"
	});

});