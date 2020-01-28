--ORDER BY 4
SELECT *
FROM emp
WHERE DEPTNO IN(10,30) AND sal > 1500
ORDER BY ENAME DESC;

-- ROWNOM :���ȣ�� ��Ÿ���� �÷�
SELECT ROWNUM, empno, ename
FROM emp
WHERE deptno IN(10,30)
AND sal > 1500;

-- ROWNUM�� WHERE�������� ��밡��
-- �����ϴ� �� : = ROWNUM = 1, ROWNUM <= 2 -- ROWNUM, ROWNUM <= N
-- �������� �ʴ� �� : ROWNUM =2, ROWNUM >= 2 --> ROWNUM N(N�� 1�� �ƴ� ����), ROWNUM >= N(N�� 1�� �ƴ� ����)
-- ROWNUM �̹� ���� �����Ϳ��ٰ� ������ �ο�
-- **������1. ���� ���� ������ ����(ROWNUM�� �ο����� ���� ��)�� ��ȸ�� �� ����.
-- **������2. ORDER BY ���� SELECT �� ���Ŀ� ����
-- ���뵵 : ����¡ ó��
-- ���̺� �ִ� ��� ���� ��ȸ�ϴ� ���� �ƴ϶� �츮�� ���ϴ� �������� �ش��ϴ� �� �����͸� ��ȸ�� �Ѵ�.
-- ����¡ ó���� ������� : 1�������� �Ǽ�, ���� ����
-- EMP���̺��� �� ROW �Ǽ� : 14
-- ����¡�� 5���� �����͸� ��ȸ
-- 1page : 1~5
-- 2page : 6~10
-- 3page : 11~15
SELECT ROWNUM rn, empno, ename
FROM emp
ORDER BY ename;

-- ���ĵ� ����� ROWNUM�� �ο� �ϱ� ���ؼ��� IN-LINE VIEW�� ����Ѵ�.
-- �������� : 1.����, 2.ROWNUM �ο�

-- SELECT *�� ����� ��� �ٸ� EXPRESSION�� ǥ���ϱ� ���ؼ� ���̺��.* ���̺��Ī.*�� ǥ���ؾ��Ѵ�.
SELECT ROWNUM, emp.*
FROM emp;

SELECT ROWNUM, e.*
FROM emp e;

SELECT *
FROM
(SELECT ROWNUM rn, a.*
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename) a)
    WHERE rn BETWEEN 6 AND 10;
   
    SELECT *
FROM
(SELECT ROWNUM rn, a.*
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename) a)
    WHERE rn >= 1 AND rn <= 5;
   
-- ROWNUM > rn
-- 1 page : rn 1~5, ���ı����� ename
-- 2 page : rn 6~10
-- 3 page : rn 11~15
-- n page : rn (n-1)*pageSize +1 ~ n * pageSize
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
     FROM
        (SELECT empno, ename
         FROM emp
         ORDER BY ename) a)
WHERE rn BETWEEN (1 - 1) * 5 AND 1 * 5;

--ROWNUM 1
SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;

SELECT *
FROM
(SELECT ROWNUM rn, empno, ename
FROM emp)
WHERE rn BETWEEN 1 AND 10;

--ROWNUM 2
SELECT *
FROM
(SELECT ROWNUM rn, empno, ename
FROM emp)
WHERE rn BETWEEN 11 AND 20;

--ROWNUM 3
SELECT *
FROM
(SELECT ROWNUM rn, a.*
FROM 
(SELECT  empno, ename
FROM emp 
ORDER BY ename)a)
WHERE rn BETWEEN 11 AND 14;
-- WHERE rn BETWEEN (1 - 1) * 10 + 1 AND 1 * 10; (����ȭ)
--order by�� rownum�� ���� ����ϸ� ������ ���׹����� �ȴ�.

SELECT *
FROM
(SELECT ROWNUM rn, a.*
FROM 
(SELECT  empno, ename
FROM emp 
ORDER BY ename)a)
WHERE rn BETWEEN (:page-1) * :pageSize +1 AND :page * :pageSize  ;

-- DUAL ���̺� : �����Ϳ� �������, �Լ��� �׽�Ʈ �غ� �������� ���
-- ���ڿ� ��ҹ��� : LOWER, UPPER, INITCAP
SELECT LOWER('Hello, World!'), UPPER('Hello, World!'), INITCAP('Hello, World!')
FROM dual;

SELECT LOWER('Hello, World!'), UPPER('Hello, World!'), INITCAP('Hello, World!')
FROM emp; -- ���̺� �Ǽ� ��ŭ ���

-- �Լ��� WHERE �� ������ ��� ����
-- ��� �̸��� SMITH�� ����� ��ȸ
SELECT  *
FROM emp
WHERE ename = UPPER(:ename);

-- SQL �ۼ��� �Ʒ� ���´� ���� �ؾ��Ѵ�
-- ���̺��� �÷��� �������� ���� ���·� SQL�� �ۼ��Ѵ�
SELECT  *
FROM emp
WHERE LOWER(ename) = :ename;

--
SELECT CONCAT('Hello', ', World') CONCAT,  
       SUBSTR('Hello, World' , 1, 5) sub, -- 1~5
       LENGTH('Hello, World') len,
       INSTR('Hello, World', 'o') ins,
       INSTR('Hello, World', 'o', 6) ins2,
       LPAD('Hello, World', 15, '*') LP,
       RPAD('Hello, World', 15, '*') RP,
       REPLACE('Hello, World', 'H' , 'T') REP,
       TRIM('   Hello, World   ') TR, -- ������ ����
       TRIM('d' FROM 'Hello, World') TR --������ �ƴ� �ҹ��� d����
FROM dual;

-- ���� �Լ�
-- ROUND : �ݿø� (10. 6�� �Ҽ��� ù��° �ڸ����� �ݿø� --> 11)
-- TRUNC : ����(����) (10.6�� �Ҽ��� ù��° �ڸ����� ���� --> 10)
-- ROUND, TURNC : ���° �ڸ����� �ݿø�/ ����
-- MOD : ������ (���� �ƴ϶� ������ ������ �� ������ ��) ( 13/5 -> ����:2 ������ :3)

-- ROUND(��� ����, ���� ��� �ڸ�)
SELECT ROUND(105.54 , 1), -- �ݿø� ����� �Ҽ��� ù��° �ڸ����� �������� --> �ι�° �ڸ����� �ݿø�
       ROUND(105.55 , 1), 
       ROUND(105.55 , 0), -- �ݿø� ����� �����θ� --> �Ҽ��� ù��° �ڸ����� �ݿø�
       ROUND(105.54 , -1), -- �ݿø� ����� 10�� �ڸ����� --> ���� �ڸ����� �ݿø�
       ROUND(105.55) -- �ι�° ���ڸ� �Է����� ���� ��� 0�� ����
FROM dual;

SELECT TRUNC(105.54, 1), -- ������ ����� �Ҽ��� ù��° �ڸ����� �������� --> �ι�° �ڸ����� ����
       TRUNC(105.55, 1), -- ������ ����� �Ҽ��� ù��° �ڸ����� �������� --> �ι�° �ڸ����� ����
       TRUNC(105.55, 0), -- ������ ����� ������(���� �ڸ�)���� �������� --> �Ҽ��� ù��° �ڸ����� ����
       TRUNC(105.55, -1), -- ������ ����� 10�� �ڸ����� �������� --> �����ڸ����� ����
       TRUNC(105.55) -- �ι�° ���ڸ� �Է����� ���� ��� 0�� ����
FROM dual;

-- EMP���̺��� ����� �޿�(sal)�� 1000���� �������� ��
SELECT ename, sal, sal/1000 -- ���� ���غ�����
FROM emp;

SELECT ename, sal, TRUNC(sal/1000),
                   MOD(sal, 1000) -- mod�� ����� divisor ���� �׻��۴� , 0~999
FROM emp;

DESC emp;

--�⵵2�ڸ�/��2�ڸ�/����2�ڸ�
SELECT ename, hiredate
FROM emp;

-- SYSDATE : ���� ����Ŭ ������ �ú��ʰ� ���Ե� ��¥ ������ �����ϴ� Ư�� �Լ�
-- �Լ���(����1, ����2)
-- date + ���� = ���� ����
-- 1 = �Ϸ�
-- 1�ð� = 1/24
-- 2020/01/28 + 5
-- ���� ǥ�� : ����
-- ���� ǥ�� : �̱� �����̼� + ���ڿ� + �̱� �����̼� --> '���ڿ�'
-- ��¥ ǥ�� : TO_DATE('���ڿ� ��¥ ��', '���ڿ� ��¥ ���� ǥ�� ����') --> TO_DATE('2020-31-28', 'YYYY-MM-DD')
SELECT SYSDATE + 5, SYSDATE + 1/24
FROM dual;