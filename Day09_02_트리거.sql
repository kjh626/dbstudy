/*
    트리거(TRIGGER)
    1. DML(INSERT, UPDATE, DELETE) 작업 후 자동으로 실행되는 데이터베이스 객체이다.
    2. 행(ROW) 단위로 트리거가 동작한다.
    3. 종류
        1) BEFORE 트리거 : DML 동작 이전에 수행된다.
        2) AFTER  트리거 : DML 동작 이후에 수행된다.
    4. 형식
        CREATE [OR REPLACE] TRIGGER 트리거명
        BEFORE | AFTER
        INSERT OR UPDATE OR DELETE
        ON 테이블명 -- 대상이 되는 테이블
        FOR EACH ROW  -- 행단위 작업(행마다 트리거가 동작한다)
        BEGIN
            트리거본문
        END;
*/

SET SERVEROUTPUT ON;

-- TRIG1 정의(TRIGGER 동작 더이상 원하지 않으면 DROP TRIGGER 하면 됨)
CREATE OR REPLACE TRIGGER TRIG1
    AFTER
    UPDATE
    ON EMPLOYEES
    FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello World');
END;

-- TRIG1 동작 확인(EMPLOYEES 테이블의 데이터를 수정해 본다.) => 트리거는 따로 실행(호출) 코드가 없다.
UPDATE EMPLOYEES
    SET LAST_NAME = 'Queen'
 WHERE EMPLOYEE_ID = 100;

-- TRIG1 삭제
DROP TRIGGER TRIG1;


-- TRIG2 정의
CREATE OR REPLACE TRIGGER TRIG2
    AFTER
    INSERT OR UPDATE OR DELETE    -- 작성 순서 없음
    ON EMPLOYEES 
    FOR EACH ROW
BEGIN
    IF INSERTING THEN   -- 삽입 후 동작할 작업
        DBMS_OUTPUT.PUT_LINE('INSERT를 했군요.');
    ELSIF UPDATING THEN   -- 수정 후 동작할 작업
        DBMS_OUTPUT.PUT_LINE('UPDATE를 했군요.');
    ELSIF DELETING THEN   -- 삭제 후 동작할 작업
        DBMS_OUTPUT.PUT_LINE('DELETE를 했군요.');
    END IF;
END;


-- TRIG2 동작 확인
INSERT INTO EMPLOYEES(EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID) VALUES(99, 'A', 'A', SYSDATE, 'A');  -- 5개 칼럼은 필수칼럼이라 꼭 잡아줘야한다.
UPDATE EMPLOYEES SET FIRST_NAME = 'Kim' WHERE EMPLOYEE_ID = 99;
DELETE FROM EMPLOYEES WHERE EMPLOYEE_ID = 99;

-- TRIG2 삭제
DROP TRIGGER TRIG2;










