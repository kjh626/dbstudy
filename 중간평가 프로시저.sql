-- 전달된 부서번호의 부서를 삭제하는 프로시저를 작성하시오.
-- 전달된 부서에 근무하는 모든 사원을 함께 삭제하시오.
CREATE OR REPLACE PROCEDURE DELETE_PROC(DEPTNO IN DEPARTMENT_TBL.DEPT_NO%TYPE)
IS
    -- 변수가 필요하면  IS밑에 선언하고 추가하면 된다.
BEGIN
    DELETE 
      FROM EMPLOYEE_TBL
     WHERE DEPART = DEPTNO;
    DELETE
      FROM DEPARTMENT_TBL
     WHERE DEPT_NO = DEPTNO;
    COMMIT;
EXCEPTION 
     WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE(SQLCODE);   --예외 코드
          DBMS_OUTPUT.PUT_LINE(SQLERRM);   --에러메시지
          ROLLBACK;  -- 예외가 발생했으니 롤백도 해줘야함
END;

EXECUTE DELETE_PROC(1);
--실제 평가문제는 테이블 3개 지우는 것 어떻게하면 딜리트 3개 정상적으로 할 수 있을지 고민해서 풀어라.