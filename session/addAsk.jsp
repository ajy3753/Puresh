<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@page import="java.text.*"%>
<%
	request.setCharacterEncoding("UTF-8");
	
	// DB 연결
	String DB_URL = "jdbc:mysql://localhost:3306/pureshDB";
	String DB_ID = "pureshManager";
	String DB_PASSWORD = "1234";
	Class.forName("org.gjt.mm.mysql.Driver");
	Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

	// userID
	String id = (String)session.getAttribute("sid");

	// sendAsk에서 넘겨 받은 값
	String askCtg = request.getParameter("askCtg");
	String askName = request.getParameter("askName");
	String askContent = request.getParameter("askContent");
	String agreeEmail = request.getParameter("agreeEmail");
	if(agreeEmail == null) {
		agreeEmail = "NO";
	}
	String askStatus = "접수";

	// 가장 최근 askID 불러오기
	String setAsk = "SELECT * FROM V_setAsk";
	PreparedStatement pstmtSet = con.prepareStatement(setAsk);
	ResultSet rsSet = pstmtSet.executeQuery();
	rsSet.next();

	String askID = rsSet.getString("askID");

	rsSet.close();
	pstmtSet.close();

	// 새 askID 만들기용 변수
	char[] askArray = askID.toCharArray();
	char sort = askArray[9];
	String place = "";
	int num;

	// 현재 시간 불러오기
	Timestamp now = new Timestamp(System.currentTimeMillis());
	SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
	String date = format.format(now);

	// 마지막 askID에 기록된 날짜 비교
	String lastDate = "";
	for(int i = 1; i < 9; i++) {
		lastDate += Character.toString(askArray[i]);
	}

	int last = Integer.parseInt(lastDate);
	int today = Integer.parseInt(date);

	// 날짜가 지나면 001로 시작, 안 지났으면 +1
	if(last < today ) {
		sort = 'A';
		place = "001";
	}
	else {
		for(int i = 10; i < askArray.length; i++) {
			place += Character.toString(askArray[i]);
		}
		num = Integer.parseInt(place) + 1;
		if(num > 999) {
			int i = sort + 1;
			sort = (char)i;
			num = 1;
		}
		place = Integer.toString(num);
		char[] numArray = place.toCharArray();
		if(numArray.length == 1) {
			place = "00" + num;
		}
		if(numArray.length == 2) {
			place = "0" + num;
		}
	}

	// 새 askID 설정
	askID = "A" + date + sort + place;

	// 문의 업로드
	String addAsk = "INSERT INTO askTBL(askID, userID, askCtg, askName, askContent, agreeEmail, askStatus, askDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
	PreparedStatement pstmtAdd = con.prepareStatement(addAsk);
	pstmtAdd.setString(1, askID);
	pstmtAdd.setString(2, id);
	pstmtAdd.setString(3, askCtg);
	pstmtAdd.setString(4, askName);
	pstmtAdd.setString(5, askContent);
	pstmtAdd.setString(6, agreeEmail);
	pstmtAdd.setString(7, askStatus);
	pstmtAdd.setTimestamp(8, now);

	pstmtAdd.executeUpdate();
	pstmtAdd.close();
%>
<%
	con.close();
	response.sendRedirect("../mypage.jsp?ctg=ask");
%>
</body>
</html>