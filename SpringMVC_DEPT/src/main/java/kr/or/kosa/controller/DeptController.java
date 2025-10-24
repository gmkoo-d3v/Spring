package kr.or.kosa.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.kosa.dto.Dept;
import kr.or.kosa.service.DeptService;

@RestController
@RequestMapping("/dept")
public class DeptController {
	
	private DeptService deptService;
	
	@Autowired
	public void setDeptservice(DeptService deptService) {
		this.deptService = deptService;
	}
	
	// 전체조회
	@GetMapping
	public ResponseEntity<List<Dept>> deptList(){
		List<Dept> list = new ArrayList<Dept>();
		try {
			System.out.println("전체조회 실행");
			list = deptService.selectAllDeptList();
			return new ResponseEntity<List<Dept>>(list, HttpStatus.OK);
		} catch (Exception e) {
			System.out.println("비정상");
			e.printStackTrace();
			return new ResponseEntity<List<Dept>>(list, HttpStatus.BAD_REQUEST);
		}
	}
	
	// 조건조회
	@GetMapping("{deptno}")
	public ResponseEntity<Dept> deptListByDeptno(@PathVariable("deptno") int deptno) {
		try {
			System.out.println("조건조회 실행: " + deptno);
			Dept dept = deptService.selectDeptByDeptno(deptno);
			return new ResponseEntity<Dept>(dept, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<Dept>(HttpStatus.BAD_REQUEST);
		}
	}
	
	// 삽입
	@PostMapping
	public ResponseEntity<String> insert(@RequestBody Dept dept){
		try {
			System.out.println("insert 실행");
			System.out.println(dept.toString());
			deptService.insert(dept);
			return new ResponseEntity<String>("insert success", HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<String>("insert fail", HttpStatus.BAD_REQUEST);
		}
	}
	
	// 수정
	@PutMapping
	public ResponseEntity<String> update(@RequestBody Dept dept){
		try {
			System.out.println("update 실행");
			System.out.println(dept.toString());
			deptService.update(dept);
			return new ResponseEntity<String>("update success", HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<String>("update fail", HttpStatus.BAD_REQUEST);
		}
	}
	
	// 삭제
	@DeleteMapping("{deptno}")
	public ResponseEntity<String> delete(@PathVariable("deptno") int deptno){
		try {
			System.out.println("delete 실행: " + deptno);
			deptService.delete(deptno);
			return new ResponseEntity<String>("delete success", HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<String>("delete fail", HttpStatus.BAD_REQUEST);
		}
	}
}
