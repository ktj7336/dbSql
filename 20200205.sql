-- sub5
SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT*
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1);
                  
-- sub6
SELECT pid
FROM cycle 
WHERE cid = 2;

SELECT*
FROM product
WHERE pid NOT IN (200, 300, 400);

SELECT *
FROM product;

SELECT*
FROM cycle
WHERE cid = 1
AND pid IN ( SELECT pid
             FROM cycle
             WHERE cid = 2);
             
-- sub7
SELECT a.cid, customer.cnm, a.pid, product.pnm, a.day, a.cnt
FROM
(SELECT*
FROM cycle
WHERE cid = 1
AND pid IN ( SELECT pid
             FROM cycle
             WHERE cid = 2))a, customer, product
WHERE a.cid = customer.cid
AND a.pid = product.pid;

SELECT cycle.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.pid IN ( SELECT pid
             FROM cycle
             WHERE cid = 2)
AND cycle.cid = customer.cid
AND cycle.pid = product.pid;

             
SELECT *
FROM customer;

SELECT *
FROM customer
WHERE cnm = 'brown'
AND cid = 1;

SELECT *
FROM product
WHERE pid = 100;


-- 매니저가 존재하는 직원을 조회(king을 제외한 13명의 데이터가 조회)
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- EXSITS 조건에 만족하는 행이 존재 하는지 확인하는 연산자
-- 다른 연산자와 다르게 WHERE 절에 컬럼을 기술하지 않는다
--    WHERE empno = 7369
--    WHERE EXSITS (SELECT 'X'
--                  FROM .....);

-- 매니저가 존재하는 직월을 EXISTS 연산자를 통해 조회
-- 매니저도 직원
SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X'
              FROM emp m
              WHERE e.mgr = m.empno);
              
-- sub9
-- 1번 고객이 애음하는 제품 ==> 100, 400
SELECT *
FROM product p
WHERE EXISTS (SELECT 'X'
              FROM cycle c
              WHERE c.cid =1
              AND p.pid = c.pid);


select *
from product;

select *
from cycle;

-- sub10
SELECT *
FROM product p
WHERE NOT EXISTS (SELECT 'X'
              FROM cycle c
              WHERE c.cid =1
              AND p.pid = c.pid);

-- 집합연산
-- 합집합 : UNION - 중복제거(집합개념) / UNION ALL - 중복을 제거하지 않음(속도 향상)
-- 교집합 : INTERSECT (집합개념)
-- 차집합 : MINUS (집합개념)
-- 집합연산 공통사항
-- 두 집합의 컬럼의 개수, 타입이 일치 해야 한다

--동일한 집합을 합집하기 때문에 중복되는 데이터는 한번만 적용된다
SELECT empno, ename
FROM emp 
WHERE empno IN (7566, 7698)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

-- UNION ALL연산자는 UNION 연산자와 다르게 중복을 허용한다
SELECT empno, ename
FROM emp 
WHERE empno IN (7566, 7698)

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

-- INTERSECT (교집합) : 위, 아래 집합에서 값이 같은 행만 조회
SELECT empno, ename
FROM emp 
WHERE empno IN (7566, 7698, 7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

-- MINUS(차집합) : 위 집합에서 아래 집합의 데이터를 제거한 나머지 집합
SELECT empno, ename
FROM emp 
WHERE empno IN (7566, 7698, 7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

--집합의 기술 순서가 영향이 가는 집합 연산자
-- A UNION B    B UNION A ==> 같음
-- A UNION ALL B    B UNION ALL A ==> 같음(집합)
-- A INTERSECT B    B INTERSECT A ==> 같음
-- A MINUS B    B  MINUS A ==> 다름

-- 집합연산의 결과 컬럼 이름은 첫번째 집합의 컬럼명을 따른다
SELECT 'X' fir, 'B' sec
FROM dual

UNION

SELECT 'Y', 'A'
FROM dual;

-- 정렬(ORDER BY)는 집합연산 가장 마지막 집합 다음에 기술

SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (10, 20)

UNION

SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (30, 40)
ORDER BY DEPTNO;

-- 햄버거 도시 발전지수

SELECT *
FROM fastfood;

SELECT *
FROM fastfood
GROUP by sido;

-- 시도, 시군구, 버거지수
-- 버거지수 값이 높은 도시가 먼저 나오도록 정렬
-- 버거지수 ==> (kfc개수 + 버거킹개수 + 맥도날드개수 + )/ 롯데리아 개수
SELECT count(*)
FROM fastfood;

SELECT gb, sido, sigungu  
FROM fastfood
WHERE sido IN ('대전광역시') AND sigungu IN ('중구'); 

-- 대전시 대덕구 버거지수 :
-- 대전시 중구 버거지수 :
-- 대전시 서구 버거지수 :
-- 대전시 유성구 버거지수 :
-- 대전시 동구 버거지수 :