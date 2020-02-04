-- cross join --> īƼ�� ���δ�Ʈ(cartesian product)
-- �����ϴ� �� ���̺��� ���� ������ �����Ǵ� ���
-- ������ ��� ���տ� ���� ����(����)�� �õ�
--dept(4��), emp(14)�� cross join�� ����� 4*14 = 56��
-- dept ���̺�� emp���̺��� ������ �ϱ� ���� from ���� �ΰ��� ���̺��� ��� 
-- where���� �� ���̺��� ���� ������ ����

SELECT dept.dname, emp.empno, emp.ename
FROM dept, emp
WHERE dept.deptno = 10
AND dept.deptno = emp.deptno;

-- cross 1
SELECT *
FROM customer c, product p;


select *
from customer;

select *
from product;

-- subquery : �����ȿ� �ٸ� ������ �� �ִ� ���
-- subquery�� ���� ��ġ�� ���� 3������ �з�
-- SELECT �� : SCALAR SUBQUERY : �ϳ��� ��, �ϳ��� �÷��� �����ؾ� ������ �߻����� ����
-- FROM �� : INLINE - VIEW (VIEW)
-- WHERE �� : SUBQUERY QUERY


-- ���ϰ��� �ϴ� ��
-- SMITH�� ���� �μ��� ���ϴ� �������� ������ ��ȸ
-- 1.SMITH�� ���ϴ� �μ� ��ȣ�� ���Ѵ�
-- 2. 1������ ���� �μ� ��ȣ�� ���ϴ� ������ ������ ��ȸ�Ѵ�

-- 1.
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

-- 2. 1������ ���� �μ���ȣ�� �̿��Ͽ� �ش� �μ��� ���ϴ� ���� ������ ��ȸ 
SELECT *
FROM emp
WHERE deptno = 20;

-- subquery�� �̿��ϸ� �ΰ��� ������ ���ÿ� �ϳ��� sql�� ������ ����
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');

-- sub1 
-- 1. ��� �޿� ���ϱ�
-- 2. ���� ��� �޿����� ���� �޿��� �޴»��
SELECT COUNT(*) 
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);

-- sub2
SELECT * 
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);

-- ������ ������
-- IN : ���������� �������� ��ġ�ϴ� ���� ���� �� ��
-- ANY (Ȱ�뵵�� �ټ� ������) : ���������� �������� �� ���̶� ������ ������ ��
-- ALL (Ȱ�뵵�� �ټ� ������) : ���������� �������� ��� �࿡ ���� ������ ������ ��

-- sub3
-- SMITH�� ���ϴ� �μ��� ��� ������ ��ȸ
-- SMITH�� WARD ������ ���ϴ� �μ��� ��� ������ ��ȸ

-- ���������� ����� ���� ���� ���� = �����ڸ� ������� �� �Ѵ�
SELECT *
FROM emp
WHERE deptno IN (20, 30);

SELECT *
FROM emp
WHERE ename IN ('SMITH', 'WARD');

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH','WARD'));
                 
-- SMITH, WARD ����� �޿����� �޿��� ���� ������ ��ȸ(SMITH, WARD�� �޿��� �ƹ��ų�)
-- SMITH : 800
-- WARD : 1250
-- ==> 1250���� ���� ���
SELECT*
FROM emp
WHERE sal < ANY (800, 1250);

SELECT sal
FROM emp
WHERE ename IN ('SMITH', 'WARD');

SELECT*
FROM emp
WHERE sal < ANY (SELECT sal
                 FROM emp
                 WHERE ename IN ('SMITH','WARD'));

-- SMITH, WARD ����� �޿����� �޿��� ���� ������ ��ȸ(SMITH, WARD�� �޿� 2���� ��ο� ���� ������)
-- SMITH : 800
-- WARD : 1250
-- ==> 1250���� �޿��� ���� ���
SELECT*
FROM emp
WHERE sal > ALL (SELECT sal
                 FROM emp
                 WHERE ename IN ('SMITH','WARD'));
                 

-- IN, NOT IN�� NULL�� ���õ� ���� ����;

-- ������ ������ ����� 7902 �̰ų� null;
-- IN �����ڴ� OR �����ڷ� ġȯ ����
SELECT *
FROM emp
WHERE mgr IN (7902, null);

-- null �񱳴� = �����ڰ� �ƴ϶� IS NULL�� �� �ؾ������� IN�����ڴ� =�� ����Ѵ�
SELECT *
FROM emp
WHERE mgr = 7902
OR mgr = null;

-- NOT IN (7902, null) ==> AND
-- �����ȣ�� 7902�� �ƴϸ鼭(AND) null�� �ƴ� ������
SELECT *
FROM emp
WHERE empno NOT IN (7902, null);

SELECT *
FROM emp
WHERE empno != 7902
AND empno IS NOT NULL;

-- pairwise(������)
-- �������� ����� ���ÿ� ���� ��ų��
-- (mgr, deptno)
-- (7698, 30), (7839, 10)
SELECT *
FROM emp
WHERE(mgr, deptno)IN(SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN(7499, 7782));


-- non-piarwise�� �������� ���ÿ� ������Ű�� ���� ���·� �ۼ�
-- mgr ���� 7698 �̰ų� 7839 �̸鼭
-- deptno�� 10 �̰ų� 30���� ����
-- mgr, deptno
-- (7698, 10) (7698, 30)
-- (7839, 10) (7839, 30)
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE deptno IN (7499, 7782))
AND deptno IN (SELECT deptno
               FROM emp
               WHERE empno IN (7499, 7782));

-- ��Į�� �������� : SELECT ���� ���, 1���� ROW, 1���� COL�� ��ȸ�ϴ� ����
-- ��Į�� ���������� MAIN ������ �÷��� ����ϴ°� �����ϴ�
SELECT (SELECT SYSDATE
        FROM dual), dept.*
FROM dept;

SELECT empno, ename, deptno, (SELECT dname FROM dept WHERE deptno = emp.deptno) dname
FROM emp;

-- INLINE VIEW : FROM ���� ����Ǵ� ��������

-- MAIN ������ �÷��� SUBQUERY ���� ��� �ϴ��� ������ ���� �з�
-- ��� �� ��� : correlated subquery(��ȣ ���� ����), ���������� �ܵ����� ���� �ϴ°� �Ұ���
--              ��������� �������ִ� (main ==> sub)
-- ������� ������� : non-correlated subquery(���ȣ ���� ��������), ���������� �ܵ����� �����ϴ°� ����
--                  ��������� ������ ���� �ʴ�(main ==> sub, sub ==> main)

-- ��� ������ �޿� ��պ��� �޿��� ���� ����� ��ȸ
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
-- ������ ���� �μ��� �޿� ��պ��� �޿��� ���� ����� ��ȸ
SELECT *
FROM emp m
WHERE sal > (SELECT AVG(sal)
             FROM emp  s
             WHERE s.deptno = m.deptno);
             
-- ���� ������ ������ �̿��ؼ� Ǯ���
-- 1. ���� ���̺� ����
--    emp, �μ��� �޿� ���(inline view)
SELECT emp.*--emp.ename, sal, dept_sal.*
FROM emp, (SELECT deptno, ROUND(AVG(sal))avg_sal 
            FROM emp 
            GROUP BY deptno)dept_sal
WHERE emp.deptno = dept_sal.deptno
AND emp.sal > dept_sal.avg_sal;

-- sub4
-- ������ �߰�
INSERT INTO dept VALUES (99, 'ddit', 'deajeon');
COMMIT;

-- ROLLBACK; -- Ʈ����� ���
-- COMMIT; -- Ʈ����� Ȯ��

-- ���� �غ���
SELECT dept.*
FROM dept m, (SELECT deptno, dname , loc
           FROM dept s
           GROUP BY deptno)
WHERE m.dname = s.dname
AND deptno = 99;

select *
from emp;