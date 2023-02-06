/*
    DDL
    1. Data Definition Language
    2. 데이터 정의어
    3. 데이터베이스 객체(user, table, sequence, view, index 등)를 생성/수정/삭제하는 언어이다.
    4. 완료된 작업을 취소할 수 없다.(COMMIT할 필요가 없다. ROLLBACK을 할 수 없다(커밋은 저장, 롤백은 취소)) -> 삭제할 때 조심하자.
    5. 종류
        1) CREATE : 생성
        2) ALTER  : 수정 (제약조건 CONSTRAINT에 쓸 것. 만들 때는 없었는데 나중에 필요해지면 수정해야 한다)
        3) DROP   : 삭제
*/
-- 테이블 삭제 (실무에서는 DROP을 쓸 일이 없다고 보면 됨)
DROP TABLE CUSTOMER_TBL;
DROP TABLE BANK_TBL;

-- BANK_TBL 테이블 생성
CREATE TABLE BANK_TBL(
    BANK_CODE VARCHAR2(20 BYTE) NOT NULL,
    BANK_NAME VARCHAR2(30 BYTE),
    CONSTRAINT PK_BANK PRIMARY KEY(BANK_CODE)
);

-- CUSTOMER_TBL 테이블 생성
CREATE TABLE CUSTOMER_TBL(
    NO        NUMBER            NOT NULL,
    NAME      VARCHAR2(30 BYTE) NOT NULL,
    PHONE     VARCHAR2(30 BYTE) UNIQUE,
    AGE       NUMBER            CHECK (AGE BETWEEN 0 AND 100),
    BANK_CODE VARCHAR2(20 BYTE),
    CONSTRAINT PK_CUSTOMER PRIMARY KEY(NO),
    CONSTRAINT FK_CUSTOMER_BANK FOREIGN KEY(BANK_CODE) REFERENCES BANK_TBL(BANK_CODE)
);