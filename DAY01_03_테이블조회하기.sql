/*
    DQL
    1. Data Query Language
    2. 데이터 질의(조회) 언어
    3. 테이블의 데이터를 조회하는 언어이다.
    4. 테이블 내용의 변경이 생기지 않는다.
        (트랜잭션의 처리 대상이 아니고, COMMIT이 필요하지 않다.)
        ※ 내용이 바뀌는 작업(삽입,수정,삭제)을 DB에서는 트랜잭션 처리대상으로 본다
    5. 형식([]는 생략가능)
        SELECT 조회할칼럼, 조회할칼럼, 조회할칼럼, ...   
        FROM 테이블이름    -- 절(SELECT절, FROM절..) 별로 엔터로 끊어주는 것이 좋다. (현재 총 6개의 절)
        [WHERE 조건]       -- 보고싶은 게 뭐니?
        [GROUP BY 그룹화할칼럼 [HAVING 그룹조건식]]   -- 그루핑은 함수가 필요하다.       
        [ORDER BY 정렬할칼럼 정렬방식]   -- 보고싶은 순서(돈이 많은 순, 성적이 높은 순, 낮은 순...)
    6. 순서 (나중가면 이게 정말 중요했구나 알게 됨. 암기해야 됨 FROM -> WHERE -> GROUP BY -> SELECT -> ORDER BY)
        ④ SELECT 조회할칼럼, 조회할칼럼, 조회할칼럼, ...   
        ① FROM 테이블이름 
        ② [WHERE 조건]    
        ③ [GROUP BY 그룹화할칼럼 [HAVING 그룹조건식]] 
        ⑤ [ORDER BY 정렬할칼럼 정렬방식]  
*/

/*
    트랜잭션
    1. Transaction
    2. 여러 개의 세부 작업으로 구성된 하나의 작업을 의미한다. (파일 이동 시킨다고 생각 <= 옮길 폴더에 복사, 본래 폴더에선 삭제하는 과정이라 생각)
    3. 모든 세부 작업이 성공하면 COMMIT하고, 하나라도 실패하면 모든 세부 작업의 취소를 진행한다.
        (All or Nothing)
*/

-- 조회 실습. => 대부분은 4,5번 방식으로 쿼리 많이 만든다.
-- 1. 사원 테이블에서 사원명 조회하기
--  1) 기본 방식
SELECT ENAME   -- SELECT 문의 결과는 테이블이다. 칼럼이 하나이고 ROW가 12개인 테이블이라고 볼 수 있다.
  FROM EMP;      -- 한 문장이다.(Ctrl + enter로 실행 가능)

--  2) 오너 명시하기(테이블을 가지고 있는 계정)
SELECT ENAME
  FROM SCOTT.EMP;     -- SCOTT계정에 저장되어 있는 EMP테이블

--  3) 테이블 명시하기(칼럼을 가지고 있는 테이블)
SELECT EMP.ENAME    -- EMP테이블 의 ENAME
  FROM EMP;

--  4) 테이블 별명 지정하기 (통상 테이블의 이름은 길다. 그러니까 짧게 부르기 위해서 별명)
SELECT E.ENAME
  FROM EMP E;         -- EMP 테이블의 별명을 E 로 부여한다. AS(ALIAS)를 사용할 수 없다.

--  5) 칼럼 별명 지정하기
SELECT E.ENAME AS 사원명   -- E.ENAME 칼럼의 별명을 '사원명'으로 부여한다. AS(ALIAS)를 사용할 수 있다.(주의할 점: 테이블의 별명을 지정할 때는 AS 못 씀)
  FROM EMP E;

-- 2. 사원 테이블의 모든 칼럼 조회하기
--  1) * 활용하기 (SELECT절에서 *는 모든 칼럼을 의미한다.)
SELECT *        -- 불려 가기 싫으면 사용 금지!(이거 써서 개발하면 끌려간다)
  FROM EMP;     -- (null)은 비어있는 칸이라는 뜻이다. 진짜 null이라 적혀있는 게아니라

--  2) 모든 칼럼 직접 작성하기
SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO 
  FROM EMP;
  
-- 3. 동일한 데이터는 한 번만 조회하기
--     DISTINCT : 중복된 데이터 추려서 보여준다.
SELECT DISTINCT JOB
  FROM EMP;

-- 4. JOB이 MANAGER인 사원 목록 조회하기
SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO
  FROM EMP
 WHERE JOB = 'MANAGER';
 
SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO
  FROM EMP
 WHERE JOB IN('MANAGER');

-- 5. SAL이 1500 초과인 사원 목록 조회하기
SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO
  FROM EMP
 WHERE SAL > 1500;
 
-- 6. SAL이 2000 ~ 2999 인 사원 목록 조회하기
SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL COMM, DEPTNO
  FROM EMP
 WHERE SAL BETWEEN 2000 AND 2999;
 
-- 7. COMM을 받는 사원 목록 조회하기
--    1) NULL 이다   : IS NULL
--    2) NULL 아니다 : IS NOT NULL (!= 쓰지마라)
SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO
  FROM EMP
 WHERE COMM IS NOT NULL
   AND COMM != 0;   -- 한 줄에 조건 하나씩해서 줄맞춰줄 수 있다.
   /*
    WHERE 1 = 1                -- 이렇게 써야될 때가 생길 거다. (의미는 여기까지는 쿼리문 바꾸지 않겠다)
    [AND COMM IS NOT NULL]    -- 이 조건([ ])이 빠질 때도 있고 넣어야 할 때도 있다.
    [AND COMM != 0];          -- 1 = 1 안 쓰면 [] 빠졌을 때 WHERE 다음에 AND 오면 오류가 나게 된다.(=> 1=1넣는 게 좋지는 않은데..)
   */

-- 8. ENAME이 A로 시작하는 사원 목록 조회하기
--    1) WILD CARD (만능문자) -> WILD CARD는 =을 쓰면 안 된다. 그래서 LIKE 가 있음
--      (1) % : 글자 수 제한 없는 모든 문자 (A% -> AI, APP, APPLE 가능) <- 이거 공부해라
--      (2) _ : 1글자로 제한된 모든 문자    (A_ -> AI, AP, AM 가능) <- 거의 안 씀
--    2) 연산자
--      (1) LIKE     : WILD CARD를 포함한다.
--      (2) NOT LIKE : WILD CARD를 포함하지 않는다.
SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO
  FROM EMP
 WHERE ENAME LIKE 'A%';    -- A가 어딨든 상관없다 (%A%), A로 끝나는(%A), A로 시작하는(A%)

