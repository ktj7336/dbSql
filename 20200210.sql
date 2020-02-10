-- 1. PRIMARY KEY 제약 조건 생성시 오라클 dbms는 해당 컬럼으로 unique index를 자동으로 생성한다
--    (** 정화히는 unique 제약에 의하 unique 인덱스가 자동으로 생성된다
--        PRIMARY KEY = UNIQUE + NOT NULL )


-- index : 해당 컬럼으로 미리 정렬을 해놓은 객체
-- 정령이 되어있기 때문에 찾고자 하는 값이 존재하는지 빠르게 알수가 있다
-- 만약에 인덱스가 없다면 새로운 데이터를 입력할 때
-- 중복되는 값을 찾기 위해서 최악의 경우 테이블의 모든 데이터를 찾아야 한다
-- 하지만 인덱스가 있으면 이미 정렬이 되어있기 때문에값의 존재 유무를 빠르게 알수가 있다

-- 2. FOREIGN KEY 제약조건도 
-- 참조하는 테이블에 값이 있는지를 확인 해야한다.
-- 그래서 참조하는 컬럼에 인덱스가 있어야지만 FOREIGN KEY 재약을 생성할 수가 있다

-- FOREIGN KEY 생성시 옵션
-- FOREIGN KEY (참조 무결성) : 참조하는 테이블의 컬럼에 존재하는 값만 입력 될 수 있도록 제한
-- (ex : emp 테이블에 새로운 데이터를 입력시 deptno 컬럼에는 dept 테이블에 존재하는 부서번호만 입력 될수 있다)

-- FOREIGN KEY 가 생성됨에 따라 데이터를 삭제할 때 유의점
-- 어떤 테이블에서 참조하고 있는 데이터를 바로 삭제가 안됨
-- (ex : EMP.deptno ==> DEPT.deptno 컬럼을 참조 하고 있을 때
--       부서 테이블의 데이터를 삭제 할 수가 없음)

SELECT *
FROM emp_test;

SELECT *
FROM dept_test;

INSERT INTO dept_test VALUES (98, 'ddit2', '대전');
INSERT INTO emp_test (empno, ename, deptno) VALUES(9999, 'brown', 99);

-- emp : 9999, 99
-- dept : 98, 99
-- ==> 98번 부서를 참조하는 emp 테이블의 데이터는 없음
--     99번 부서를 참조하는 emp 테이블의 데이터는 9999번 brown 사번이 있음

DELETE dept_test
WHERE deptno = 99;

-- emp 테이블에서 참조하는 데이터가 없는 98번 부서를 삭제하면?

-- FOREIGN KEY 옵션
-- 1. ON DELETE CASCADE : 부모가 삭제될 경우(dept) 참조하는 자식 데이터도 같이 삭제한다(emp)
-- 2. ON DELETE SET NULL : 부모가 삭제될 경우(dept) 참조하는 자식 데이터의 컬럼을 NULL로 설정

-- emp_test 테이블을 DROP후 옵션을 번갈아 가며 생성후 삭제 테스트
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno)
            REFERENCES dept_test(deptno) ON DELETE CASCADE);
            
INSERT INTO emp_test VALUES (9999, 'brown', 99);
commit;
-- emp_test 테이블의 deptno 컬럼은 dept_test 테이블의 deptno 컬럼을 참조 (ON DELETE CASCADE)
-- 옵션에 따라서 부모테이블(dept_test)삭제시 참조하고 있는 자식 데이터도 같이 삭제된다.
DELETE dept_test
WHERE deptno = 99;

-- 옵션 부여하지 하지 않앗을 때는 위의 DELETE 쿼리가 에러 발생
-- 옵션에 따라서 참조하는 자식테이블의 데이터가 정상적으로 삭제가 되었는지 SELECT 확인

SELECT *
FROM emp_test;

-- FK ON DELETE SET NULL 옵션 테스트
-- 부모 테이블의 데이터 삭제시 (dept_test) 지식테이블에서 참조하는 데이터를 NULL로 업데이트;
ROLLBACK;
SELECT *
FROM dept_test;

DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno)
            REFERENCES dept_test(deptno) ON DELETE SET NULL);
            
INSERT INTO emp_test VALUES (9999, 'brown', 99);
commit;

-- dept_test 테이블의 99번 부서를 삭제하게 되면(부모 테이블을 삭제하면)
-- 99번 부서를 참조하는 emp_test 테이블의 9999번(brown) 데이터의 deptno 컬럼을
-- FK 옵션에 따라 NULL로 변경한다

DELETE dept_test
WHERE deptno = 99;

-- 부모 테이블의 데이터 삭제후 자식 테이블의 데이터가 NULL로 변경되었는지 확인

SELECT *
FROM emp_test;

-- CHECK 제약조건 : 컬럼에 들어가는 값의 종류를 제한할 때 사용
-- ex : 급여 컬럼을 숫자로 관리, 급여가 음수가 들어갈 수 있을까?
--      일반적인 경우 급여값은 > 0
--      CHECK 제약을 사용할 경우 급여값 0보다 큰 값이 겁사 가능
--      CHECK 제약을 사용할 경우 급여값이 0보다 큰값이 검사 가능
--      EMP테이블의 job 컬럼에 들어가는 값을 다음 4가지로 제한 가능
--      'SALESMAN', 'PRESIDENT', 'ANALYST', 'MANAGER'

-- 테이블 생성시 컬럼 기술과 함께 CHECK 제약 생성
-- emp_test 테이블의 sal 컬럼이 0보다 크다는 CHECK 제약조건 생성
INSERT INTO dept_test VALUES (99, 'ddit', '대전');
DROP TABLE emp_test;
CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR2(10),
        deptno NUMBER(2),
        sal NUMBER CHECK ( sal > 0),
        
        CONSTRAINT pk_emp_test PRIMARY KEY (empno),
        CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno)
                REFERENCES dept_test (deptno)
);
INSERT INTO emp_test VALUES (9999, 'brown', 99, 1000);
INSERT INTO emp_test VALUES (9998, 'sally', 99, -1000); --(sal체크조건에 따라 0보다 큰 값만 입력 가능)

-- 새로운 테이블 생성
-- CREATE TABLE 테이블명 (
--      컬럼1....
-- );

-- CREATE TABLE 테이블명 AS
-- SELECT 결과를 새로운 테이블로 생성

-- emp 테이블을 이용해서 부서번호가 10인 사원들만 조회하여 해당 데이터로 emp_test2 테이블을 생성
SELECT *
FROM emp
WHERE deptno = 10;

CREATE TABLE emp_test2 AS
SELECT *
FROM emp
WHERE deptno = 10;

SELECT *
FROM emp_test2;

-- TABLE 변경
-- 1.컬럼추가
-- 2.컬럼 사이즈 변경, 타입 변경
-- 3.기본값 설정
-- 4.컬럼명을 RENAME
-- 5.컬럼을 삭제
-- 6.제약조건 추가/삭제

-- TABLE 변경 1. 컬럼추가
DROP TABLE emp_test;

CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR2(10),
        deptno NUMBER(2),
        
        CONSTRAINT pk_emp_test PRIMARY KEY (empno),
        CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno)
);

-- ALTER TABLE 테이블명 ADD (신규컬럼명 신규컬럼 타입)
ALTER TABLE emp_test ADD (hp VARCHAR2(20));
DESC emp_test;

SELECT *
FROM emp_test;

-- TABLE 변경 2.컬럼 사이즈 변경, 타입 변경
-- ex: 컬럼 varchar2(20) ==> varchar2(5)
--     기존에 데이터가 존재할 경우 정상적으로 실행이 안될 확률이 매우 높음
-- 일반적으로 데이터가 존재하지 않는 상태, 즉 테이블을 생성한 직후에 컬럼의 사이즈, 타입이 잘못 된 경우
-- 컬럼 사이즈, 타입을 변경함

-- 데이터가 입력된 이후로는 활용도가 매우 떨어짐 (사이즈는 늘리는것만 가능)
DESC emp_test;
--hp VARCHAR2(20) ==> hp VARCHAR2(30);

-- ALTER TABLE 테이블명 MODIFY (기존 컬럼명 신규 컬럼 타입(사이즈));
ALTER TABLE emp_test MODIFY (hp VARCHAR2(30));
DESC emp_test;

-- 컬럼 타입 변경
-- hp VARCHAR2(30) ==> hp NUMBER
ALTER TABLE emp_test MODIFY (hp NUMBER);

DESC emp_test;

-- 컬럼 기본값 설정
-- ALTER TABLE 테이블명 MODIFY (컬럼명 DEFAULT 기본값);

-- hp NUMBER ==> hp VARCHAR2(20) DEFAULT '010';
ALTER TABLE emp_test MODIFY (hp VARCHAR(20) DEFAULT '010');
DESC emp_test;

-- hp 컬럼에는 값을 넣지 않았지만 DEFAULT 설정에 의해 '010' 문자열이 기본값으로 저장된다
INSERT INTO emp_test (empno, ename, deptno) VALUES (9999, 'brown', 99);
SELECT *
FROM emp_test;

-- TABLE 4. 변경시 컬럼 변경
-- 변경하려고 하는 컬럼이 FK제약, PK제약이 있어도 상관 없음
-- ALTER TABLE 테이블명 RENAME COLUMN 기존 컬럼명 TO 신규 컬럼명
-- hp ==> hp_n
ALTER TABLE emp_test RENAME COLUMN hp TO hp_n;
SELECT*
FROM emp_test;

-- 테이블 변경 5. 컬럼 삭제
-- ALTER TABLE 테이블명 DROP COLUMN 컬럼명
-- emp_test 테이블에서 hp_n 컬럼 삭제

-- emp_test에 hp_n 컬럼이 있는 것을 확인
SELECT *
FROM emp_test;

ALTER TABLE emp_test DROP COLUMN hp_n;
-- emp_test hp_n 컬럼이 삭제되었는지 확인
SELECT *
FROM emp_test;

-- 1. emp_test 테이블을 drop후 empno, ename, deptno, hp 4개의 컬럼으로 테이블 생성
-- 2. empno, ename, deptno 3가지 컬럼에만 (9999, 'brown', 99) 데이터로 INSERT
-- 3. emp_test 테이블의 hp 컬럼의 기본값을 '010'으로 설정
-- 4. 2번과정에 입력한 데이터의 hp컬럼 값이 어떻게 바뀌는지 확인

-- TABLE 변경 6. 제약조건 추기/삭제
-- ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 제약조건타입{PRIMARY KEY, FOREINGN KEY) (해당컬럼)
-- ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명

-- 1. emp_test 테이블 삭제후 
-- 2. 제약조건 없이 테이블을 생성
-- 3. PRIMARY KEY, FOREIGN KEY 제약을 ALTER TABLE 변경을 통해 생성
-- 4. 두개의 제약조건에 대해 테스트
DROP TABLE emp_test;

CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR(10),
        deptno NUMBER(2));
        
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);
ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept_test FOREIGN KEY(deptno) REFERENCES dept_test(deptno);

-- PRIMARY KEY 테스트
INSERT INTO emp_test VALUES (9999, 'brown', 99);
INSERT INTO emp_test VALUES (9999, 'sally', 99); -- 첫번째 INSERT 구문에 의해 중복되므로 실패

-- FOREIGN KEY 테스트
INSERT INTO emp_test VALUES (9999, 'sally', 98); -- dept_test 테이블에 존재하지 않는 부서번호이므로 실패

-- 제약조건 삭제 : PRIMARY KEY, FOREING KEY
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;
ALTER TABLE emp_test DROP CONSTRAINT fk_emp_test_dept_test;

-- 제약조건이 없으므로 empno가 중복된 값이 들어갈 수 있고, dept,test테이블에 존재하지 않는 deptno값도 들어갈 수가 있다
INSERT INTO emp_test VALUES (9999, 'brown', 99);
INSERT INTO emp_test VALUES (9999, 'sally', 99);

--존재하지 않는 98번부서로 데이터 입력
INSERT INTO emp_test VALUES (9998, 'sally', 98);

SELECT *
FROM emp_test;

-- PRIMARY KEY, FOREIGN KEY, NOT NULL, CHECK, UNIQUE

-- 제약조건 활성화/비활성화
-- ALTER TABLE 테이블명 ENABLE | DISABLE CONSTRAINT 제약조건명

-- 1. emp_test 테이블 삭제
-- 2. emp_test 테이블 생성
-- 3. ALTER TABLE PRIMARY KEY(empno), FOREIGN KEY(dept_test_deptno)제약조건 생성
-- 4. 두개의 제약조건을 비활성화
-- 5. 비활성화가 되었는지 INESRT를 통해 확인
-- 6. 제약조건을 위배한 데이터가 들어간 상태에서 제약조건 활성화
DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2));
    
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);
ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept_test FOREIGN KEY(deptno) REFERENCES dept_test(deptno);

ALTER TABLE emp_test DISABLE CONSTRAINT pk_emp_test;
ALTER TABLE emp_test DISABLE CONSTRAINT fk_emp_test_dept_test;

INSERT INTO emp_test VALUES (9999, 'brown', 99);
INSERT INTO emp_test VALUES (9999, 'sally', 98);
commit;

SELECT *
FROM emp_test;

-- emp_test테이블에는 empno컬럼의 값이 9999인 사원이 두명 존재하기 때문에 
-- PRIMARY KEY 제약조건을 활성화 할 수가 없다
-- ==> empno컬럼의 값이 중복되지 않도록 수정하고 제약조건을 활성화 할 수 있다
ALTER TABLE emp_test ENABLE CONSTRAINT pk_emp_test;
ALTER TABLE emp_test ENABLE CONSTRAINT fk_emp_test_dept_test;

-- empno 중복제거
DELETE emp_test
WHERE ename = 'brown';

-- PRIMARY KEY 제약조건 활성화
ALTER TABLE emp_test ENABLE CONSTRAINT pk_emp_test;

-- dept_test 테이블에 존재하지 않는 부서번호 98을 emp_test에서 사용중
-- 1. dept_test테이블에 98번 부서를 등록하거나
-- 2. sally의 부서번호 99번으로 변경하거나
-- 3. sally를 지우거나
UPDATE emp_test SET deptno = 99
WHERE ename = 'sally';

ALTER TABLE emp_test ENABLE CONSTRAINT fk_emp_test_dept_test;
commit;