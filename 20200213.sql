-- synonym : ���Ǿ�
-- 1. ��ü ��Ī�� �ο�
--    ==>�̸��� �����ϰ� ǥ��

-- sem����ڰ� �ڽ��� ���̺� emp���̺��� ����ؼ� ���� v_emp view
-- hr ����ڰ� ����� �� �ְ� �� ������ �ο�

-- v_emp : �ΰ��� ���� sal, comm �� ������ view

-- hr����� v_emp�� ����ϱ� ���� ������ ���� �ۼ�
SELECT*
FROM KTJ.v_emp;

--synonym KTJ.v_emp ==> v_emp
-- v_emp == sem.v_emp

SELECT *
FROM v_emp;

-- 1. sem�������� v_emp�� hr �������� ��ȸ�� �� �ֵ��� ��ȸ���� �ο�
GRANT SELECT ON v_emp TO hr;

-- 2. hr���� v_emp ��ȸ�ϴ°� ��� (���� 1������ �޾ұ� ������)
--    ���� �ش� ��ü�� �����ڸ� ��� : sem.v_emp
--    �����ϰ� sem.v_emp ==> v_emp ����ϰ� ���� ��Ȳ
--    synonym ����
-- CREATE SYNONYM �ó�� �̸� FOR �� ��ü��

-- SYNONYM ����
-- DROP SYNONYM �ó�� �̸�

-- ����
-- 1. �ý��� ���� : TABLE�� ����, VIEW ��������...
-- 2. ��ü ���� :  Ư�� ��ü�� ���� SELECT, UPDATE, INSERT, DELETE...

-- ROLE : ������ ��Ƴ��� ����
-- ����ں��� ���� ������ �ο��ϰ� �Ǹ� ������ �δ�
-- Ư�� ROLE�� ������ �ο��ϰ� �ش� ROLE ����ڿ��� �ο�
-- �ش� ROLE�� �����ϰ� �Ǹ� ROLE�� ���� �ִ� ��� ����ڿ��� ����

-- ���� �ο�/ȸ��
-- �ý��� ���� : GRANT �����̸� TO ����� | ROLE
--             REVOKE �����̸� FROM ����� | ROLE
-- ��ü ���� : GRANT �����̸� ON ��ü�� TO | ROLE
--            REVOKE �����̸� ON ��ü�� FROM ����� | ROLE

-- data dictionary : ����ڰ� �������� �ʰ�, dbms�� ��ü������ �����ϴ� �ý��� ������ ���� view
-- data dictionary ���ξ�
-- 1. USER : �ش� ����ڰ� ������ ��ü
-- 2. ALL : �ش� ����ڰ� ������ ��ü + �ٸ� ����ڷ� ���� �ο����� ���� 
-- 3. DBA : ��� ������� ��ü

-- vs Ư�� VIEW

SELECT *
FROM USER_TABLES;

SELECT *
FROM ALL_TABLES;

SELECT*
FROM DBA_TABLES;

-- DICTIONARY ���� Ȯ�� : SYS.DICTIONARY
SELECT*
FROM DICTIONARY;

-- ��ǥ���� dictionary
-- OBJECTS : ��ü ���� ��ȸ(���̺�, �ε���, VIEW, SYNONYM...)
-- TABLES : ���̺� ������ ��ȸ
-- TAB_COLUMNS : ���̺��� �÷� ���� ��ȸ
-- INDEXES : �ε��� ���� ��ȸ
-- IND_COLUMNS : �ε��� ���� �÷� ��ȸ
-- CONSTRAINT : ���� ���� ��ȸ
-- CONS_COLUMNS : �������� ���� �÷� ��ȸ
-- TAB_COMMENTS : ���̺� �ּ�
-- COL_COMMENTS : ���̺��� �÷� �ּ�
SELECT*
FROM USER_OBJECTS;

-- emp, dept ���̺��� �ε����� �ε��� �÷� ���� ��ȸ
-- user_indexes, user_ind_columns join
-- ���̺��, �ε�����, �÷���
-- emp      ind_n_emp_04 ename
-- emp      ind_n_emp_04 job

SELECT table_name, index_name, column_name, column_position
FROM user_ind_columns
ORDER BY table_name, index_name, column_position;

SELECT *
FROM USER_INDEXES a, user_ind_columns b 
WHERE a.index_name = b.index_name;

-- multiple insert : �ϳ��� insert �������� ���� ���̺� �����͸� �Է��ϴ� DML
SELECT*
FROM dept_test;

SELECT*
FROM dept_test2;

-- ������ ���� ���� ���̺� ���� �Է��ϴ� multiple insert;
INSERT ALL
    INTO dept_test
    INTO dept_test2
SELECT 98, '���', '�߾ӷ�' FROM dual UNION ALL
SELECT 97, 'IT', '����' FROM dual;

-- ���̺� �Է��� �÷��� �����Ͽ� multiple insert
INSERT ALL
    INTO dept_test (deptno, loc) VALUES( deptno, loc)
    INTO dept_test2
SELECT 98 deptno, '���' dname, '�߾ӷ�' loc FROM dual UNION ALL
SELECT 97, 'IT', '����' FROM dual;

-- ���̺� �Է��� �����͸� ���ǿ� ���� multiple insert
--CASE
--    WHEN ���Ǳ�� THEN
--END;

INSERT ALL
    WHEN deptno = 98 THEN
        INTO dept_test (deptno, loc) VALUES( deptno, loc)
    ELSE
        INTO dept_test2
SELECT 98 deptno, '���' dname, '�߾ӷ�' loc FROM dual UNION ALL
SELECT 97, 'IT', '����' FROM dual;

ROLLBACK;

-- ������ �����ϴ� ù��° insert�� �����ϴ� multiple  insert
INSERT ALL
    WHEN deptno >= 98 THEN
        INTO dept_test (deptno, loc) VALUES( deptno, loc)
    WHEN dpetno >= 97 THEN
        INTO dept_test2
    ELSE
        INTO dept_test2
SELECT 98 deptno, '���' dname, '�߾ӷ�' loc FROM dual UNION ALL
SELECT 97, 'IT', '����' FROM dual;

-- ����Ŭ ��ü : ���̺� �������� ������ ��Ƽ������ ����
-- ���̺� �̸� �����ϳ� ���� ������ ���� ����Ŭ ���������� ������
-- �и��� ������ �����͸� ����

-- dept_test ==> dept_test_20200201

INSERT FIRST
    WHEN deptno >= 98 THEN
        INTO dept_test
    WHEN depno >= 97 THEN
        INTO dept_test_20200202
    ELSE
        INTO dept_test2
SELECT 98 deptno, '���' dname, '�߾ӷ�' loc FROM dual UNION ALL
SELECT 97, 'IT', '����' FROM dual;

SELECT *
FROM dept_test;

-- MERGE : ����
-- ���̺� �����͸� �Է�/���� �Ϸ�����
-- 1. ���� �Է��Ϸ��� �ϴ� �����Ͱ� �����ϸ�
--    ==> ������Ʈ
-- 2. ���� �Է��Ϸ��� �ϴ� �����Ͱ� �������� ������
--    ==> INSERT

-- 1. SELECT ����
-- 2-1. SELECT ���� ����� 0 ROW�̸� INSERT
-- 2-2. SELECT ���� ����� 1 ROW�̸� UPDATE

-- MERGE ������ ����ϰ� �Ǹ� SELECT �� ���� �ʾƵ� �ڵ����� ������ ������ ����
-- INSERT Ȥ�� UPDATE �����Ѵ�
-- 2���� ������ �ѹ����� �ش�

-- MERGE INTO ���̺�� [alias]
-- USING (TABLE | VIEW | IN-LINE-VIEW)
-- OR  (��������)
-- WHEN MATCHED THEN
--      UPDATE SET col1 = �÷���, col2 = �÷���.....
-- WHEN NOT MATCHED THEN
--      INSERT (�÷�1, �÷�2......) VALUES (�÷���1, �÷���2.....)
SELECT *
FROM emp_test;

DELETE emp_test;

-- �α׸� �ȳ���� ==> ������ �ȵȴ� ==> �׽�Ʈ������
TRUNCATE TABLE emp_test;

-- emp���̺��� emp_test�� �����Ѵ� (7369-SMITH)
INSERT INTO emp_test
SELECT empno, ename, deptno, '010'
FROM emp
WHERE empno = 7369;

UPDATE emp_test SET ename = 'brown'
WHERE empno = 7369;

COMMIT;

-- emp���̺��� ��� ������ emp_test���̺�� ����
-- emp���̺��� ���������� emp_test���� �������� ������ insert
-- emp���̺��� �����ϰ� emp_test���� �����ϸ� ename, deptno�� update

-- emp���̺� �����ϴ� 14���� �������� emp_test���� �����ϴ� 7369�� ������ 13���� �����Ͱ�
-- emp_test ���̺� �űԷ� �Է��� �ǰ�
-- emp_test�� �����ϴ� 7369���� �����ʹ� ename(brown)�� emp���̺� �����ϴ� �̸��� SMITH�� ����
MERGE INTO emp_test a
USING emp b
ON (a. empno = b. empno)
WHEN MATCHED THEN
    UPDATE SET a.ename = b.ename, 
               a.deptno = b.deptno
WHEN NOT MATCHED THEN
    INSERT (empno, ename, deptno) VALUES (b.empno, b.ename, b.deptno);
    
SELECT *
FROM emp_test;

-- �ش� ���̺� �����Ͱ� ������ insert ������ update
-- emp_test���̺� ����� 9999���� ����� ������ ���Ӱ� insert
-- ������ update
-- (9999, 'brown', '10', '010')

INSERT INTO emp_test VALUES (9999, 'brown', 10, '010');
UPDATE emp_test SET ename = 'brown',
                    deptno = 10,
                    hp = '010'
WHERE empno = 9999;

MERGE INTO emp_test
USING dual
ON (empno = 9999)
WHEN MATCHED THEN 
    UPDATE SET ename = ename || '_u',
               deptno = 10,
               hp = '010'
WHEN NOT MATCHED THEN 
    INSERT VALUES (9999, 'brown', 10, '010');
    
SELECT * 
FROM emp_test;

DESC emp_test;

-- MERGE, WINDOW FUNCTION (�м��Լ�)

-- report group function 1

SELECT deptno, sum(sal) sal
FROM emp
GROUP BY deptno

UNION ALL

SELECT null, sum(sal)
FROM emp;

-- I/O
-- CPU CACHE > RAM > SSD > HDD > NETWORK

-- REPORT GROUP FUNCTION
-- ROLLUP
-- CUBE
-- GROUPING

-- ROLLUP 
-- ����� : GROUP BT ROLLUP (�÷�1, �÷�2...)
-- SUBGROUP�� �ڵ������� ����
-- SUBGROUP�� �����ϴ� ��Ģ : ROLLUP�� ����� �÷��� �����ʿ������� �ϳ��� �����ϸ鼭
--                          SUB GROUP�� ����

-- EX : GROUP BY ROLLUP (deptno)
-- ==>
-- ù��° sub group : GROUP BY deptno
-- �ι�° sub group : GROUP BY NULL ==> ��ü ���� ���

-- GROUP_AD1�� GROUP BY ROLLUP ���� ����Ͽ� �ۼ�
SELECT deptno, sum(sal)
FROM emp
GROUP BY ROLLUP (deptno);

SELECT job, deptno, sum(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--GROUP BY job, deptno : ������, �μ��� �޿���
--GROUP BY job : �����κ� �޿���
--GROUP BY : ��ü �޿���

SELECT job, deptno,
       GROUPING(job),GROUPING(deptno),
       sum(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);


-- report group function 2
SELECT CASE WHEN GROUPING(job) =1 AND GROUPING(deptno) = 1 THEN '�Ѱ�'
            else job
       END job, 
       deptno, 
       sum(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP (job,deptno);

-- DECODE�� �غ���
SELECT DECODE(GROUPING(job),1,'�Ѱ�',0,job)job,
            deptno,
            sum(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);
    