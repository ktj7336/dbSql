--WHERE ���� ����ϴ� ���ǿ� ������ ��ȸ ����� ������ ��ġ�� �ʴ´�
--SQL�� ������ ������ ���� �ִ�
--���� : Ű�� 185cm �̻��̰� �����԰� 70kg �̻��� ������� ����
--  -->�����԰� 70kg �̻��̰� Űī 185cm �̻��� ������� ����
-- ������ Ư¡ : ���տ��� ������ ����
-- {1, 5, 10} --> {10, 5, 1} : �� ������ ���� �����ϴ�
-- ���̺��� ������ ������� ����
-- SELECT ����� ������ �ٸ����� ���� �����ϸ� �������� ���ָ� �Ѵ�
--> ���ı�� ����(ORDER BY)
--     �߻��� ������� ���� --> ����x
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD')
AND hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD');

-- IN ������
-- Ư¡ ���տ� ���ԵǴ��� ���θ� Ȯ��
-- �μ���ȣ�� 10�� Ȥ��(OR) 20���� ���ϴ� ���� ��ȸ
SELECT empno, ename, deptno
FROM emp
WHERE deptno IN (10, 20);

--IN �����ڸ� ������� �ʰ� OR ������ ���
SELECT empno, ename, deptno
FROM emp
WHERE deptno = 10
OR deptno = 20;

-- emp ���̺��� ����̸��� SMITH, JONES �� ������ ��ȸ (empno, ename, deptno)
-- AND / OR
-- ���� ���
SELECT empno, ename, deptno
FROM emp
WHERE ename IN ('SMITH', 'JONES');

SELECT userid ���̵�, usernm �̸�, alias ����
FROM users
WHERE userid IN ('brown', 'cony', 'sally');

--���ڿ� ��Ī ������ : LIKE, %, _
--������ ������ ������ ���ڿ� ��ġ�� ���ؼ� �ٷ�
--�̸��� BR�� �����ϴ� ����� ��ȸ
--�̸��� R ���ڿ��� ���� ����� ��ȸ

-- ��� �̸��� s�� �����ϴ� ��� ��ȸ
-- SMITH, SMILE, SKC
-- % : � ���ڿ�(�ѱ���, ���� �������� �ְ�, ���� ���ڿ��� �ü��� �ִ�)
SELECT *
FROM emp
WHERE ename LIKE 'S%';

-- ���ڼ��� ������ ���� ��Ī
-- _ ��Ȯ�� �ѹ���
-- ���� �̸��� s�� �����ϰ� �̸��� ��ü ���̰� 5���� �� ����
-- S____
SELECT * 
FROM emp
WHERE ename LIKE 'S____';

-- ��� �̸��� s���ڰ� ���� ��� ��ȸ
-- ename LIKE '%S%'
SELECT * 
FROM emp
WHERE ename LIKE '%S%';

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '��%';

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%��%';

-- null �� ���� (IS)
-- comm �÷��� ���� null�� �����͸� ��ȸ (WHERE comm = null)
SELECT *
FROM emp
WHERE comm IS null;

SELECT *
FROM emp
WHERE comm >= 0;

-- ����� �����ڰ� 7698, 7839 �׸��� null�� �ƴ� ������ ��ȸ
-- NOT IN �����ڿ����� NULL ���� ���� ��Ű�� �ȵȴ�
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839);

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839)
AND mgr IS NOT NULL;

--7
SELECT *
FROM emp
WHERE job IN ('SALESMAN')  
AND hiredate > TO_DATE('1981/06/01', 'YYYY/MM/DD'); 

--8
SELECT *
FROM emp
WHERE deptno > 10 
AND hiredate > TO_DATE('1981/06/01', 'YYYY/MM/DD');

--9
SELECT *
FROM emp
WHERE deptno NOT IN (10)
AND hiredate > TO_DATE('1981/06/01', 'YYYY/MM/DD');

--10
SELECT *
FROM emp
WHERE deptno IN (20, 30)
AND hiredate > TO_DATE('1981/06/01', 'YYYY/MM/DD');

--11
SELECT *
FROM emp
WHERE job ='SALESMAN' 
OR hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--12
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE('78__');

--13
SELECT *
FROM emp
WHERE job ='SALESMAN' OR empno BETWEEN 7800 AND 7899;

--������ �켱����
-- *, / �����ڰ� +, - ���� �켱������ ����
-- 1+5*2 = 11 -> (1+5)*2 
-- �켱���� ���� : ()
-- AND > OR 

-- emp ���̺��� ��� �̸��� SMITH �̰ų� 
--              ��� �̸��� ALLEN �̸鼭 �������� SALESMAN�� ��� ��ȸ
SELECT *
FROM emp
WHERE ename = 'SMITH'
OR ename = 'ALLEN' 
AND job = 'SALESMAN';

SELECT *
FROM emp
WHERE ename = 'SMITH'
OR (ename = 'ALLEN' AND job = 'SALESMAN');

-- ��� �̸��� SMITH �̰ų� ALLEN �̸�
-- �������� SALESMAN�� ��� ��ȸ

SELECT *
FROM emp
WHERE (ename = 'SMITH' OR ename = 'ALLEN')
AND job = 'SALESMAN';

--14
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR (empno LIKE '78%'
AND hiredate > TO_DATE ('1981/06/01', 'YYYY/MM/DD'));

--����
-- SELECT *
-- FROM table
-- [WHERE]
-- ORDER BY (�÷�|��Ī|�÷��ε��� [ASC | DESC], ....)

-- emp ���̺��� ��� ����� ename �÷� ���� �������� ���� ���� ������ ����� ��ȸ �ϼ���
SELECT *
FROM emp
ORDER BY ename ;

-- emp ���̺��� ��� ����� ename �÷� ���� �������� ���� ���� ������ ����� ��ȸ �ϼ���
SELECT *
FROM emp
ORDER BY ename DESC ;

DESC emp; -- DESC : DESCRIBE (�����ϴ�)
ORDER BY ename DESC; -- DESC : DESCENDING (����)

-- emp ���̺��� ��� ������ ename�÷����� ��������,
-- ename ���� ���� ��� mgr �÷����� �������� �����ϴ� ������ �ۼ��ϼ���
SELECT *
FROM emp
ORDER BY ename DESC, mgr;

-- ���Ľ� ��Ī�� ���
SELECT empno, ename nm, sal*12 year_sal
FROM emp
ORDER BY year_sal;

-- �÷� �ε����� ����
-- java array[0]
-- SQL COLUMN INDEX : 1���� ����
SELECT empno, ename nm, sal*12 year_sal
FROM emp
ORDER BY 3;

-- ORDER BY 1
SELECT *
FROM dept
ORDER BY dname; 

SELECT *
FROM dept
ORDER BY loc DESC;

-- ORDER BY 2
SELECT *
FROM emp
WHERE comm IS NOT NULL 
AND comm != 0
ORDER BY comm DESC, empno ASC ;

-- ORDER BY 3
SELECT *
FROM emp
<<<<<<< HEAD
WHERE mgr IS NOT NULL
=======
WHERE mgt IS NOT NULL
>>>>>>> master
ORDER BY job, empno DESC;
