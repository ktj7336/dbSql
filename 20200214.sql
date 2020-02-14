-- MERGE : SELECT�ϰ� ���� �����Ͱ� ��ȸ�Ǹ� UPDATE
--         SELECT�ϰ� ���� �����Ͱ� ��ȸ���� ������ IMSERT
-- SELECT + UPDATE / SELECT + INSERT ==> MERGE

-- REPRORT GROUP FUNCTION
-- 1. ROLLUP
--      - GROUP BY ROLLUP (�÷�1, �÷�2)
--      - ROLLUP���� ����� �÷��� �����ʿ��� �ϳ��� ������ �÷����� SUBGROUP
--      - GROUP �÷�1, �÷�2
--        UNION
--        GROUP BY �÷�1
--        UNION
--        GROUP BY 
-- 2. CUBE
-- 3. GROUPING SET 

-- report group function 3
SELECT deptno, job, sum(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP (deptno, job);

-- report group function 4
SELECT * 
FROM emp;

SELECT *
FROM dept;

SELECT d.dname, e.job, sum(sal + NVL(comm, 0)) sal
FROM emp e, dept d
WHERE e.deptno =  d.deptno
GROUP BY ROLLUP (d.dname, e.job);

SELECT b.dname, a.job, a.sal 
FROM 
(SELECT deptno, job, sum(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP (deptno, job)) a, dept b
WHERE a.deptno = b.deptno(+);

-- report group function 5
SELECT DECODE(GROUPING(d.dname),1,'����',0,d.dname) dname, 
               e.job, sum(sal + NVL(comm, 0)) sal
FROM emp e, dept d
WHERE e.deptno =  d.deptno
GROUP BY ROLLUP (d.dname, e.job);

-- REPORT GROUP FUNCTION 
-- 1. ROLLUP
-- 2. CUBE
-- 3. GROUPINGS SETS
-- Ȱ�뵵
-- 3,1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>> CUBE

-- GROUPING SETS
-- ������ ������� ���� �׷��� ����ڰ� ���� ����
-- ����� : GROUP BY GROUPING SETS(col1, col2....)
-- GROUP BY GROUPINGS SETS(col1, col2)
-- ==>
-- GROUP BY col1
-- UNION ALL
-- GROUP BY col2

-- GROUP BY GROUPING SET( (col1,col2),col3,col4)
-- ==>
-- GROUP BY col1, col2
-- UNION ALL
-- GROUP BY col3
-- UNION ALL
-- GROUP BY col4

-- GROUP SETS�� ��� �÷� ��� ������ ����� ������ ��ġ�� �ʴ´�
-- ROLLUP�� �÷� ��� ������ ��� ������ ��ģ��

-- GROUP BY GROUPING SETS(col1, col2)  
-- ==>
-- GROUP BY col1   
-- UNION 
-- GROUP BY col2


-- GROUP BY GROUPING SETS(col2, col1)  
-- ==>
-- GROUP BY col2   
-- UNION ALL
-- GROUP BY col1

SELECT job, deptno, SUM(sal) sal
FROM emp
GROUP BY GROUPING SETS(job, deptno);

-- GROUP BY GROUPING SETS(job, deptno)
-- ==>
-- GROUP BY job
-- UNION ALL
-- GROUP BY deptno;

SELECT job, SUM(sal)sal
FROM emp
GROUP BY GROUPING SETS(job, job);

-- job, deptno�� GROUP BY �� ����� 
-- mgr GROUP BY�� ����� ��ȸ�ϴ� sql�� GROUPING SETS�� �޿��� SUM(sal)�ۼ�
SELECT job, deptno, mgr, SUM(sal) sal
FROM emp
GROUP BY GROUPING SETS ((job, deptno),mgr);

-- CUBE
-- ������ ����������� �÷��� ������ sub group�� �����Ѵ�
-- �� ����� �÷��� ������ ��Ų��
-- EX : GROUP BY CUBE(col1, col2)

-- (col1, col2) ==>
-- (null, col2) == GROUP BY col2
-- (unll, null) == GROUP BY ��ü
-- (col1, null) == GROUP BY col1
-- (col1, col2) == GROUP BY col1, col2

-- ���� �÷�3���� CUBE���� ����� ��� ���ü� �ִ� ��������?

SELECT job, deptno, SUM(sal) sal
FROM emp
GROUP BY CUBE (job, deptno);

-- ȥ��
SELECT job, deptno, sum(sal) sal
FROM emp
GROUP BY job, rollup(deptno), CUBE(mgr);

-- GROUP BY job, deptno, mgr == GROUP BY job, deptno, mgr
-- GROUP BY job, deptno == GROUP BY job, deptno
-- GROUP BY job, null, mgr == GROUP BY job, mgr
-- GROUP BY job, null, null  == GROUP BY job

-- �������� update
-- 1. emp_test ���̺� drop
-- 2. emp ���̺��� �̿��ؼ� emp_test ���̺����(��� �࿡ ���� ctas)
-- 3. emp_test ���̺� dname VARCHAR2(14) �÷��߰�
-- 4. emp_test.dname �÷��� dept ���̺��� �̿��ؼ� �μ����� ������Ʈ
DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT *
FROM emp;


ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT * 
FROM emp_test;

UPDATE emp_test SET dname = (SELECT dname
                             FROM dept
                             WHERE dept.deptno = emp_test_deptno);

COMMIT;

-- �ǽ�

DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

SELECT * 
FROM dept_test;

SELECT *
FROM emp;

ALTER TABLE dept_test ADD (empcnt NUMBER);

UPDATE dept_test SET empcnt = (SELECT COUNT(deptno)
                               FROM emp
                               WHERE emp.deptno = dept_test.deptno);
                               
-- sub_a2
-- dept_test���̺� �ִ� �μ��߿� ������ ������ ���� �μ� ������ ����
-- dept_test.empcnt �÷��� ������� �ʰ�
-- emp ���̺��� �̿��Ͽ� ����
INSERT INTO dept_test VALUES (99, 'it1', 'daejeon',0);
INSERT INTO dept_test VALUES (98, 'it2', 'daejeon',0);
COMMIT;

-- ������ ������ ���� �μ� ���� ��ȸ
-- ���� �ִ� ����
-- 10�� �μ��� ���� �ִ� ����?
SELECT*
FROM dept_test;

-- sub_a3
UPDATE emp_test a SET sal = sal +200
WHERE sal < (SELECT AVG(sal)
             FROM emp_test b
             WHERE a.deptno = b. deptno);
select *
from emp_test;

-- WITH ��
-- �ϳ��� Ŀ������ �ݺ��Ǵ� subquery�� ���� ��
-- �ش� subquery�� ������ �����Ͽ� ����

-- MAIN������ ����� �� WITH ������ ���� ���� �޸𸮿� �ӽ������� ����
-- ==> MAIN ������ ���� �Ǹ� �޸� ����

-- SUBQUERY �ۼ��ÿ��� �ش� SUBQUERY�� ����� ��ȸ�ϱ� ���ؼ� I/O �ݺ������� �Ͼ���� 
-- WITH���� ���� �����Ϸ��� �ѹ��� SUBQUERY�� ����ǰ� �� ����� �޸𸮿� ������ ���� ����
-- ��, �ϳ��� �������� ������ subquery�� �ݺ������� �����°Ŵ� �߸� �ۼ��� sql�� Ȯ���� ����

-- WITH ��������̸� AS (
--     ��������
-- )
-- SELECT *
-- FROM ��������̸�

-- ������ �μ��� �޿� ����� ��ȸ�ϴ� ��������� WITH���� ���� ����
WITH sal_avg_dept AS(
    SELECT deptno, ROUND(AVG(sal),2) sal
    FROM emp
    GROUP BY deptno
),
    dept_empcnt AS(
    SELECT deptno, COUNT(*) empcnt
    FROM emp
    GROUP BY deptno)
SELECT *
FROM sal_avg_dept a, dept_empcnt b
WHERE a.deptno = b.deptno;

SELECT *
FROM sal_avg_dept a, sal_avg_dept b;

-- WITH���� �̿��� �׽�Ʈ ���̺� �ۼ�
WITH temp AS(
    SELECT sysdate -1 FROM dual UNION ALL
    SELECT sysdate -2 FROM dual UNION ALL
    SELECT sysdate -3 FROM dual)
SELECT *
FROM temp;

-- �޷¸����
-- CONNECT BY LEVEL <[=] ����
-- �ش� ���̺��� ���� ���� ��ŭ �����ϰ�, ������ ���� �����ϱ� ���ؼ� LEVEL�� �ο�
-- LEVEL�� 1���� ����
SELECT *
FROM dual
CONNECT BY LEVEL <= 10;

SELECT dept.*, LEVEL
FROM dept
CONNECT BY LEVEL <= 5;

-- 2020�� 2���� �޷��� ����
-- :dt = 202002, 202003
-- 1.
SELECT TO_DATE('202002', 'YYYYMM')  + (LEVEL -1),
      TO_CHAR(TO_DATE('202002', 'YYYYMM')  + (LEVEL -1), 'D'),
      DECODE (TO_CHAR(TO_DATE('202002', 'YYYYMM')  + (LEVEL -1), 'D'),1 ,
      TO_DATE('202002' , 'YYYYMM') + (LEVEL -1))s,
      DECODE (TO_CHAR(TO_DATE('202002', 'YYYYMM')  + (LEVEL -1), 'D'),2 ,
      TO_DATE('202002' , 'YYYYMM') + (LEVEL -1))m,
      DECODE (TO_CHAR(TO_DATE('202002', 'YYYYMM')  + (LEVEL -1), 'D'),3 ,
      TO_DATE('202002' , 'YYYYMM') + (LEVEL -1))t,
      DECODE (TO_CHAR(TO_DATE('202002', 'YYYYMM')  + (LEVEL -1), 'D'),4 ,
      TO_DATE('202002' , 'YYYYMM') + (LEVEL -1))w,
      DECODE (TO_CHAR(TO_DATE('202002', 'YYYYMM')  + (LEVEL -1), 'D'),5 ,
      TO_DATE('202002' , 'YYYYMM') + (LEVEL -1))t2,
      DECODE (TO_CHAR(TO_DATE('202002', 'YYYYMM')  + (LEVEL -1), 'D'),6 ,
      TO_DATE('202002' , 'YYYYMM') + (LEVEL -1))f,
      DECODE (TO_CHAR(TO_DATE('202002', 'YYYYMM')  + (LEVEL -1), 'D'),7 ,
      TO_DATE('202002' , 'YYYYMM') + (LEVEL -1))s2
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY (TO_DATE('202002', 'YYYYMM')),'DD');

SELECT TO_CHAR(LAST_DAY (TO_DATE('202002', 'YYYYMM')),'DD')
FROM dual;