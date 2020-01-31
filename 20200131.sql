-- JOIN (�߿��ϴ�)
-- RDBMS�� �ߺ��� �ּ�ȭ �ϴ� ������ �����ͺ��̽�
-- �ٸ� ���̺�� �����Ͽ� �����͸� ��ȸ


-- JOIN �� ���̺��� �����ϴ� �۾�
-- JOIN ����
-- 1. ANSI ����
-- 2. ORACLE ����


-- Natural Join
-- �� ���̺� �÷����� ���� �� �ش� �÷����� ����(����)
-- emp, dept ���̺��� deptno ��� �÷��� ����
SELECT *
FROM emp NATURAL JOIN dept;

-- Natural join�� ���� ���� �÷�(deptno)�� ������(ex: ���̺��, ���̺� ��Ī)�� ������� �ʰ�
-- �÷��� ����Ѵ� (dept.deptno --> deptno)
SELECT emp.empno, emp.ename, dept.dname, deptno
FROM emp NATURAL JOIN dept;

-- ���̺� ���� ��Ī�� ��밡��
SELECT e.empno, e.ename, d.dname, deptno
FROM emp e NATURAL JOIN dept d;

-- ORACLE JOIN
-- FROM ���� ������ ���̺� ����� ,�� �����Ͽ� �����Ѵ�
-- ������ ���̺��� ���������� WHERE���� ����Ѵ�
-- emp, dept ���̺� �����ϴ� deptno �÷��� [���� ��] ����
SELECT emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- ����Ŭ ������ ���̺� ��Ī
SELECT e.empno, e.ename, d.dname, e.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- ANSI : join with USING
-- ���� �Ϸ��� �ΰ��� ���̺� �̸��� ���� �÷��� �ΰ������� �ϳ��� �÷����θ� ������ �ϰ��� �Ҷ�
-- �����Ϸ��� ���� �÷��� ���
-- emp, dept ���̺��� ���� �÷� : deptno
SELECT emp.ename, dept.dname, deptno
FROM emp JOIN dept USING(deptno);

-- JOIN WITH USING�� ORACLE�� ǥ���ϸ�?
SELECT emp.ename, dept.dname, emp.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- ANSI : JOIN WITH ON
-- ���� �Ϸ����ϴ� ���̺��� �÷� �̸��� ���� �ٸ���
SELECT emp.ename, dept.dname, emp.deptno
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

-- SELF JOIN : ���� ���̺��� ����
-- ex) emp ���̺��� �����Ǵ� ����� ������ ����� �̿��Ͽ� ������ �̸��� ��ȸ�Ҷ�
SELECT e.empno, e.ename, m.empno,  m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno);

--����Ŭ �������� �ۼ�
SELECT e.empno, e.ename , m.empno, m.ename
FROM emp e , emp m
WHERE e.mgr = m.empno;

-- equal ���� : =
-- non-equal ���� : !=, >, <, BETWEEN AND

-- ����� �޿� ������ �޿� ��� ���̺��� �̿��Ͽ� �ش����� �޿� ����� ���غ���
SELECT ename, sal, salgrade.grade
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;

SELECT *
FROM salgrade;

-- ANSI ������ �̿��Ͽ� ���� ���� ���� �ۼ�
SELECT e.ename, e.sal, s.grade 
FROM emp e JOIN salgrade s ON (e.sal BETWEEN s.losal AND s.hisal);

--- JOIN 0
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno);

--- join 0-1
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.deptno != 20
ORDER BY deptno; 

--- join 0-2
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.sal >= 2500
ORDER BY deptno;

--- join 0-3
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.sal >= 2500
AND e.empno > 7600;

--- join 0-4
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.sal >= 2500
AND e.empno > 7600
AND d.dname = 'RESEARCH';

-- PROD : PROD_LGU
-- LPROD : LPROD_GU

--- join 1
SELECT *
FROM prod;

SELECT *
FROM lprod;

SELECT l.lprod_gu, l.lprod_nm, p.prod_id, p.prod_name 
FROM prod p, lprod l
WHERE p.prod_lgu = l.lprod_gu;

--- join 2
SELECT b.buyer_id, b.buyer_name, p.prod_id, p.prod_name
FROM buyer b, prod p
WHERE b.buyer_id = p.prod_buyer;

SELECT * 
FROM buyer;

--- join 3
SELECT m.mem_id, m.mem_name, p.prod_id, p.prod_name, c.cart_qty
FROM member m, cart c, prod p 
WHERE m.mem_id = c.cart_member AND c.cart_prod= p.prod_id ;

select * 
from cart;