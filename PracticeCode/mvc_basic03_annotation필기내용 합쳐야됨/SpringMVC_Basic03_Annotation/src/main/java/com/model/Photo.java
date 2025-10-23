package com.model;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

/*
	게시판 글쓰기 + 파일 업로드
	
	create table photo(
		name
		age
		image > 파일 저장이 아니고 이름만 저장 > 파일 이름 > 1.jpg
		
		이런건 어떤가 
		큰타입 (x)
		>>clob(캐릭터라지오브젝트)
		>>blob 
		2기가까진 저장가능함  
	
	)
	
	실제 파일은 (Web server 디스크)
	AWS > S3 (파일 서버) > 3차 ....
	ㄴ S3 서버 : vue , react 를 배포
	
	파일 업로드 
	1. 파일서버(S3) > 파일을 write - 이건 IO >> file, inputStream .... outputStream
	2. 정보를 가지고 > DB > insert > 파일이름, 파일 용량 , 확장자 등을 insert를 통해 저장
	
	Spring > DTO 통해서 > 파일 객체를 받는다.
	파일을 받을 수 있는 클래스 타입 : CommonsMultipartFile 타입
	
*/
// 테이블 생성 ....


public class Photo {
	private String name;
	private int age;
	private String image;
	
	//파일을 담을 수 있는 객체 List<CommonsMultipartFile> files 이게 여러개면 어러번 가능
	// Point //////////////////////////////////////////////////////////////////////
	private CommonsMultipartFile file;	// 파일을 던지면 예기 업로드한 파일 정보를 받는다.
	// 단 file이름(멤버필드 이름)  과 인풋태그가 가지고있는 name 이 같아야된다.<input type="text" name="name"><br>
	//enctype="multipart/form-data"
	public CommonsMultipartFile getFile() {
		return file;
	}

	public void setFile(CommonsMultipartFile file) {
		this.file = file;
	}
	/////////////////////////////////////////////////////////////
	
	
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	
	
	
}