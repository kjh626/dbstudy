/*
    프로시저(PROCEDURE) => 자바의 메소드와 비슷하게 역할
    1. 하나의 프로시저에 여러 개의 쿼리문을 작성해서 처리할 수 있다.
    2. 여러 개의 쿼리문이 필요한 서비스를 프로시저로 작성해 두면 사용이 편리하다.
        (예시 : 은행 이체(UPDATE 쿼리가 2개로 구성))
    3. 형식
        CREATE [OR REPLACE] PROCEDURE  프로시저명[()] ( () 안 에는 매개변수가 들어갈 수 있음 )
        IS    -- AS 도 가능
            변수선언
        BEGIN
            본문
        [EXCEPTION
            예외처리]
        END;
    4. 작성된 프로시저는 EXECUTE 프로시저(); 형식으로 실행한다.
*/

-- 프로시저1 정의(만들기)
CREATE OR REPLACE PROCEDURE PROC1
IS  -- 변수선언을 안 해도 괜찮다. IS나 AS를 넣어라
BEGIN 
      DBMS_OUTPUT.PUT_LINE('Hello World');
END;

-- 프로시저1 호출(실행하기)
EXECUTE PROC1();


-- 프로시저2 정의(만들기) : 사원번호가 100인 사원의 FIRST_NAME, LAST_NAME, SALARY를 조회하는 프로시저
CREATE OR REPLACE PROCEDURE PROC2
IS
    FNAME EMPLOYEES.FIRST_NAME%TYPE;
    LNAME EMPLOYEES.LAST_NAME%TYPE;
    SAL EMPLOYEES.SALARY%TYPE;
BEGIN
      SELECT FIRST_NAME, LAST_NAME, SALARY
        INTO FNAME, LNAME, SAL
        FROM EMPLOYEES
       WHERE EMPLOYEE_ID = 100;
    DBMS_OUTPUT.PUT_LINE(FNAME || ',' || LNAME || ',' || SAL);
END;

-- 프로시저2 호출(실행하기)
EXECUTE PROC2();


-- 프로시저3 정의(만들기) : 사원번호를 전달하면 해당 사원의 FIRST_NAME, LAST_NAME, SALARY를 조회하는 프로시저
-- 입력 파라미터 (이런 특징을 가지고 있다!)
-- 1. 프로시저로 값을 전달할 때 사용한다.
-- 2. 형식 : 변수명 IN 타입 (입력파라미터 역할을 수행할 수 있게 해준다.(IN))
CREATE OR REPLACE PROCEDURE PROC3(EMP_ID IN EMPLOYEES.EMPLOYEE_ID%TYPE)
IS
    FNAME EMPLOYEES.FIRST_NAME%TYPE;
    LNAME EMPLOYEES.LAST_NAME%TYPE;
    SAL EMPLOYEES.SALARY%TYPE;
BEGIN
      SELECT FIRST_NAME, LAST_NAME, SALARY
        INTO FNAME, LNAME, SAL
        FROM EMPLOYEES
       WHERE EMPLOYEE_ID = EMP_ID;  -- 매개변수 역할을 할 EMP_ID를 여기에 넣어줌
    DBMS_OUTPUT.PUT_LINE(FNAME || ',' || LNAME || ',' || SAL);
EXCEPTION 
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('예외가 발생했습니다.');
END;

-- 프로시저3 호출(실행하기) 메소드에 매개변수 넣듯이 해줌.
EXECUTE PROC3(1);


-- 프로시저4 정의(만들기) : 결과(FIRST_NAME, LAST_NAME, SALARY)를 외부에서 전달하도록 해줄 것임. (=> 쉽게 말하면 메소드 반환값을 받아 오겠다는 것)
-- 사원번호가 100인 사원의 FIRST_NAME, LAST_NAME을 출력 파라미터로 반환하는 프로시저
-- 출력 파라미터
-- 1. 프로시저의 실행 결과를 저장하는 변수이다.
-- 2. 형식 : 변수명 OUT 타입
CREATE OR REPLACE PROCEDURE PROC4(FNAME OUT EMPLOYEES.FIRST_NAME%TYPE, LNAME OUT EMPLOYEES.LAST_NAME%TYPE)
IS
BEGIN
   SELECT FIRST_NAME, LAST_NAME
     INTO FNAME, LNAME   -- 이 곳에서 출력 파라미터에 값이 저장된다.
     FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 100;
END;

-- 프로시저4 호출(실행하기)
-- FNAME과 LNAME값을 저장할 변수를 선언한 뒤, 프로시저에 전달해야 한다.
DECLARE
    FNAME EMPLOYEES.FIRST_NAME%TYPE;
    LNAME EMPLOYEES.LAST_NAME%TYPE;
BEGIN
    PROC4(FNAME, LNAME);    -- PLSQL 내부에서 프로시저를 호출할 때는 EXECUTE를 생략해야 한다.
    DBMS_OUTPUT.PUT_LINE(FNAME || ',' || LNAME);
END;


-- 프로시저5  3,4 번 프로시저 합치기
-- 사원번호를 전달하면, 해당 사원의 FIRST_NAME이 출력 파라미터 FNAME에 저장되도록 작성.
-- 없는 사원번호가 전달되면 출력 파라미터 FNAME에 'NOname'이 저장되도록 작성.
CREATE OR REPLACE PROCEDURE PROC5
(
    EMP_ID IN EMPLOYEES.EMPLOYEE_ID%TYPE, 
    FNAME OUT EMPLOYEES.FIRST_NAME%TYPE
)
IS
BEGIN
    SELECT FIRST_NAME
      INTO FNAME
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = EMP_ID;
EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        FNAME := 'NOname';
END;
-- 메소드를 하나 만들었다 생각하면 된다.

-- 프로시저5 호출(실행하기) <- 변수가 있어야 호출을 할 수가 있다. 변수선언은? => DECLARE
DECLARE
    FNAME EMPLOYEES.FIRST_NAME%TYPE;
    EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE;
BEGIN   -- 선언했으면 곧바로 호출!
    PROC5(100, FNAME);    -- PLSQL 내부에서 프로시저를 호출할 때는 EXECUTE를 생략해야 한다.
    DBMS_OUTPUT.PUT_LINE('사원번호 ' || EMP_ID || '은 ' || FNAME || '입니다.');
END;
--예시) PROC5(100, FNAME) : 사원번호 100은 Steven입니다.
--      PROC5(0, FNAME) : 사원번호 0은 NOname입니다.



/*
    프로시저 연습
    1. BUY_PROC 프로시저 구현하기
    2. 처리할 일
        1) 구매내역 테이블에 구매 내역을 추가(INSERT)한다.
        2) 제품 테이블의 재고 내역을 수정(UPDATE)한다.
        3) 고객 테이블의 포인트를 수정(UPDATE)한다.
*/

-- 테이블 삭제하기
DROP TABLE BUY_TBL;
DROP TABLE CUST_TBL;
DROP TABLE PROD_TBL;

-- 시퀀스 삭제하기
DROP SEQUENCE BUY_SEQ;

-- 제품 테이블 구성하기
CREATE TABLE PROD_TBL (
    /*설에*/P_CODE  NUMBER NOT NULL,
    /*명붙*/P_NAME  VARCHAR2(20 BYTE),
    /*을이*/P_PRICE NUMBER,
    /*앞기*/P_STOCK NUMBER
);

ALTER TABLE PROD_TBL
    ADD CONSTRAINT PK_PROD PRIMARY KEY(P_CODE);
INSERT INTO PROD_TBL(P_CODE, P_NAME, P_PRICE, P_STOCK) VALUES(1000, '홈런볼', 1000, 100);
INSERT INTO PROD_TBL(P_CODE, P_NAME, P_PRICE, P_STOCK) VALUES(1001, '맛동산', 2000, 100);
COMMIT;

-- 고객 테이블 구성하기
CREATE TABLE CUST_TBL (
    C_NO    NUMBER NOT NULL,
    C_NAME  VARCHAR2(20 BYTE),
    C_POINT NUMBER
);

ALTER TABLE CUST_TBL
    ADD CONSTRAINT PK_CUST PRIMARY KEY(C_NO);
INSERT INTO CUST_TBL(C_NO, C_NAME, C_POINT) VALUES(1, '정숙', 0);
INSERT INTO CUST_TBL(C_NO, C_NAME, C_POINT) VALUES(2, '재홍', 0);
COMMIT;

-- 구매 테이블 구성하기
CREATE TABLE BUY_TBL(
    B_NO     NUMBER NOT NULL, -- 기본키
    C_NO     NUMBER NOT NULL, -- 외래키
    P_CODE   NUMBER,          -- 외래키
    B_AMOUNT NUMBER
);

ALTER TABLE BUY_TBL
    ADD CONSTRAINT PK_BUY PRIMARY KEY(B_NO);
ALTER TABLE BUY_TBL
    ADD CONSTRAINT FK_BUY_CUST FOREIGN KEY(C_NO)
        REFERENCES CUST_TBL(C_NO)
            ON DELETE CASCADE;
ALTER TABLE BUY_TBL
    ADD CONSTRAINT FK_BUY_PROD FOREIGN KEY(P_CODE)
        REFERENCES PROD_TBL(P_CODE)
            ON DELETE SET NULL;

-- 시퀀스 생성
CREATE SEQUENCE BUY_SEQ
    NOCACHE;



-- BUY_PROC 프로시저 정의
CREATE OR REPLACE PROCEDURE BUY_PROC
(
    /* 고객번호 */  CNO IN CUST_TBL.C_NO%TYPE, 
    /* 제품코드 */  PCODE IN PROD_TBL.P_CODE%TYPE, 
    /* 구매수량 */  BUY_AMOUNT IN BUY_TBL.B_AMOUNT%TYPE
)
IS  -- 변수 선언할 게 추가적으로 있으면 적어주면 된다.
BEGIN

    -- 1) 구매내역 테이블에 구매 내역을 추가(INSERT)한다.
    INSERT INTO BUY_TBL(B_NO, C_NO, P_CODE, B_AMOUNT) VALUES(BUY_SEQ.NEXTVAL, CNO, PCODE, BUY_AMOUNT);
    
    -- 2) 제품 테이블의 재고 내역을 수정(UPDATE)한다.
    UPDATE PROD_TBL SET P_STOCK = P_STOCK - BUY_AMOUNT WHERE P_CODE = PCODE;
    
    -- 3) 고객 테이블의 포인트를 수정(UPDATE)한다.
    --    총 구매액의 10%를 정수로 올림처리해서 포인트로 준다.
    UPDATE CUST_TBL SET C_POINT = C_POINT + CEIL((SELECT P_PRICE FROM PROD_TBL WHERE P_CODE = PCODE) * BUY_AMOUNT * 0.1) WHERE C_NO = CNO;   -- 가격은 제품 테이블에서 PRICE를 SELECT 해줘야 함. 구매수량은 변수로 받아오기로 해서 상관x
    
    -- 4) 커밋
    COMMIT;
    
EXCEPTION

    WHEN OTHERS THEN  -- 모든 예외를 처리
    
        -- 예외 사유 확인
        DBMS_OUTPUT.PUT_LINE(SQLCODE || '(' || SQLERRM || ')');
        
        -- 롤백
        ROLLBACK;
    
END;

-- BUY_PROC의 호출
--1) 방법1
EXECUTE BUY_PROC(1, 1000,10);  -- 고객번호 1, 제품코드 1000, 구매수량 10

--2) 방법2
BEGIN
    BUY_PROC(2, 1001, 5);   -- 고객번호 2, 제품코드 1001 , 구매수량 5
END;


