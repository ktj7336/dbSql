-- TRUNCATE �׽�Ʈ
-- 1.REDO�α׸� �������� �ʱ� ������ ������ ������ ������ �Ұ��ϴ�
-- 2. DML(SELECT, INSERT, UPDATE, DELETE)�� �ƴ϶�
--    DDL�� �з� (ROLLBACK�� �Ұ�)

-- �׽�Ʈ �ó�����
-- emp���̺��� ���縦 �Ͽ� emp_copy��� �̸����� ���̺� ����
-- emp_copy ���̺��� ������� TRUNCATE TABLE EMP_COPY ����

-- EMP_COPY ���̺��� �����Ͱ� �����ϴ��� (���������� ������ �Ǿ�����) Ȯ��
-- EMP_COPY ���̺� ����
-- CREATE ==> DDL (ROLLBACK�� �ȵȴ�)
CREATE TABLE EMP_COPY AS
SELECT *
FROM emp;

SELECT *
FROM emp_copy;

TRUNCATE TABLE emp_copy;

-- TRUNCATE TABLE ���ɾ�� DDL �̱� ������ ROLLBACK �� �Ұ��ϴ�
-- ROLLBACK �� SELECT�� �غ��� �����Ͱ� ���� ���� ���� ���� �� �� �ִ�.
ROLLBACK;

-- ����ȭ ����

--DDL : Data Definition Language - ������ ���Ǿ�
-- ��ü�� ����, ����, ������ ���
-- ROLLBACK �Ұ�
-- �ڵ� COMMIT

-- ���̺� ����
-- CREATE TABLE [��Ű����.]���̺���(
--       �÷��� �÷�Ÿ�� [�⺻ ������],
--       �÷�2�� �÷�2Ÿ�� [�⺻ ������].....
-- );

-- rnager��� �̸��� ���̺� ����
CREATE TABLE ranger(
    ranger_no NUMBER,
    ranger_nm VARCHAR2(50),
    reg_dt DATE DEFAULT SYSDATE);

SELECT *
FROM ranger;

INSERT INTO ranger (ranger_no, ranger_nm) VALUES (1, 'brown');
COMMIT;

-- ���̺� ����
-- DROP TABLE ���̺���;
-- ranger ���̺� ����(drop);
DROP TABLE ranger;

SELECT *
FROM ranger;

-- DDL�� ROLLBACK �Ұ�
ROLLBACK;
-- ���̺��� �ѹ���� ���� ���� Ȯ�� �� �� �ִ�
SELECT *
FROM ranger;

-- ������ Ÿ��
-- ���ڿ� (varchar2���, char Ÿ�� ��� ����)
-- varchar2(10) : �������� ���ڿ�, ������ 1~4000byte 
--               �ԷµǴ� ���� �÷� ������� �۾Ƶ� ���� ������ �ٽ� ������ ä���� �ʴ´�
-- char(10) :�������� ���ڿ�
--           �ش� �÷��� ���ڿ��� 5byte�� �����ϸ� ������ 5byte �������� ä������
--            'test' ==> 'test    '
--            'test' != 'test    '

-- ���� 
-- NUBER(p, s) : p - ��ü�ڸ��� (38), s - �Ҽ��� �ڸ���
-- INTEGER ==> NUMBER(38,0)
-- ranger_no NUMBER ==> NUMBER(38.0)

-- ��¥
-- DATE - ���ڿ� �ð� ������ ����
--        7byte

-- ��¥ - DATE
--       VARCAHR2(8) '20200207'
--       �� �ΰ��� Ÿ���� �ϳ��� �����ʹ� 1byte�� ����� ���̰� ����
--       ������ ���� ���� ���� �Ǹ� ������ �� ���� �������, ����� Ÿ�Կ� ���� ������ �ʿ�

-- LOB - (Large OBject) - �ִ� 4GB
-- CLOB - (Character Large OBject)
--        VARCHAR2�� ���� �� ���� �������� ���ڿ�(4000byte �ʰ� ���ڿ�)
--        ex: �� �����Ϳ� ������ html �ڵ�

-- BLOB - (Byte Large OBject)
--        ������ �����ͺ��̽��� ���̺����� ������ ��

--        �Ϲ������� �Խñ� ÷�������� ���̺��� ���� �������� �ʰ�
--        ���� ÷�������� ��ũ�� Ư�� ������ �����ϰ�, �ش� [���]�� ���ڿ��� ����

--        ������ �ſ� �߿��� ��� : ���� ������� ���Ǽ� -> [����]�� ���̺��� ����

-- �������� : �����Ͱ� ���Ἲ�� ��Ű���� ���� ����
-- 1. UNIQUE ��������
--    �ش� �÷��� ���� �ٸ� ���� �����Ϳ� �ߺ����� �ʵ��� ����
--    EX : ����� ���� ����� ���� ���� ����

-- 2. NOT NULL �������� (CHECK ��������)
--    �ش� �÷��� ���� �ݵ�� �����ؾ��ϴ� ����
--    EX : ��� �÷��� NULL�� ����� ������ ���� ����
--         ȸ�����Խ� �ʼ� �Է»��� (GITHUB - �̸��� , �̸�)

-- 3. PRIMARY KEY ���� ����
--    UNIQUE + NOT NULL
--    EX : ����� ���� ����� ���� ���� ����, ����� ���� ����� ���� ���� �ִ�
--    PRIMARY KEY ���� ������ ������ ��� UNIQUE INDEX�� �����ȴ�

-- 4. FOREIGN KEY ���� ���� (�������Ἲ)
--    �ش� �÷��� �����ϴ� �ٸ� ���̺��� ���� �����ϴ� ���� �־�� �Ѵ�
--    emp ���̺��� deptno�÷��� dept���̺��� deptno�÷��� ����(����)
--    emp ���̺��� deptno �÷����� dept ���̺��� �������� �ʴ� �μ���ȣ�� �Է� �� �� ����
--    EX : ���� dept ���̺��� �μ���ȣ�� 10, 20, 30, 40���� ���� �� ���
--         emp ���̺��� ���ο� ���� �߰� �ϸ鼭 �μ���ȣ ���� 99������ ����� ��� �� �߰��� �����Ѵ� 

-- 5. CHECK �������� (���� üũ)
--    NOT NULL ���� ���ǵ� CHECK ���࿡ ����
--    emp ���̺��� JOB �÷��� ��� �ü� �ִ� ���� 'SALESMAN', 'PRESIDENT', 'CLEARK'

-- �������� ���� ���
-- 1. ���̺��� �����ϸ鼭 �÷��� ���
-- 2. ���̺��� �����ϸ鼭 �÷� ��� ���Ŀ� ������ ���������� ���
-- 3. ���̺� ������ ������ �߰������� ���������� �߰�

-- CREATE TABLE ���̺���(
--  �÷�1 �÷� Ÿ�� [1.��������],
--  �÷�2 �÷� Ÿ�� [1.��������],

-- [TABLE_CONSTRAINT]
-- };

-- 3. ALTER TABLE emp......

-- PRIMARY KEY ���������� �÷� ������ ����(1�� ���)
-- dept�� ���̺��� �����Ͽ� dept_test ���̺��� PRIMARY KEY �������ǰ� �Բ� ����
-- �� �̹���� ���̺��� key �÷��� ���� �÷��� �Ұ�, ���� �÷��� ���� ����
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);
INSERT INTO dept_test (deptno) VALUES (99); -- ���������� ����
INSERT INTO dept_test (deptno) VALUES (99); -- �ٷ� ���� ������ ���� ���� ���� �����Ͱ� �̹� �����

-- ��������, �츮�� ���ݱ��� ������ ����� dept ���̺��� dept �÷����� 
-- UNIQUE �����̳� PRIMARY KEY ���� ������ ������ ������
-- �Ʒ� �ΰ��� INSERT ������ ���������� ����ȴ�
INSERT INTO dept(deptno) VALUES (99);
INSERT INTO dept(deptno) VALUES (99);
ROLLBACK;

-- �������� Ȯ�� ���
-- 1. TOOL�� ���� Ȯ��
--    Ȯ���ϰ��� �ϴ� ���̺��� ����
-- 2. dictionary�� ���� Ȯ�� (USER_TABLES)

SELECT * 
FROM USER_CONSTRAINTS
WHERE table_name = 'DEPT_TSET';

SELECT *
FROM USER_CONS_COLUMNS
WHERE CONSTRAINT_NAME = 'SYS_C007085';

-- 3. �𵨸� ( ex: exerd) ���� Ȯ��
-- �������� ���� ������� ���� ��� ����Ŭ���� ���������̸��� ���Ƿ� �ο� (ex : sys_c007085)
-- �������� �������� ������ 
-- ���� ��Ģ�����ϰ� �����ϴ°� ����, � ������ ����
-- PRIMARY KEY �������� : PK_���̺���
-- FOREIGN KEY �������� : FK_������̺���_�������̺���
DROP TABLE dept_test;
--�÷� ������ ���������� �����ϸ缭 �������� �̸��� �ο�
-- CONSTRAINT �������Ǹ� ��������Ÿ��(PRIMARY KEY)

CREATE TABLE dept_test(
    deptno NUMBER(2)CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);
INSERT INTO dept_test (deptno) VALUES(99);
INSERT INTO dept_test (deptno) VALUES(99);

-- 2. ���̺� ������ �÷� ������� ������ ���� ���� ���
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_dept_test PRIMARY KEY (deptno)
);

-- NOT NULL �������� �����ϱ�
-- 1. �÷��� ����ϱ� 
--    �� �÷��� ����ϸ鼭 �������� �̸��� �ο��ϴ°� �Ұ�
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13),
    
    CONSTRAINT PK_dept_test PRIMARY KEY (deptno)
);

-- NOT NULL �������� Ȯ��
INSERT INTO dept_test (deptno, dnmae) VALUES (99, NULL);

-- 2. ���̺� ������ �÷� ��� ���Ŀ� ���� �����߰�
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT NN_dept_test_dname CHECK (deptno IS NOT NULL)
);

-- UNIQUE ���� : �ش� �÷��� �ߺ��Ǵ� ���� ������ ���� ����, �� NULL�� �Է� ����
-- PRIMARY KEY = UNIQUE + NOT NULL

-- 1. ���̺� ������ �÷� ���� UNIQUE ��������
--    dname �÷��� UNIQUE ��������
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2)  CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13)
);

-- dept_test ���̺��� dname �÷��� ������ unique ���������� Ȯ��
INSERT INTO dept_test VALUES (98, 'ddit','daejeon');
INSERT INTO dept_test VALUES (99, 'ddit','deajeon');

-- 2. ���̺� ������ �÷��� �������� ���. �������� �̸� �ο�
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2)  CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR2(14)CONSTRAINT UK_dept_test_dname UNIQUE,
    loc VARCHAR2(13)
);

-- dept_test ���̺��� dname �÷��� ������ unique ���������� Ȯ��
INSERT INTO dept_test VALUES (98, 'ddit','daejeon');
INSERT INTO dept_test VALUES (99, 'ddit','deajeon');

-- 2. ���̺� ������ �÷� ������� �������� ���� -���� �÷�(deptno-dname)(UNIQUE)
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR(14),
    loc VARCHAR(13),
    
    CONSTRAINT UK_dept_test_deptno_dname UNIQUE (deptno, dname)
);

-- ���� �÷��� ���� UNIQUE ���� Ȯ�� (deptno, dname)
INSERT INTO dept_test VALUES (99, 'ddit' , 'deajeon');
INSERT INTO dept_test VALUES (98, 'ddit' , 'deajeon');
INSERT INTO dept_test VALUES (98, 'ddit' , '����');

-- FOREIGN KEY ��������
-- �����ϴ� ���̺��� �÷��� �����ϴ� ���� ��� ���̺��� �÷��� �Է��� �� �ֵ��� ����
-- EX : emp���̺��� deptno �÷��� ���� �Է��� ��, dept ���̺��� deptno �÷��� �����ϴ� �μ���ȣ�� 
--      �Է� �� �� �ֵ��� ����
--      �������� �ʴ� �μ���ȣ�� emp ���̺����� ������� ���ϰԲ� ����

-- 1. dept_test ���̺� ����
-- 2. emp_test ���̺� ����
--    . emp_test ���̺� ������ deptno �÷����� dept.deptno �÷��� �����ϵ��� FK�� ����
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRAINT pk_dept_test PRIMARY KEY(deptno)
);

DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(1),
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test (deptno),
    
    CONSTRAINT PK_EMP_TEST PRIMARY KEY (empno)
);

-- ������ �Է¼��� 
-- emp_test ���̺��� �����͸� �Է��ϴ°� �����Ѱ�?
--  . ���ݻ�Ȳ(dept_test, emp_test ���̺��� ��� ���� - �����Ͱ� �������� ������)
INSERT INTO emp_test VALUES (9999, 'brown', NULL); -- FK�� ������ �÷����� NULL�� ���
INSERT INTO emp_test VALUES (9998, 'sally' , 10); -- 10�� �μ��� dept_test ���̺��� �������� �ʾƼ� ����

--dept_test ���̺��� �����͸� �غ�
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
INSERT INTO emp_test VALUES (9998, 'sally' , 10); -- 10�� �μ��� dept_test�� �������� �����Ƿ� ����
INSERT INTO emp_test VALUES (9998, 'sally' , 99); -- 99�� �μ��� dept_test�� �����ϹǷ� ���� ����

-- ���̺� ������ �÷� ��� ���� FOREIGN KEY �������� ����
DROP TABLE emp_test;
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname  VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRAINT pk_dept_test PRIMARY KEY (deptno)
);
INSERT INTO dept_test VALUES (99, 'ddit', 'deajeon');

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno)
);
INSERT INTO emp_test VALUES (9999, 'brown', 10); -- dept_test ���̺��� 10�� �μ��� �������� �ʾ� ����
INSERT INTO emp_test VALUES (9999, 'brown', 99); -- dept_test ���̺��� 99�� �μ��� �����ϹǷ� ���� ����