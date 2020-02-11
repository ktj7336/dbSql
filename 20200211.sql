-- ����
DROP TABLE emp_test;

CREATE TABLE emp_test(
 empno NUMBER(4),
 ename VARCHAR2(10),
 deptno NUMBER(6),
 hp NUMBER);
 
 SELECT * 
 FROM emp_test;
 
 INSERT INTO emp_test(empno,ename,deptno) VALUES(9999,'brown',99);
 
 ALTER TABLE emp_test MODIFY (hp VARCHAR2(20) DEFAULT('010'));

-- �������� Ȯ�� ���
-- 1. tool
-- 2. dictionary view
-- �������� : USER_CONSTRAINTS
-- �������� �÷� : USER_CONS_COLUMNS
-- ���������� ��� �÷��� ���õǾ� �ִ��� �˼� ���� ������ ���̺��� ������ �и��Ͽ� ����
-- 1������.
SELECT *
FROM USER_CONSTRAINTS
WHERE table_name IN ('EMP', 'EMP_TEST', 'DEPT_TEST');

-- emp, dept pk, fk ������ �������� ����
-- 2. emp : pk( empno)
-- 3.       fk ( deptno) - dept.deptno
-- 1. dept : pk ( deptno)

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY(empno);
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY(deptno);
ALTER TABLE dept ADD CONSTRAINT fk_emp_dept FOREIGN KEY(deptno) REFERENCES dept (deptno) ;

-- ���̺�, �÷� �ּ� : DICTIONARY Ȯ�� ����
-- ���̺� �ּ� : USER_TAB_COMMENTS
-- �÷� �ּ� : USER_COL_COMMENTS

-- �ּ� ����
-- ���̺� �ּ� : COMMENT ON TABLE ���̺�� IS '�ּ�'
-- �÷� �ּ� : COMMENT ON COLUMN ���̺�.�÷� IS '�ּ�'

-- emp : ����
-- dept : �μ�

COMMENT ON TABLE emp IS '����';
COMMENT ON TABLE dept IS '�μ�';

SELECT *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME IN ('EMP','DEPT');

SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN ('EMP', 'DEPT');

-- DEPT  DEPTNO : �μ���ȣ
-- DEPT  DNAME : �μ���
-- DEPT  LOC : �μ���ġ
-- EMP  EMPNO : ������ȣ
-- EMP  ENAME : �����̸�
-- EMP  JOB : ������
-- EMP  MGR : �Ŵ��� ������ȣ
-- EMP  HIREDATE : �Ի�����
-- EMP  SAL : �޿�
-- EMP  COMM : ������
-- EMP  DEPTNO : �ҼӺμ���ȣ
COMMENT ON COLUMN dept.deptno IS '�μ���ȣ';
COMMENT ON COLUMN dept.dname IS '�μ���';
COMMENT ON COLUMN dept.loc IS '�μ���ġ';

COMMENT ON COLUMN emp.empno IS '������ȣ';
COMMENT ON COLUMN emp.ename IS '�����̸�';
COMMENT ON COLUMN emp.job IS '������';
COMMENT ON COLUMN emp.mgr IS '�Ŵ��� ������ȣ';
COMMENT ON COLUMN emp.hiredate IS '�Ի�����';
COMMENT ON COLUMN emp.sal IS '�޿�';
COMMENT ON COLUMN emp.comm IS '������';
COMMENT ON COLUMN emp.deptno IS '�ҼӺμ���ȣ';

-- comment1(����)
SELECT *
FROM user_tab_comments t , user_col_comments c
WHERE t.TABLE_NAME = c.TABLE_NAME 
AND TABLE_NAME IN ('CUSTOMER', 'PRODUCT' , 'CYCLE', 'DAILY') ;

-- VIEW = QUERY
-- TABLE ó�� DBMS�� �̸� �ۼ��� ��ü
-- ==> �ۼ����� �ʰ� QUERY���� �ٷ� �ۼ��� VIEW : IN-LINEVIEW ==> �̸��� ���� ������ ��Ȱ���� �Ұ�
-- VIEW�� ���̺��̴� (X)

-- ������
-- 1. ���� ����(Ư�� �÷��� �����ϰ� ������ ����� �����ڿ� ����)
-- 2. INLINE-VIEW�� VIEW�� �����Ͽ� ��Ȱ��
--    ���� ���� ����

-- ���� ���
-- CREATE [OR REPLACE] VIEW ���Ī [ column1, column2....)] AS
-- SUBQUREY

-- emp ���̺��� 8���� �÷��� sal, comm �÷��� ������ 6�� �÷��� �����ϴ� v_emp VIEW ����
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

-- �ý��� �������� KTJ �������� VIEW �������� �߰�
-- GRANT CREATE VIEW TO KTJ;

-- ���� �ζ��� ��� �ۼ���
SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno 
        FROM emp);
-- VIEW ��ü Ȱ��
SELECT *
FROM v_emp;

-- emp���̺��� �μ����� ���� ==> dept ���̺�� ������ ����ϰ� ����
-- ���ε� ����� view�� ���� �س����� �ڵ带 �����ϰ� �ۼ��ϴ°� ����

-- VIEW : v_emp_dept
-- dname(�μ���), empno(������ȣ), ename(�����̸�), job(������), hiredate(�Ի�����)
CREATE OR REPLACE VIEW v_emp_dept AS
SELECT dept.dname, emp.empno, emp.ename, emp.job, emp.hiredate
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- �ζ��� ��� �ۼ���
SELECT *
FROM (SELECT dept.dname, emp.empno, emp.ename, emp.job, emp.hiredate
      FROM emp, dept
      WHERE emp.deptno = dept.deptno);
      
-- VIEW Ȱ���
SELECT *
FROM v_emp_dept;

-- SMITH ���� ������ v_emp_dept view �Ǽ� ��ȭ�� Ȯ��
DELETE emp
WHERE ename = 'SMITH';

-- VIEW�� �������� �����͸� ���� �ʰ�, ������ �������� ���� ����(SQL)�̱� ������
-- VIEW���� �����ϴ� ���̺��� �����Ͱ� ������ �Ǹ� VIEW�� ��ȸ ����� ������ �޴´�

-- SEQUENCE : ������ - �ߺ����� �ʴ� �������� �������ִ� ����Ŭ ��ü
-- CREATE SEQUENCE ������_�̸�
-- [OPTION...]
-- ����Ģ : SEQ_���̺��

-- emp ���̺��� ����� ������ ����
CREATE SEQUENCE seq_emp;

-- ������ ���� �Լ� 
-- NEXTVAL : ���������� ���� ���� �����ö� ���
-- CURRVAL : NEXTVAL�� ����ϰ��� ���� �о� ���� ���� ��Ȯ��

-- ������ ������
-- ROLLBACK�� �ϴ��� NEXTVAL�� ���� ���� ���� �������� �ʴ´�
-- NEXTVAL�� ���� ���� �޾ƿ��� �� ���� �ٽ� ����� �� ����

SELECT seq_emp.NEXTVAL
FROM dual;

SELECT seq_emp.CURRVAL
FROM dual;

SELECT *
FROM emp_test;

INSERT INTO emp_test VALUES (seq_emp.NEXTVAL, 'james', 99, '017');

-- �ε����� ������ empno ������ ��ȸ �ϴ� ���
-- emp ���̺��� pk_emp ���������� �����Ͽ� empno�÷����� �ε����� �������� �ʴ� ȯ���� ����

ALTER TABLE emp DROP CONSTRAINT pk_emp;

explain plan for
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

-- emp ���̺��� empno �÷����� PK ������ �����ϰ� ������ SQL�� ����
-- PK : UNIQUE + NOT NULL
--      (UNIQUE �ε����� �������ش�)
-- ==> empno �÷����� unique �ε����� ������

-- �ε����� sql�� �����ϰ� �Ǹ� �ε����� ���� ���� ��� �ٸ��� �������� Ȯ��;
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

SELECT rowid, emp.*
FROM emp;

SELECT empno, rowid
FROM emp
ORDER BY empno;

explain plan for
SELECT *
FROM emp
WHERE empno = 7782;


SELECT *
FROM emp
WHERE ename = 'SMITH';

-- SELECT ��ȸ�÷��� ���̺� ���ٿ� ��ġ�� ����
-- SELECT * FROM emp WHERE empno = 7782;
-- ==>
-- SELECT empno FROM emp WHERE empno = 7782;

-- UNIQUE VS NON-UNIQUE �ε����� ���� Ȯ��
-- 1. PK_EMP ����
-- 2. EMPNO �÷����� NON - UNIQUE �ε��� ����
-- 3. ���� ��ȹ Ȯ��

ALTER TABLE emp DROP CONSTRAINT pk_emp;
CREATE INDEX idx_n_emp_01 ON emp (empno);

explain plan for
SELECT *
FROM emp 
WHERE empno = 7782;

SELECT *
FROM TABLE (dbms_xplan.display);

-- emp ���̺� job �÷��� �������� �ϴ� ���ο� non-unique �ε����� ����
CREATE INDEX idx_n_emp_02 ON emp (job);

SELECT job, rowid
FROM emp
ORDER BY job;

-- ���ð����� ����
-- 1. emp ���̺��� ��ü �б�
-- 2. idx_n_emp_01(empno) �ε��� Ȱ��
-- 3. idx_n_emp_02(job) �ε��� Ȱ��
explain plan for
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT * 
FROM TABLE(dbms_xplan.display);