-- 카테고리 정렬용
-- 1) 인기순
CREATE VIEW V_best AS SELECT P.prodID, prodName, prodPrice, FORMAT(prodPrice, 0), prodCtg, prodType, prodImg, prodStatus, prodDate FROM prodTBL P LEFT OUTER JOIN orderTBL O ON O.prodID = P.prodID GROUP BY P.prodID
ORDER BY SUM(orderStock) DESC, prodName;
-- 2) 최신순
CREATE VIEW V_new AS SELECT prodID, prodName, prodPrice, FORMAT(prodPrice, 0), prodCtg, prodType, prodImg, prodStatus, prodDate FROM prodTBL ORDER BY prodDate DESC, prodName;
-- 3) 낮은 가격순
CREATE VIEW V_priceLow AS SELECT prodID, prodName, prodPrice, FORMAT(prodPrice, 0), prodCtg, prodType, prodImg, prodStatus, prodDate FROM prodTBL ORDER BY prodPrice, prodName;
-- 4) 높은 가격순
CREATE VIEW V_priceHigh AS SELECT prodID, prodName, prodPrice, FORMAT(prodPrice, 0), prodCtg, prodType, prodImg, prodStatus, prodDate FROM prodTBL ORDER BY prodPrice DESC, prodName;

-- 메인 페이지용
-- Weekly Best
CREATE VIEW V_bestWeekly AS SELECT P.prodID, prodName, FORMAT(prodPrice, 0) AS 'priceComma', prodCtg, prodType, prodImg, prodStatus FROM prodTBL P LEFT OUTER JOIN orderTBL O ON O.prodID = P.prodID WHERE TIMESTAMPDIFF(DAY, orderStart, '2024-04-30') <= 7 AND prodStatus = '판매중' GROUP BY P.prodID ORDER BY SUM(orderStock) DESC, prodName;
-- New
CREATE VIEW V_prdEvent AS SELECT P.prodID, prodName, prodPrice, FORMAT(prodPrice, 0), prodCtg, prodImg, prodStatus, prodDate, prodEvent FROM prodTBL P LEFT OUTER JOIN orderTBL O ON O.prodID = P.prodID WHERE prodStatus = '판매중' GROUP BY P.prodID ORDER BY SUM(orderStock) DESC, prodName;

-- 이벤트용
-- 1) NEW 페이지 상품 불러오기
CREATE VIEW V_newEvent AS SELECT prodID, prodName, FORMAT(prodPrice, 0) AS 'priceComma', prodCtg, prodType, prodImg, prodStatus, prodEvent FROM prodTBL WHERE prodEvent LIKE "%" ORDER BY prodID DESC;
-- 2) event 페이지 목록 불러오기
CREATE VIEW V_eventList AS SELECT eventID, eventName, eventImg, DATE_FORMAT(eventStart, '%Y.%m.%d') AS 'startDate', eventEnd, DATE_FORMAT(eventEnd, '%Y.%m.%d') AS 'endDate', TIMESTAMPDIFF(DAY, CURDATE( ), eventEnd) AS 'Dday', prizeImg, prizeDate, DATE_FORMAT(prizeDate, '%Y.%m.%d') AS 'prizeDay' FROM eventTBL ORDER BY eventID DESC;
-- 3) eventDetail 불러오기
CREATE VIEW V_eventDetail AS SELECT eventID, eventName, eventInfo, eventStart, eventEnd, TIMESTAMPDIFF(DAY, CURDATE( ), eventEnd), IFNULL(TIMESTAMPDIFF(DAY, CURDATE( ), prizeDate), 1) FROM eventTBL;

-- 상품 정보 불러오기용
CREATE VIEW V_detail AS SELECT prodID, prodName, prodPrice, FORMAT(prodPrice, 0) AS 'priceComma', prodStock, prodCtg, prodType, prodVolume, prodImg, prodInfo, prodStatus FROM prodTBL;

-- 유저 정보 불러오기용
-- 1) 마이페이지 상단 헤더
CREATE VIEW V_myHeader AS SELECT userID, userName, FORMAT(userPoint, 0) FROM userTBL;
-- 2) 주문자(유저) 정보 불러오기
CREATE VIEW V_orderUser AS SELECT userID, userName, userPhone, userAdress, userPoint FROM userTBL;
-- 3) 유저 정보 불러오기 (mypage_user)
CREATE VIEW V_loadUser AS SELECT userID, userPassword, userName, userGender, userPhone, userEmail, agreeEmail, userAdress, userBirth, IFNULL(userType, '테스트 결과 없음') AS 'typeResult' FROM userTBL;

-- order용
-- 1) 주문내역 목록 불러오기 (mypage_order)
CREATE VIEW V_orderList AS SELECT orderID, userID, O.prodID, prodName, prodCtg, prodImg, orderName, orderStock, orderTotal, FORMAT(orderTotal, 0), orderStatus, IFNULL(deliveryNumber, '운송장 미등록'), orderStart, DATE_FORMAT(orderStart, '%Y-%m-%d %H:%i') FROM orderTBL O, prodTBL P WHERE O.prodID = P.prodID ORDER BY orderName DESC;
-- 2) orderDetail
CREATE VIEW V_orderDetail AS SELECT orderID, userID, O.prodID, prodName, prodImg, orderName, orderPrice, orderStock, orderStatus, orderTotal, FORMAT(orderTotal, 0), orderStart, orderEnd, DATE_FORMAT(orderStart, '%Y-%m-%d %H:%i'), DATE_FORMAT(orderEnd, '%Y-%m-%d') FROM orderTBL O, prodTBL P WHERE O.prodID = P.prodID ORDER BY orderName DESC;

-- cart용
-- 1) 장바구니 목록 불러오기 (mypage_cart)
CREATE VIEW V_cartList AS SELECT cartID, userID, prodID, cartStock, IFNULL(cartStock, 0), cartDate FROM cartTBL ORDER BY cartID DESC;

-- wish용
-- 1) 관심상품 목록 불러오기 (mypage_wish)
CREATE VIEW V_wishList AS SELECT wishID, userID, prodID, wishDate, DATE_FORMAT(wishDate, '%Y-%m-%d') FROM wishTBL ORDER BY wishID DESC;

-- pay용
-- 1) 결제 정보 불러오기 (mypage_orderDetail 및 mypage_pay)
CREATE VIEW V_payDetail AS SELECT payID, userID, orderName, orderer, receiver, receiverAddr, receiverPhone, payMethod, methodBank, methodAccount, methodName, orderTotal, FORMAT(orderTotal, 0), deliveryCharge, FORMAT(deliveryCharge, 0), payPoint, FORMAT(payPoint, 0), payTotal, FORMAT(payTotal, 0), DATE_FORMAT(payDate, '%Y-%m-%d %H:%i') FROM payTBL ORDER BY payID DESC;
-- 2) 추가 정보 불러오기 (mypage_orderDetail)
CREATE VIEW V_payPlus AS SELECT payID, userID, orderName, methodBank, methodAccount, methodName, methodDate, refundBank, refundAccount, refundName FROM payTBL;
-- 3) 수정용 정보 불러오기 (mypage_orderModify)

-- ask용
-- 1) 문의 내역 불러오기
CREATE VIEW V_askList AS SELECT askID, userID, askCtg, askName, askContent, askStatus, agreeEmail, DATE_FORMAT(askDate, '%Y.%m. %d') AS 'Date', answer, DATE_FORMAT(answerDate, '%Y.%m.%d') AS 'answerDate' FROM askTBL ORDER BY askID DESC;

-- review용
-- 1) 리뷰 평점 (소수점 한 자리에서 반올림)
CREATE VIEW V_scoreAVG AS SELECT prodID, ROUND(AVG(ratingScore), 1) FROM reviewTBL GROUP BY prodID;
-- 2) 점수 개수
CREATE VIEW V_scoreCount AS SELECT prodID, ratingScore FROM reviewTBL;
-- 3) 퍼센티지 구하기
CREATE VIEW V_scorePercent AS SELECT prodID, COUNT(reviewID) FROM reviewTBL GROUP BY prodID;
-- 4) V_reviewList
CREATE VIEW V_reviewList AS SELECT reviewID, userID, RPAD(SUBSTR(userID, 1, 3), LENGTH(userID), '*') AS 'RPAD_userID', R.prodID, prodName, prodImg, orderID, orderStock, ratingScore, reviewContent, reviewDate, DATE_FORMAT(reviewDate, '%Y-%m-%d') AS 'Date' FROM reviewTBL R, prodTBL P WHERE R.prodID = P.prodID ORDER BY reviewID DESC;

-- tableID 설정용
-- 1) orderID 설정용
CREATE VIEW V_setOrder AS SELECT orderID, userID, orderName, IFNULL(orderName, 'P00000000A') FROM orderTBL ORDER BY orderID DESC;
-- 2) cartID 설정용
CREATE VIEW V_setCart AS SELECT cartID FROM cartTBL ORDER BY cartID DESC LIMIT 1;
-- 3) wishID 설정용
CREATE VIEW V_setWish AS SELECT wishID FROM wishTBL ORDER BY wishID DESC LIMIT 1;
-- 4) payID 설정용
CREATE VIEW V_setPay AS SELECT payID FROM payTBL ORDER BY payID DESC LIMIT 1;
-- 5) reviewID 설정용
CREATE VIEW V_setReview AS SELECT reviewID FROM reviewTBL ORDER BY reviewID DESC LIMIT 1;
-- 6) askID 설정용
CREATE VIEW V_setAsk AS SELECT askID FROM askTBL ORDER BY askID DESC LIMIT 1;

-- pureshManager용
-- 1) 로그인
CREATE VIEW V_pureshManager AS SELECT userID, userPassword FROM userTBL WHERE userID = 'puresh';
-- sub_userList
CREATE VIEW V_userList AS SELECT userID, RPAD(SUBSTR(userID, 1, 4), LENGTH(userID), '✦') AS 'RPAD_userID', userName, RPAD(SUBSTR(userName, 1, 1), LENGTH(userName)/3, '✦') AS 'RPAD_userName', userGender, userPhone, DATE_FORMAT(userDate, '%Y-%m-%d') FROM userTBL WHERE userID != 'puresh' ORDER BY userDate;
-- sub_sendEmail
CREATE VIEW V_sendEmail AS SELECT userID, RPAD(SUBSTR(userID, 1, 4), LENGTH(userID), '✦') AS 'RPAD_userID', RPAD(SUBSTR(userName, 1, 1), LENGTH(userName)/3, '✦') AS 'RPAD_userName', userEmail, agreeEmail FROM userTBL WHERE userID != 'puresh' ORDER BY userID;
-- sub_grade
CREATE VIEW V_grade AS SELECT U.userID, RPAD(SUBSTR(U.userID, 1, 4), LENGTH(U.userID), '✦') AS 'RPAD_userID', COUNT(orderID) AS 'COUNT_orderID', SUM(orderTotal) AS 'SUM_orderTotal', FORMAT(SUM(orderTotal), 0) AS 'totalComma' FROM userTBL U LEFT OUTER JOIN orderTBL O ON U.userID = O.userID WHERE U.userID != 'puresh' GROUP BY U.userID ORDER BY SUM(orderTotal) DESC;
-- sub_prodList
CREATE VIEW V_prodList AS SELECT prodID, prodName, FORMAT(prodPrice, 0) AS 'priceComma', prodImg, prodStock, prodStatus, IFNULL(prodEvent, '') AS 'Event', DATE_FORMAT(prodDate, '%Y-%m-%d') AS 'Date' FROM prodTBL ORDER BY prodDate DESC;
-- sub_updateProd
CREATE VIEW V_updateProd AS SELECT prodID, prodName, prodPrice, FORMAT(prodPrice, 0) AS 'priceComma', prodCtg, prodType, prodVolume, prodImg, prodInfo, prodStock, prodStatus, IFNULL(prodEvent, '') AS 'Event', prodDate FROM prodTBL;
-- sub_orderList
CREATE VIEW V_orderListSub AS SELECT orderID, userID, RPAD(SUBSTR(userID, 1, 4), LENGTH(userID), '✦') AS 'RPAD_userID', orderName, orderStock, FORMAT(orderTotal, 0) AS 'totalComma', orderStatus, orderStart FROM orderTBL ORDER BY orderName DESC;
-- sub_updateOrder
CREATE VIEW V_orderDetailSub AS SELECT orderID, userID, orderName, prodName, FORMAT(orderPrice, 0) AS 'priceComma', orderStock, FORMAT(orderTotal, 0) AS 'totalComma', orderStatus, orderStart, IFNULL(deliveryNumber, '운송장 미등록') AS 'deliveryNumber', IFNULL(orderEnd, '구매확정 미진행') AS 'orderEnd' FROM orderTBL O, prodTBL P WHERE O.prodID = P.prodID ORDER BY orderID;
-- sub_delivery
CREATE VIEW V_delivery AS SELECT orderID, O.orderName, RPAD(SUBSTR(receiver, 1, 2), LENGTH(receiver)/3, '✦') AS 'RPAD_receiver', receiverPhone, orderStatus, IFNULL(deliveryNumber, '운송장 미등록') AS 'deliveryNumber', DATE_FORMAT(orderStart, '%Y-%m-%d') AS 'orderStart' FROM orderTBL O, payTBL P WHERE O.orderName = P.orderName AND orderStatus IN ('상품 준비 중', '배송 중', '배송 완료') ORDER BY orderStart DESC;
-- sub_reviewChart
CREATE VIEW V_reivewChart AS SELECT R.prodID, prodName, prodImg, COUNT(reviewID) AS 'reviewCount', ROUND(SUM(ratingScore)/COUNT(reviewID), 1) AS 'scoreAVG' FROM reviewTBL R, prodTBL P WHERE P.prodID = R.prodID GROUP BY R.prodID ORDER BY prodName;
-- sub_reivewClass
CREATE VIEW V_reivewClass AS SELECT reviewID, R.prodID, prodImg, RPAD(SUBSTR(userID, 1, 4), LENGTH(userID), '✦') AS 'userID', orderStock, ratingScore, reviewContent, DATE_FORMAT(reviewDate, '%Y-%m-%d') AS 'reviewDate' FROM reviewTBL R, prodTBL P WHERE R.prodID = P.prodID ORDER BY reviewID DESC;


-- sub_askList
CREATE VIEW V_askListSub AS SELECT askID, RPAD(SUBSTR(userID, 1, 4), LENGTH(userID), '✦') AS 'RPAD_userID', askCtg, askName, askStatus, askDate FROM askTBL WHERE userID != 'puresh' ORDER BY askStatus = '접수' DESC, askID DESC;
-- sub_updateAsk
CREATE VIEW V_updateAsk AS SELECT askID, userID, askCtg, askName, askContent, askStatus, agreeEmail, askDate, answer, answerDate FROM askTBL;