package service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.EmpDao;
import vo.Emp;

@Service
public class EmpService {
	
	@Autowired
	private SqlSession sqlSession;
	
	/**
	 * 페이징 및 검색으로 직원 목록 조회
	 */
	public List<Emp> getEmps(String pg, String f, String q) {
		System.out.println("=== EmpService.getEmps() 호출 ===");
		int page = 1;
		if (pg != null && !pg.isEmpty()) {
			page = Integer.parseInt(pg);
		}

		String field = (f != null && !f.isEmpty()) ? f : null;
		String query = (q != null && !q.isEmpty()) ? q : null;

		System.out.println("page=" + page + ", field=" + field + ", query=" + query);

		EmpDao empDao = sqlSession.getMapper(EmpDao.class);
		System.out.println("empDao=" + empDao);

		try {
			List<Emp> result = empDao.getEmps(page, field, query);
			System.out.println("DB 조회 결과: " + result);
			System.out.println("결과 크기: " + (result != null ? result.size() : "null"));
			return result;
		} catch (Exception e) {
			System.err.println("=== ERROR in getEmps ===");
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * 직원 상세 조회
	 */
	public Emp getEmpDetail(String empno) {
		EmpDao empDao = sqlSession.getMapper(EmpDao.class);
		try {
			return empDao.getEmp(empno);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * 직원 등록
	 */
	public String empReg(Emp emp, HttpServletRequest request) throws Exception {
		EmpDao empDao = sqlSession.getMapper(EmpDao.class);
		
		int result = empDao.insert(emp);
		
		if (result > 0) {
			return "redirect:/emp/emp.do";
		} else {
			return "redirect:/emp/empReg.do?error=1";
		}
	}
	
	/**
	 * 직원 수정 화면 (조회)
	 */
	public Emp empEdit(String empno) throws Exception {
		EmpDao empDao = sqlSession.getMapper(EmpDao.class);
		return empDao.getEmp(empno);
	}
	
	/**
	 * 직원 수정 처리
	 */
	public String empEdit(Emp emp, HttpServletRequest request) {
		EmpDao empDao = sqlSession.getMapper(EmpDao.class);
		
		try {
			int result = empDao.update(emp);
			if (result > 0) {
				return "redirect:/emp/empDetail.do?empno=" + emp.getEmpno();
			} else {
				return "redirect:/emp/empEdit.do?empno=" + emp.getEmpno() + "&error=1";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "redirect:/emp/empEdit.do?empno=" + emp.getEmpno() + "&error=1";
		}
	}
	
	/**
	 * 직원 삭제
	 */
	public String empDel(String empno) {
		EmpDao empDao = sqlSession.getMapper(EmpDao.class);
		
		try {
			int result = empDao.delete(empno);
			if (result > 0) {
				return "redirect:/emp/emp.do";
			} else {
				return "redirect:/emp/empDetail.do?empno=" + empno + "&error=1";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "redirect:/emp/empDetail.do?empno=" + empno + "&error=1";
		}
	}
	
	/**
	 * 부서별 직원 조회
	 */
	public List<Emp> getEmpsByDept(String deptno) {
		EmpDao empDao = sqlSession.getMapper(EmpDao.class);
		try {
			return empDao.getEmpsByDeptno(deptno);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * 직책별 직원 조회
	 */
	public List<Emp> getEmpsByJob(String job) {
		EmpDao empDao = sqlSession.getMapper(EmpDao.class);
		try {
			return empDao.getEmpsByJob(job);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * 전체 직원 수 조회
	 */
	public int getTotalCount(String f, String q) {
		String field = (f != null && !f.isEmpty()) ? f : null;
		String query = (q != null && !q.isEmpty()) ? q : null;
		
		EmpDao empDao = sqlSession.getMapper(EmpDao.class);
		try {
			if (field != null && query != null) {
				return empDao.getCount(field, query);
			} else {
				return empDao.getTotalCount();
			}
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
}
