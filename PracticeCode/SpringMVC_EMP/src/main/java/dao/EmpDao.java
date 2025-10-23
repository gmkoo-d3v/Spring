package dao;

import java.sql.SQLException;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import vo.Emp;

/**
 * EMP 테이블 CRUD 인터페이스
 */
public interface EmpDao {
    
    // ========== 조회 (SELECT) ==========
    
    /**
     * 전체 직원 수 조회
     * @return 전체 직원 수
     */
    public int getTotalCount() throws ClassNotFoundException, SQLException;
    
    /**
     * 조건별 직원 수 조회
     * @param field 검색 필드 (ename, job, deptno 등)
     * @param query 검색어
     * @return 조건에 맞는 직원 수
     */
    public int getCount(@Param("field") String field, @Param("query") String query) throws ClassNotFoundException, SQLException;
    
    /**
     * 전체 직원 목록 조회
     * @return 전체 직원 리스트
     */
    public List<Emp> getAllEmps() throws ClassNotFoundException, SQLException;
    
    /**
     * 페이징 및 검색 조건으로 직원 목록 조회
     * @param page 페이지 번호
     * @param field 검색 필드 (ename, job, deptno 등)
     * @param query 검색어
     * @return 조건에 맞는 직원 리스트
     */
    public List<Emp> getEmps(@Param("page") int page, @Param("field") String field, @Param("query") String query) throws ClassNotFoundException, SQLException;
    
    /**
     * 특정 직원 상세 조회
     * @param empno 사원번호
     * @return 직원 정보
     */
    public Emp getEmp(String empno) throws ClassNotFoundException, SQLException;
    
    /**
     * 부서별 직원 조회
     * @param deptno 부서번호
     * @return 해당 부서 직원 리스트
     */
    public List<Emp> getEmpsByDeptno(String deptno) throws ClassNotFoundException, SQLException;
    
    /**
     * 직책별 직원 조회
     * @param job 직책
     * @return 해당 직책 직원 리스트
     */
    public List<Emp> getEmpsByJob(String job) throws ClassNotFoundException, SQLException;
    
    /**
     * 급여 범위로 직원 조회
     * @param minSal 최소 급여
     * @param maxSal 최대 급여
     * @return 급여 범위 내 직원 리스트
     */
    public List<Emp> getEmpsBySalRange(@Param("minSal") double minSal, @Param("maxSal") double maxSal) throws ClassNotFoundException, SQLException;
    
    
    // ========== 등록 (INSERT) ==========
    
    /**
     * 직원 등록
     * @param emp 등록할 직원 정보
     * @return 등록된 행 수
     */
    public int insert(Emp emp) throws ClassNotFoundException, SQLException;
    
    
    // ========== 수정 (UPDATE) ==========
    
    /**
     * 직원 정보 수정
     * @param emp 수정할 직원 정보
     * @return 수정된 행 수
     */
    public int update(Emp emp) throws ClassNotFoundException, SQLException;
    
    /**
     * 급여 인상
     * @param empno 사원번호
     * @param increaseAmount 인상 금액
     * @return 수정된 행 수
     */
    public int updateSalary(@Param("empno") String empno, @Param("increaseAmount") double increaseAmount) throws ClassNotFoundException, SQLException;

    /**
     * 부서 이동
     * @param empno 사원번호
     * @param deptno 새 부서번호
     * @return 수정된 행 수
     */
    public int updateDepartment(@Param("empno") String empno, @Param("deptno") String deptno) throws ClassNotFoundException, SQLException;
    
    
    // ========== 삭제 (DELETE) ==========
    
    /**
     * 직원 삭제
     * @param empno 사원번호
     * @return 삭제된 행 수
     */
    public int delete(String empno) throws ClassNotFoundException, SQLException;
    
    /**
     * 부서별 직원 삭제
     * @param deptno 부서번호
     * @return 삭제된 행 수
     */
    public int deleteByDeptno(String deptno) throws ClassNotFoundException, SQLException;
    
    
    // ========== 통계/집계 ==========
    
    /**
     * 부서별 평균 급여 조회
     * @param deptno 부서번호
     * @return 평균 급여
     */
    public double getAvgSalByDept(String deptno) throws ClassNotFoundException, SQLException;
    
    /**
     * 부서별 직원 수 조회
     * @param deptno 부서번호
     * @return 직원 수
     */
    public int getCountByDept(String deptno) throws ClassNotFoundException, SQLException;
    
    /**
     * 사원번호 중복 체크
     * @param empno 사원번호
     * @return 존재 여부 (true: 존재, false: 미존재)
     */
    public boolean existsEmpno(String empno) throws ClassNotFoundException, SQLException;
}