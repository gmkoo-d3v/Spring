package ncontroller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import service.EmpService;
import vo.Emp;

@Controller
@RequestMapping("/emp/")  // 부분 경로 설정
public class EmpController {
	
	// EmpService 의존 (객체의 주소 필요)
	private EmpService empService;
	
	@Autowired
	public void setEmpService(EmpService empService) {
		this.empService = empService;
	}
	
	/**
	 * 날짜 형식 변환을 위한 InitBinder
	 * String → Date 자동 변환
	 */
	@InitBinder
	public void initBinder(WebDataBinder binder) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		dateFormat.setLenient(false);
		binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
	}
	
	// 직원 목록 조회
	@RequestMapping("emp.do")   // /emp/emp.do
	public String emps(String pg, String f, String q, Model model) {
		System.out.println("=== EmpController.emps() 호출 ===");
		System.out.println("pg=" + pg + ", f=" + f + ", q=" + q);

		List<Emp> list = empService.getEmps(pg, f, q);

		System.out.println("list=" + list);
		System.out.println("list size=" + (list != null ? list.size() : "null"));

		model.addAttribute("list", list);
		return "emp/emp";
	}
	
	// 직원 상세 조회
	@RequestMapping("empDetail.do")
	public String empDetail(String empno, Model model) {
		Emp emp = empService.getEmpDetail(empno);
		model.addAttribute("emp", emp);
		return "emp/empDetail";
	}
	
	// 직원 등록 화면
	@GetMapping(value="empReg.do")
	public String empReg() {
		return "emp/empReg";
	}
	
	// 직원 등록 처리
	@PostMapping(value="empReg.do")
	public String empReg(Emp emp, HttpServletRequest request) {
		String url = null;
		
		try {
			url = empService.empReg(emp, request);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return url;
	}
	
	// 직원 수정 화면 (데이터)
	@GetMapping(value="empEdit.do")
	public String empEdit(String empno, Model model) {
		Emp emp = null;
		
		try {
			emp = empService.empEdit(empno);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		model.addAttribute("emp", emp);
		return "emp/empEdit";
	}
	
	// 직원 수정 처리 (update)
	@PostMapping("empEdit.do")
	public String empEdit(Emp emp, HttpServletRequest request) {
		return empService.empEdit(emp, request);
	}
	
	// 직원 삭제
	@GetMapping("empDel.do")
	public String empDel(String empno) {
		return empService.empDel(empno);
	}
	
	// 부서별 직원 조회
	@GetMapping("empByDept.do")
	public String empByDept(String deptno, Model model) {
		List<Emp> list = empService.getEmpsByDept(deptno);
		model.addAttribute("list", list);
		model.addAttribute("deptno", deptno);
		return "emp/empByDept";
	}
	
	// 직책별 직원 조회
	@GetMapping("empByJob.do")
	public String empByJob(String job, Model model) {
		List<Emp> list = empService.getEmpsByJob(job);
		model.addAttribute("list", list);
		model.addAttribute("job", job);
		return "emp/empByJob";
	}
}
