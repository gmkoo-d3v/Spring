package com.controller;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class CookieController {
	//HttpServletResponse 이런거 스프링에서도 여전히 사용
	@RequestMapping("/cookie/make.do")
	public String make(HttpServletResponse response){
		// 자바는 원칙적으로 웹에 못쓰기 때문에
		
		response.addCookie(new Cookie("SpringAuth","1004")); //클라이언트 브라우저 write
		
		return "cookie/CookieMake"; //view 페이지 .. 보여주기
	}
	
	//public String view(HttpServletRequest request) {
		//전통적인 방법
	//}
	@RequestMapping("/cookie/view.do")
	public String view(@CookieValue(value="SpringAuth", defaultValue="1007") String auth) {
		
		System.out.println("Client 브라우저에 read 한 Cookie 값: " + auth);
		return "cookie/CookieView";
	}
}
