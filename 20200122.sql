SELECT * 
FROM LPROD;

SELECT buyer_id, buyer_name
FROM BUYER;

SELECT *
FROM CART;

SELECT mem_id, mem_pass, mem_name
FROM MEMBER;

--users ���̺� ��ȸ
SELECT *
FROM users;

--���̺� � �÷��� �ִ��� Ȯ���ϴ� ���
-- 1. SELECT *
-- 2. TOOL�� ��� (����� - TABLES)
-- 3. DESC ���̺�� (DESC - DESCRIBE)
DESC users;

-- users ���̺��� userid, usernm, reg_dt �÷��� ��ȸ�ϴ� sql�� �ۼ��ϼ���
-- ��¥ ���� (reg_dt �÷��� date������ ������ �ִ� Ÿ��)
-- SQL ��¥�÷� + (���ϱ� ����)
-- �������� ��Ģ������ �ƴѰ͵� (5+5)
-- String h = "hello";
-- String w = "world";
-- String hw = h+w; --�ڹٿ����� �� ���ڿ��� ����
-- SQL�� ���ǵ� ��¥ ���� : ��¥ + ���� = ��¥���� ������ ���ڷ� ����Ͽ� ���� ��¥�� �ȴ� (2019/01/28 + 5 = 2019/02/02)
-- reg_dt : ������� �÷�
-- null : ���� �𸣴� ����
-- null�� ���� ������ ����� �׻� null
SELECT userid u_id, usernm, reg_dt, 
reg_dt + 5 AS reg_dt_after_5day
FROM users;
DESC users;

SELECT prod_id id, prod_name name
FROM prod;

SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

SELECT buyer_id ���̾���̵�, buyer_name �̸�
FROM buyer;

--���ڿ� ����
-- �ڹ� ���� ���ڿ� ���� : + ("Hello" + "world")
-- SQL������ : || ('Hello' + || 'world')
-- SQL������ : concat ('Hello', 'world')

-- userid, usernm �÷��� ����, ��Ī id_name
SELECT userid || usernm id_name
FROM users;

SELECT concat (userid, usernm) concat_id_name
FROM users;

-- ����, ���
-- int a = 5; String msg = "HelloWorld";
-- System.out.println(msg) ; // ������ �̿��� ���
-- //����� �̿��� ���
-- System.out.println("Hello, World");

-- SQL������ ������ ����(�÷��� ����� ��Ȱ, pl/sql ���� ������ ����)
-- SQL�׼� ���ڿ� ����� �̱� �����̼����� ǥ��
-- "Hello, World" --> 'Hello, World'

-- ���ڿ� ����� �÷����� ����
-- user id : brown
-- user id : cony

SELECT 'userid :' || userid AS "use rid"
FROM users; 

SELECT TABLE_NAME
FROM USER_TABLES;

SELECT 'SELECT * FROM ' || TABLE_NAME || ';' AS QUERY
FROM USER_TABLES;

--CONCAT

SELECT CONCAT (CONCAT('SELECT * FROM ', TABLE_NAME), ';') QUERY
FROM USER_TABLES;

-- int a = 5; // �Ҵ�, ���� ������
-- if (a == 5) (a�� ���� 5���� ��)
-- sql������ ������ ������ ����(PL/SQL)
-- sql = --> equal
 
--users�� ���̺��� ��� �࿡ ���ؼ� ��ȸ
--users���� 5���� �����Ͱ� ����
SELECT *
FROM users;

--WHERE �� : ���̺��� �����͸� ��ȸ�� ��
---           ���ǿ� �´� �ุ ��ȸ
--ex : userid �÷��� ���� brown�� �ุ ��ȸ
-- brown, 'brown' ����
-- �÷�, ���ڿ� ���
SELECT *
FROM users
WHERE userid = 'brown';

-- userid�� brown�� �ƴ� �ุ ��ȸ(brown�� ������ 4��)
-- ������ : = , �ٸ��� : !=, <>
SELECT *
FROM users
WHERE userid != 'brown';

-- emp ���̺� �����ϴ� �÷��� Ȯ�� �غ�����
DESC emp;

-- emp ���̺��� enmae �÷� ���� JONES�� �ุ ��ȸ
-- * SQL KEY WORD�� ��ҹ��ڸ� ������ ������ 
-- �÷��� ���̳�, ���ڿ� ����� ��ҹ��ڸ� ������
-- 'JONES', 'Jones'�� ���� �ٸ� ���
SELECT *
FROM emp 
WHERE ename = 'JONES';

--emp ���̺��� deptno(�μ���ȣ)��
--30 ���� ũ�ų� ���� ����鸸 ��ȸ

SELECT *
FROM emp
WHERE deptno >= 30;

-- ���ڿ� : '���ڿ�'
-- ���� : 50
-- ��¥ : ??? --> �Լ��� ���ڿ��� �����Ͽ� ǥ��
--        ���ڿ��� �̿��Ͽ� ǥ�� ����(�������� ����)
--        �������� ��¥ ǥ�� ���
--        �ѱ� : �⵵4�ڸ�-��2�ڸ�-����2�ڸ�
--        �̱� : ��2�ڸ�-����2�ڸ�-�⵵4�ڸ�
--�Ի����ڰ� 1980�� 12�� 17�� ������ ��ȸ
SELECT *
FROM emp
WHERE hiredate = '80/12/17';
-- TO_DATE : ���ڿ��� date Ÿ������ �����ϴ� �Լ�
-- TO_DATE(��¥���� ���ڿ�, ù��° ������ ����)
-- '1980/02/03'
SELECT *
FROM emp
WHERE hiredate = TO_DATE('19801217', 'YYYYMMDD');

-- ��������
-- sal �÷��� ���� 1000���� 2000 ������ ���
-- sal >= 1000
-- sal <= 2000
SELECT *
FROM emp
WHERE sal >=1000
AND sal <= 2000;

--���������ڸ� �ε�ȣ ��ſ� BETWEEN AND �����ڷ� ��ü
SELECT * 
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01', 'YYYY/MM/DD') AND TO_DATE('1983/01/01', 'YYYY/MM/DD');
