SELECT *
FROM CUSTOMER;

SELECT *
FROM PRODUCT;

SELECT *
FROM CYCLE;

-- 판매점 : 200~250
-- 고객당 2.5개 제품
-- 하루 : 500~750
-- 한달 : 15000~ 17500

SELECT *
FROM daily;

SELECT *
FROM batch;

--- join 4 : join을 하면서 row를 제한하는 조건을 결합
SELECT c.cid,c.cnm, y.pid, y.day, y.cnt
FROM customer c, cycle y
WHERE y.cid = c.cid
AND c.cnm IN ('brown', 'sally'); 

--- join 5: join을 하면서(3개) row를 제한하는 조건을 결합
SELECT c.cid,c.cnm, y.pid,p.pnm, y.day, y.cnt
FROM customer c, cycle y, product p
WHERE y.cid = c.cid
AND y.pid = p.pid
AND c.cnm IN ('brown', 'sally'); 

--- join 6 : join을 하면서 (3개) row를 제한하는 조건을 결합, 그룹함수 적용
SELECT cu.cid, cu.cnm, c.pid, p.pnm, SUM(c.cnt)cnt
FROM customer cu, cycle c, product p  
WHERE cu.cid = c.cid AND c.pid = p.pid
GROUP BY cu.cid, cu.cnm, c.pid, p.pnm;

select *
from customer;

select *
from cycle;

select *
from product;

--- join 7, 8~13 hr에서 (과제)

-- outer join
-- 두 테이블을 조인할 때 연결 조건을 만족 시키지 못하는 데이터를
-- 기준으로 지정한 테이블의 데이터만이라도 조회 되게끔 하는 조인 방식

-- 연결조건 : e.mgr = m.empno --> king의 mgr null이기 때문에 조인에 실패한다
-- emp 테이블의 데이터는 총 14건 이지만 아래와 같은 쿼리에서는 결과가 13건이 된다 (1건이 조인실패)
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

-- ansi outer
-- 1. 조인에 실패하더라도 조회가될 테이블을 선정 (매니저 정보가 없어도 사원정보는 나오게끔)
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON e.mgr = m.empno;

-- right outer로 변경
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp m RIGHT OUTER JOIN emp e ON e.mgr = m.empno;


-- oracle outer join
-- 데이터가 없는 쪽의 테이블 컬럼 뒤에 (+) 기호를 붙혀준다.
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

-- 위의 sql을 ansi sql(outer join)으로 변경해보세요
-- 매니저의 부서번호가 10번인 직원만 조회
-- 아래 left outer 조인은 실질적으로 outer 조인이 아니다
-- 아래 inner 조인과 결과가 동일하다
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno AND m.deptno = 10);

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
WHERE m.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE m.deptno = 10;

-- 오라클 outer join
-- 오라클 outer join시 기준 테이블의 반대편 테이블의 모든 컬럼에 (+)를 붙여야 정삭적인 outer join으로 동작한다
-- 한 컬럼이라도 (+)를 누락하면 inner 조인으로 동작

-- 아래 oracle outer 조인은 inner 조인으로 동작 --> m.deptno 컬럼에 (+)가 붙지 않음
SELECT  e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno = 10;

SELECT  e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;

-- 사원 - 매니저간 right outer join
SELECT empno, ename, mgr
FROM emp e;

SELECT empno, ename
FROM emp m;

SELECT e.empno, e.ename, e.mgr, m.empno, e.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);

-- full outer : left outer + right outer - 중복 제거
-- left outter : 14건, right outter : 29건
SELECT e.empno, e.ename, e.mgr, m.empno, e.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

-- outer join 1
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM prod p LEFT OUTER JOIN buyprod b ON (b.buy_prod = p.prod_id AND b.buy_date ='2005/01/25');

-- 오라클 outer join에서는 (+)기호를 이용하여 full outer 문법을 지원하지 않는다
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM prod p , buyprod b
WHERE p.prod_id = b.buy_prod(+)
AND b.buy_date(+) = '2005/01/25';

select *
from prod;

select *
from buyprod;

SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_date 
FROM prod p, buyprod b
WHERE p.prod_id = b.buy_prod(+)
AND b.buy_date(+) = TO_DATE('20150125' , 'YYYYMMDD');

