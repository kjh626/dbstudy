/*
    테이블
    1. 데이터베이스의 가장 대표적인 객체이다.
    2. 데이터를 보관하는 객체이다.
    3. 표 형식으로 데이터를 보관한다.
    4. 테이블 기본 용어
        1) 열 : column, 속성(attribute), 필드(field)
        2) 행 : row,    개체(entity),    레코드(record)        
*/

/*
    오라클의 데이터 타입
    1. CHAR(size)     : 고정 길이 문자 타입(size : 1 ~ 2000바이트)
    2. VARCHAR2(size) : 가변 길이 문자 타입(size : 1 ~ 4000바이트)
    3. DATE           : 날짜/시간 타입
    4. TIMESTAMP      : 날짜/시간 타입(좀 더 정밀)
    5. NUMBER(p, s)   : 정밀도(p), 스케일(s)로 표현하는 숫자 타입
        1) 정밀도 : 정수부와 소수부를 모두 포함하는 전체 유효 숫자가 몇개인가?
        2) 스케일 : 소수부의 전체 유효숫자가 몇 개인가?
        예시)
            (1) NUMBER      : 최대 38자리 숫자(22바이트)
            (2) NUMBER(3)   : 정수부가 최대 3자리인 숫자(최대 999);
            (3) NUMBER(5,2) : 전체 5자리, 소수부 2자리인 숫자(123.45)
            (4) NUMBER(2,2) : 1 미만의 소수부, 2자리는 실수(0.15 ..?) -- 앞뒤로 불필요한 숫자는 없앰, 정수부의 0은 유효 자리가 아니다.
※ 코드를 적을 때 대문자, 소문자로 적든 상관없다. 하지만 통일을 해줘야 한다. (선생님은 100%대문자)
   우리가 집어넣는 데이터는 대문자,소문자로 적으면 유지가 된다. 키워드랑 다른 경우라고 생각

/*
    제약조건(Constraint) -- 항상 키워드의 입력은 띄어쓰기만 잘하면 된다. 순서도 상관없음(NOT NULL먼저 하든 UNIQUE먼저 하든)
    1. 널
        1) NULL 또는 생략
        2) NOT NULL
    2. 중복 데이터 방지
        UNIQUE
    3. 값의 제한 (상대적으로 제일 덜 중요)
        CHECK
*/

-- 예시 테이블
DROP TABLE PRODUCT;    -- 지우기 , 지울 때는 생성 전에 코드를 넣어 주는 것이 좋다.
CREATE TABLE PRODUCT(   -- CREATE TABLE 테이블이름. PRODUCT 생성하고 테이블에서 데이터탭은 행을 의미한다고 보면 됨.?
    CODE         VARCHAR2(2 BYTE)  NOT NULL UNIQUE,  -- 자바랑 반대로 씀. NOT NULL 쓰면 필수로 입력을 해줘야 한다는 뜻, 값이 꼭 필요하다.
    MODEL        VARCHAR2(10 BYTE) NULL, -- 얘네가 Column이 된다.(CODE, MODEL, ... )
    CATEGORY     VARCHAR2(5 BYTE),
    PRICE        NUMBER            CHECK(PRICE >= 0),  
    AMOUNT       NUMBER(2)         CHECK(AMOUNT >= 0 AND AMOUNT <= 100), -- 음수가 들어가면 안 된다.(값의 제한 필요)
    MANUFACTURED DATE
);