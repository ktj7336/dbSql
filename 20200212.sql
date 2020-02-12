explain plan for
SELECT*
FROM emp 
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE (dbms_xplan.display);

CREATE INDEX idx_n_emp_03 ON emp (job, ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT*
FROM TABLE(dbms_xplan.display);

SELECT *
FROM emp
ORDER BY job, ename;

-- 1.table full
-- 2. idx1 : empno
-- 3. idx2 : job
-- 4. idx3 : job + ename
-- 5. idx4 : ename + job;

CREATE INDEX idx_n_emp04 ON emp (ename, job);

SELECT ename, job, rowid
FROM emp
ORDER BY ename , job;

-- 3번째 인덱스를 지우자
-- 3,4번째 인덱스가 컬럼 구성이 동일하고 순서만 다르다

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

-- emp - table full, pk_emp(empno)
-- dept - table full, pk_dept(deptno)

-- (emp - table full, dept - table full)
-- (emp - table full, dept-pk_dept)
-- (emp-pk_emp, dept-table full)
-- (emp-pk_emp, dept-pk_dept)

-- 1.순서
-- 2개 테이블 조인
-- 각각의 테이블에 인덱스 5개씩  있다면
-- 한 테이블의 접근 전략 : 6 (36 * 2 = 72)
-- ORACLE - 실시간 응답 : OLTP ( ON LINE TRANSACTION PROCESSING)
--          전체 처리시간 : OLAP (ON LINE ANALYSIS PROCESSING) - 복잡한 쿼리의 실행계획을 세우는데 (30M ~ 1H)


-- emp 부터 읽을까 dept 부터 읽을까?

explain plan for
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.empno = 7788;

SELECT *
FROM TABLE(dbms_xplan.display);

CREATE TABLE dept_test2 AS
SELECT *
FROM dept
WHERE 1 = 1;

-- idx1
CREATE UNIQUE INDEX idx_u_dept_test2 ON dept_test2 (deptno);

CREATE INDEX idx_n_dept_test2 ON dept_test2 (dname);

CREATE INDEX idx_n_dept_test2_01 ON dept_test2 (deptno, dname);

-- idx2
DROP INDEX idx_u_dept_test2;
DROP INDEX idx_n_dept_test2;
DROP INDEX idx_n_dept_test2_01;

-- idx3

CREATE UNIQUE INDEX idx_u_emp_01 ON emp (empno);
