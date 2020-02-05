-- sub5
SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT*
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1);
                  
-- sub6
SELECT pid
FROM cycle 
WHERE cid = 2;

SELECT*
FROM product
WHERE pid NOT IN (200, 300, 400);

SELECT *
FROM product;

SELECT*
FROM cycle
WHERE cid = 1
AND pid IN ( SELECT pid
             FROM cycle
             WHERE cid = 2);
             
-- sub7
SELECT a.cid, customer.cnm, a.pid, product.pnm, a.day, a.cnt
FROM
(SELECT*
FROM cycle
WHERE cid = 1
AND pid IN ( SELECT pid
             FROM cycle
             WHERE cid = 2))a, customer, product
WHERE a.cid = customer.cid
AND a.pid = product.pid;

SELECT cycle.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.pid IN ( SELECT pid
             FROM cycle
             WHERE cid = 2)
AND cycle.cid = customer.cid
AND cycle.pid = product.pid;

             
SELECT *
FROM customer;

SELECT *
FROM customer
WHERE cnm = 'brown'
AND cid = 1;

SELECT *
FROM product
WHERE pid = 100;


-- �Ŵ����� �����ϴ� ������ ��ȸ(king�� ������ 13���� �����Ͱ� ��ȸ)
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- EXSITS ���ǿ� �����ϴ� ���� ���� �ϴ��� Ȯ���ϴ� ������
-- �ٸ� �����ڿ� �ٸ��� WHERE ���� �÷��� ������� �ʴ´�
--    WHERE empno = 7369
--    WHERE EXSITS (SELECT 'X'
--                  FROM .....);

-- �Ŵ����� �����ϴ� ������ EXISTS �����ڸ� ���� ��ȸ
-- �Ŵ����� ����
SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X'
              FROM emp m
              WHERE e.mgr = m.empno);
              
-- sub9
-- 1�� ���� �����ϴ� ��ǰ ==> 100, 400
SELECT *
FROM product p
WHERE EXISTS (SELECT 'X'
              FROM cycle c
              WHERE c.cid =1
              AND p.pid = c.pid);


select *
from product;

select *
from cycle;

-- sub10
SELECT *
FROM product p
WHERE NOT EXISTS (SELECT 'X'
              FROM cycle c
              WHERE c.cid =1
              AND p.pid = c.pid);

-- ���տ���
-- ������ : UNION - �ߺ�����(���հ���) / UNION ALL - �ߺ��� �������� ����(�ӵ� ���)
-- ������ : INTERSECT (���հ���)
-- ������ : MINUS (���հ���)
-- ���տ��� �������
-- �� ������ �÷��� ����, Ÿ���� ��ġ �ؾ� �Ѵ�

--������ ������ �����ϱ� ������ �ߺ��Ǵ� �����ʹ� �ѹ��� ����ȴ�
SELECT empno, ename
FROM emp 
WHERE empno IN (7566, 7698)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

-- UNION ALL�����ڴ� UNION �����ڿ� �ٸ��� �ߺ��� ����Ѵ�
SELECT empno, ename
FROM emp 
WHERE empno IN (7566, 7698)

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

-- INTERSECT (������) : ��, �Ʒ� ���տ��� ���� ���� �ุ ��ȸ
SELECT empno, ename
FROM emp 
WHERE empno IN (7566, 7698, 7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

-- MINUS(������) : �� ���տ��� �Ʒ� ������ �����͸� ������ ������ ����
SELECT empno, ename
FROM emp 
WHERE empno IN (7566, 7698, 7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

--������ ��� ������ ������ ���� ���� ������
-- A UNION B    B UNION A ==> ����
-- A UNION ALL B    B UNION ALL A ==> ����(����)
-- A INTERSECT B    B INTERSECT A ==> ����
-- A MINUS B    B  MINUS A ==> �ٸ�

-- ���տ����� ��� �÷� �̸��� ù��° ������ �÷����� ������
SELECT 'X' fir, 'B' sec
FROM dual

UNION

SELECT 'Y', 'A'
FROM dual;

-- ����(ORDER BY)�� ���տ��� ���� ������ ���� ������ ���

SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (10, 20)

UNION

SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (30, 40)
ORDER BY DEPTNO;

-- �ܹ��� ���� ��������

SELECT *
FROM fastfood;

SELECT *
FROM fastfood
GROUP by sido;

-- �õ�, �ñ���, ��������
-- �������� ���� ���� ���ð� ���� �������� ����
-- �������� ==> (kfc���� + ����ŷ���� + �Ƶ����尳�� + )/ �Ե����� ����
SELECT count(*)
FROM fastfood;

SELECT gb, sido, sigungu  
FROM fastfood
WHERE sido IN ('����������') AND sigungu IN ('�߱�'); 

-- ������ ����� �������� :
-- ������ �߱� �������� :
-- ������ ���� �������� :
-- ������ ������ �������� :
-- ������ ���� �������� :