package ncontroller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class IndexController {

	@RequestMapping("/index.do") // web-inf/views/index.jsp 로 전송시킴
	public String index() {
		return "index";
		
		//   /WEB-INF/views/ + index + .jsp
	}
}
