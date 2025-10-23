package ncontroller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class IndexController {
	
	// 메인 페이지 - emp 목록으로 리다이렉트
	@RequestMapping("/index.do")
	public String index() {
		return "redirect:/emp/emp.do";
	}
	
	// 루트 경로 - emp 목록으로 리다이렉트
	@RequestMapping("/")
	public String root() {
		return "redirect:/emp/emp.do";
	}
}
