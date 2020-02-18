-- ����� ��������(leaf ==> root node(���� node))
-- ��ü ��带 �湮�ϴ°� �ƴ϶� �ڽ��� �θ��常 �湮 (����İ� �ٸ���)
-- ������ : ��������
-- ������ : �����μ�
SELECT dept_h.*,LEVEL, LPAD(' ', (LEVEL-1) * 4) || deptnm
FROM dept_h
START WITH deptnm = '��������'
CONNECT BY PRIOR p_deptcd = deptcd;

-- h4
SELECT lpad(' ', (LEVEL-1) * 4) || s_id s_id, value
FROM h_sum
START WITH s_id = 0
CONNECT BY PRIOR s_id = ps_id;

-- ������ ������ �� ���� ���� ��� ��ġ�� ���� ��� �� (pruning branch -����ġ��)
-- FROM => START WITH, CONNECT BY => WHERE 
-- 1. WHERE : ���� ������ �ϰ� ���� ���� ����
-- 2. CONNECT BY : ���� ������ �ϴ� �������� ���� ����;
-- WHERE �� ����� : �� 9���� ���� ��ȸ�Ǵ� �� Ȯ��
-- WHERE �� (deptnm != '������ȹ��') : ������ȹ�θ� ������ 8���� �� ��ȸ�Ǵ� �� Ȯ��
SELECT lpad(' ',(LEVEL-1)* 4) || org_cd org_cd, no_emp
FROM no_emp
WHERE org_cd != '������ȹ��'
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

-- CONNECT BY ���� ������ ���
SELECT lpad(' ',(LEVEL-1)* 4) || org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd AND org_cd != '������ȹ��';

-- CONNECT_BY_ROOT(�÷�) : �ش� �÷��� �ֻ��� ���� ���� ��ȯ
-- SYS_CONNECT_BY_PATH(�÷�, ������) : �ش� ���� �÷��� ���Ŀ� �÷� ���� ��õ, �����ڷ� �̾��ش�
-- CONNECT_BY_ISLEAF : �ش� ���� LEAF �������(����� �ڽ��� ������) ���� ���� [1 : leaf, 0 : no leaf]
SELECT lpad(' ',(LEVEL-1)* 4) || org_cd org_cd, no_emp,
       CONNECT_BY_ROOT(org_cd) root,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-') path,
       CONNECT_BY_ISLEAF leaf
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

-- h6
SELECT seq, lpad(' ',(LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq is null
CONNECT BY PRIOR seq = parent_seq;

-- h7
SELECT seq, lpad(' ',(LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq is null
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;

-- h8
SELECT seq, lpad(' ',(LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq is null
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq desc;

-- �׷��ȣ�� ������ �÷��� �߰�
ALTER TABLE board_test ADD (gn NUMBER);

UPDATE board_test SET gn = 4
WHERE seq IN (4, 5, 6, 7, 8, 10, 11);

UPDATE board_test SET gn = 2
WHERE seq IN (2, 3);

UPDATE board_test SET gn = 1
WHERE seq IN (1, 9);

commit;

SELECT seq, lpad(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn desc, seq asc;

-- �ٸ� ���
SELECT seq, lpad(' ', (LEVEL-1)*4) || title title, DECODE(parent_seq, NULL, seq, parent_seq) root
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY root desc, seq asc;

SELECT *
FROM emp
ORDER BY deptno desc, empno asc;

-- ana0 �μ��� sal ���� ���ϱ�
SELECT * 
FROM emp
ORDER BY deptno;

SELECT ename, sal , deptno
FROM emp
ORDER BY deptno;

SELECT 
FROM 
(SELECT LEVEL lv 
FROM dual
CONNECT BY LEVEL <= 14) a,
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno) b
WHERE b.cnt >= a.lv
ORDER BY b.deptno, a.lv;