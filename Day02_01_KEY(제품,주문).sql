/*
    KEY 제약조건
    1. 기본키(PK : Primary Key)
        1) 개체무결성
        2) PK는 NOT NULL + UNIQUE 해야 한다.
    2. 외래키(FK : Foreign Key)
        1) 참조무결성
        2) FK는 참조하는 값만 가질 수 있다.
*/

/*
    일대다(1:M) 관계
    1. PK와 FK를 가진 테이블 간의 관계이다.
        1) 부모 테이블 : 1, PK를 가진 테이블
        2) 자식 테이블 : M, FK를 가진 테이블
    2. 생성과 삭제 규칙
        1) 생성 규칙 : "반드시" 부모 테이블을 먼저 생성한다.
        2) 삭제 규칙 : "반드시" 자식 테이블을 먼저 삭제한다.
*/

-- 테이블 삭제 (삭제를 몰아서 위쪽에 배치하고, 생성을 몰아서 아래쪽으로 배치하면 문제 없을 것)
DROP TABLE ORDER_TBL;    -- 삭제 규칙을 지켜줘야 한다. (만든 순서 거꾸로 해주면 됨.)
DROP TABLE PRODUCT_TBL;

-- 제품 테이블(부모 테이블)
CREATE TABLE PRODUCT_TBL(
    PROD_NO NUMBER NOT NULL PRIMARY KEY,   -- 문법 기억해라. 보통 NOT NULL 써준다. UNIQUE는 같이 써주면 안 됨.
    PROD_NAME VARCHAR2(10 BYTE),
    PROD_PRICE NUMBER,
    PROD_STOCK NUMBER
);

-- 주문 테이블(자식 테이블)
CREATE TABLE ORDER_TBL(
    ORDER_NO NUMBER NOT NULL PRIMARY KEY,
    USER_ID VARCHAR2(10 BYTE),
    PROD_NO NUMBER REFERENCES PRODUCT_TBL(PROD_NO),  -- 외래키 문법
    ORDER_DATE DATE
);