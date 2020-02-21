--- pro_2
CREATE OR REPLACE PROCEDURE registdept_test(p_deptno IN dept_test.deptno%TYPE, 
                                            p_dname IN dept_test.dname%TYPE, p_loc IN dept_test.loc%TYPE) IS
BEGIN 
    INSERT INTO dept_test VALUES (p_deptno, p_dname, p_loc, 0);
END;
/

exec registdept_test (99, 'ddit1', 'daejeon');
select * from dept_test;

DESC dept_test; 

-- pro_3
CREATE OR REPLACE PROCEDURE UPDATEdept_test(p_deptno IN dept_test.deptno%TYPE, 
                                            p_dname IN dept_test.dname%TYPE, p_loc IN dept_test.loc%TYPE) IS
BEGIN 
    UPDATE dept_test SET dname = p_dname, loc = p_loc
    WHERE deptno = p_deptno;
END;
/
exec UPDATEdept_test (99, 'ddit_m', 'daejeon');

select * from dept_test;


-- ���պ��� %rowtype : Ư�� ���̺��� ���� ��� �÷��� ������ �� �ִ� ���� 
-- ����� : ������ ���̺�� %rowtype

DECLARE 
    v_dept_row dept%ROWTYPE;
BEGIN
    SELECT * INTO v_dept_row
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ' ' || v_dept_row.dname || ' '  || v_dept_row.loc);
END;
/

-- ���պ��� RECORD
-- �����ڰ� ���� �������� �÷��� ������ �� �ִ� Ÿ���� �����ϴ� Ÿ��
-- java�� �����ϸ� Ŭ������ �����ϴ� ����
-- �ν��Ͻ��� ����� ������ ��������
-- ����
-- TYPE Ÿ���̸�(�����ڰ� ����) IS RECODE (
--      ������1 ����Ÿ��, 
--      ������2 ����Ÿ��,
-- );
-- ������ Ÿ���̸�
DECLARE
    TYPE dept_row IS RECORD(
        deptno NUMBER(2),
        dname VARCHAR2(14)
        );
    v_dept_row dept_row;
BEGIN
    SELECT deptno, dname INTO v_dept_row
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_row. deptno || ' ' || v_dept_row.dname);
END;
/

-- table type ���̺� Ÿ��
-- �� : ��Į�� ����
-- �� : %ROWTYPE, record type
-- �� : table type
--     � ��(%ROWTYPE, RECODE TYPE)�� ������ �� �ִ���
--     �ε��� Ÿ���� ��������

-- DEPT ���̺��� ������ ������ �ִ� table type�� ����
-- ������ ��� ��Į�� Ÿ��, rowtype������ �� ���� ������ ���� �� �־�����
-- table Ÿ�� ������ �̿��ϸ� ���� ���� ������ ���� �� �ִ�
-- pl/sql ������ �ڹٿ� �ٸ��� �迭�� ���� �ε����� ������ �����Ǿ� ���� �ʰ� ���ڿ��� �����ϴ�
-- �׷��� table Ÿ���� ������ ���� �ε����� ���� Ÿ�Ե� ���� ���
-- BINARY_INTEGER Ÿ���� pl/sql ������ ��� ������ Ÿ������ 
-- NUMBER Ÿ���� �̿��Ͽ� ������ ��� �����ϰ� ���� NUMBER Ÿ���� ���� Ÿ���̴�
DECLARE 
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dept_tab dept_tab;
BEGIN 
    SELECT * BULK COLLECT INTO v_dept_tab
    FROM dept;
    --���� ��Į�󺯼�, record Ÿ���� �ǽ��ÿ��� 
    -- ���ุ ��ȸ �ǵ��� WHERE���� ���� ���� �Ͽ���
    
    -- �ڹٿ����� �迭[�ε��� ��ȣ]
    -- table����(�ε��� ��ȣ)�� ����
    --FOR (int i = 0; i <10; i++);
    
    FOR i IN 1..v_dept_tab.count LOOP
        DBMS_OUTPUT.PUT_LINE(v_dept_tab(i).deptno || ' ' || v_dept_tab(i).dname);
    END LOOP;
END;
/
-- �������� IF
-- ����

-- IF ���ǹ� THEN
--    ���๮;
-- ELSIF ���ǹ� THEN
--    ���๮;
-- ELSIF ���ǹ� THEN
--    ���๮;
-- ELSE
--    ���๮;
-- END IF;

DECLARE
    p NUMBER(1) := 2; --���� ����� ���ÿ� ���� ����
BEGIN
    IF p = 1 THEN
        DBMS_OUTPUT.PUT_LINE('1�Դϴ�.');
    ELSIF p = 2 THEN
        DBMS_OUTPUT.PUT_LINE('2�Դϴ�.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('�˷����� �ʾҽ��ϴ�.');
    END IF;
END;
/

-- CASE ����
-- 1.�Ϲ� ���̽�(java�� switch�� ����)
-- 2.�˻� ���̽�(if,else if, else)

-- �Ϲ� ���̽�
CASE expression
    WHEN value THEN
        ���๮;
    WHEN value THEN
        ���๮;
    ELSE
        ���๮;
END CASE;

DECLARE
    P number(1) := 2;
BEGIN
    CASE p
        WHEN 1 THEN
            DBMS_OUTPUT.PUT_LINE('1�Դϴ�.');
        WHEN 2 THEN
            DBMS_OUTPUT.PUT_LINE('2�Դϴ�.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('�𸣴� ���Դϴ�.');
    END CASE;
END;
/

DECLARE 
    p NUMBER(1) := 2;
BEGIN
    CASE 
        WHEN p = 1 THEN
            DBMS_OUTPUT.PUT_LINE('1�Դϴ�');
        WHEN p = 2 THEN
            DBMS_OUTPUT.PUT_LINE('2�Դϴ�');
        ELSE
             DBMS_OUTPUT.PUT_LINE('�𸣴� ���Դϴ�.');
    END CASE;
END;
/

-- FOR LOOP ����
-- FOR ��������/�ε������� IN [REVERSE] ���۰�..���ᰪ LOOP
--     �ݺ��� ����
-- END LOOP;
-- 1���� 5���� FOR LOOP �ݺ����� �̿��Ͽ� ���� ��� 
DECLARE
BEGIN
    FOR i IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/
-- ������ ���
DECLARE
BEGIN
    FOR i IN 2..9 LOOP
        FOR j IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(i || '*' || j || '=' || i*j);
        END LOOP;
    END LOOP;
END;
/

-- while loop ����
-- WHILE ���� LOOP
--      �ݺ������� ����;
-- END LOOP;
DECLARE 
    i NUMBER := 0;
BEGIN
    WHILE i <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        i := i+1;
    END LOOP;
END;
/

-- LOOP�� ==> while(ture)
-- LOOP
--     �ݺ������� ����
--     EXIT ����;
-- END LOOP;
DECLARE 
    i NUMBER := 0;
BEGIN
    LOOP
        EXIT WHEN i > 5;
        DBMS_OUTPUT.PUT_LINE(i);
        i := i + 1;
    END LOOP;
END;
/