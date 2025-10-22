<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<!--  
	초급자의 실수 1순위
	enctype="multipart/form-data"
	나는 사람과 차를 같이 수송할수 있는 배다
	전송: 텍스트 + 파일 
	DTO로 파일도 받을수 있다.
-->
	<form method="post" enctype="multipart/form-data">
		이름:<input type="text" name="name"><br>
		나이:<input type="text" name="age"><br>
		사진:<input type="file" name="file"><br>
		<input type="submit" value="파일 업로드">
	</form>
</body>
</html>