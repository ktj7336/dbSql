-- sub7

select sido, sigungu, gb
from fastfood
where sido in ('대전광역시') and sigungu in ('대덕구') 
order by gb; -- 0.28


select sido, sigungu, gb
from fastfood
where sido in ('대전광역시') and sigungu in ('중구') 
order by gb; -- 1.16



select sido, sigungu, gb
from fastfood
where sido in ('대전광역시') and sigungu in ('서구') 
order by gb; -- 1.21


-- 분자(kfc, 버거킹, 맥도날드)
SELECT sido, sigungu, COUNT(*)
FROM fastfood
WHERE sido = '대전광역시'
AND gb IN ('KFC','버거킹','맥도날드')
GROUP BY sido, sigungu;

-- 대전시 롯데리아
SELECT sido, sigungu, COUNT(*)
FROM fastfood
WHERE sido = '대전광역시'
AND gb IN ('롯데리아')
GROUP BY sido, sigungu;

SELECT a.sido, a.sigungu, ROUND(a.c1/b.c2, 2) hambuger_score
FROM(
SELECT sido, sigungu, COUNT(*) c1
FROM fastfood
WHERE /*sido = '대전광역시'
AND*/ gb IN ('KFC','버거킹','맥도날드')
GROUP BY sido, sigungu)a,

(SELECT sido, sigungu, COUNT(*) c2
FROM fastfood
WHERE /*sido = '대전광역시'
AND*/ gb IN ('롯데리아')
GROUP BY sido, sigungu)b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY hambuger_score DESC;

--fastfood 테이블을 한번만 읽는 방식으로 작성하기
SELECT sido, sigungu, ROUND((kfc+ BURGERKING + mac) / lot, 2) burger_score
FROM 
(SELECT sido, sigungu,
                     NVL(SUM ((DECODE(gb, 'KFC', 1)),0)kfc, NVL(SUM (DECODE(gb, '버거킹', 1)),0)BURGERKING,
                     NVL(SUM (DECODE(gb, '맥도날드', 1)),0)mac ,NVL(SUM(DECODE(gb, '롯데리아' , 1)),1) lot
FROM fastfood
WHERE gb IN ('KFC' , '버거킹' , '맥도날드' , '롯데리아')
GROUP BY sido, sigungu)
ORDER BY burger_score DESC;

SELECT sido, sigungu, ROUND(sal/people) pri_sal
FROM tax
ORDER BY pri_sal DESC;

-- 햄버거 지수, 개인별 근로소득 금액 순위가 같은 시도별로 (조인)
-- 지수, 개인별 근로소득 금액으로 정렬후 rownum을 통해 순위를 부여 같은 순위의 행끼리 조인
-- 햄버거지수 시도, 햄버거지수 시군구, 햄버거지수, 세금 시도, 세금 시군구, 개인별 근로소득액
-- 서울특별시 중구 5.56         서울특별시 강남구 70
-- 서울특별시 도봉구 5          서울특별시 서초구 69
-- 경기도 구리시                서울특별시 용산구 57
-- 서울특별시 강남구 4.57       경기도 과천시 54
-- 서울특별시 서초구 4          서울특별시 종로구 47

SELECT sido, sigungu, ROUND((kfc+ BURGERKING + mac) / lot, 2) burger_score
FROM 
(SELECT sido, sigungu,
                     NVL (SUM ((DECODE(gb, 'KFC', 1)),0)kfc, NVL SUM( (DECODE(gb, '버거킹', 1)),0)BURGERKING,
                     NVL (SUM ((DECODE(gb, '맥도날드', 1)),0)mac ,NVL SUM(
                     (DECODE(gb, '롯데리아' , 1)),1) lot
FROM fastfood  
WHERE gb IN ('KFC' , '버거킹' , '맥도날드' , '롯데리아')
GROUP BY sido, sigungu)
ORDER BY burger_score DESC;


-- ROWNUM 사용시 주의
-- 1. SELECT ==> ORDER BY
--    정렬된 결과에 ROWNUM을 적용하기 위해서는 INLINE-VIEW
-- 2. 1번부터 순차적으로 조회가 되는 조건에 대해서만 WHERE 절에서 기술이 가능
--    ROWNUM = 1 (O)
--    ROWNUM = 2 (X)
--    ROWNUM < 10 (O)
--    ROWNUM > 10 (X)

SELECT b.sido, b.sigungu, b.burger_score, a.sido, a.sigungu, a.pri_sal
FROM 
(SELECT ROWNUM rn, a.*
FROM 
(SELECT sido, sigungu, ROUND(sal/people) pri_sal
 FROM tax
 ORDER BY pri_sal DESC) a) a,

(SELECT ROWNUM rn, b.*
FROM
(SELECT sido, sigungu, ROUND((kfc + BURGERKING + mac) / lot, 2) burger_score
FROM 
(SELECT sido, sigungu, 
       NVL(SUM(DECODE(gb, 'KFC', 1)), 0) kfc, NVL(SUM(DECODE(gb, '버거킹', 1)), 0) BURGERKING,
       NVL(SUM(DECODE(gb, '맥도날드', 1)), 0) mac, NVL(SUM(DECODE(gb, '롯데리아', 1)), 1) lot       
FROM fastfood
WHERE gb IN ('KFC', '버거킹', '맥도날드', '롯데리아')
GROUP BY sido, sigungu)
ORDER BY burger_score DESC) b ) b
WHERE a.rn = b.rn;

-- empno 컬럼은 not null 제약 조건이 있다 - insert 시 반드시 값이 존재해야 정상적으로 입력된다
-- empno 컬럼을 제외한 나머지 컬럼은 nulltable 이다 (null 값이 저장될수 있다)
INSERT INTO emp (empno, ename, job)
VALUES ( 9999, 'brown', NULL);

SELECT *
FROM emp;

INSERT INTO emp (ename, job)
VALUES ('sally' , 'SALESMAN');

-- 문자열 : '문자열' ==> "문자열"
-- 숫자 : 10 
-- 날짜 : to_date('20200206' , 'YYYYMMDD'), sysdate

-- emp 테이블의 hiredate 컬럼은 date 타입
-- emp 테이블의 8개 컬럼에 값을 입력
DESC emp;
INSERT INTO emp VALUES (9998, 'sally', 'SALESMAN' , NULL, SYSDATE, 1000, NULL, 99); 
ROLLBACK;

-- 여러건의 데이터를 한번에 INSERT :
-- INSERT INTO 테이블명 (컬럼명1, 컬럼명2..)
-- SELECT...
-- FROM ;
INSERT INTO emp
SELECT 9998, 'sally', 'SALESMAN', NULL, SYSDATE , 1000, NULL, 99
FROM dual
UNION ALL
SELECT 9999, 'brown', 'CLERK', NULL, TO_DATE('20200205', 'YYYYMMDD'), 1100 , NULL , 99
FROM dual;

SELECT *
FROM emp;

-- update 쿼리
-- update 테이블명 컬럼명 1 = 갱신할 컬럼 값 1, 컬럼명 2 = 갱신할 컬럼 값2,.......
-- where 행 제한 조건 
-- 업데이트 쿼리 작성시 where 절이 존재하지 않으면 해당 테이블의 모등 행을 대상을 업데이트가 일어난다
-- update, delete 절에 where절이 없으면 의도한게 맞는지 다시한번 확인한다

-- where절이 있다고 하더라도 해당 조건으로 해당 테이블을 select 하는 쿼리를 작성하여 실행하면
-- update 대상 행을 조회 할수 있으므로 확인 하고 실행하는 것도 사고 발생 방지에 도움이 된다

-- 99번 부서번호를 갖는 부서 정보가 dept테이블에 있는 상황
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

SELECT*
FROM dept;

-- 99번 부서번호를 갖는 부서의 dname 컬럼의 값을 '대덕IT', ioc 컬럼의 값을 '영민빌딩'으로 업데이트
UPDATE dept SET dname = '대덕IT', loc = '영민빌딩'
WHERE deptno = 99;

ROLLBACK;

-- 10 ==> subquery
-- SMITH, WARD이 속한 부서에 소속된 직원 정보
SELECT *
FROM emp
WHERE deptno IN (20, 30);

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));
                 
-- update시에도 서브 쿼리 사용이 가능
INSERT INTO emp (empno, ename)VALUES (9999, 'brown');
-- 9999번 사원 deptno, job 정보를 SMITH 사원이 속한 부서정보, 담당업무로 업데이트;

UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH'),
                job = (SELECT job FROM emp WHERE ename = 'SMITH')
WHERE empno = 9999;

SELECT *
FROM emp;

-- delete sql : 특정 행을 삭제
-- delete [from] 테이블명
-- where 행 제한 조건;
SELECT *
FROM dept;
-- 99번 부서번호에 해당하는 부서 정보 삭제
DELETE dept
WHERE deptno = 99;
COMMIT;

-- subquery를 통해서 특정 행을 제한하는 조건을 갖는 delete
-- 매니저가 7698 사번인 직원을 삭제 하는 쿼리를 작성
DELETE emp
WHERE empno = 7698;

DELETE emp
WHERE empno IN (SELECT empno
                FROM emp
                WHERE mgr = 7698);

SELECT *
FROM emp;

ROLLBACK;

-- 트랜잭션 : 여러 단계의 과정을 하나의 작업 행위로 묶는 단위
