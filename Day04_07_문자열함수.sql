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