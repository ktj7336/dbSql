-- 쿼리 실행 결과 11건
-- 페이징 처리(페이지당 10건의 게시글)
-- 1페이지 : 1~10
-- 2페이지 : 11~20
-- 바인드변수 : page, :pageSize
SELECT seq, lpad(' ', (LEVEL-1)*4) || title title, DECODE(parent_seq, NULL, seq, parent_seq) root
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY root desc, seq asc;


SELECT*
FROM
(SELECT  a.*,ROWNUM rn
FROM
(SELECT seq, lpad(' ', (LEVEL-1)*4) || title title, DECODE(parent_seq, NULL, seq, parent_seq) root
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY root desc, seq asc)a)
WHERE rn BETWEEN (:page -1)* :pageSize + 1 AND :page * :pageSize ;

-- 쿼리를 분석함수를 사용해서 표현하면.. (20200218 과제)
-- 부서별 급여 랭킹
SELECT ename, sal, deptno, ROW_NUMBER () OVER (PARTITION BY deptno ORDER BY sal DESC) rank 
FROM emp;

-- 분석함수 문법
-- 분석함수명([인자]) OVER ([PARTITION BY 컬럼] [ORDER BY 컬럼] [WINDOWING])
-- PARTITION BY 컬럼 : 해당 컬럼이 같은 ROW 끼리 하나의 그룹으로 묶는다
-- ORDER BY 컬럼 : PARTITOIN BY에 의해 묶은 그룹 내에서 ORDER BY 컬럼으로 정렬
-- ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rank; 

-- 순위 관련 분석함수
-- RANK() : 같은 값을 가질때 중복 순위를 인정, 후순위는 중복 값만큼 떨어진 값부터 시작
--          2등이 2명이면 3등은 없고 4등부터 후순위가 생성된다
-- DENSE_RANK() : 같은 값을 가질때 중복 순위를 인정, 후순위는 중복순위 다음부터 시작
--                  2등이 2명이더라도 후순위는 3등부터 시작
-- ROW_NUMBER() : ROWNUM과 유사, 중복된 값을 혀용하지 않음

-- 부서별, 급여 순위를 3개의 랭킹 관련함수를 적용
SELECT ename, sal, deptno,
        RANK() OVER (PARTITION BY deptno ORDER BY sal) sal_rank,
        DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal) sal_dense_rank,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) sal_row_rank
FROM EMP;

-- ana1
SELECT empno, ename, sal, deptno,
        RANK() OVER (ORDER BY sal) sal_rank,
        DENSE_RANK() OVER (ORDER BY sal) sal_dense_rank,
        ROW_NUMBER() OVER (ORDER BY sal) sal_row_rank
FROM emp;

-- ana2

SELECT empno, ename, emp.deptno, cnt
FROM emp,
    (SELECT deptno, COUNT(*)
     FROM emp
     GROUP BY deptno)dept_cnt
WHERE emp.deptno = dept_cnt.deptno;

-- 통계관련 분석함수 (GROUP 함수에서 제공하는 함수 종류와 동일)
-- SUM(컬럼)
-- COUNT(*), COUNT(컬럼)
-- MIN(컬럼)
-- MAX(컬럼)
-- AVG(컬럼)

-- no_ana2를 분석함수를 사용하여 작성
-- 부서별 직원 수
SELECT empno, ename, deptno, COUNT(*) OVER(PARTITION BY deptno) cnt
FROM emp;

-- ana2
SELECT empno, ename, sal, deptno, ROUND(AVG(sal) OVER (PARTITION BY deptno),2)avg_sal
FROM emp;

-- ana3
SELECT empno, ename, sal, deptno, MAX(sal) OVER(PARTITION BY deptno) max_sal
FROM emp;

-- ana4
SELECT empno, ename, sal, deptno, MIN(sal) OVER(PARTITION BY deptno) min_sal
FROM emp;

-- 급여를 내림차순 정렬하고, 급여가 같을 때는 입사일자가 빠른사람이 높은 우선순위가 되도록 정렬하여
-- 현재행의 대음행(LEAD)의 sal 컬럼을 구하는 쿼리 작성
SELECT empno, ename, hiredate, sal, LEAD(sal) OVER(ORDER BY sal DESC, hiredate) lead_sal
FROM emp;

-- ana5 
SELECT empno, ename, hiredate, sal, LAG(sal) OVER(ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

-- ana6
SELECT empno, ename, hiredate, job, sal, LAG(job) OVER(PARTITION BY job ORDER BY sal DESC) lag_sal
FROM emp;

-- no_ana3
--SELECT *
--FROM
--    (SELECT a.*, ROWNUM rn
--     FROM 
--     (SELECT *
--      FROM emp
--      ORDER BY sal, emp) a)A;
      
-- no_ana3을 분석함수를 이용하여 sql 작성
SELECT empno, ename, sal, sum(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) cumm_sal
FROM emp;

-- 현재행을 기준으로 이전 한행부터 이후 한행가지 총 3개행의 sal 합계 구하기
SELECT empno, ename, sal, SUM(sal) OVER(ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)c_sum
FROM emp;

-- ana7
-- ORDER BY 기술후 WINDOWING 절을 기술하지 않을경우 다음 WINDOWNG이 기본 값으로 적용된다
-- RANGE UNDOUNDED PRECDIGNG
-- RANGE BETWEEN UNBOUNDED PRECDING AND CURRENT ROW
SELECT empno, ename, sal, SUM(sal) OVER(PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)c_sum
FROM emp;

-- WINDOWING 의 RANGE, ROWS비교
-- RANGE : 논리적인 행의 단위, 같은 값을 가지는 컬럼까지 자신의 행으로 취급
-- ROWS : 물리적인 행의 단위

SELECT empno, ename, deptno, sal,
        SUM(sal) OVER(PARTITION BY deptno ORDER BY sal ROWS UNBOUNDED PRECEDING)row_,
        SUM(sal) OVER(PARTITION BY deptno ORDER BY sal RANGE UNBOUNDED PRECEDING)range_,
        SUM(sal) OVER(PARTITION BY deptno ORDER BY sal )default_
FROM emp;_