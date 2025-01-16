DROP DATABASE IF EXISTS pureshDB;
CREATE DATABASE pureshDB;
DROP USER IF EXISTS pureshManager@localhost;
CREATE USER pureshManager@localhost IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON pureshDB.* TO pureshManager@localhost;
USE pureshDB;

/*
-- 테스트용 및 시연용 계정 : test (1234)
-- 관리자 페이지 계정 : puresh (1234)
*/

-- <TABLE>
CREATE TABLE userTBL (
	userID VARCHAR(10) NOT NULL,
	userPassword VARCHAR(20) NOT NULL,
	userName VARCHAR(15) NOT NULL,
	userGender VARCHAR(3) DEFAULT NULL,
	userPhone VARCHAR(13) NOT NULL,
	userEmail VARCHAR(30) NOT NULL,
	agreeEmail VARCHAR(3) NOT NULL,
	userAdress VARCHAR(50) DEFAULT NULL,
	userBirth DATE DEFAULT NULL,
	userType VARCHAR(10) DEFAULT NULL,
	userPoint INT NOT NULL DEFAULT '0',
	userDate TIMESTAMP NOT NULL,
	PRIMARY KEY (userID)
);

CREATE TABLE prodTBL (
	prodID VARCHAR(10) NOT NULL,
	prodName VARCHAR(20) NOT NULL,
	prodPrice INT NOT NULL,
	prodStock INT NOT NULL,
	prodCtg VARCHAR(15) NOT NULL,
	prodType VARCHAR(10) NOT NULL,
	prodVolume INT NOT NULL,
	prodImg VARCHAR(45) NOT NULL,
	prodInfo VARCHAR(45) NOT NULL,
	prodStatus VARCHAR(10) NOT NULL,
	prodDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	prodEvent VARCHAR(30) DEFAULT NULL,
	PRIMARY KEY (prodID)
);

CREATE TABLE orderTBL (
	orderID VARCHAR(15) NOT NULL,
	userID VARCHAR(10) NOT NULL,
	prodID VARCHAR(10) NOT NULL,
	orderName VARCHAR(20) NOT NULL,
	orderPrice INT NOT NULL,
	orderStock INT NOT NULL,
	orderTotal INT NOT NULL,
	orderStatus VARCHAR(10) NOT NULL,
	deliveryNumber VARCHAR(12) DEFAULT NULL,
	orderStart TIMESTAMP NOT NULL,
	orderEnd TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY (orderID),
	KEY userID_order_idx (userID),
	KEY prodID_order_idx (prodID),
	CONSTRAINT prodID_order FOREIGN KEY (prodID) REFERENCES prodTBL (prodID),
	CONSTRAINT userID_order FOREIGN KEY (userID) REFERENCES userTBL (userID)
);

CREATE TABLE payTBL (
	payID VARCHAR(15) NOT NULL,
	userID VARCHAR(10) NOT NULL,
	orderName VARCHAR(20) NOT NULL,
	orderer VARCHAR(20) NOT NULL,
	receiver VARCHAR(20) NOT NULL,
	receiverAddr VARCHAR(50) NOT NULL,
	receiverPhone VARCHAR(15) NOT NULL,
	payMethod VARCHAR(20) NOT NULL,
	methodBank VARCHAR(15) DEFAULT NULL,
	methodAccount VARCHAR(20) DEFAULT NULL,
	methodName VARCHAR(20) DEFAULT NULL,
	methodDate DATE DEFAULT NULL,
	refundBank VARCHAR(15) DEFAULT NULL,
	refundAccount VARCHAR(20) DEFAULT NULL,
	refundName VARCHAR(20) DEFAULT NULL,
	orderTotal INT NOT NULL,
	deliveryCharge INT NOT NULL,
	payPoINT INT NOT NULL DEFAULT '0',
	payTotal INT NOT NULL,
	payDate TIMESTAMP NOT NULL,
	PRIMARY KEY (payID),
	KEY userID_pay_idx (userID),
	CONSTRAINT userID_pay FOREIGN KEY (userID) REFERENCES userTBL (userID)
);

CREATE TABLE wishTBL (
	wishID VARCHAR(15) NOT NULL,
	userID VARCHAR(10) NOT NULL,
	prodID VARCHAR(10) NOT NULL,
	wishDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (wishID),
	KEY userID_wish_idx (userID),
	KEY prodID_wish_idx (prodID),
    CONSTRAINT userID_wish FOREIGN KEY (userID) REFERENCES userTBL (userID),
	CONSTRAINT prodID_wish FOREIGN KEY (prodID) REFERENCES prodTBL (prodID)
);

CREATE TABLE cartTBL (
	cartID VARCHAR(15) NOT NULL,
	userID VARCHAR(10) NOT NULL,
	prodID VARCHAR(10) NOT NULL,
	cartStock INT NOT NULL DEFAULT '1',
	cartDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (cartID),
	KEY userID_cart_idx (userID),
	KEY prodID_cart_idx (prodID),
	CONSTRAINT userID_cart FOREIGN KEY (userID) REFERENCES userTBL (userID),
	CONSTRAINT prodID_cart FOREIGN KEY (prodID) REFERENCES prodTBL (prodID)
);

CREATE TABLE reviewTBL (
	reviewID VARCHAR(15) NOT NULL,
	prodID VARCHAR(10) NOT NULL,
	userID VARCHAR(10) NOT NULL,
	orderID VARCHAR(15) NOT NULL,
	orderStock INT NOT NULL,
	ratingScore INT NOT NULL,
	reviewContent TEXT NOT NULL,
	reviewDate TIMESTAMP NOT NULL,
	PRIMARY KEY (reviewID),
	KEY prodID_review_idx (prodID),
	KEY userID_review_idx (userID),
	KEY orderID_review (orderID),
	CONSTRAINT prodID_review FOREIGN KEY (prodID) REFERENCES prodTBL (prodID),
	CONSTRAINT userID_review FOREIGN KEY (userID) REFERENCES userTBL (userID),
	CONSTRAINT orderID_review FOREIGN KEY (orderID) REFERENCES orderTBL (orderID)
);

CREATE TABLE eventTBL (
	eventID VARCHAR(5) NOT NULL,
	eventName VARCHAR(25) NOT NULL,
	eventImg VARCHAR(50) NOT NULL,
	eventInfo VARCHAR(50) NOT NULL,
	eventStart DATE DEFAULT NULL,
	eventEnd DATE DEFAULT NULL,
	prizeImg VARCHAR(50) DEFAULT NULL,
	prizeDate DATE DEFAULT NULL,
	prizeList TEXT,
	PRIMARY KEY (eventID)
);

CREATE TABLE askTBL (
	askID VARCHAR(15) NOT NULL,
	userID VARCHAR(10) NOT NULL,
	askCtg VARCHAR(15) NOT NULL,
	askName VARCHAR(20) NOT NULL,
	askContent TEXT NOT NULL,
	agreeEmail VARCHAR(3) NOT NULL,
	askStatus VARCHAR(10) NOT NULL,
	askDate TIMESTAMP NOT NULL,
	answer TEXT,
	answerDate TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY (askID),
	KEY userName_ask_idx (userID),
	CONSTRAINT userName_ask FOREIGN KEY (userID) REFERENCES userTBL (userID)
);

/*
-- userTBL recode
*/
INSERT INTO userTBL (userID, userPassword, userName, userGender, userPhone, userEmail, agreeEmail, userAdress, userBirth, userType, userPoint, userDate) VALUES ('puresh', '1234', '퓨레시', '비공개', '000-0000-0000', 'puresh@puresh.com', 'NO', '남서울대학교 멀티미디어학과', NULL, NULL, 1560, '2021-03-02 00:00:00');
INSERT INTO userTBL (userID, userPassword, userName, userGender, userPhone, userEmail, agreeEmail, userAdress, userBirth, userType, userPoint, userDate) VALUES ('algus1454', '1234', '김미현', '여자', '010-9123-4112', 'algus1454@gmail.com', 'YES', '경기도 고양시 일산동구 장항동', NULL, NULL, 23000, '2023-03-14 17:40:37');
INSERT INTO userTBL (userID, userPassword, userName, userGender, userPhone, userEmail, agreeEmail, userAdress, userBirth, userType, userPoint, userDate) VALUES ('ckdtjr6869', '1234', '김창섭', '남자', '010-6468-1286', 'ckdtjq6869@gmail.com', 'YES', '울산광역시 남구 신정동', NULL, NULL, 1970, '2023-03-14 17:39:52');
INSERT INTO userTBL (userID, userPassword, userName, userGender, userPhone, userEmail, agreeEmail, userAdress, userBirth, userType, userPoint, userDate) VALUES ('ehdgus0817', '1234', '이동현', '남자', '010-3623-5432', 'ehdgus0817@naver.com', 'YES', '경기도 성남시 분당구 정자동', NULL, NULL, 5780, '2023-03-14 17:39:52');
INSERT INTO userTBL (userID, userPassword, userName, userGender, userPhone, userEmail, agreeEmail, userAdress, userBirth, userType, userPoint, userDate) VALUES ('gkdus0829', '1234', '김하연', '여자', '010-7685-7421', 'gkdus0829@naver.com', 'NO', '경기도 수원시 팔달구 인계동', NULL, NULL, 980, '2023-03-14 17:40:37');
INSERT INTO userTBL (userID, userPassword, userName, userGender, userPhone, userEmail, agreeEmail, userAdress, userBirth, userType, userPoint, userDate) VALUES ('gPwls6656', '1234', '정혜진', '여자', '010-1286-7523', 'gPwls6656@naver.com', 'NO', '대전광역시 유성구 봉명동', NULL, NULL, 2300, '2023-03-14 17:40:37');
INSERT INTO userTBL (userID, userPassword, userName, userGender, userPhone, userEmail, agreeEmail, userAdress, userBirth, userType, userPoint, userDate) VALUES ('gurtn3938', '1234', '최혁수', '남자', '010-3498-5212', 'gurtn3938@naverl.com', 'YES', '대전광역시 서구 둔산동', NULL, NULL, 30, '2023-03-14 17:40:37');
INSERT INTO userTBL (userID, userPassword, userName, userGender, userPhone, userEmail, agreeEmail, userAdress, userBirth, userType, userPoint, userDate) VALUES ('gustlr3519', 'gustlrwkd123', '변현식', '남자', '010-5687-2341', 'gustlr3519@gmail.com', 'NO', '서울특별시 송파구 잠실동', NULL, NULL, 1000, '2023-03-14 17:39:52');
INSERT INTO userTBL (userID, userPassword, userName, userGender, userPhone, userEmail, agreeEmail, userAdress, userBirth, userType, userPoint, userDate) VALUES ('rkdms0087', '1234', '이가은', '여자', '010-5671-8234', 'rkdms0087@naver.com', 'YES', '서울특별시 강서구 화곡동', NULL, NULL, 8005, '2023-03-14 17:40:37');
INSERT INTO userTBL (userID, userPassword, userName, userGender, userPhone, userEmail, agreeEmail, userAdress, userBirth, userType, userPoint, userDate) VALUES ('tldms0604', '1234', '장시은', '남자', '010-9435-8435', 'tldms0604@gmail.com', 'NO', '서울특별시 강남구 역삼동', NULL, NULL, 400, '2023-03-14 17:40:37');
INSERT INTO userTBL (userID, userPassword, userName, userGender, userPhone, userEmail, agreeEmail, userAdress, userBirth, userType, userPoint, userDate) VALUES ('tndus5521', '1234', '박수연', '여자', '010-7896-2352', 'tndus5521@gmail.com', 'YES', '부산광역시 해운대구 우동', NULL, NULL, 320, '2023-03-14 17:40:37');
INSERT INTO userTBL (userID, userPassword, userName, userGender, userPhone, userEmail, agreeEmail, userAdress, userBirth, userType, userPoint, userDate) VALUES ('tnwl8877', '1234', '최수지', '여자', '010-9789-2345', 'tnwl8877@gmail.com', 'YES', '대구광역시 중구 동인동', NULL, NULL, 20, '2023-03-14 17:40:37');
INSERT INTO userTBL (userID, userPassword, userName, userGender, userPhone, userEmail, agreeEmail, userAdress, userBirth, userType, userPoint, userDate) VALUES ('wldms3535', '1234', '최지은', '여자', '010-6781-8231', 'wldms3535@gamil.com', 'NO', '인천광역시 연수구 송도동', NULL, NULL, 600, '2023-03-14 17:40:37');
INSERT INTO userTBL (userID, userPassword, userName, userGender, userPhone, userEmail, agreeEmail, userAdress, userBirth, userType, userPoint, userDate) VALUES ('wldus6433', '1234', '김지연', '여자', '010-4647-9891', 'wldus6433@gmail.com', 'NO', '인천광역시 남동구 만수동', NULL, NULL, 0, '2023-03-14 17:40:37');
INSERT INTO userTBL (userID, userPassword, userName, userGender, userPhone, userEmail, agreeEmail, userAdress, userBirth, userType, userPoint, userDate) VALUES ('wlgP7858', '1234', '홍지혜', '여자', '010-1789-4123', 'wlgP7858@gmail.com', 'YES', '부산광역시 서구 암남동', NULL, NULL, 2340, '2023-03-14 17:40:37');
INSERT INTO userTBL (userID, userPassword, userName, userGender, userPhone, userEmail, agreeEmail, userAdress, userBirth, userType, userPoint, userDate) VALUES ('wngur9844', '1234', '김주혁', '남자', '010-3467-1245', 'wngur9844@gmail.com', 'YES', '광주광역시 북구 중흥동', NULL, NULL, 150, '2023-03-14 17:40:37');
INSERT INTO userTBL (userID, userPassword, userName, userGender, userPhone, userEmail, agreeEmail, userAdress, userBirth, userType, userPoint, userDate) VALUES ('test', '1234', '테스트유저', '비공개', '010-0123-4567', 'test@nsu.ac.kk', 'YES', '남서울대학교', NULL, '블루베리 타입', 44594, '2023-03-27 01:31:32');

/*
-- prodTBL recode
*/
INSERT INTO prodTBL (prodID, prodName, prodPrice, prodStock, prodCtg, prodType, prodVolume, prodImg, prodInfo, prodStatus, prodDate, prodEvent) VALUES ('PCA001', '아보카도 크림', 12900, 3, '크림', '지성', 50, 'images/prodImg/PCA001.jpg', 'images/prodImg/PCA001_info.png', '판매중', '2023-02-23 00:00:00', NULL);
INSERT INTO prodTBL (prodID, prodName, prodPrice, prodStock, prodCtg, prodType, prodVolume, prodImg, prodInfo, prodStatus, prodDate, prodEvent) VALUES ('PCB001', '블루베리 크림', 23800, 225, '크림', '수부지', 50, 'images/prodImg/PCB001.jpg', 'images/prodImg/PCB001_info.png', '판매중', '2023-01-29 00:00:00', NULL);
INSERT INTO prodTBL (prodID, prodName, prodPrice, prodStock, prodCtg, prodType, prodVolume, prodImg, prodInfo, prodStatus, prodDate, prodEvent) VALUES ('PCM001', '망고 크림', 34500, 0, '크림', '복합', 50, 'images/prodImg/PCM001.jpg', 'images/prodImg/PCM001_info.png', '품절', '2023-03-11 00:00:00', NULL);
INSERT INTO prodTBL (prodID, prodName, prodPrice, prodStock, prodCtg, prodType, prodVolume, prodImg, prodInfo, prodStatus, prodDate, prodEvent) VALUES ('PCW001', '수박 크림', 32000, 20, '크림', '건성', 50, 'images/prodImg/PCW001.png', 'images/prodImg/PCW001_info.png', '판매중', '2023-03-13 00:00:00', 'New Watermelon');
INSERT INTO prodTBL (prodID, prodName, prodPrice, prodStock, prodCtg, prodType, prodVolume, prodImg, prodInfo, prodStatus, prodDate, prodEvent) VALUES ('PLA001', '아보카도 로션', 59000, 112, '로션', '지성', 100, 'images/prodImg/PLA001.jpg', 'images/prodImg/PLA001_info.png', '판매중', '2023-02-23 00:00:00', NULL);
INSERT INTO prodTBL (prodID, prodName, prodPrice, prodStock, prodCtg, prodType, prodVolume, prodImg, prodInfo, prodStatus, prodDate, prodEvent) VALUES ('PLB001', '블루베리 로션', 24300, 452, '로션', '수부지', 100, 'images/prodImg/PLB001.jpg', 'images/prodImg/PLB001_info.png', '판매중', '2023-01-29 00:00:00', NULL);
INSERT INTO prodTBL (prodID, prodName, prodPrice, prodStock, prodCtg, prodType, prodVolume, prodImg, prodInfo, prodStatus, prodDate, prodEvent) VALUES ('PLM001', '망고 로션', 13900, 28, '로션', '복합', 100, 'images/prodImg/PLM001.jpg', 'images/prodImg/PLM001_info.png', '판매중', '2023-03-11 00:00:00', NULL);
INSERT INTO prodTBL (prodID, prodName, prodPrice, prodStock, prodCtg, prodType, prodVolume, prodImg, prodInfo, prodStatus, prodDate, prodEvent) VALUES ('PLW001', '수박 로션', 21000, 254, '로션', '건성', 100, 'images/prodImg/PLW001.png', 'images/prodImg/PLW001_info.png', '판매중', '2023-03-13 00:00:00', 'New Watermelon');
INSERT INTO prodTBL (prodID, prodName, prodPrice, prodStock, prodCtg, prodType, prodVolume, prodImg, prodInfo, prodStatus, prodDate, prodEvent) VALUES ('PSA001', '아보카도 세럼', 14000, 337, '세럼', '지성', 75, 'images/prodImg/PSA001.jpg', 'images/prodImg/PSA001_info.png', '판매중', '2023-02-23 00:00:00', NULL);
INSERT INTO prodTBL (prodID, prodName, prodPrice, prodStock, prodCtg, prodType, prodVolume, prodImg, prodInfo, prodStatus, prodDate, prodEvent) VALUES ('PSB001', '블루베리 세럼', 46000, 145, '세럼', '수부지', 75, 'images/prodImg/PSB001.jpg', 'images/prodImg/PSB001_info.png', '판매중', '2023-01-29 00:00:00', NULL);
INSERT INTO prodTBL (prodID, prodName, prodPrice, prodStock, prodCtg, prodType, prodVolume, prodImg, prodInfo, prodStatus, prodDate, prodEvent) VALUES ('PSM001', '망고 세럼', 12400, 238, '세럼', '복합', 75, 'images/prodImg/PSM001.jpg', 'images/prodImg/PSM001_info.png', '판매중', '2023-03-11 00:00:00', NULL);
INSERT INTO prodTBL (prodID, prodName, prodPrice, prodStock, prodCtg, prodType, prodVolume, prodImg, prodInfo, prodStatus, prodDate, prodEvent) VALUES ('PSW001', '수박 세럼', 53000, 30, '세럼', '건성', 75, 'images/prodImg/PSW001.png', 'images/prodImg/PSW001_info.png', '판매중', '2023-03-13 00:00:00', 'New Watermelon');
INSERT INTO prodTBL (prodID, prodName, prodPrice, prodStock, prodCtg, prodType, prodVolume, prodImg, prodInfo, prodStatus, prodDate, prodEvent) VALUES ('PTA001', '아보카도 토너', 23900, 0, '토너', '지성', 125, 'images/prodImg/PTA001.jpg', 'images/prodImg/PTA001_info.png', '품절', '2023-02-23 00:00:00', NULL);
INSERT INTO prodTBL (prodID, prodName, prodPrice, prodStock, prodCtg, prodType, prodVolume, prodImg, prodInfo, prodStatus, prodDate, prodEvent) VALUES ('PTB001', '블루베리 토너', 32400, 75, '토너', '수부지', 125, 'images/prodImg/PTB001.jpg', 'images/prodImg/PTB001_info.png', '판매중', '2023-01-29 00:00:00', NULL);
INSERT INTO prodTBL (prodID, prodName, prodPrice, prodStock, prodCtg, prodType, prodVolume, prodImg, prodInfo, prodStatus, prodDate, prodEvent) VALUES ('PTM001', '망고 토너', 38000, 0, '토너', '복합', 125, 'images/prodImg/PTM001.jpg', 'images/prodImg/PTM001_info.png', '재입고 예정', '2023-03-11 00:00:00', NULL);
INSERT INTO prodTBL (prodID, prodName, prodPrice, prodStock, prodCtg, prodType, prodVolume, prodImg, prodInfo, prodStatus, prodDate, prodEvent) VALUES ('PTW001', '수박 토너', 19800, 922, '토너', '건성', 125, 'images/prodImg/PTW001.png', 'images/prodImg/PTW001_info.png', '판매중', '2023-03-13 00:00:00', 'New Watermelon');

/*
-- orderTBL recode
*/
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20231220A001', 'wlgP7858', 'PTB001', 'P20231220A', 32400, 1, 32400, '구매 확정', NULL, '2023-12-20 00:00:00', '2024-01-01 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20231220A002', 'tnwl8877', 'PTB001', 'P20231220A', 32400, 3, 97200, '구매 확정', NULL, '2023-12-20 03:02:39', '2024-02-10 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20231226A001', 'wlgP7858', 'PSM001', 'P20231226A', 12400, 1, 12400, '구매 확정', NULL, '2023-12-26 00:00:00', '2024-01-08 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20231229A001', 'wngur9844', 'PSM001', 'P20231229A', 12400, 4, 49600, '구매 확정', NULL, '2023-12-29 00:00:00', '2024-01-10 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20231230A001', 'wldms3535', 'PSM001', 'P20231230A', 12400, 1, 12400, '구매 확정', NULL, '2023-12-30 00:00:00', '2024-01-05 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20231231A001', 'gustlr3519', 'PTM001', 'P20231231A', 38000, 2, 76000, '구매 확정', NULL, '2023-12-31 00:00:00', '2024-01-10 03:59:03');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240101A001', 'ehdgus0817', 'PTA001', 'P20240101A', 23900, 1, 23900, '구매 확정', NULL, '2024-01-01 00:00:00', '2024-01-31 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240103A001', 'tnwl8877', 'PSA001', 'P20240103A', 14000, 2, 28000, '구매 확정', NULL, '2024-01-03 00:00:00', '2024-01-13 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240103A002', 'algus1454', 'PSB001', 'P20240103A', 46000, 1, 46000, '구매 확정', NULL, '2024-01-03 19:39:29', '2024-01-20 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240117A001', 'algus1454', 'PTA001', 'P20240113A', 23900, 4, 95600, '구매 확정', NULL, '2024-01-17 00:00:00', '2024-02-09 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240117A002', 'gurtn3938', 'PTM001', 'P20240113A', 38000, 4, 152000, '구매 확정', NULL, '2024-01-17 23:48:32', '2024-03-10 23:30:47');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240129A001', 'tndus5521', 'PLW001', 'P20240129A', 21000, 1, 21000, '구매 확정', NULL, '2024-01-29 00:00:00', '2024-02-11 10:30:40');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240129A002', 'tndus5521', 'PSW001', 'P20240129A', 53000, 3, 159000, '구매 확정', NULL, '2024-01-29 00:00:00', '2024-02-05 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240131A001', 'rkdms0087', 'PLW001', 'P20240131A', 21000, 2, 42000, '구매 확정', NULL, '2024-01-31 00:00:00', '2024-03-07 03:39:18');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240131A002', 'wldms3535', 'PTB001', 'P20240131A', 32400, 3, 97200, '구매 확정', NULL, '2024-01-31 08:03:30', '2024-02-09 20:40:39');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240202A001', 'wngur9844', 'PCW001', 'P20240202A', 32000, 3, 96000, '구매 확정', NULL, '2024-02-02 00:00:00', '2024-03-07 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240202A002', 'algus1454', 'PLM001', 'P20240202A', 13900, 2, 27800, '구매 확정', NULL, '2024-02-02 15:39:58', '2024-02-11 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240203A001', 'gurtn3938', 'PLW001', 'P20240203A', 21000, 3, 63000, '구매 확정', NULL, '2024-02-03 00:00:00', '2024-02-07 19:39:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240203A002', 'gurtn3938', 'PSW001', 'P20240203A', 53000, 1, 53000, '구매 확정', NULL, '2024-02-03 00:00:00', '2024-02-29 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240203A003', 'gustlr3519', 'PLW001', 'P20240203A', 21000, 4, 84000, '구매 확정', NULL, '2024-02-03 12:56:19', '2024-02-14 09:03:38');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240204A001', 'ckdtjr6869', 'PLM001', 'P20240204A', 13900, 1, 13900, '구매 확정', NULL, '2024-02-04 00:00:00', '2024-02-07 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240204A002', 'ckdtjr6869', 'PSB001', 'P20240204A', 46000, 1, 46000, '구매 확정', NULL, '2024-02-04 00:00:00', '2024-03-11 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240207A001', 'ehdgus0817', 'PLM001', 'P20240207A', 13900, 1, 13900, '구매 확정', NULL, '2024-02-07 00:00:00', '2024-02-08 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240208A001', 'gkdus0829', 'PLM001', 'P20240208A', 13900, 2, 27800, '구매 확정', NULL, '2024-02-08 00:00:00', '2024-02-14 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240208A002', 'gkdus0829', 'PTA001', 'P20240208A', 23900, 2, 47800, '구매 확정', NULL, '2024-02-08 00:00:00', '2024-02-21 10:40:19');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240211A001', 'gPwls6656', 'PLM001', 'P20240211A', 13900, 1, 13900, '구매 확정', NULL, '2024-02-11 00:00:00', '2024-02-21 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240211A002', 'rkdms0087', 'PSW001', 'P20240211A', 53000, 1, 53000, '구매 확정', NULL, '2024-02-11 14:05:39', '2024-03-11 16:40:36');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240214A001', 'algus1454', 'PCA001', 'P20240214A', 12900, 3, 38700, '구매 확정', NULL, '2024-02-14 00:00:00', '2024-03-10 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240229A001', 'wldms3535', 'PCM001', 'P20240229A', 34500, 1, 34500, '구매 확정', NULL, '2024-02-29 00:00:00', '2024-04-01 19:34:59');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240301A001', 'tldms0604', 'PLW001', 'P20240301A', 21000, 1, 21000, '구매 확정', NULL, '2024-03-01 00:00:00', '2024-03-13 01:00:03');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240301A002', 'tnwl8877', 'PCW001', 'P20240301A', 32000, 4, 128000, '구매 확정', NULL, '2024-03-01 13:54:17', '2024-04-13 20:30:28');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240301A003', 'tnwl8877', 'PCM001', 'P20240301A', 34500, 2, 69000, '구매 확정', NULL, '2024-03-01 13:54:17', '2024-04-13 19:40:39');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240302A001', 'wldms3535', 'PSA001', 'P20240302A', 14000, 1, 14000, '구매 확정', NULL, '2024-03-02 00:00:00', '2024-03-07 09:39:03');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240302A002', 'wngur9844', 'PCM001', 'P20240302A', 34500, 2, 69000, '구매 확정', NULL, '2024-03-02 08:38:39', '2024-03-13 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240302A003', 'wngur9844', 'PSA001', 'P20240302A', 14000, 3, 42000, '구매 확정', NULL, '2024-03-02 08:38:39', '2024-04-17 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240303A001', 'gustlr3519', 'PSW001', 'P20240303A', 53000, 1, 53000, '구매 확정', NULL, '2024-03-03 00:00:00', '2024-04-11 21:39:33');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240307A001', 'wngur9844', 'PTB001', 'P20240307A', 32400, 3, 97200, '구매 확정', NULL, '2024-03-07 00:00:00', '2024-04-14 00:03:03');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240310A001', 'gustlr3519', 'PCB001', 'P20240310A', 23800, 3, 71400, '구매 확정', NULL, '2024-03-10 00:00:00', '2024-03-27 09:03:49');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240310A002', 'gustlr3519', 'PLA001', 'P20240310A', 59000, 2, 118000, '구매 확정', NULL, '2024-03-10 00:00:00', '2024-03-29 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240310A003', 'gkdus0829', 'PCA001', 'P20240310A', 12900, 3, 38700, '구매 확정', NULL, '2024-03-10 02:40:17', '2024-04-10 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240312A001', 'ckdtjr6869', 'PCA001', 'P20240312A', 12900, 5, 64500, '구매 확정', NULL, '2024-03-12 00:00:00', '2024-03-27 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240312A002', 'ckdtjr6869', 'PLB001', 'P20240312A', 24300, 2, 48600, '구매 확정', NULL, '2024-03-12 00:00:00', '2024-03-28 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240314A001', 'gPwls6656', 'PTA001', 'P20240314A', 23900, 2, 47800, '구매 확정', NULL, '2024-03-14 00:00:00', '2024-03-28 04:05:30');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240315A001', 'rkdms0087', 'PCB001', 'P20240315A', 23800, 1, 23800, '구매 확정', NULL, '2024-03-15 00:00:00', '2024-03-27 23:34:29');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240320A001', 'gurtn3938', 'PCB001', 'P20240320A', 23800, 4, 95200, '구매 확정', NULL, '2024-03-20 00:00:00', '2024-04-01 14:39:39');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240320A002', 'gurtn3938', 'PLA001', 'P20240320A', 59000, 4, 236000, '구매 확정', NULL, '2024-03-20 00:00:00', '2024-04-07 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240321A001', 'gPwls6656', 'PCA001', 'P20240321A', 12900, 1, 12900, '구매 확정', NULL, '2024-03-21 00:00:00', '2024-04-10 13:58:09');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240321A002', 'gPwls6656', 'PLB001', 'P20240321A', 24300, 2, 48600, '구매 확정', NULL, '2024-03-21 00:00:00', '2024-04-10 13:45:29');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240323A001', 'ehdgus0817', 'PCA001', 'P20240323A', 12900, 2, 25800, '구매 확정', NULL, '2024-03-23 00:00:00', '2024-04-01 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240324A001', 'wldms3535', 'PCW001', 'P20240324A', 32000, 3, 96000, '구매 확정', NULL, '2024-03-24 00:00:00', '2024-04-01 19:49:39');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240324A002', 'wldus6433', 'PSA001', 'P20240324A', 14000, 3, 42000, '구매 확정', NULL, '2024-03-24 16:49:03', '2024-04-07 04:43:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240326A001', 'ehdgus0817', 'PLB001', 'P20240326A', 24300, 1, 24300, '구매 확정', NULL, '2024-03-26 00:00:00', '2024-04-04 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240326A002', 'ehdgus0817', 'PSB001', 'P20240326A', 46000, 2, 92000, '구매 확정', NULL, '2024-03-26 00:00:00', '2024-04-12 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240327A001', 'tndus5521', 'PTM001', 'P20240327A', 38000, 3, 114000, '구매 확정', NULL, '2024-03-27 00:00:00', '2024-04-07 14:30:40');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240403A001', 'wldus6433', 'PCM001', 'P20240403A', 34500, 1, 34500, '구매 확정', NULL, '2024-04-03 00:00:00', '2024-04-13 20:23:29');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240403A002', 'wldus6433', 'PCW001', 'P20240403A', 32000, 3, 96000, '구매 확정', NULL, '2024-04-03 00:00:00', '2024-04-13 22:29:12');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240403A003', 'wlgP7858', 'PCM001', 'P20240403A', 34500, 2, 69000, '구매 확정', NULL, '2024-04-03 00:00:00', '2024-04-11 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240404A001', 'wlgP7858', 'PCW001', 'P20240404A', 32000, 1, 32000, '구매 확정', NULL, '2024-04-04 00:00:00', '2024-04-11 00:04:03');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240407A001', 'tldms0604', 'PCB001', 'P20240407A', 23800, 3, 71400, '구매 확정', NULL, '2024-04-07 00:00:00', '2024-04-13 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240407A002', 'tldms0604', 'PLA001', 'P20240407A', 59000, 3, 177000, '구매 확정', NULL, '2024-04-07 00:00:00', '2024-04-14 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240409A001', 'tndus5521', 'PCB001', 'P20240409A', 23800, 2, 47600, '구매 확정', NULL, '2024-04-09 00:00:00', '2024-04-15 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240409A002', 'tndus5521', 'PLA001', 'P20240409A', 59000, 5, 413000, '구매 확정', NULL, '2024-04-09 00:00:00', '2024-04-15 00:20:03');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240411A001', 'gkdus0829', 'PLB001', 'P20240411A', 24300, 3, 72900, '구매 확정', NULL, '2024-04-11 00:00:00', '2024-04-23 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240411A002', 'tldms0604', 'PTM001', 'P20240411A', 38000, 2, 76000, '구매 확정', NULL, '2024-04-11 06:16:40', '2024-04-28 07:30:03');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240415A001', 'gkdus0829', 'PSB001', 'P20240415A', 46000, 3, 138000, '구매 확정', NULL, '2024-04-15 00:00:00', '2024-04-23 04:03:39');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240417A001', 'gPwls6656', 'PSB001', 'P20240417A', 46000, 2, 92000, '구매 확정', NULL, '2024-04-17 00:00:00', '2024-04-30 14:03:23');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240418A001', 'algus1454', 'PLB001', 'P20240418A', 24300, 2, 48600, '구매 확정', NULL, '2024-04-18 00:00:00', '2024-04-29 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240418A002', 'tldms0604', 'PSW001', 'P20240418A', 53000, 2, 106000, '구매 확정', NULL, '2024-04-18 23:29:00', '2024-05-01 09:30:50');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240419A001', 'tnwl8877', 'PSM001', 'P20240419A', 12400, 1, 12400, '구매 확정', NULL, '2024-04-19 00:00:00', '2024-04-28 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240420A001', 'wldus6433', 'PSM001', 'P20240420A', 12400, 1, 12400, '구매 확정', NULL, '2024-04-20 00:00:00', '2024-05-01 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240423A001', 'rkdms0087', 'PLA001', 'P20240423A', 59000, 1, 59000, '구매 확정', NULL, '2024-04-23 00:00:00', '2024-04-30 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240423A002', 'wlgP7858', 'PSA001', 'P20240423A', 14000, 1, 14000, '구매 확정', NULL, '2024-04-23 23:24:27', '2024-04-29 13:30:40');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240425A001', 'ckdtjr6869', 'PTA001', 'P20240425A', 23900, 1, 23900, '구매 확정', NULL, '2024-04-25 00:00:00', '2024-05-05 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240425A002', 'wldus6433', 'PTB001', 'P20240425A', 32400, 1, 32400, '구매 확정', NULL, '2024-04-25 22:30:54', '2024-05-06 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240430A001', 'rkdms0087', 'PTM001', 'P20240430A', 38000, 2, 76000, '구매 확정', NULL, '2024-04-30 00:00:00', '2024-05-03 00:00:00');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240603A001', 'test', 'PLA001', 'P20240603A', 59000, 2, 118000, '주문 취소', NULL, '2024-06-03 21:30:18', NULL);
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240603A002', 'test', 'PTW001', 'P20240603B', 19800, 3, 59400, '리뷰 완료', '584300200542', '2024-06-03 21:31:20', '2024-06-03 21:35:27');
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240603A003', 'test', 'PSM001', 'P20240603C', 12400, 2, 24800, '배송 중', '584300200542', '2024-06-03 21:39:32', NULL);
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240603A004', 'test', 'PTB001', 'P20240603D', 32400, 1, 32400, '배송 준비 중', '584300200542', '2024-06-03 21:42:48', NULL);
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240603A005', 'test', 'PLA001', 'P20240603D', 59000, 4, 236000, '배송 준비 중', NULL, '2024-06-03 21:42:48', NULL);
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240603A006', 'test', 'PSW001', 'P20240603E', 53000, 2, 106000, '입금 대기', NULL, '2024-06-03 21:52:23', NULL);
INSERT INTO orderTBL (orderID, userID, prodID, orderName, orderPrice, orderStock, orderTotal, orderStatus, deliveryNumber, orderStart, orderEnd) VALUES ('O20240603A007', 'test', 'PSA001', 'P20240603F', 14000, 2, 28000, '입금 대기', NULL, '2024-06-03 21:54:06', NULL);

/*
-- payTBL recode
*/
INSERT INTO payTBL (payID, userID, orderName, orderer, receiver, receiverAddr, receiverPhone, payMethod, methodBank, methodAccount, methodName, methodDate, refundBank, refundAccount, refundName, orderTotal, deliveryCharge, payPoint, payTotal, payDate) VALUES ('P00000000A001', 'puresh', 'P000000A', '퓨레시', '퓨레시', '남서울대학교 멀티미디어학과', '010-0000-0000', '무통장입금', '카카오뱅크', '3333-33333-33333', '퓨레시', NULL, NULL, NULL, NULL, 0, 4000, 0, 0, '2021-03-02 00:00:00');
INSERT INTO payTBL (payID, userID, orderName, orderer, receiver, receiverAddr, receiverPhone, payMethod, methodBank, methodAccount, methodName, methodDate, refundBank, refundAccount, refundName, orderTotal, deliveryCharge, payPoint, payTotal, payDate) VALUES ('P20240603A001', 'test', 'P20240603A', '테스트유저', '테스트유저', '남서울대학교', '010-123-4567', '무통장 입금', 'KB국민은행', '333333-33-333333', '홍길동', NULL, '우리은행', '1111-111-111111', '홍길동', 118000, 0, 0, 118000, '2024-06-03 21:30:18');
INSERT INTO payTBL (payID, userID, orderName, orderer, receiver, receiverAddr, receiverPhone, payMethod, methodBank, methodAccount, methodName, methodDate, refundBank, refundAccount, refundName, orderTotal, deliveryCharge, payPoint, payTotal, payDate) VALUES ('P20240603A002', 'test', 'P20240603B', '테스트유저', '테스트유저', '남서울대학교', '010-123-4567', '무통장 입금', '케이뱅크', '888888-88-888888', '심청', NULL, 'KEB하나은행', '000-000000-00000', '허선생', 59400, 4000, 0, 63400, '2024-06-03 21:31:20');
INSERT INTO payTBL (payID, userID, orderName, orderer, receiver, receiverAddr, receiverPhone, payMethod, methodBank, methodAccount, methodName, methodDate, refundBank, refundAccount, refundName, orderTotal, deliveryCharge, payPoint, payTotal, payDate) VALUES ('P20240603A003', 'test', 'P20240603C', '테스트유저', '김삿갓', '강원도 영월군 김삿갓면 와석리', '010-123-4567', '카카오페이 송금', NULL, NULL, '김삿갓1807', '2024-06-03', '신한은행', '777-777-777777', '김병연', 24800, 4000, 200, 28600, '2024-06-03 21:39:32');
INSERT INTO payTBL (payID, userID, orderName, orderer, receiver, receiverAddr, receiverPhone, payMethod, methodBank, methodAccount, methodName, methodDate, refundBank, refundAccount, refundName, orderTotal, deliveryCharge, payPoint, payTotal, payDate) VALUES ('P20240603A004', 'test', 'P20240603D', '테스트유저', '박씨부인', '남서울대학교', '010-123-4567', '무통장 입금', 'NH농협', '666-6666-6666-null', '박씨', NULL, '토스뱅크', '0000-0000-0000', '박씨네계모임', 268400, 0, 1000, 267400, '2024-06-03 21:42:48');
INSERT INTO payTBL (payID, userID, orderName, orderer, receiver, receiverAddr, receiverPhone, payMethod, methodBank, methodAccount, methodName, methodDate, refundBank, refundAccount, refundName, orderTotal, deliveryCharge, payPoint, payTotal, payDate) VALUES ('P20240603A005', 'test', 'P20240603E', '테스트유저', '무통장입금확인용', '남서울대학교', '010-123-4567', '무통장 입금', 'KB국민은행', '222222-22-222222', '송금정보를확인하세요', NULL, 'KB국민은행', '111111-99-992222', '입금완료알림을눌러보세요', 106000, 0, 10000, 96000, '2024-06-03 21:52:23');
INSERT INTO payTBL (payID, userID, orderName, orderer, receiver, receiverAddr, receiverPhone, payMethod, methodBank, methodAccount, methodName, methodDate, refundBank, refundAccount, refundName, orderTotal, deliveryCharge, payPoint, payTotal, payDate) VALUES ('P20240603A006', 'test', 'P20240603F', '테스트유저', '카카오송금확인용', '남서울대학교', '010-123-4567', '카카오페이 송금', NULL, NULL, '송금코드를확인하세요', '2024-06-05', '카카오뱅크', '2822-83-8293333', '주문취소시포인트반환', 28000, 4000, 3394, 28606, '2024-06-03 21:54:06');

/*
-- wishTBL recode
*/
INSERT INTO wishTBL (wishID, userID, prodID, wishDate) VALUES ('W00000000A001', 'puresh', 'PLW001', '2021-03-02 00:00:00');
INSERT INTO wishTBL (wishID, userID, prodID, wishDate) VALUES ('W20240331A001', 'test', 'PCA001', '2024-03-31 03:50:50');
INSERT INTO wishTBL (wishID, userID, prodID, wishDate) VALUES ('W20240331A002', 'test', 'PTM001', '2024-03-31 03:50:52');
INSERT INTO wishTBL (wishID, userID, prodID, wishDate) VALUES ('W20240331A005', 'test', 'PCW001', '2024-03-31 04:22:57');

/*
-- cartTBL recode
*/
INSERT INTO cartTBL (cartID, userID, prodID, cartStock, cartDate) VALUES ('C00000000A001', 'puresh', 'PCA001', 1, '2021-03-02 00:00:00');
INSERT INTO cartTBL (cartID, userID, prodID, cartStock, cartDate) VALUES ('C20240529A001', 'test', 'PSM001', 2, '2024-05-29 13:15:55');
INSERT INTO cartTBL (cartID, userID, prodID, cartStock, cartDate) VALUES ('C20240529A002', 'test', 'PLA001', 4, '2024-05-29 13:32:29');
INSERT INTO cartTBL (cartID, userID, prodID, cartStock, cartDate) VALUES ('C20240602A001', 'test', 'PCW001', 1, '2024-06-02 21:26:14');

/*
-- reviewTBL recode
*/
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240101A001', 'PTB001', 'wlgP7858', 'O20231220A001', 1, 3, '너무 끈적이고 향이 너무 강해요.', '2024-01-01 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240105A001', 'PSM001', 'wldms3535', 'O20231230A001', 1, 3, '그냥저냥 쓸만한거 같아요.', '2024-01-05 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240108A001', 'PSM001', 'wlgP7858', 'O20231226A001', 1, 3, '친구추천으로 구매했는데 제 피부타입하고는 안맞는거 같아요.', '2024-01-08 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240110A001', 'PSM001', 'wngur9844', 'O20231229A001', 1, 4, '향이 살짝 강했지만 괜찮았어요.', '2024-01-10 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240110A002', 'PTM001', 'gustlr3519', 'O20231231A001', 2, 5, '끈적이지도 않고 너무 좋습니다.', '2024-01-10 03:59:03');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240113A001', 'PSA001', 'tnwl8877', 'O20240103A001', 2, 4, '친구가 엄청 좋았다고 또 사달래요.', '2024-01-13 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240120A001', 'PSB001', 'algus1454', 'O20240103A002', 1, 4, '포장도 깔끔하고 제품도 괜찮습니다.', '2024-01-20 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240131A001', 'PTA001', 'ehdgus0817', 'O20240101A001', 1, 4, '만족스러웠습니다. 다음에 또 구매할게요.', '2024-01-31 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240205A001', 'PSW001', 'tndus5521', 'O20240129A002', 3, 2, '트러블도 생기고 향도 별로였어요.', '2024-02-05 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240207A001', 'PLM001', 'ckdtjr6869', 'O20240204A001', 1, 5, '피부톤이 밝아지는거 같아서 좋아요.', '2024-02-07 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240207A002', 'PLW001', 'gurtn3938', 'O20240203A001', 3, 4, '제품이 피부에 잘 흡수되고 촉촉함이 오래갑니다.', '2024-02-07 19:39:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240208A001', 'PLM001', 'ehdgus0817', 'O20240207A001', 1, 4, '조금 끈적거리지만 다른 부분은 다 괜찮아요.', '2024-02-08 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240209A001', 'PSB001', 'algus1454', 'O20240117A001', 4, 4, '제가 좋아하는 향이에요.', '2024-02-09 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240209A002', 'PTB001', 'wldms3535', 'O20240131A002', 3, 4, '제 스타일 입니다.', '2024-02-09 20:40:39');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240210A001', 'PTB001', 'tnwl8877', 'O20231220A002', 3, 5, '다음에 또 사야겠어요.', '2024-02-10 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240211A001', 'PLM001', 'algus1454', 'O20240202A002', 2, 5, '트러블이 나지 않아서 좋아요.', '2024-02-11 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240211A002', 'PLW001', 'tndus5521', 'O20240129A001', 1, 3, '가격이 조금 비싼거 같아요.', '2024-02-11 10:30:40');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240214A001', 'PLM001', 'gkdus0829', 'O20240208A001', 2, 4, '포장도 깔끔하고 제품도 괜찮습니다.', '2024-02-14 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240214A002', 'PLW001', 'gustlr3519', 'O20240203A003', 4, 4, '제품은 좋은데 배송이 오래걸려요.', '2024-02-14 09:03:38');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240221A001', 'PLM001', 'gPwls6656', 'O20240211A001', 1, 5, '여자친구가 좋아해요. 어디서 샀냐고 물어봤어요.', '2024-02-21 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240221A002', 'PTA001', 'gkdus0829', 'O20240208A002', 2, 3, '그럭저럭 쓸만했습니다.', '2024-02-21 10:40:19');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240229A001', 'PSW001', 'gurtn3938', 'O20240203A002', 1, 5, '배송이 빠르고 제품이 엄청 괜찮았어요.', '2024-02-29 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240307A001', 'PCW001', 'wngur9844', 'O20240202A001', 3, 5, '정말 잘 사용했어요 다음에 또 구매할게요.', '2024-03-07 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240307A002', 'PLW001', 'rkdms0087', 'O20240131A001', 2, 3, '배송이 너무 오래걸렸어요.', '2024-03-07 03:39:18');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240307A003', 'PSA001', 'wldms3535', 'O20240302A001', 1, 4, '잘 사용하겠습니다.', '2024-03-07 09:39:03');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240310A001', 'PCA001', 'algus1454', 'O20240214A001', 3, 4, '제품이 피부에 잘 흡수되고 촉촉함이 오래갑니다.', '2024-03-10 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240310A002', 'PTM001', 'gurtn3938', 'O20240117A002', 4, 5, '향기가 너무 좋아요.', '2024-03-10 23:30:47');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240311A001', 'PSB001', 'ckdtjr6869', 'O20240204A002', 1, 5, '매번 잘 사용하고있습니다.', '2024-03-11 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240311A002', 'PSW001', 'rkdms0087', 'O20240211A002', 1, 5, '제품 향이 너무 좋아요. 트러블도 안생기고요.', '2024-03-11 16:40:36');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240313A001', 'PCM001', 'wngur9844', 'O20240302A002', 2, 3, '포장이 아쉬웠어요.', '2024-03-13 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240313A002', 'PLW001', 'tldms0604', 'O20240301A001', 1, 3, '제품 양이 조금 적은거 같아요.', '2024-03-13 01:00:03');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240327A001', 'PCA001', 'ckdtjr6869', 'O20240312A001', 5, 5, '향이 좋아서 매일 잘 사용하고 있어요.', '2024-03-27 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240327A002', 'PCB001', 'gustlr3519', 'O20240310A001', 3, 3, '그럭저럭 쓸만한거 같아요.', '2024-03-27 09:03:49');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240327A003', 'PCB001', 'rkdms0087', 'O20240315A001', 1, 4, '피부가 좋아지는게 느껴져요.', '2024-03-27 23:34:29');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240328A001', 'PLB001', 'ckdtjr6869', 'O20240312A002', 2, 5, '가격대비 효과가 아주 좋은 제품이에요.', '2024-03-28 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240328A002', 'PTA001', 'gPwls6656', 'O20240314A001', 2, 4, '피부가 건조해서 이용했는데 효과가 좋아요.', '2024-03-28 04:05:30');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240329A001', 'PLA001', 'gustlr3519', 'O20240310A002', 2, 4, '친구따라서 샀는데 만족스럽습니다.', '2024-03-29 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240401A001', 'PCA001', 'ehdgus0817', 'O20240323A001', 2, 4, '피부가 건조해서 이용했는데 효과가 좋아요.', '2024-04-01 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240401A002', 'PCB001', 'gurtn3938', 'O20240320A001', 4, 4, '친구한테 추천할 정도로 좋았어요.', '2024-04-01 14:39:39');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240401A003', 'PCM001', 'wldms3535', 'O20240229A001', 1, 4, '여자친구가 너무 좋다고 하네요.', '2024-04-01 19:34:59');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240401A004', 'PCW001', 'wldms3535', 'O20240324A001', 3, 5, '다른 제품도 이용해보고 싶어요. 좋아요.', '2024-04-01 19:49:39');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240404A001', 'PLB001', 'ehdgus0817', 'O20240326A001', 1, 5, '향기도 좋고 피부에 잘 스며들어서 좋아요.', '2024-04-04 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240407A001', 'PLA001', 'gurtn3938', 'O20240320A002', 4, 5, '너무 만족스럽게 이용하고 있어요.', '2024-04-07 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240407A002', 'PSA001', 'wldus6433', 'O20240324A002', 3, 5, '너무 잘 산거 같아요. 다음에는 다른 제품도 구매해봐야겠어요.', '2024-04-07 04:43:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240407A003', 'PTM001', 'tndus5521', 'O20240327A001', 3, 5, '피부에 잘 스며들어요.', '2024-04-07 14:30:40');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240410A001', 'PCA001', 'gkdus0829', 'O20240310A003', 3, 5, '너무 만족스럽고 다음에 또 구매할래요.', '2024-04-10 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240410A003', 'PLB001', 'gPwls6656', 'O20240321A002', 2, 5, '지금까지 이용한 제품중에 가장 좋았어요.', '2024-04-10 13:45:29');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240410A004', 'PCA001', 'gPwls6656', 'O20240321A001', 1, 4, '가격이 저렴해서 좋아요.', '2024-04-10 13:58:09');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240411A001', 'PCM001', 'wlgP7858', 'O20240403A003', 2, 4, '향기가 너무 좋아요.', '2024-04-11 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240411A002', 'PCW001', 'wlgP7858', 'O20240404A001', 1, 5, '제품이 너무 만족스러웠습니다.', '2024-04-11 00:04:03');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240411A003', 'PSW001', 'gustlr3519', 'O20240303A001', 1, 4, '피부톤이 밝아지는거 같아서 좋아요.', '2024-04-11 21:39:33');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240412A001', 'PSB001', 'ehdgus0817', 'O20240326A002', 2, 5, '제가 생각한 그대로여서 좋아요.', '2024-04-12 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240413A001', 'PCB001', 'tldms0604', 'O20240407A001', 3, 1, '향이 너무 강하고 끈적거려요.', '2024-04-13 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240413A002', 'PCM001', 'tnwl8877', 'O20240301A003', 2, 5, '촉촉함이 오래가서 좋습니다.', '2024-04-13 19:40:39');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240413A003', 'PCM001', 'wldus6433', 'O20240403A001', 1, 3, '끈적하고 효과가 미미해요.', '2024-04-13 20:23:29');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240413A004', 'PCW001', 'tnwl8877', 'O20240301A002', 4, 4, '조금 끈적이는데 그래도 괜찮아요.', '2024-04-13 20:30:28');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240413A005', 'PCW001', 'wldus6433', 'O20240403A002', 3, 5, '더 많이 살 껄 그랬어요. 또 구매할게요.', '2024-04-13 22:29:12');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240414A001', 'PLA001', 'tldms0604', 'O20240407A002', 3, 4, '제 피부에 잘 맞아서 좋아요.', '2024-04-14 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240414A002', 'PTB001', 'wngur9844', 'O20240307A001', 3, 4, '이 제품으로 바꾼뒤로 트러블이 안생겨서 좋아요.', '2024-04-14 00:03:03');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240415A001', 'PCB001', 'tndus5521', 'O20240409A001', 2, 4, '친구한테 선물했더니 좋아해요.', '2024-04-15 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240415A002', 'PLA001', 'tndus5521', 'O20240409A002', 5, 4, '향기가 약간 센거 같아요.', '2024-04-15 00:20:03');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240417A001', 'PSA001', 'wngur9844', 'O20240302A003', 3, 5, '가성비가 엄청 좋아요.', '2024-04-17 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240423A001', 'PLB001', 'gkdus0829', 'O20240411A001', 3, 5, '타사 제품들보다 훨씬 좋아요.', '2024-04-23 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240423A002', 'PSB001', 'gkdus0829', 'O20240415A001', 3, 5, '언니가 엄청 좋아해요.', '2024-04-23 04:03:39');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240428A001', 'PSM001', 'tnwl8877', 'O20240419A001', 1, 2, '배송도 느리고 포장도 정성스럽지가 않아요.', '2024-04-28 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240428A002', 'PTM001', 'tldms0604', 'O20240411A002', 2, 4, '제품 용량이 조금 적어요.', '2024-04-28 07:30:03');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240429A001', 'PLB001', 'algus1454', 'O20240418A001', 2, 5, '제 피부타입에 맞는 제품이에요.', '2024-04-29 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240429A002', 'PSA001', 'wlgP7858', 'O20240423A002', 1, 4, '향기가 약간 센거 같아요.', '2024-04-29 13:30:40');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240430A001', 'PLA001', 'rkdms0087', 'O20240423A001', 1, 2, '피부에 트러블이 조금 생겼어요.', '2024-04-30 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240430A002', 'PSB001', 'gPwls6656', 'O20240417A001', 2, 5, '선배 선물로 사드렸는데 엄청 좋아해요.', '2024-04-30 14:03:23');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240501A001', 'PSM001', 'wldus6433', 'O20240420A001', 1, 3, '리뷰보고 샀는데 엄청 좋진 않았어요.', '2024-05-01 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240501A002', 'PSW001', 'tldms0604', 'O20240418A002', 2, 4, '피부에 흡수가 잘 됩니다.', '2024-05-01 09:30:50');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240503A001', 'PTM001', 'rkdms0087', 'O20240430A001', 2, 4, '다른 제품도 구매해보고 싶어요.', '2024-05-03 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240505A001', 'PTA001', 'ckdtjr6869', 'O20240425A001', 1, 5, '리뷰보고 주문했는데 너무 맘에 들어요.', '2024-05-05 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240506A001', 'PTB001', 'wldus6433', 'O20240425A002', 1, 4, '향이 조금 강해요.', '2024-05-06 00:00:00');
INSERT INTO reviewTBL (reviewID, prodID, userID, orderID, orderStock, ratingScore, reviewContent, reviewDate) VALUES ('R20240603A001', 'PTW001', 'test', 'O20240603A002', 3, 4, '적당히 쓸만해요\r\n양이 좀 적은 거 같아요', '2024-06-03 21:36:17');

/*
-- eventTBL recode
*/
INSERT INTO eventTBL (eventID, eventName, eventImg, eventInfo, eventStart, eventEnd, prizeImg, prizeDate, prizeList) VALUES ('E0001', '플라스틱 공병 수거 캠페인', 'images/event/E0001.png', 'images/event/E0001_info.png', '2024-03-01', '2024-08-31', 'images/event/E0001.png', NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, eventImg, eventInfo, eventStart, eventEnd, prizeImg, prizeDate, prizeList) VALUES ('E0002', '4월 리뷰 이벤트', 'images/event/E0002.png', 'images/event/E0002_info.png', '2024-04-01', '2024-04-30', 'images/event/E0002_prize.png', '2024-05-06', NULL);
INSERT INTO eventTBL (eventID, eventName, eventImg, eventInfo, eventStart, eventEnd, prizeImg, prizeDate, prizeList) VALUES ('E0003', '5월 리뷰 이벤트', 'images/event/E0003.png', 'images/event/E0003_info.png', '2024-05-01', '2024-05-31', 'images/event/E0003.png', NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, eventImg, eventInfo, eventStart, eventEnd, prizeImg, prizeDate, prizeList) VALUES ('E0004', '5월 가정의 달 봄맞이 쿠폰', 'images/event/E0004.png', 'images/event/E0004_info.png', '2024-05-05', '2024-05-31', 'images/event/E0004.png', NULL, NULL);

/*
-- askTBL recode
*/
INSERT INTO askTBL (askID, userID, askCtg, askName, askContent, agreeEmail, askStatus, askDate, answer, answerDate) VALUES ('A00000000A001', 'puresh', '배송 문의', '테스트 컬럼', '테스트용입니다.', 'NO', '접수', '2023-03-02 00:00:00', '퓨레시', '2023-04-05 00:00:00');
INSERT INTO askTBL (askID, userID, askCtg, askName, askContent, agreeEmail, askStatus, askDate, answer, answerDate) VALUES ('A20240509A003', 'test', '기타 문의', '이 편지는 17세기 영국에서 시작되어', '이 편지는 17세기 영국에서 시작되어 21세기 대한민국까지 도달했습니다. 이 편지를 복사해서 \r\n7명에게 전달하지 않으면 근시일 내에 큰 화를 입을 것입니다. 실제로 이 편지를 무시하고 보내\r\n지 않았던 홍아무개는 아버지를 아버지라 부르지 못하는 화를 입었습니다. 반대로 7명에게 편\r\n지를 보냈던 흥아무개는 박씨를 얻어 부자가 되었습니다. 절대로 이 편지를 무시하지 마십시오.', 'YES', '답변 완료', '2024-05-09 10:33:49', 'ㅇ', '2024-05-11 06:19:59');
INSERT INTO askTBL (askID, userID, askCtg, askName, askContent, agreeEmail, askStatus, askDate, answer, answerDate) VALUES ('A20240511A001', 'test', '환불 문의', '문의테스트중', '전부 환불해주세요.\r\n그냥 환불해주세요.\r\n맘에 안들어.', 'NO', '답변 완료', '2024-05-11 06:34:04', '환불 규정에 부합하지 않아 환불이 불가능합니다.', '2024-05-29 12:53:02');
INSERT INTO askTBL (askID, userID, askCtg, askName, askContent, agreeEmail, askStatus, askDate, answer, answerDate) VALUES ('A20240531A001', 'test', '기타 문의', '새로운 과일 라인 출시', ' 혹시 라즈베리나 플럼 라인은 출시 안 하시나요?', 'NO', '답변 완료', '2024-05-31 19:44:43', '현재로선 계획에 없으나 추후 출시 예정이 되어있습니다.\r\n앞으로도 퓨레시에 많은 관심 부탁드립니다.', '2024-05-31 19:45:34');

-- <View>
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
