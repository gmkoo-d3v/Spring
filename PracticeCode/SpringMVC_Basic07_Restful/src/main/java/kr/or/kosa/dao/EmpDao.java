package kr.or.kosa.dao;

import java.util.List;

import kr.or.kosa.dto.Emp;

public interface EmpDao {
	//Mapper 와 연동할 추상함수 (CRUD)
	
	List<Emp> select();
	
	Emp selectByEmpno(int empno);
	
	int insert(Emp emp);
	
	int update(Emp emp);
	
	int delete(int empno);
}
