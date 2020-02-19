-- ���� ���� ��� 11��
-- ����¡ ó��(�������� 10���� �Խñ�)
-- 1������ : 1~10
-- 2������ : 11~20
-- ���ε庯�� : page, :pageSize
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

-- ������ �м��Լ��� ����ؼ� ǥ���ϸ�.. (20200218 ����)
-- �μ��� �޿� ��ŷ
SELECT ename, sal, deptno, ROW_NUMBER () OVER (PARTITION BY deptno ORDER BY sal DESC) rank 
FROM emp;

-- �м��Լ� ����
-- �м��Լ���([����]) OVER ([PARTITION BY �÷�] [ORDER BY �÷�] [WINDOWING])
-- PARTITION BY �÷� : �ش� �÷��� ���� ROW ���� �ϳ��� �׷����� ���´�
-- ORDER BY �÷� : PARTITOIN BY�� ���� ���� �׷� ������ ORDER BY �÷����� ����
-- ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rank; 

-- ���� ���� �м��Լ�
-- RANK() : ���� ���� ������ �ߺ� ������ ����, �ļ����� �ߺ� ����ŭ ������ ������ ����
--          2���� 2���̸� 3���� ���� 4����� �ļ����� �����ȴ�
-- DENSE_RANK() : ���� ���� ������ �ߺ� ������ ����, �ļ����� �ߺ����� �������� ����
--                  2���� 2���̴��� �ļ����� 3����� ����
-- ROW_NUMBER() : ROWNUM�� ����, �ߺ��� ���� �������� ����

-- �μ���, �޿� ������ 3���� ��ŷ �����Լ��� ����
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

-- ������ �м��Լ� (GROUP �Լ����� �����ϴ� �Լ� ������ ����)
-- SUM(�÷�)
-- COUNT(*), COUNT(�÷�)
-- MIN(�÷�)
-- MAX(�÷�)
-- AVG(�÷�)

-- no_ana2�� �м��Լ��� ����Ͽ� �ۼ�
-- �μ��� ���� ��
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

-- �޿��� �������� �����ϰ�, �޿��� ���� ���� �Ի����ڰ� ��������� ���� �켱������ �ǵ��� �����Ͽ�
-- �������� ������(LEAD)�� sal �÷��� ���ϴ� ���� �ۼ�
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
      
-- no_ana3�� �м��Լ��� �̿��Ͽ� sql �ۼ�
SELECT empno, ename, sal, sum(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) cumm_sal
FROM emp;

-- �������� �������� ���� ������� ���� ���డ�� �� 3������ sal �հ� ���ϱ�
SELECT empno, ename, sal, SUM(sal) OVER(ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)c_sum
FROM emp;

-- ana7
-- ORDER BY ����� WINDOWING ���� ������� ������� ���� WINDOWNG�� �⺻ ������ ����ȴ�
-- RANGE UNDOUNDED PRECDIGNG
-- RANGE BETWEEN UNBOUNDED PRECDING AND CURRENT ROW
SELECT empno, ename, sal, SUM(sal) OVER(PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)c_sum
FROM emp;

-- WINDOWING �� RANGE, ROWS��
-- RANGE : ������ ���� ����, ���� ���� ������ �÷����� �ڽ��� ������ ���
-- ROWS : �������� ���� ����

SELECT empno, ename, deptno, sal,
        SUM(sal) OVER(PARTITION BY deptno ORDER BY sal ROWS UNBOUNDED PRECEDING)row_,
        SUM(sal) OVER(PARTITION BY deptno ORDER BY sal RANGE UNBOUNDED PRECEDING)range_,
        SUM(sal) OVER(PARTITION BY deptno ORDER BY sal )default_
FROM emp;_