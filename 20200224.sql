-- 동일한 SQL 문장이랑 : 텍스트가 완벽하게 동일한 SQL
-- 1. 대소문자 가림
-- 2. 공백도 동일 해야함
-- 3. 조회 결과가 같다고 동일한 SQL이 아님
-- 4. 주석도 영향을 미침

-- 그렇기 때문에 다음 SQL 문장은 동일한 문장이 아님
SELECT * FROM dept;
select * FROM dept;
select   * FROM dept;
select*
FROM dept;

-- SQL 실행시 V$SQL 뷰에 데이터가 조회되는지 확인
SELECT /* sql_test */ *
FROM dept
WHERE deptno = 10;

SELECT /* sql_test */ *
FROM dept
WHERE deptno = 20;

-- 위 두개의 SQL은 검색하고자 하는 부서번호만 다르고 나머지 텍스트는 동일하다. 하지만 부서번호가 다르기 때문에 
-- DBMS 입장에서는 서로 다른 SQL로 인식된다
-- ==> 다른 SQL 실행 계획을 세운다
-- ==> 실행 계획을 공유하지 못한다
-- ==> 해결책 바인드 변수
-- SQL 에서 변경되는 부분을 별도로 전송을 하고 실행계획 세워진  이후에
-- 바인딩 작업을 거쳐 실제 사용자가 원하는 변수 값으로 치환후 실행
-- ==> 실행 계획을 공유 ==> 메모리 자원 낭비 방지
SELECT /* sql_test*/ *
FROM dept
WHERE deptno = :deptno;

-- SQL 커서 : SQL물을 실행하기 위한 메모리 공간
-- 기존에 사용한 SQL문은 묵시적 커서를 사용
-- 로직을 제어 하기 위한 커서 : 명시적 커서

-- SELECT 결과 여려건을 TABLE 타입의 변수에 저장할 수 있지만
-- 메모리는 한정적이기 때문에 많은양의 데이터를 담기에는 제한이 따름

-- SQL 커서를 통해 개발자가 직접 데이터를 FETCH 함으로써 SELECT 결과를
-- 전부 불러오지 않고도 개발이 가능

-- 커서 선언 방법 : 
-- 선언부(DECLARE)에서 선언
--      CURSOR 커서이름 IS
--          제어할 쿼리

-- 실행부(BEGIN)에서 커서 열기
--     OPEN 커서이름

-- 실행부(BEGIN)에서 커서로 부터 데이터 FETCH
--      FETCH 커서이름 INTO 변수

-- 실행부(BEGIN)에서 커서 닫기
--      CLOSE 커서이름

-- 부서 테이블을 활용하여 모든 행에 대해 부서번호와 부서 이름을 CURSOR를 통해
-- FETCH, FETCH 된 결과를 확인
SET SERVEROUTPUT ON;

DECLARE 
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
BEGIN
    OPEN dept_cursor;
    
    LOOP
        FETCH dept_cursor INTO v_deptno, v_dname;
        EXIT WHEN dept_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_deptno || ':' || v_dname);
    
    END LOOP;
END;
/

-- CURSOR를 열고 닫는 과정이 다소 거추장 스러움
-- CURSOR는 일반적으로 LOOP와 함꼐 사용하는 경우가 많음
-- ==> 명시적 커서를 FOR loop에서 사용할 수 있게 끔 문법으로 제공

-- List<String> userNameList = new ArrayList<String>();
-- userNameList.add("brown");
-- userNameList.add("cony");
-- userNameList.add("sally");

-- 일반 for
-- for(int i = 0; i < userNameList.size(); i++){
--      String userName = userNameList.get(i);
-- }

-- 향상된 for 
-- for(String userName : userNameList){
--     userName값을 사용....
-- }

-- java의 향상된 for 문과 유사
-- FOR record_name(한행의 정보를 담을 변수이름 / 변수를 직접 선언안함) IN 커서이름 LOOP
--     record_name.컬럼명
-- END LOOP
DECLARE
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
BEGIN
    FOR rec IN dept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' : ' || rec.dname);
    END LOOP;
END;
/

-- 인자가 있는 명시적 커서
-- 기존 커서 선언 방법
--     CURSOR 커서이름 IS
--          서브쿼리...;
--
-- 인자가 있는 있는 커서 선언방법
--     CURSOR 커서이름(인자1 인자1타입....) IS
--         서브쿼리
--         (커서 선언시에 작성한 인자를 서브쿼리에서 사용할수 있다)
DECLARE
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    CURSOR dept_cursor(p_deptno dept.deptno%TYPE) IS
        SELECT deptno, dname
        FROM dept
        WHERE deptno <= p_deptno;
BEGIN
    FOR rec IN dept_cursor(20) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' : ' || rec.dname);
    END LOOP;
END;
/

-- 인터페이스를 이용하여 객체를 생성 가능한가

-- FOR LOOP에서 커서를 인라인 형태로 작성
-- FOR 레코드이름 IN 커서이름
-- ==>
-- FOR 레코드 이름 IN (서브쿼리)
DECLARE
BEGIN
    FOR rec IN(SELECT deptno, dname FROM dept) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' : ' || rec.dname);
    END LOOP;
END;
/

-- pro_3
CREATE OR REPLACE PROCEDURE avgdt IS
    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dt_tab dt_tab;
    
    v_diff_sum NUMBER := 0;
BEGIN
    SELECT * BULK COLLECT INTO v_dt_tab
    FROM dt;
    
    --DT 테이블에는 8행이 있는데 1~7번행 까지만 LOOP를 시행
    FOR i IN 1..v_dt_tab.COUNT-1 LOOP
        v_diff_sum := v_diff_sum + v_dt_tab(i).dt - v_dt_tab(i+1). dt;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(v_diff_sum / (v_dt_tab.COUNT -1));
END;
/
exec avgdt;

 -- 분석함수 사용해서 해보기
 SELECT AVG(diff)
 FROM
 (SELECT dt - lead(dt) OVER(ORDER BY dt DESC) diff 
 FROM dt) a;
 
 SELECT (MAX(dt) - MIN(dt)) / (COUNT(dt)-1) avg
 FROM dt;
