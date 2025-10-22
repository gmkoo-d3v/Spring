package com.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class SearchController {
	/*
	
		1. 전통적인 (프레임에 종속적이지 않음)
		2. DTO   (insert , update )
		3. parameter >> ?list.do?id=7902  >> search(String id)   (select, delete)
		4. @RequestParam >> default 값이 있다 >> 실수로 파라메터값 미입력 혹은 강제로 쓰고싶을때
		5. REST 방식 (비동기 처리) method = GET , POST , PUT , DELETE
			@PathVariable >> /member/{memberid} >> /member/100
			
		   <a href="search/external.do">external.do</a><br>
		   <a href="search/external.do?p">external.do</a><br>
		   <a href="search/external.do?query=world">external.do</a><br>
		   <a href="search/external.do?p=555">external.do</a><br>
		
	
	  public ModelAndView searchExternal(String query , int p){}이렇게 심플하게해도된다.
	*/
		
	@RequestMapping("/search/external.do")
	public ModelAndView searchExternal(@RequestParam(value="query",defaultValue = "kosa") String query,
		// 니가 값을 안주면 난 kosa를 기본으로 받을꺼야
										@RequestParam(value="p",defaultValue = "10") int p){	
			System.out.println("param query : "+query);
			System.out.println("param p:"+p);
		
		return new ModelAndView("search/external");
		// /WEB_INF/views/ +search/external +.jsp
	}
}
