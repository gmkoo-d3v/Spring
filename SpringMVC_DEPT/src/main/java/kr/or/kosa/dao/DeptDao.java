package kr.or.kosa.dao;

import java.util.List;

import kr.or.kosa.dto.Dept;

public interface DeptDao {
	// Mapper와 연동할 추상함수 (CRUD)
	
	List<Dept> select();
	
	Dept selectByEmpno(int deptno);
	
	int insert(Dept dept);
	
	int update(Dept dept);
	
	int delete(int deptno);
}
