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

-- 3��° �ε����� ������
-- 3,4��° �ε����� �÷� ������ �����ϰ� ������ �ٸ���

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

-- 1.����
-- 2�� ���̺� ����
-- ������ ���̺� �ε��� 5����  �ִٸ�
-- �� ���̺��� ���� ���� : 6 (36 * 2 = 72)
-- ORACLE - �ǽð� ���� : OLTP ( ON LINE TRANSACTION PROCESSING)
--          ��ü ó���ð� : OLAP (ON LINE ANALYSIS PROCESSING) - ������ ������ �����ȹ�� ����µ� (30M ~ 1H)


-- emp ���� ������ dept ���� ������?

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
