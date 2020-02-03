SELECT *
FROM CUSTOMER;

SELECT *
FROM PRODUCT;

SELECT *
FROM CYCLE;

-- �Ǹ��� : 200~250
-- ���� 2.5�� ��ǰ
-- �Ϸ� : 500~750
-- �Ѵ� : 15000~ 17500

SELECT *
FROM daily;

SELECT *
FROM batch;

--- join 4 : join�� �ϸ鼭 row�� �����ϴ� ������ ����
SELECT c.cid,c.cnm, y.pid, y.day, y.cnt
FROM customer c, cycle y
WHERE y.cid = c.cid
AND c.cnm IN ('brown', 'sally'); 

--- join 5: join�� �ϸ鼭(3��) row�� �����ϴ� ������ ����
SELECT c.cid,c.cnm, y.pid,p.pnm, y.day, y.cnt
FROM customer c, cycle y, product p
WHERE y.cid = c.cid
AND y.pid = p.pid
AND c.cnm IN ('brown', 'sally'); 

--- join 6 : join�� �ϸ鼭 (3��) row�� �����ϴ� ������ ����, �׷��Լ� ����
SELECT cu.cid, cu.cnm, c.pid, p.pnm, SUM(c.cnt)cnt
FROM customer cu, cycle c, product p  
WHERE cu.cid = c.cid AND c.pid = p.pid
GROUP BY cu.cid, cu.cnm, c.pid, p.pnm;

select *
from customer;

select *
from cycle;

select *
from product;

--- join 7, 8~13 hr���� (����)

-- outer join
-- �� ���̺��� ������ �� ���� ������ ���� ��Ű�� ���ϴ� �����͸�
-- �������� ������ ���̺��� �����͸��̶� ��ȸ �ǰԲ� �ϴ� ���� ���

-- �������� : e.mgr = m.empno --> king�� mgr null�̱� ������ ���ο� �����Ѵ�
-- emp ���̺��� �����ʹ� �� 14�� ������ �Ʒ��� ���� ���������� ����� 13���� �ȴ� (1���� ���ν���)
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

-- ansi outer
-- 1. ���ο� �����ϴ��� ��ȸ���� ���̺��� ���� (�Ŵ��� ������ ��� ��������� �����Բ�)
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON e.mgr = m.empno;

-- right outer�� ����
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp m RIGHT OUTER JOIN emp e ON e.mgr = m.empno;


-- oracle outer join
-- �����Ͱ� ���� ���� ���̺� �÷� �ڿ� (+) ��ȣ�� �����ش�.
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

-- ���� sql�� ansi sql(outer join)���� �����غ�����
-- �Ŵ����� �μ���ȣ�� 10���� ������ ��ȸ
-- �Ʒ� left outer ������ ���������� outer ������ �ƴϴ�
-- �Ʒ� inner ���ΰ� ����� �����ϴ�
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno AND m.deptno = 10);

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
WHERE m.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE m.deptno = 10;

-- ����Ŭ outer join
-- ����Ŭ outer join�� ���� ���̺��� �ݴ��� ���̺��� ��� �÷��� (+)�� �ٿ��� �������� outer join���� �����Ѵ�
-- �� �÷��̶� (+)�� �����ϸ� inner �������� ����

-- �Ʒ� oracle outer ������ inner �������� ���� --> m.deptno �÷��� (+)�� ���� ����
SELECT  e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno = 10;

SELECT  e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;

-- ��� - �Ŵ����� right outer join
SELECT empno, ename, mgr
FROM emp e;

SELECT empno, ename
FROM emp m;

SELECT e.empno, e.ename, e.mgr, m.empno, e.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);

-- full outer : left outer + right outer - �ߺ� ����
-- left outter : 14��, right outter : 29��
SELECT e.empno, e.ename, e.mgr, m.empno, e.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

-- outer join 1
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM prod p LEFT OUTER JOIN buyprod b ON (b.buy_prod = p.prod_id AND b.buy_date ='2005/01/25');

-- ����Ŭ outer join������ (+)��ȣ�� �̿��Ͽ� full outer ������ �������� �ʴ´�
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM prod p , buyprod b
WHERE p.prod_id = b.buy_prod(+)
AND b.buy_date(+) = '2005/01/25';

select *
from prod;

select *
from buyprod;

SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_date 
FROM prod p, buyprod b
WHERE p.prod_id = b.buy_prod(+)
AND b.buy_date(+) = TO_DATE('20150125' , 'YYYYMMDD');

