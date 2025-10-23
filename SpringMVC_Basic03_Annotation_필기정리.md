# SpringMVC Basic03 - Annotation 방식 필기 정리

## 📌 전체 개요

### 기존 방식의 문제점
```java
/*
public class NoticeController implements Controller 기존방식
하나의 요청만 처리

<bean id="/customer/notice.htm"
      class="controllers.customer.NoticeController">

단순한 작업이 아니면 ....
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
게시판 하나만 만들어도 (목록 , 글쓰기 , 수정 , 삭제 ..요청 여러개)
>> 하나의 클래스가 여러개의 요청을 처리 하면 >> @Controller >> 그안에서 함수단위 mapping 작업 가능
*/
```

---

## TEST_1: HelloController - 기본 @Controller 사용법

### 📝 필기 내용
```java
/*
public class NoticeController  implements Controller 기존방식
하나의 요청만 처리

<bean  id="/customer/notice.htm"
       class="controllers.customer.NoticeController">

단순한 작업이 아니면 ....
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
게시판 하나만 만들어도 (목록 , 글쓰기 , 수정 , 삭제 ..요청 여러개)
>> 하나의 클래스가 여러개의 요청을 처리 하면 >> @Controller >> 그안에서 함수단위 mapping 작업 가능
*/
```

### 코드 예시
```java
@Controller
public class HelloController {

    //생성자
    public HelloController() {
        System.out.println(" HelloController  생성됨");
    }

    //요청 <a href="hello.do">hello.do 요청하기</a>
    @RequestMapping("/hello.do")
    public ModelAndView hello() {
        System.out.println("hello.do 요청에 대해서 method call");

        ModelAndView mv = new ModelAndView();
        mv.addObject("greeting",getGreeting());
        mv.setViewName("Hello"); //   /WEB-INF/views + Hello + .jsp
        return mv;
    }
}
```

### spring-servlet.xml 설정
```xml
<!-- TEST_1  @Controller 자동으로 빈객체가 되지 않아요 -->
<bean id="helloController" class="com.controller.HelloController"></bean>
```

---

## TEST_2: NewArticleController - GET/POST 방식 구분

### 📝 필기 내용 1: 클라이언트 요청 처리 방식
```java
/*
클라이언트 요청
1. 화면주세요 (글쓰기, 로그인화면): write.do
2. 처리해주세요 (글쓰기 업무 처리, 로그인 업무 처리): writeok.do

요청주소가 : write.do
요청주소가 : writeok.do
---------------------------------------
Spring 에서는 생각^^
클라이언트 요청 판단
method 단위
GET, POST (form method="post")

** 요청의 주소가 동일하더라도 (1개의 요청 주소로) > 화면 , 처리 판단 > 전송방식(GET, POST)
http:// ...../newArticle.do
요청방식
GET 화면 > view
POST 서비스 처리 >> DB 연동 >> 데이터 처리 >> view
*/
```

### 📝 필기 내용 2: 의존성 주입
```java
//NewArticleController 는 ArticleService에 의존합니다 (주소가 필요해)
//DI (setter , constructor , member field)

private ArticleService articleService;

@Autowired  //IOC 컨테이너 ArticleService 서비스 타입의 객체 존재 자동 주입
public void setArticleService(ArticleService articleService) {
    this.articleService = articleService;
}
```

### 📝 필기 내용 3: GET 처리
```java
//2가지
//1. GET  > "/article/newArticle.do"
//2. POST > "/article/newArticle.do"

//요청 : GET
//http://localhost:8090/SpringMVC_Basic03_Annotation/article/newArticle.do
@GetMapping
public String form() { //GET 처리되는 함수 (화면 처리)
    /*
        public ModelAndView form(){
           ModelAndView mv= new ModelAndView();
           mv.setViewName="hello.jsp"
        }

     규칙 : 함수의 return type String 이면 리턴 값의 view 주소
    */

    return "article/newArticleForm";

    //internalViewRe....>  /WEB-INF/views/ + article/newArticleForm + .jsp
}
```

### 📝 필기 내용 4: POST 처리 및 자동 데이터 전달
```java
@PostMapping   //데이터 받아서 처리해주 ....
public String submit(NewArticleCommand command) {  //POST 처리되는 함수 (로직 처리)

    System.out.println("POST 처리 ....");
    System.out.println("command : " + command.toString());
    this.articleService.writeArticle(command);

    //데이터 담는 작업
    //ModelAndView 데이터 ... view 까지 전달

    /*
    생략 ...
    NewArticleCommand article = new NewArticleCommand();
    article.setParentId( Integer.parseInt(request.getParameter("parentId")));
    article.setTitle(request.getParameter("title"));
    article.setContent(request.getParameter("content"));

    ModelAndView mv = new ModelAndView();
    mv.addObject("newArticleCommand", article);  //request.setAttribute("newArticleCommand", article)
    mv.setViewName("article/newArticleSubmitted");

    */

    //spring view 데이터 보내요 ...
    //NewArticleCommand > newArticleCommand 자동 생성
    //mv.addObject("newArticleCommand", article); 자동

    return "article/newArticleSubmitted";
}
```

### 📝 필기 내용 5: 전통적인 방법 (권장하지 않음)
```java
/*
호랑이 담배 피던 시절에 했던 코드 .... HttpServletRequest request >> spring 고민 고민 ....
@PostMapping  //5.x.x
public ModelAndView sumbit(HttpServletRequest request) { //처리
    System.out.println("POST 처리해주세요");

    NewArticleCommand article = new NewArticleCommand();
    article.setParentId( Integer.parseInt(request.getParameter("parentId")));
    article.setTitle(request.getParameter("title"));
    article.setContent(request.getParameter("content"));


    this.articleService.writeArticle(article);
    ModelAndView mv = new ModelAndView();
    mv.addObject("newArticleCommand", article);  //request.setAttribute("newArticleCommand", article)
    mv.setViewName("article/newArticleSubmitted");


    return mv;
}
*/
```

### 📝 필기 내용 6: Spring의 자동화 처리
```java
/*
 2. Spring 에서 parameter DTO 객체로 받기
 2.1 자동화 >> 선행조건 >> input 태그의 name값이 DTO 객체의 memberfield 명과 동일

 @PostMapping  //5.x.x
 public ModelAndView sumbit(NewArticleCommand command) { //처리
    System.out.println("POST 처리해주세요");

    //1. 자동 DTO 객체 생성 : NewArticleCommand command = new NewArticleCommand();
    //2. 넘어온 parameter  setter 함수를 통해서 자동 주입  => article.setParentId 자동
    //3. NewArticleCommand command 객체 자동 IOC 컨테이너 안에 등록 : id=newArticleCommand
    //   <bean id="newArticleCommand"  class="....

    this.articleService.writeArticle(command);
    ModelAndView mv = new ModelAndView();
    mv.addObject("newArticleCommand", command);  //request.setAttribute("newArticleCommand", article)
    mv.setViewName("article/newArticleSubmitted");


    return mv;
}
*/
```

### 📝 필기 내용 7: Parameter 처리 방법 정리
```java
/*
1. 전통적인 방법
public ModelAndView searchExternal(HttpServletRequest request) {
    String id= request.getParameter("id")
}

2. DTO 객체를 통한 전달 방법(게시판, 회원가입 데이터) ^^
public ModelAndView searchExternal(MemberDto member){}

public String searchExternal(MemberDto member){

 return String view 주소 전달
 return String view (데이터 출력) > 페이지 > forward > memberDto 객체 만들어 > 자도 forward

 /search/external.do?id=hong&name=김유신&age=100
 2.1 DTO 있는 member field 이름이 >>
 private String id;
 private String name;

}

약속 : return String .. Model 만들면 데이터 전달
      return String  .. 화면 UI


3. 가장 만만한 방법
public ModelAndView searchExternal(String id, String name , int age){
  /search/external.do?id=hong&name=김유신&age=100
  ** 각각의 parameter 에 자동 매핑
}

4. @RequestParam  annotation 사용하기
4.1 유효성 처리
4.2 기본값 처리


5.REST 방식 (비동기 처리) method= GET , POST , PUT , DELETE
@PathVariable >>  /member/{memberid} >>  /member/100

100 추출해서 parameter  사용
*/
```

### spring-servlet.xml 설정
```xml
<!-- TEST_2
 하나의 요청 주소 (method 판단)
 GET  (화면)  > 함수호출
 POST (처리)  > 처리함수 호출
 -->
<bean class="com.controller.NewArticleController"></bean>
<bean class="com.service.ArticleService"></bean>
```

---

## TEST_3: OrderController - List 타입 데이터 처리

### 📝 필기 내용 1: GET/POST 하나의 주소로 처리
```java
/*
하나의 요청 주소로 2가지 업무
GET  > 화면
POST > 처리해 주세요
*/

@Controller
@RequestMapping("/order/order.do")
public class OrderController {

    @GetMapping
    public String form() {
        return "order/OrderForm";
    }

    @PostMapping
    public String submit(OrderCommand orderCommand) {
        return "order/OrderCommitted"; //뷰의 주소
    }
}
```

### 📝 필기 내용 2: List 타입 자동 매핑 원리
```java
/*
private List<OrderItem> orderItem; parameter 로
orderItem[0]
orderItem[1]
orderItem[2]

setter 동작
public void setOrderItem(List<OrderItem> orderItem) {
        this.orderItem = orderItem;
}
할려면 ArrayList 필요 ....


생략된 코드
1. OrderCommand orderCommand = new OrderCommand();
2. 자동매핑 >>  member field >> private List<OrderItem> orderItem >> 자동 주입

3. List<OrderItem> itemList = new ArrayList();
   >> orderItem[0].itemid >> 1
   >> orderItem[0].number >> 10
   >> orderItem[0].remark >> 파손주의

   itemList.add(new OrderItem(1,10,"파손주의");


   >> orderItem[1].itemid >> 2
   >> orderItem[1].number >> 3
   >> orderItem[1].remark >> 리모컨 별도

   itemList.add(new OrderItem(2,3,"리모컨 별도");


   >> orderItem[2].itemid >> 3
   >> orderItem[2].number >> 5
   >> orderItem[2].remark >> 파손주의

   itemList.add(new OrderItem(3,5,"파손주의");

  orderCommand.setOrderItem(itemList); 최종 ....

4. view 전달
   forward ...

   submit(OrderCommand orderCommand)
   key >> OrderCommand >> orderCommand  >> mv.addObject("orderCommand",주소)
   value >> OrderCommand 객체 주소
*/
```

### 📝 필기 내용 3: OrderCommand 클래스 설명
```java
/*
주문서 클래스
하나의 주문은 여러개의 상품(OrderItem) 을 가질 수 있다

Board  /  reply(댓글)
하나의 게시글은 여러개의 댓글을 가질 수 있다
Board클래스 ...
private List<Reply> replyList;


하나의 은행은 여러개의 계좌를 가질 수 있다
*/

public class OrderCommand { //주문 (주문 1건은 여러개의 주문상세(상품) 을 가질 수 있다
  //KEY POINT
    private List<OrderItem> orderItem;

    public List<OrderItem> getOrderItem() {
        return orderItem;
    }

    public void setOrderItem(List<OrderItem> orderItem) {
        this.orderItem = orderItem;
    }
}

/*
 주문 발생 (2건의)
 1 , 10 , 파손주의
 2 , 2  , 리모콘별도주문

 OrderCommand command = new OrderCommand();

 List<OrderItem> itemList = new ArrayList();
 itemList.add(new OrderItem(1,10,"파손주의"));
 itemList.add(new OrderItem(2, 3,"리모콘별도주문"));

 command.setOrderItem(itemList);


*/
```

### 📝 필기 내용 4: JSP에서 배열 형태로 전송
```html
<!--
 OrderCommand command = new OrderCommand();

  List<OrderItem> itemList = new ArrayList<>();
  itemList.add(new OrderItem(1,10,...));
  itemList.add(new OrderItem(2,1,...));

  command.setOrderItem(itemList);
 -->
<form method="post">
    상품_1<br>
    상품ID: <input type="text" name="orderItem[0].itemid"> <!-- new OrderItem(1,10,...) -->
    상품수량: <input type="text" name="orderItem[0].number">
    상품주의사항: <input type="text" name="orderItem[0].remark">
    <br>
    상품_2<br>
    상품ID: <input type="text" name="orderItem[1].itemid"><!-- new OrderItem(2,1,...)  -->
    상품수량: <input type="text" name="orderItem[1].number">
    상품주의사항: <input type="text" name="orderItem[1].remark">
    <br>
    상품_3<br>
    상품ID: <input type="text" name="orderItem[2].itemid"> <!-- new OrderItem(2,1,...)  -->
    상품수량: <input type="text" name="orderItem[2].number">
    상품주의사항: <input type="text" name="orderItem[2].remark">
    <br>
    <hr>
    <input type="submit" value="전송">
</form>
```

### spring-servlet.xml 설정
```xml
<!--  TEST_3  -->
<bean class="com.controller.OrderController"></bean>
```

---

## TEST_4: SearchController - @RequestParam 사용

### 📝 필기 내용: Parameter 처리 5가지 방법
```java
/*
  1. 전통적인 ..
  2. DTO .. (insert , update )
  3. parameter  >>  ?list.do?id=7902  >>  search(String id)  (select , delete)
  4. @RequstParam >> default >>

  5. REST 방식 (비동기 처리) method= GET , POST , PUT , DELETE
     @PathVariable >>  /member/{memberid} >>  /member/100


  <a href="search/external.do">external.do</a><br>
  <a href="search/external.do?p">external.do</a><br>
  <a href="search/external.do?query=world">external.do</a><br>
  <a href="search/external.do?p=555">external.do</a><br>


public ModelAndView searchExternal(String query , int p) {}
 */
@RequestMapping("/search/external.do")
public ModelAndView searchExternal(@RequestParam(value="query", defaultValue = "kosa") String query,
                                   @RequestParam(value="p",     defaultValue = "10") int p) {

    System.out.println("param query : " + query);
    System.out.println("param p : " + p);

    return new ModelAndView("search/external"); //view 이름
    //  /WEB-INF/views/ + search/external + .jsp
}
```

### spring-servlet.xml 설정
```xml
<!-- TEST_4 -->
<bean class="com.controller.SearchController"></bean>
```

---

## TEST_5: CookieController - Cookie 처리

### 코드 예시
```java
@Controller
public class CookieController {

    @RequestMapping("/cookie/make.do")
    public String make(HttpServletResponse response) {

        response.addCookie(new Cookie("SpringAuth","1004")); //클라이언트 브라우져 write

        return "cookie/CookieMake";  //view 페이지 ....보여주기

    }

    //public String view(HttpServletRequest request) {
        //전통적인 방법
    //}
    @RequestMapping("/cookie/view.do")
    public String view(@CookieValue(value="SpringAuth" , defaultValue = "1007") String auth) {

        System.out.println("Client 브라우져에 read 한 Cookie 값 : " + auth);

        return "cookie/CookieView";
    }
}
```

### spring-servlet.xml 설정
```xml
<!-- TEST_5 -->
<bean class="com.controller.CookieController"></bean>
```

---

## TEST_6: ImageController - 파일 업로드

### 📝 필기 내용 1: Photo DTO 자동 매핑
```java
/*
    1. Photo DTO 타입으로 데이터 받기
    1.1 자동화 : name 속성값이 Photo 타입클래스의 member field 명과 동일
    2. public String submit(Photo photo) 내부적으로 ...
       >> Photo photo = new Photo();
       >> photo.setName("홍길동");
       >> photo.setAge(20);
       >> photo.setImage() >> 자동 주입 안되요 >> 수동으로 >> 가공 CommonsMultipartFile 추출(이름)
       >> photo.setFile(CommonsMultipartFile file) 파일 자동으로 들어와요

 */
System.out.println(photo.toString());
//Photo [name=hong, age=100, image=null,
//file=MultipartFile[field="file", filename=w3schools.jpg, contentType=image/jpeg, size=4377]]

CommonsMultipartFile imageFile = photo.getFile();
System.out.println("imagefile getName()" + imageFile.getName() );
System.out.println("imagefile getContentType()" + imageFile.getContentType() );
System.out.println("imagefile getOriginalFilename()" + imageFile.getOriginalFilename() );
System.out.println("imagefile getBytes().length" + imageFile.getBytes().length );

//필요한 정보가 있다면 추출해서 DB > Table > insert 해야 되요

//POINT 파일명 추출 image=null
photo.setImage(imageFile.getOriginalFilename()); //수동 ...
```

### 📝 필기 내용 2: 파일 업로드 처리
```java
//upload (서버에 파일쓰기)
//자동화 : cos.jar (무료) ,  덱스트 업로드(제품 구매)

//수동으로 코딩( I/O)
String fileName = imageFile.getOriginalFilename();
//HttpServletRequest request
String path = request.getServletContext().getRealPath("/upload"); //실 배포 경로
String fpath = path + "\\" + fileName;  // C:\\Web\\upload\\a.jpg

System.out.println(fpath);

FileOutputStream fs = null;

try {
       fs = new FileOutputStream(fpath); //파일이 없으면 빈 파일 ( a.jpg) 자동
       fs.write(imageFile.getBytes()); //image생성 .... 업로드한 파일 서버에 write

} catch (Exception e) {
       e.printStackTrace();
}finally {
     try {
        fs.close();
    } catch (IOException e) {
        e.printStackTrace();
    }
}

//요기까지 작업 서버에 특정 폴더에 (upload) : 파일 생성
//DB 연결 > DAO > 게시판 테이블 > Insert  했다고 치고
```

### 📝 필기 내용 3: spring-servlet.xml 설정 설명
```xml
<!-- TEST_6 파일 업로드  -->
<!--
        import org.springframework.web.multipart.commons.CommonsMultipartResolver;
        import org.springframework.web.multipart.commons.CommonsMultipartFile;

        CommonsMultipartFile 사용해서  업로드를 할려면 몇가지 기본 세팅

        CommonsMultipartResolver  : 업로드한 파일에 대한 정보 관리(크기 , 이름....)

        파일 처리 (의존 객체)
        //C:\Spring\Framework\spring-framework-3.0.2.RELEASE-dependencies\org.apache.commons\com.springsource.org.apache.commons.fileupload\1.2.0
        com.springsource.org.apache.commons.fileupload-1.2.0.jar
        com.springsource.org.apache.commons.io-1.4.0.jar

        CommonsMultipartResolver  : 업로드한 파일에 정보 관리(크기 , 이름  , 중복이름 정책)

     -->
     <!--
        <property name="uploadTempDir" value="uploadTempDir"/>
        <bean id="uploadTempDir" class="org.springframework.core.io.FileSystemResource">
        <constructor-arg value="c:/temp/"/>
        </bean>
    -->
    <bean class="com.controller.ImageController"></bean>
    <bean id="multipartResolver"  class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
            <property name="maxUploadSize" value="1048760"></property>
            <property name="defaultEncoding" value="UTF-8"></property>
    </bean>
```

---

## 🎯 핵심 정리

### 1. @Controller의 필요성
- **기존 방식**: 하나의 클래스 = 하나의 요청 처리
- **@Controller 방식**: 하나의 클래스에서 여러 요청을 메서드 단위로 처리
- 게시판 같은 기능(목록, 글쓰기, 수정, 삭제)을 하나의 클래스에서 관리

### 2. GET/POST 구분 처리
- **동일한 URL**로 GET과 POST를 구분하여 처리
- **GET**: 화면 요청 → `@GetMapping`
- **POST**: 데이터 처리 → `@PostMapping`

### 3. Parameter 자동 매핑 조건
- **input name 속성** = **DTO 필드명**
- Spring이 자동으로 객체 생성 및 setter 호출
- 자동으로 Model에 등록되어 View로 전달

### 4. List 타입 처리
- **배열 형태**: `orderItem[0].itemid`
- Spring이 자동으로 ArrayList 생성 및 데이터 추가
- setter를 통해 최종 객체에 주입

### 5. Parameter 처리 5가지 방법
1. HttpServletRequest (전통적, 권장X)
2. DTO 객체 (게시판, 회원가입 등)
3. 개별 파라미터 (간단한 경우)
4. @RequestParam (기본값, 유효성 처리)
5. @PathVariable (REST 방식)

### 6. 파일 업로드
- **CommonsMultipartResolver** 설정 필수
- 파일명은 **수동으로** 설정: `photo.setImage(imageFile.getOriginalFilename())`
- FileOutputStream으로 서버에 파일 저장
- DB에는 파일 정보만 저장

### 7. Return Type
- **ModelAndView**: 데이터 + View 직접 제어
- **String**: View 이름만 반환, 데이터는 자동 전달

---

## 📚 main.html - 전체 테스트 메뉴

```html
<h3>TEST_1</h3>
<a href="hello.do">hello.do 요청하기</a>

<h3>TEST_2 : http: 전송 GET(화면) , POST(처리) > 화면  or 로직처리 </h3>
<a href="article/newArticle.do">글쓰기(GET)</a>

<h3>TEST_3 : http: 전송 GET(화면) , POST(처리) > 화면  or 로직처리 > List</h3>
<a href="order/order.do">주문하기(화면)</a>

<h3>TEST_4 Spring parameter 다루기</h3>
<a href="search/external.do">external.do</a><br>
<a href="search/external.do?p">external.do</a><br>
<a href="search/external.do?query=world">external.do</a><br>
<a href="search/external.do?p=555">external.do</a><br>

<h3>TEST_5 Spring Cookie 사용하기</h3>
<a href="cookie/make.do">make.do 쿠키 생성하기</a><br>
<a href="cookie/view.do">view.do 쿠키 보기</a><br>

<h3>TEST_6 CommonsmultipartFile 를 사용한 Spring 파일 업로드</h3>
<a href="image/upload.do">image 파일 업로드</a>
```

---

**작성일**: 2025-10-23
**출처**: 실습코드/SpringMVC_Basic03_Annotation 주석 내용 기반 정리
