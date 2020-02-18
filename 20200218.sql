-- 상향식 계층쿼리(leaf ==> root node(상위 node))
-- 전체 노드를 방문하는게 아니라 자신의 부모노드만 방문 (하향식과 다른점)
-- 시작점 : 디자인팀
-- 연결은 : 상위부서
SELECT dept_h.*,LEVEL, LPAD(' ', (LEVEL-1) * 4) || deptnm
FROM dept_h
START WITH deptnm = '디자인팀'
CONNECT BY PRIOR p_deptcd = deptcd;

-- h4
SELECT lpad(' ', (LEVEL-1) * 4) || s_id s_id, value
FROM h_sum
START WITH s_id = 0
CONNECT BY PRIOR s_id = ps_id;

-- 계층형 쿼리의 행 제한 조건 기술 위치에 따른 결과 비교 (pruning branch -가지치기)
-- FROM => START WITH, CONNECT BY => WHERE 
-- 1. WHERE : 계층 연결을 하고 나서 행을 제한
-- 2. CONNECT BY : 계층 연결을 하는 과정에서 행을 제한;
-- WHERE 절 기술전 : 총 9개의 행이 조회되는 것 확인
-- WHERE 절 (deptnm != '정보기획부') : 정보기획부를 제외한 8개의 행 조회되는 것 확인
SELECT lpad(' ',(LEVEL-1)* 4) || org_cd org_cd, no_emp
FROM no_emp
WHERE org_cd != '정보기획부'
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

-- CONNECT BY 절에 조건을 기술
SELECT lpad(' ',(LEVEL-1)* 4) || org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd AND org_cd != '정보기획부';

-- CONNECT_BY_ROOT(컬럼) : 해당 컬럼의 최상위 행의 값을 변환
-- SYS_CONNECT_BY_PATH(컬럼, 구분자) : 해당 행의 컬럼이 거쳐온 컬럼 값을 추천, 구분자로 이어준다
-- CONNECT_BY_ISLEAF : 해당 행이 LEAF 노드인지(연결된 자식이 없는지) 값을 리턴 [1 : leaf, 0 : no leaf]
SELECT lpad(' ',(LEVEL-1)* 4) || org_cd org_cd, no_emp,
       CONNECT_BY_ROOT(org_cd) root,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-') path,
       CONNECT_BY_ISLEAF leaf
FROM no_emp
START WITH org_cd = 'XX회사'
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

-- 그룹번호를 저장할 컬럼을 추가
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

-- 다른 방법
SELECT seq, lpad(' ', (LEVEL-1)*4) || title title, DECODE(parent_seq, NULL, seq, parent_seq) root
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY root desc, seq asc;

SELECT *
FROM emp
ORDER BY deptno desc, empno asc;

-- ana0 부서별 sal 순위 구하기
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