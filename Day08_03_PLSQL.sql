/*
    PL/SQL
    
    1. 오라클 전용 문법이고 프로그래밍 처리가 가능한 SQL이다.
    2. 형식
        [DECLARE
            변수 선언]
        BEGIN 
            수행할 PL/SQL
        END;
    3. 변수에 저장된 값을 출력하기 위해서 서버 출력을 ON 시켜줘야 한다.
       최초 1번만 실행시켜 두면 된다.(디폴트는 OFF)
        SET SERVEROUTPUT ON;
*/

-- 서버출력 ON
SET SERVEROUTPUT ON;

-- 서버출력 확인
BEGIN 
    DBMS_OUTPUT.PUT_LINE('Hello World');
END;

/*
    테이블 복사하기
    1. CREATE TABLE과 복사할 데이터의 조회(SELECT)를 이용한다.
    2. PK와 FK 제약조건은 복사되지 않는다.
    3. 복사하는 쿼리
        1) 데이터를 복사하기
            CREATE TABLE 테이블 AS(SELECT 칼럼 FROM 테이블);
        2) 데이터를 제외하고 구조만 복사하기(1=2 는 FALSE, 이것을 만족하는 데이터는 없다. => 칼럼만 복사하기)
            CREATE TABLE 테이블 AS(SELECT 칼럼 FROM 테이블 WHERE 1=2);
*/
-- HR 계정의 EMPLOYEES 테이블을 GDJ61 계정으로 복사해서 기초 데이터로 사용하기
DROP TABLE EMPLOYEES;
CREATE TABLE EMPLOYEES
    AS (SELECT *
         FROM HR.EMPLOYEES);   -- 테이블 복사할 때 쓰는 서브쿼리, NULL 제약조건은 넘어옴. 제약조건 PK,FK는 안 넘어옴.

-- EMPLOYEES 테이블에 PK 생성하기
ALTER TABLE EMPLOYEES
    ADD CONSTRAINT PK_EMPLOYEE PRIMARY KEY(EMPLOYEE_ID);


/*
    변수 선언하기
    1. 대입 연산자(:=)를 사용한다.
    2. 종류
       1) 스칼라 변수 : 타입을 직접 지정한다.
       2) 참조 변수   : 특정 칼럼의 타입을 가져다가 지정한다.
       3) 레코드 변수 : 2개 이상의 칼럼을 합쳐서 하나의 타입으로 지정한다.
       4) 행 변수     : 행 전체 데이터를 저장한다.
*/

-- 1. 스칼라 변수
--    직접 타입을 명시
DECLARE 
    NAME VARCHAR2(10 BYTE);
    AGE NUMBER(3);
BEGIN 
    NAME := '제시카';
    AGE := 30;
    DBMS_OUTPUT.PUT_LINE('이름은 ' || NAME || '입니다.');
    DBMS_OUTPUT.PUT_LINE('나이는 ' || AGE || '살입니다.');
END;

-- 2. 참조 변수
--    특정 칼럼의 타입을 그대로 사용하는 변수
--    SELECT절의 INTO를 이용해서 테이블의 데이터를 가져와서 변수에 저장할 수 있다.
--    선언 방법 : 변수명 테이블명.칼럼명%TYPE
DECLARE
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

-- 3. 레코드 변수
--    여러 칼럼의 값을 동시에 저장하는 변수  (자바에서 필드 사용하는 거랑 비슷)
--    레코드 변수 정의(만들기)와 레코드 변수 선언으로 구분해서 진행

DECLARE
    -- 레코드 변수 정의하기
    TYPE MY_RECORD_TYPE IS RECORD(   -- 타입명 : MY_RECORD_TYPE
        FNAME EMPLOYEES.FIRST_NAME%TYPE,
        LNAME EMPLOYEES.LAST_NAME%TYPE,
        SAL EMPLOYEES.SALARY%TYPE
    );
    -- 레코드 변수 선언하기
    EMP MY_RECORD_TYPE;
BEGIN 
    SELECT FIRST_NAME, LAST_NAME, SALARY
      INTO EMP  -- EMP 변수에 집어 넣어라(SELECT 에 있는 3개를)
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = 100;
    DBMS_OUTPUT.PUT_LINE(EMP.FNAME || ',' || EMP.LNAME || ',' || EMP.SAL);
END;

-- 4. 행 변수
--    행 전체 데이터를 저장할 수 있는 타입
--    항상 행 전체 데이터를 저장해야 한다.
--    선언 방법 : 변수명 테이블명%ROWTYPE
DECLARE
    EMP EMPLOYEES%ROWTYPE;
BEGIN 
    SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID
      INTO EMP
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = 100;
    DBMS_OUTPUT.PUT_LINE(EMP.FIRST_NAME || ',' || EMP.LAST_NAME || ',' || EMP.SALARY);
END;



/*
    IF 구문
    
    IF 조건식 THEN
        실행문
    ELSIF 조건식 THEN
        실행문
    ELSE 
        실행문
    END IF;   (<- 이런 거 조심..!)
    
*/

-- 성적에 따른 학점(A,B,C,D,F)
DECLARE
    SCORE NUMBER(3);
    GRADE CHAR(1 BYTE);
BEGIN
    SCORE := 50;
    IF SCORE >= 90 THEN
        GRADE := 'A';
    ELSIF SCORE >= 80 THEN 
        GRADE := 'B';
    ELSIF SCORE >= 70 THEN 
        GRADE := 'C';
    ELSIF SCORE >= 60 THEN
        GRADE := 'D';
    ELSE
        GRADE := 'F';
    END IF;
    DBMS_OUTPUT.PUT_LINE(SCORE || '점은 ' || GRADE || '학점입니다.');
END;

-- EMPLOYEE_ID가 150인 사원의 SALARY가 15000 이상이면 '고액연봉', 아니면 '보통연봉'을 출력하시오.
DECLARE -- 변수처리 하는것 ↓↓
    EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE;
    SAL EMPLOYEES.SALARY%TYPE;
    MESSAGE VARCHAR2(20 BYTE);
BEGIN
    EMP_ID := 150;
    SELECT SALARY
    INTO SAL
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = EMP_ID;
    IF SAL >= 15000 THEN
        MESSAGE := '고액연봉';
    ELSE
        MESSAGE := '보통연봉';
    END IF;
    DBMS_OUTPUT.PUT_LINE('사원번호 ' || EMP_ID || '인 사원의 연봉은 ' || SAL || '이고 ' || MESSAGE || '입니다.');
END;

-- EMPLOYEE_ID가 150인 사원의 COMMISSION_PCT가 0이면 '커미션없음', 아니면 실제 커미션(COMMISSION_PCT * SALARY)을 출력하시오.
DECLARE
    EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE;
    COMM_PCT EMPLOYEES.COMMISSION_PCT%TYPE; -- 타입 설정해줌.
    SAL EMPLOYEES.SALARY%TYPE; -- SAL이라고 선언해주고 EMPLOYEES테이블의 SALARY와 같은 타입이다.
    MESSAGE VARCHAR2(20 BYTE);
BEGIN
    EMP_ID := 150;  -- 초기화 해줌.
    SELECT NVL(COMMISSION_PCT, 0), SALARY
      INTO COMM_PCT, SAL     -- COMM_PCT에 넣어라
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = EMP_ID;
    IF COMM_PCT = 0 THEN
        MESSAGE := '커미션없음';
    ELSE
        MESSAGE := TO_CHAR(COMM_PCT * SAL);  -- 숫자 타입을 스트링 타입으로 바꿔줌
     END IF;
     DBMS_OUTPUT.PUT_LINE('사원번호 ' || EMP_ID || '인 사원의 커미션은 ' || MESSAGE || '입니다.');
END;

/*
    CASE 구문 (IF의 대용품?)
    
    CASE
        WHEN 조건식 THEN
            실행문
        WHEN 조건식 THEN
            실행문
        ELSE
            실행문
    END CASE;
*/

-- EMPLOYEE_ID가 150인 사원의 PHONE_NUMBER에 따른 지역을 출력하시오.
-- 011 : MOBILE
-- 515 : EAST
-- 590 : WEST
-- 603 : SOUTH
-- 650 : NORTH
DECLARE
    EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE;
    PHONE CHAR(3 BYTE);
    MESSAGE VARCHAR2(6 BYTE);
BEGIN
    EMP_ID := 150;
    SELECT SUBSTR(PHONE_NUMBER, 1, 3)
      INTO PHONE  -- SELECT한 것을 PHONE에 넣어준다.
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = EMP_ID;
    CASE
        WHEN PHONE = '011' THEN
            MESSAGE := 'MOBILE';
        WHEN PHONE = '515' THEN
            MESSAGE := 'EAST';
        WHEN PHONE = '590' THEN
            MESSAGE := 'WEST';
        WHEN PHONE = '603' THEN
            MESSAGE := 'SOUTH';
        WHEN PHONE = '650' THEN
            MESSAGE := 'NORTH';
    END CASE;
    DBMS_OUTPUT.PUT_LINE(PHONE || ',' || MESSAGE);
END;


/*
    WHILE 구문
    
    WHILE 조건식 LOOP
        실행문
    END LOOP;

*/

-- 1 ~ 5 출력하기
DECLARE
    N NUMBER(1);
BEGIN
    N := 1;
    WHILE N <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N + 1;
    END LOOP;
END;

-- 사원번호가 100 ~ 206인 사원들의 FIRST_NAME, LAST_NAME을 조회하시오.
DECLARE
    EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE;
    FNAME EMPLOYEES.FIRST_NAME%TYPE;
    LNAME EMPLOYEES.LAST_NAME%TYPE;
BEGIN
    EMP_ID := 100;
    WHILE EMP_ID <= 206 LOOP
        SELECT FIRST_NAME, LAST_NAME
          INTO FNAME, LNAME
          FROM EMPLOYEES
         WHERE EMPLOYEE_ID = EMP_ID;
        DBMS_OUTPUT.PUT_LINE(FNAME || ' ' || LNAME);
    EMP_ID := EMP_ID + 1;
    END LOOP;
END;

-- 사원번호가 100 ~ 206인 사원들의 FIRST_NAME, LAST_NAME을 조회하시오.
-- FIRST_NAME과 LAST_NAME을 저장할 수 있는 레코드 변수를 활용하시오.

DECLARE
    EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE;
    TYPE NAME_TYPE IS RECORD(
        FNAME EMPLOYEES.FIRST_NAME%TYPE,
        LNAME EMPLOYEES.LAST_NAME%TYPE
    );
    FULL_NAME NAME_TYPE;
BEGIN 
    EMP.EMP_ID := 100;
    WHILE EMP.EMP_ID <= 206 LOOP
        SELECT FIRST_NAME, LAST_NAME, EMPLOYEE_ID
          INTO EMP
          FROM EMPLOYEES
          WHERE EMPLOYEE_ID = EMP_ID;
        DBMS_OUTPUT.PUT_LINE(EMP.FNAME || ',' || EMP.LNAME || ',' || EMP.EMP_ID);
    EMP_ID := EMP_ID + 1;
    END LOOP;
END;