-- sub7

select sido, sigungu, gb
from fastfood
where sido in ('����������') and sigungu in ('�����') 
order by gb; -- 0.28


select sido, sigungu, gb
from fastfood
where sido in ('����������') and sigungu in ('�߱�') 
order by gb; -- 1.16



select sido, sigungu, gb
from fastfood
where sido in ('����������') and sigungu in ('����') 
order by gb; -- 1.21


-- ����(kfc, ����ŷ, �Ƶ�����)
SELECT sido, sigungu, COUNT(*)
FROM fastfood
WHERE sido = '����������'
AND gb IN ('KFC','����ŷ','�Ƶ�����')
GROUP BY sido, sigungu;

-- ������ �Ե�����
SELECT sido, sigungu, COUNT(*)
FROM fastfood
WHERE sido = '����������'
AND gb IN ('�Ե�����')
GROUP BY sido, sigungu;

SELECT a.sido, a.sigungu, ROUND(a.c1/b.c2, 2) hambuger_score
FROM(
SELECT sido, sigungu, COUNT(*) c1
FROM fastfood
WHERE /*sido = '����������'
AND*/ gb IN ('KFC','����ŷ','�Ƶ�����')
GROUP BY sido, sigungu)a,

(SELECT sido, sigungu, COUNT(*) c2
FROM fastfood
WHERE /*sido = '����������'
AND*/ gb IN ('�Ե�����')
GROUP BY sido, sigungu)b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY hambuger_score DESC;

--fastfood ���̺��� �ѹ��� �д� ������� �ۼ��ϱ�
SELECT sido, sigungu, ROUND((kfc+ BURGERKING + mac) / lot, 2) burger_score
FROM 
(SELECT sido, sigungu,
                     NVL(SUM ((DECODE(gb, 'KFC', 1)),0)kfc, NVL(SUM (DECODE(gb, '����ŷ', 1)),0)BURGERKING,
                     NVL(SUM (DECODE(gb, '�Ƶ�����', 1)),0)mac ,NVL(SUM(DECODE(gb, '�Ե�����' , 1)),1) lot
FROM fastfood
WHERE gb IN ('KFC' , '����ŷ' , '�Ƶ�����' , '�Ե�����')
GROUP BY sido, sigungu)
ORDER BY burger_score DESC;

SELECT sido, sigungu, ROUND(sal/people) pri_sal
FROM tax
ORDER BY pri_sal DESC;

-- �ܹ��� ����, ���κ� �ٷμҵ� �ݾ� ������ ���� �õ����� (����)
-- ����, ���κ� �ٷμҵ� �ݾ����� ������ rownum�� ���� ������ �ο� ���� ������ �ೢ�� ����
-- �ܹ������� �õ�, �ܹ������� �ñ���, �ܹ�������, ���� �õ�, ���� �ñ���, ���κ� �ٷμҵ��
-- ����Ư���� �߱� 5.56         ����Ư���� ������ 70
-- ����Ư���� ������ 5          ����Ư���� ���ʱ� 69
-- ��⵵ ������                ����Ư���� ��걸 57
-- ����Ư���� ������ 4.57       ��⵵ ��õ�� 54
-- ����Ư���� ���ʱ� 4          ����Ư���� ���α� 47

SELECT sido, sigungu, ROUND((kfc+ BURGERKING + mac) / lot, 2) burger_score
FROM 
(SELECT sido, sigungu,
                     NVL (SUM ((DECODE(gb, 'KFC', 1)),0)kfc, NVL SUM( (DECODE(gb, '����ŷ', 1)),0)BURGERKING,
                     NVL (SUM ((DECODE(gb, '�Ƶ�����', 1)),0)mac ,NVL SUM(
                     (DECODE(gb, '�Ե�����' , 1)),1) lot
FROM fastfood  
WHERE gb IN ('KFC' , '����ŷ' , '�Ƶ�����' , '�Ե�����')
GROUP BY sido, sigungu)
ORDER BY burger_score DESC;


-- ROWNUM ���� ����
-- 1. SELECT ==> ORDER BY
--    ���ĵ� ����� ROWNUM�� �����ϱ� ���ؼ��� INLINE-VIEW
-- 2. 1������ ���������� ��ȸ�� �Ǵ� ���ǿ� ���ؼ��� WHERE ������ ����� ����
--    ROWNUM = 1 (O)
--    ROWNUM = 2 (X)
--    ROWNUM < 10 (O)
--    ROWNUM > 10 (X)

SELECT b.sido, b.sigungu, b.burger_score, a.sido, a.sigungu, a.pri_sal
FROM 
(SELECT ROWNUM rn, a.*
FROM 
(SELECT sido, sigungu, ROUND(sal/people) pri_sal
 FROM tax
 ORDER BY pri_sal DESC) a) a,

(SELECT ROWNUM rn, b.*
FROM
(SELECT sido, sigungu, ROUND((kfc + BURGERKING + mac) / lot, 2) burger_score
FROM 
(SELECT sido, sigungu, 
       NVL(SUM(DECODE(gb, 'KFC', 1)), 0) kfc, NVL(SUM(DECODE(gb, '����ŷ', 1)), 0) BURGERKING,
       NVL(SUM(DECODE(gb, '�Ƶ�����', 1)), 0) mac, NVL(SUM(DECODE(gb, '�Ե�����', 1)), 1) lot       
FROM fastfood
WHERE gb IN ('KFC', '����ŷ', '�Ƶ�����', '�Ե�����')
GROUP BY sido, sigungu)
ORDER BY burger_score DESC) b ) b
WHERE a.rn = b.rn;

-- empno �÷��� not null ���� ������ �ִ� - insert �� �ݵ�� ���� �����ؾ� ���������� �Էµȴ�
-- empno �÷��� ������ ������ �÷��� nulltable �̴� (null ���� ����ɼ� �ִ�)
INSERT INTO emp (empno, ename, job)
VALUES ( 9999, 'brown', NULL);

SELECT *
FROM emp;

INSERT INTO emp (ename, job)
VALUES ('sally' , 'SALESMAN');

-- ���ڿ� : '���ڿ�' ==> "���ڿ�"
-- ���� : 10 
-- ��¥ : to_date('20200206' , 'YYYYMMDD'), sysdate

-- emp ���̺��� hiredate �÷��� date Ÿ��
-- emp ���̺��� 8�� �÷��� ���� �Է�
DESC emp;
INSERT INTO emp VALUES (9998, 'sally', 'SALESMAN' , NULL, SYSDATE, 1000, NULL, 99); 
ROLLBACK;

-- �������� �����͸� �ѹ��� INSERT :
-- INSERT INTO ���̺�� (�÷���1, �÷���2..)
-- SELECT...
-- FROM ;
INSERT INTO emp
SELECT 9998, 'sally', 'SALESMAN', NULL, SYSDATE , 1000, NULL, 99
FROM dual
UNION ALL
SELECT 9999, 'brown', 'CLERK', NULL, TO_DATE('20200205', 'YYYYMMDD'), 1100 , NULL , 99
FROM dual;

SELECT *
FROM emp;

-- update ����
-- update ���̺�� �÷��� 1 = ������ �÷� �� 1, �÷��� 2 = ������ �÷� ��2,.......
-- where �� ���� ���� 
-- ������Ʈ ���� �ۼ��� where ���� �������� ������ �ش� ���̺��� ��� ���� ����� ������Ʈ�� �Ͼ��
-- update, delete ���� where���� ������ �ǵ��Ѱ� �´��� �ٽ��ѹ� Ȯ���Ѵ�

-- where���� �ִٰ� �ϴ��� �ش� �������� �ش� ���̺��� select �ϴ� ������ �ۼ��Ͽ� �����ϸ�
-- update ��� ���� ��ȸ �Ҽ� �����Ƿ� Ȯ�� �ϰ� �����ϴ� �͵� ��� �߻� ������ ������ �ȴ�

-- 99�� �μ���ȣ�� ���� �μ� ������ dept���̺� �ִ� ��Ȳ
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

SELECT*
FROM dept;

-- 99�� �μ���ȣ�� ���� �μ��� dname �÷��� ���� '���IT', ioc �÷��� ���� '���κ���'���� ������Ʈ
UPDATE dept SET dname = '���IT', loc = '���κ���'
WHERE deptno = 99;

ROLLBACK;

-- 10 ==> subquery
-- SMITH, WARD�� ���� �μ��� �Ҽӵ� ���� ����
SELECT *
FROM emp
WHERE deptno IN (20, 30);

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));
                 
-- update�ÿ��� ���� ���� ����� ����
INSERT INTO emp (empno, ename)VALUES (9999, 'brown');
-- 9999�� ��� deptno, job ������ SMITH ����� ���� �μ�����, �������� ������Ʈ;

UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH'),
                job = (SELECT job FROM emp WHERE ename = 'SMITH')
WHERE empno = 9999;

SELECT *
FROM emp;

-- delete sql : Ư�� ���� ����
-- delete [from] ���̺��
-- where �� ���� ����;
SELECT *
FROM dept;
-- 99�� �μ���ȣ�� �ش��ϴ� �μ� ���� ����
DELETE dept
WHERE deptno = 99;
COMMIT;

-- subquery�� ���ؼ� Ư�� ���� �����ϴ� ������ ���� delete
-- �Ŵ����� 7698 ����� ������ ���� �ϴ� ������ �ۼ�
DELETE emp
WHERE empno = 7698;

DELETE emp
WHERE empno IN (SELECT empno
                FROM emp
                WHERE mgr = 7698);

SELECT *
FROM emp;

ROLLBACK;

-- Ʈ����� : ���� �ܰ��� ������ �ϳ��� �۾� ������ ���� ����
