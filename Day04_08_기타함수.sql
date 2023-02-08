-- 기타 함수


-- 1. 순위 구하기
--    1) RANK() OVER(ORDER BY 순위구할칼럼 ASC)  : 오름차순 순위(낮은 값이 1등), ASC는 생략 가능
--    2) RANK() OVER(ORDER BY 순위구할칼럼 DESC) : 내림차순 순위(높은 값이 1등).
--    3) 동점자는 같은 등수로 처리
--    4) 순위 순으로 정렬된 상태로 조회
-- 인기게시글 메인화면에 몇 개만 띄우겠다. 조회수로 순위 구해서 TOP3, TOP5해서 빼는 쿼리써서 처리하는...
SELECT
       EMPLOYEE_ID
     , FIRST_NAME || ' ' || LAST_NAME AS NAME  
     , SALARY
     , RANK() OVER(ORDER BY SALARY DESC) AS 연봉순위 
  FROM
       EMPLOYEES;
       
       
-- 2. 분기 처리하기
-- 1) DECODE(표현식 
--      , 값1, 결과1
--      , 값2, 결과2
--      , ...)
--    표현식=값1 이면 결과1을 반환, 표현식=값2이면 결과2를 반환, ...
--    표현식과 값의 동등 비교(=)만 가능하다.
-- 다른 테이블 EMPLOYEES, DEPARTMENTS 에서 사원이름과 부서이름을 셀렉트할 수 있을까? 1) 조인 2) 디코드
--   -> 조인을 쓰면 쿼리 성능이 떨어지는데, 디코드를 쓸 때는 직접 적어주기 때문에 쿼리 성능이 좋다.
SELECT 
       EMPLOYEE_ID
     , FIRST_NAME
     , LAST_NAME
     , DEPARTMENT_ID
     , DECODE(DEPARTMENT_ID
          , 10, 'Administration'
          , 20, 'Marketing'
          , 30, 'Purchasing'
          , 40, 'Human Resources'
          , 50, 'Shipping'
          , 60, 'IT') AS DEPARTMENT_NAME
  FROM
       EMPLOYEES
 WHERE 
       DEPARTMENT_ID IN(10, 20, 30, 40, 50, 60);
-- 한계가 명확함. 동등비교만 가능하니까.. 크기비교가 필요한 경우에는 안 된다.

-- 2) 분기 표현식
-- CASE
--     WHEN 조건식1 THEN 결과값1
--     WHEN 조건식2 THEN 결과값2
--     ...
--     ELSE 결과값N   -- 나머지 결과값.
-- END
SELECT 
       EMPLOYEE_ID
     , FIRST_NAME
     , LAST_NAME
     , SALARY
     , CASE
          WHEN SALARY >= 15000 THEN 'A'
          WHEN SALARY >= 10000 THEN 'B'
          WHEN SALARY >= 5000  THEN 'C'
          ELSE 'D'
       END AS GRADE
  FROM
       EMPLOYEES;


-- 3. 행 번호 반환하기
--    ROW_NUMBER() OVER(ORDER BY 순위구할칼럼 ASC|DESC)  
-- 정렬 결과에 행 번호를 추가해서 반환하는 함수이다. 
-- 예를 들어 순위구할 때 행번호 구하는 게 더 유용할 수가 있다. 우리들은 순위구하는 것보다 행번호 붙이는 걸(ROW_NUMBER) 더 많이 사용함. (RANK와 비슷하지만..)
-- RANK와는 다른 점 동점자일 때 같은 번호로 처리하지 않음.
-- ROW_NUMBER는 10개(33~24) 를 1페이지에 보여주고 10개(23~14)를 2페이지에 보여주고 10개(13~4)를 3페이지에 보여주고 (3,2,1)은 4페이지로 가고
-- 웹툰에서 페이지 번호 쓸 때처럼 우리가 이런 경우에 쓸 듯
SELECT
       ROW_NUMBER() OVER(ORDER BY SALARY DESC) AS 행번호
     , EMPLOYEE_ID
     , FIRST_NAME
     , LAST_NAME
     , SALARY
  FROM 
       EMPLOYEES;
