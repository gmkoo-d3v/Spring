package com.service;

import org.springframework.stereotype.Service;

import com.model.NewArticleCommand;

/*

@Service 
public class ArticelService

자동화
@Service 붙어 있는 클래스는 componentScan 자동으로 빈객체 생성
<context:component-scan base-package="com.service">

*/

public class ArticleService {
	public ArticleService() {
		System.out.println("ArticleService 서비스 생성자 호출");
	}
	public void writeArticle(NewArticleCommand command) {
		//DAO 있다고 가정
		//Dao dao = new Dao(); dao.insert(command) 했다 치고
		System.out.println("글쓰기 작업이 완료:"+ command.toString());
	}
}
