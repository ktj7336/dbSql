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
-- ���س⵵�� ¦���̸�
--  �Ի�⵵�� ¦���� �� �ǰ����� �����
--  �Ի�⵵�� Ȧ���� �� �ǰ����� ������
-- ���س⵵�� Ȧ���̸�
--  �Ի�⵵�� ¦���� �� �ǰ����� ������
--  �Ի�⵵�� Ȧ���� �� �ǰ����� �����

-- ���س⵵�� ¦������, Ȧ������ Ȯ��
-- DATE Ÿ�� -> ���ڿ�(�������� ����, YYYY-MM-DD HH24:MI:SS)
-- ¦�� -> 2�� �������� ������ 0
-- Ȧ�� -> 2�� �������� ������ 1
SELECT MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), 2)
FROM dual;

SELECT empno, ename, hiredate,
          MOD(TO_NUMBER(TO_CHAR(hiredate, 'YYYY')), 2)hire,
          MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), 2),
          CASE
                WHEN MOD(TO_NUMBER(TO_CHAR(hiredate, 'YYYY')), 2) = MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), 2)
                    THEN '�ǰ����� �����'
                ELSE '�ǰ����� ������'
          END CONTATCT_TO_DOCTOR
FROM emp;

-- GROUP BY ���� ���� ����
-- �μ���ȣ ���� ROW ���� ���� ��� : GROUP BY deptno
-- ������ ���� ROW ���� ���� ��� : GROUP BY job
-- MGR�� ���� �������� ���� ROW ���� ���� ��� : GROUP BY mgr, job

-- �׷��Լ��� ����
-- SUM : �հ� 
-- COUNT : ����  -NULL ���� �ƴ� ROW�� ����)
-- MAX : �ִ밪
-- MIN : �ּҰ�
-- AVG : ���

-- �׷��Լ��� Ư¡
-- �ش� �÷��� NULL���� ���� ROW�� ������ ��� �ش� ���� �����ϰ� ����Ѵ� (NULL ������ ����� null)


-- �μ��� �޿� ��

-- �׷��Լ� ������
-- GROUP BY ���� ���� �÷��̿��� �ٸ��÷��� SELECT���� ǥ���Ǹ� ����
SELECT deptno, ename, 
        SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal), ROUND(AVG(sal),2), COUNT(sal)
FROM emp
GROUP BY deptno, ename;

-- GROUP BY ���� ���� ���¿��� �׷��Լ��� ����� ���
-- --> ��ü���� �ϳ��� ������ ���´�
SELECT  SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal), ROUND(AVG(sal),2), 
        COUNT(sal), -- sal �÷��� ���� null�� �ƴ� row�� ����
        COUNT(comm), -- COMM �÷��� ���� null�� �ƴ� row�� ����
        COUNT(*) -- ����� �����Ͱ� �ִ���
FROM emp;

-- GROUP BY�� ������  empno�̸� ������� ���??
-- �׷�ȭ�� ���þ��� ������ ���ڿ�, �Լ�, ���ڵ��� SELCET���� ������ ���� ����
SELECT  SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal), ROUND(AVG(sal),2), 
        COUNT(sal),
        COUNT(comm), 
        COUNT(*)
FROM emp
GROUP BY empno;

-- SINGLE ROW FUNCTION�� ��� WHERE ������ ����ϴ� ���� �����ϳ�
-- MULTI ROW FUNCTION (GROUP FUNCTION)�� ��� WHERE ������ ����ϴ� ���� �Ұ��� �ϰ�
-- HAVING ������ ������ ����Ѵ�

-- �μ��� �޿� �� ��ȸ, �� �޿����� 9000�̻��� row�� ��ȸ
-- deptno, �޿���
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
-- ORACLE 9i ���� ������ GROUP BY���� ����� �÷����� ������ ����
-- ORACLE 10G ���� ���ʹ� GROUP BY���� ����� �÷����� ������ ���� ���� �ʴ´� (GROUP BY ����� �ӵ� UP)

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
-- �μ��� ���� �ִ��� : 10, 20, 30 --> 3���� row�� ����
-- >���̺��� row ���� ��ȸ : GROUP BY ���� COUNT(*)
-- �迭
SELECT COUNT(*)cnt
FROM
(SELECT deptno, COUNT(deptno) cnt 
 FROM emp
 GROUP BY deptno);

