-- cond 1
SELECT empno, ename,
        CASE WHEN deptno = 10 THEN 'ACCOUNTING'
             WHEN deptno = 20 THEN 'RESEARCH'
             WHEN deptno = 30 THEN 'SALES'
             WHEN deptno = 40 THEN 'OPERATIONS'
             ELSE 'DDIT'
        END DNAME

FROM emp;

-- cond 2
-- 올해년도가 짝수이면
--  입사년도가 짝수일 때 건강검진 대상자
--  입사년도가 홀수일 때 건강검진 비대상자
-- 올해년도가 홀수이면
--  입사년도가 짝수일 때 건강검진 비대상자
--  입사년도가 홀수일 때 건강검진 대상자

-- 올해년도가 짝수인지, 홀수인지 확인
-- DATE 타입 -> 문자열(여러가지 포맷, YYYY-MM-DD HH24:MI:SS)
-- 짝수 -> 2로 나눴을때 나머지 0
-- 홀수 -> 2로 나눴을때 나머지 1
SELECT MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), 2)
FROM dual;

SELECT empno, ename, hiredate,
          MOD(TO_NUMBER(TO_CHAR(hiredate, 'YYYY')), 2)hire,
          MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), 2),
          CASE
                WHEN MOD(TO_NUMBER(TO_CHAR(hiredate, 'YYYY')), 2) = MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), 2)
                    THEN '건강검진 대상자'
                ELSE '건강검진 비대상자'
          END CONTATCT_TO_DOCTOR
FROM emp;

-- GROUP BY 행을 묶을 기준
-- 부서번호 같은 ROW 끼리 묶는 경우 : GROUP BY deptno
-- 담당업무 같은 ROW 끼리 묶는 경우 : GROUP BY job
-- MGR가 같고 담당업무가 같은 ROW 끼리 묶는 경우 : GROUP BY mgr, job

-- 그룹함수의 종류
-- SUM : 합계 
-- COUNT : 갯수  -NULL 값이 아닌 ROW의 갯수)
-- MAX : 최대값
-- MIN : 최소값
-- AVG : 평균

-- 그룹함수의 특징
-- 해당 컬럼에 NULL값을 갖는 ROW가 존재할 경우 해당 값은 무시하고 계산한다 (NULL 연산의 결과는 null)


-- 부서별 급여 합

-- 그룹함수 주위점
-- GROUP BY 절에 나온 컬럼이외의 다른컬럼이 SELECT절에 표현되면 에러
SELECT deptno, ename, 
        SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal), ROUND(AVG(sal),2), COUNT(sal)
FROM emp
GROUP BY deptno, ename;

-- GROUP BY 절이 없는 상태에서 그룹함수를 사용한 경우
-- --> 전체행을 하나의 행으로 묶는다
SELECT  SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal), ROUND(AVG(sal),2), 
        COUNT(sal), -- sal 컬럼의 값이 null이 아닌 row의 갯수
        COUNT(comm), -- COMM 컬럼의 값이 null이 아닌 row의 갯수
        COUNT(*) -- 몇건의 데이터가 있는지
FROM emp;

-- GROUP BY의 기준이  empno이면 결과수가 몇건??
-- 그룹화와 관련없는 임의의 문자열, 함수, 숫자등은 SELCET절에 나오는 것이 가능
SELECT  SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal), ROUND(AVG(sal),2), 
        COUNT(sal),
        COUNT(comm), 
        COUNT(*)
FROM emp
GROUP BY empno;

-- SINGLE ROW FUNCTION의 경우 WHERE 절에서 사용하는 것이 가능하나
-- MULTI ROW FUNCTION (GROUP FUNCTION)의 경우 WHERE 절에서 사용하는 것이 불가능 하고
-- HAVING 절에서 조건을 기술한다

-- 부서별 급여 합 조회, 단 급여합이 9000이상인 row만 조회
-- deptno, 급여합
SELECT deptno, SUM(sal) sum_sal
FROM emp
GROUP BY deptno
HAVING SUM(sal) > 9000;

-- grp1
SELECT MAX(sal) max_sal, MIN(sal)min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal, COUNT(sal)count_sal,
       COUNT(mgr)count_mgr, COUNT(*)count_all
FROM emp;

-- grp2
SELECT deptno, 
       MAX(sal) max_sal, MIN(sal)min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal, COUNT(sal)count_sal,
       COUNT(mgr)count_mgr, COUNT(*)count_all
FROM emp
GROUP BY deptno;

-- grp3
SELECT 
        CASE WHEN deptno = 10 THEN 'ACCOUNTING'
             WHEN deptno = 20 THEN 'RESEARCH'
             WHEN deptno = 30 THEN 'SALES'
        END dname,
        MAX(sal) max_sal, MIN(sal)min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal, COUNT(sal)count_sal,
       COUNT(mgr)count_mgr, COUNT(*)count_all
       
FROM emp
GROUP BY deptno
ORDER BY deptno;

-- grp4
-- ORACLE 9i 이전 까지는 GROUP BY절에 기술한 컬럼으로 정렬을 보정
-- ORACLE 10G 이후 부터는 GROUP BY절에 기술한 컬럼으로 정렬을 보장 하지 않는다 (GROUP BY 연산시 속도 UP)

SELECT TO_CHAR(hiredate, 'YYYYMM')hire_YYYYMM, COUNT(TO_CHAR(hiredate, 'YYYYMM'))cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM')
ORDER BY TO_CHAR(hiredate, 'YYYYMM');

-- grp 5

SELECT TO_CHAR(hiredate, 'YYYY')hire_YYYY, COUNT(TO_CHAR(hiredate, 'YYYY'))cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY')
ORDER BY TO_CHAR(hiredate, 'YYYY');

-- grp 6
SELECT COUNT(*)cnt
FROM dept;

-- grp 7
-- 부서가 뭐가 있는지 : 10, 20, 30 --> 3개의 row가 존재
-- >테이블의 row 수를 조회 : GROUP BY 없이 COUNT(*)
-- 배열
SELECT COUNT(*)cnt
FROM
(SELECT deptno, COUNT(deptno) cnt 
 FROM emp
 GROUP BY deptno);

