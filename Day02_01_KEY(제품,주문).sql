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
CREATE TABLE PRODUCT_TBL( -- 제약조건 이름 주는 방법 CONSTRAINT ~~~ PRIMARY KEY
    PROD_NO NUMBER NOT NULL,   -- 문법 기억해라. 보통 NOT NULL 써준다. UNIQUE는 같이 써주면 안 됨.
    PROD_NAME VARCHAR2(10 BYTE),
    PROD_PRICE NUMBER,
    PROD_STOCK NUMBER,
    CONSTRAINT PK_PROD PRIMARY KEY(PROD_NO) -- 이렇게도 쓸 수 있음. ☆이 문법을 외워라.☆
);

-- 주문 테이블(자식 테이블)
CREATE TABLE ORDER_TBL(
    ORDER_NO NUMBER NOT NULL,
    USER_ID VARCHAR2(10 BYTE),
    PROD_NO NUMBER,  -- 외래키 문법
    ORDER_DATE DATE,     -- 외래키 제약조건 이름 주는 방법 REFERENCES 앞에 CONSTRAINT ~~~~
    CONSTRAINT PK_ORDER PRIMARY KEY(ORDER_NO),  -- ☆이 문법을 외워라☆
    CONSTRAINT FK_ORDER_PROD FOREIGN KEY(PROD_NO) REFERENCES PRODUCT_TBL(PROD_NO)  -- ☆이 문법을 외워라☆
);




/*
제약조건에 관련된 정보를 저장하는 테이블이 있다.
    제약조건 테이블(오라클에 의해 만들어지고 관리되는 테이블)
    1. SYS, SYSTEM 관리 계정으로 접속해서 확인한다.
    2. 종류 - 주체가 3가지로 나뉘어 있다.(ALL, USER, DBA)
        1) ALL_CONSTRAINTS  -- 모든
        2) USER_CONSTRAINTS -- 사용자용
        3) DBA_CONSTRAINTS  -- 관리자 제약조건
    이걸 기억해서 ALL_TABLES, USER_TABLES, DBA_TABLES 이렇게도 가능. 뒤에 붙여주면 된다.
    이걸 데이터 사전이라고 부른다. DATA DICTIONARY, CATALOG
*/

-- 테이블의 구조를 확인하는 쿼리문 (설명)
--DESCRIBE ALL_CONSTRAINTS;
--SELECT * FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME LIKE 'PK%';   -- * : 모든 칼럼의 데이터를 확인할 수 있다.

