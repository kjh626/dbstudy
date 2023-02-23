-- 삽입/삭제/수정하면 메시지를 출력하는 트리거 만들기

SET SERVEROUTPUT ON;  -- 이거 해야 메시지 확인 가능함. 1번만 하면됨

CREATE OR REPLACE TRIGGER MY_TRIGGER
-- AFTER, BEFORE 할 지는 문제에 적혀있음
    AFTER
    INSERT OR DELETE OR UPDATE -- 1개 2개 3개 다 적을 수 있다.
    ON DEPARTMENT_TBL
    FOR EACH ROW  -- 행단위로
BEGIN
    DBMS_OUTPUT.PUT_LINE('하하하하하');
END;
--트리거만 제출하면 된다.
INSERT INTO DEPARTMENT_TBL(DEPT_NO, DEPT_NAME, LOCATION) VALUES(5, '개발부', '서울');  -- 이건 트리거 동작 확인하려고 임의로 쿼리문 작성한 것.
COMMIT;
