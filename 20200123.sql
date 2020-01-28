--WHERE 절에 기술하는 조건에 순서는 조회 결과에 영향을 미치지 않는다
--SQL은 집합의 개념을 갖고 있다
--집합 : 키가 185cm 이상이고 몸무게가 70kg 이상인 사람들의 모임
--  -->몸무게가 70kg 이상이고 키카 185cm 이상인 사람들의 모임
-- 집합의 특징 : 집합에는 순서가 없다
-- {1, 5, 10} --> {10, 5, 1} : 두 집합은 서로 동일하다
-- 테이블에는 순서가 보장되지 않음
-- SELECT 결과가 순서가 다르더라도 값이 동일하면 정답으로 간주를 한다
--> 정렬기능 제공(ORDER BY)
--     잘생긴 사람들의 모임 --> 집합x
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD')
AND hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD');

-- IN 연산자
-- 특징 집합에 포함되느지 여부를 확인
-- 부서번호가 10번 혹은(OR) 20번에 속하는 직원 조회
SELECT empno, ename, deptno
FROM emp
WHERE deptno IN (10, 20);

--IN 연산자를 사용하지 않고 OR 연산자 사용
SELECT empno, ename, deptno
FROM emp
WHERE deptno = 10
OR deptno = 20;

-- emp 테이블에서 사원이름이 SMITH, JONES 인 직원만 조회 (empno, ename, deptno)
-- AND / OR
-- 문자 상수
SELECT empno, ename, deptno
FROM emp
WHERE ename IN ('SMITH', 'JONES');

SELECT userid 아이디, usernm 이름, alias 별명
FROM users
WHERE userid IN ('brown', 'cony', 'sally');

--문자열 매칭 연산자 : LIKE, %, _
--위에서 연습한 조건은 문자열 일치에 대해서 다룸
--이름이 BR로 시작하는 사람만 조회
--이름에 R 문자열이 들어가는 사람만 조회

-- 사원 이름이 s로 사작하는 사원 조회
-- SMITH, SMILE, SKC
-- % : 어떤 문자열(한글자, 글자 없을수도 있고, 여러 문자열이 올수도 있다)
SELECT *
FROM emp
WHERE ename LIKE 'S%';

-- 글자수를 제한한 매턴 매칭
-- _ 정확히 한문자
-- 직원 이름이 s로 시작하고 이름의 전체 길이가 5글자 인 직원
-- S____
SELECT * 
FROM emp
WHERE ename LIKE 'S____';

-- 사원 이름에 s글자가 들어가는 사원 조회
-- ename LIKE '%S%'
SELECT * 
FROM emp
WHERE ename LIKE '%S%';

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';

-- null 비교 연산 (IS)
-- comm 컬럼의 값이 null인 데이터를 조회 (WHERE comm = null)
SELECT *
FROM emp
WHERE comm IS null;

SELECT *
FROM emp
WHERE comm >= 0;

-- 사원의 관리자가 7698, 7839 그리고 null이 아닌 직원만 조회
-- NOT IN 연산자에서는 NULL 값을 포함 시키면 안된다
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

--연산자 우선순위
-- *, / 연산자가 +, - 보다 우선순위가 높다
-- 1+5*2 = 11 -> (1+5)*2 
-- 우선순위 변경 : ()
-- AND > OR 

-- emp 테이블에서 사원 이름이 SMITH 이거나 
--              사원 이름이 ALLEN 이면서 담당업무가 SALESMAN인 사원 조회
SELECT *
FROM emp
WHERE ename = 'SMITH'
OR ename = 'ALLEN' 
AND job = 'SALESMAN';

SELECT *
FROM emp
WHERE ename = 'SMITH'
OR (ename = 'ALLEN' AND job = 'SALESMAN');

-- 사원 이름이 SMITH 이거나 ALLEN 이면
-- 담당업무가 SALESMAN인 사원 조회

SELECT *
FROM emp
WHERE (ename = 'SMITH' OR ename = 'ALLEN')
AND job = 'SALESMAN';

--14
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR (empno LIKE '78%'
AND hiredate > TO_DATE ('1981/06/01', 'YYYY/MM/DD'));

--정렬
-- SELECT *
-- FROM table
-- [WHERE]
-- ORDER BY (컬럼|별칭|컬럼인덱스 [ASC | DESC], ....)

-- emp 테이블의 모든 사원들 ename 컬럼 값을 기준으로 오름 차순 정렬한 결과를 조회 하세요
SELECT *
FROM emp
ORDER BY ename ;

-- emp 테이블의 모든 사원들 ename 컬럼 값을 기준으로 내림 차순 정렬한 결과를 조회 하세요
SELECT *
FROM emp
ORDER BY ename DESC ;

DESC emp; -- DESC : DESCRIBE (설명하다)
ORDER BY ename DESC; -- DESC : DESCENDING (내림)

-- emp 테이블에서 사원 정보를 ename컬럼으로 내림차순,
-- ename 값이 같을 경우 mgr 컬럼으로 오름차순 정렬하는 쿼리를 작성하세요
SELECT *
FROM emp
ORDER BY ename DESC, mgr;

-- 정렬시 별칭을 사용
SELECT empno, ename nm, sal*12 year_sal
FROM emp
ORDER BY year_sal;

-- 컬럼 인덱스로 정렬
-- java array[0]
-- SQL COLUMN INDEX : 1부터 시작
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
