package vo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class Emp {
	private Integer empno;      // 사원번호
    private String ename;       // 사원명
    private String job;         // 직책
    private Integer mgr;        // 매니저 번호
    
    @DateTimeFormat(pattern = "yyyy-MM-dd")  // 날짜 포맷 지정
    private Date hiredate;      // 입사일
    
    private Double sal;         // 급여
    private Double comm;        // 커미션
    private Integer deptno;     // 부서번호
}
