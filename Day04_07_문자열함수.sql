-- 문자열 함수


-- 1. 대소문자 변환 함수
SELECT
       UPPER(EMAIL)   -- 대문자
     , LOWER(EMAIL)   -- 소문자
     , INITCAP(EMAIL) -- 첫 글자는 대문자, 나머지는 소문자
  FROM 
       EMPLOYEES;
       
       
-- 2. 글자 수(바이트 수) 반환 함수
SELECT
       LENGTH('HELLO')    -- 글자 수 : 5
     , LENGTH('안녕')     -- 글자 수 : 2
     , LENGTHB('HELLO')   -- 바이트 수 : 5
     , LENGTHB('안녕')    -- UTF8처리, 3바이트씩 : 6
  FROM 
       DUAL;
       
       
-- 3. 문자열 연결 함수/연산자
--    1) 함수   : CONCAT(A, B)  주의! 인수가 2개만 전달 가능하다.(CONCAT(A, B, C) 같은 형태는 불가능하다.)
--    2) 연산자 : ||   주의! OR 연산 아닙니다! 오라클 전용입니다.
--        예시) 검색할 때 A를 검색 -> '%' || 'A' || '%' 를 해줘서 대입해주면 A를 포함한 이름 검색 가능 
--              (JAVA에서             "%" + "A" + "%" 해서 보내주면 DB에서는 연산할 필요 없어짐)
--              => 누군가는(DB,JAVA) 해야하는 데 누가 할 지를 선택해야 한다. => ★꿀팁!★)둘 다 할 수 있으면 DB에서 하는 것이 매우매우 좋다.
SELECT
       CONCAT(CONCAT(FIRST_NAME, ' '), LAST_NAME)
     , FIRST_NAME || ' ' || LAST_NAME                     -- JAVA의 +역할을 한다.  
  FROM 
       EMPLOYEES;
  
       
-- 4. 문자열 일부 반환하기
--    SUBSTR(칼럼, BEGIN, LENGTH) : BEGIN부터 LENGTH개를 반환
--    주의! BEGIN은 1에서 시작한다.(INDEX가 아니다)
SELECT 
       SUBSTR(EMAIL, 1, 3)    -- 1번째 글자부터 3글자를 가져오시오.
  FROM 
       EMPLOYEES;


-- 5. 특정 문자열의 위치 반환하기
--    INSTR(칼럼, 찾을문자열)
--    주의! 반환되는 위치 정보는 인덱스가 아니므로 0부터 시작하지 않고, 1부터 시작한다.
--    못 찾으면 0을 반환한다.
SELECT
       INSTR(EMAIL, 'A')    -- 'A'의 위치를 반환
  FROM 
       EMPLOYEES;
       
       
-- 6. 문자열 채우기(PADDING)
--    1) LPAD(칼럼, 전체폭, 채울문자)
--    2) RPAD(칼럼, 전체폭, 채울문자)
SELECT
       LPAD(DEPARTMENT_ID, 3, '0')
     , RPAD(EMAIL, 10, '*')
  FROM
       EMPLOYEES;


-- 연습문제
SELECT
       LPAD(NVL(DEPARTMENT_ID, 0), 3, '0')
     , RPAD(SUBSTR(EMAIL, 1, 2), 5, '*')
  FROM
       EMPLOYEES;
       
       
-- 7. 불필요한 공백 제거
--    1) LTRIM(칼럼) : 왼쪽 공백 제거
--    2) RTRIM(칼럼) : 오른쪽 공백 제거
--    3) TRIM(칼럼)  : 왼쪽, 오른쪽 공백 모두 제거
-- DB의 자료가 엉망일 때 정리하려고, 엑셀같은 거 DB에 임포트할 때 공백붙어서 올 수가 있다. 그래서 TRIM써서 가공할 필요가 있다.
SELECT
       '[' || LTRIM('      HELLO') || ']'
     , '[' || RTRIM('HELLO      ') || ']'
     , '[' || TRIM('   HELLO    ') || ']'
  FROM 
       DUAL;