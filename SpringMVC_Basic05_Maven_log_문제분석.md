# SpringMVC_Basic05_Maven_log 프로젝트 구동 문제 분석

## 📋 문제 상황
- **환경**: Eclipse + Tomcat
- **증상**: 구동이 됐다가 안 됐다가 반복됨
- **원인**: 여러 프로젝트가 동시에 워크스페이스에 있고, 톰캣에 하나만 배포하는 환경에서 설정 충돌 및 캐시 문제 발생

---

## 🔍 주요 발견 사항

### 1. root-context.xml의 DataSource 설정 문제 ⚠️

**현재 상태**: 여러 DataSource 설정이 주석으로 혼재
```xml
<!-- SPY(x) , POOL(x) : 주석처리됨 -->
<!-- DB  SPY(0) : 주석처리됨 -->

<!-- POOL 만 사용  배포용 : 현재 활성화 -->
<bean id="hikariConfig" class="com.zaxxer.hikari.HikariConfig">
    <property name="driverClassName" value="oracle.jdbc.driver.OracleDriver"></property>
    <property name="jdbcUrl" value="jdbc:oracle:thin:@localhost:1521:xe"></property>
    <property name="username" value="springuser"></property>
    <property name="password" value="1004"></property>
</bean>
<bean id="driverManagerDataSource" class="com.zaxxer.hikari.HikariDataSource" destroy-method="close">
    <constructor-arg ref="hikariConfig"></constructor-arg>
</bean>

<!-- 현재 개발중  net.sf.log4jdbc,pool : 주석처리됨 -->
```

**문제점**:
- 4가지 DataSource 설정이 혼재되어 있어 혼란 유발
- 개발용(log4jdbc 포함)과 배포용(순수 HikariCP) 설정이 섞여 있음
- **49번 라인**에 **zero-width space(​) 특수문자** 존재 가능성

---

### 2. Eclipse 프로젝트 설정 충돌

#### .classpath 분석
```xml
<!-- Tomcat 9.0 런타임이 하드코딩되어 있음 -->
<classpathentry kind="con" path="org.eclipse.jst.server.core.container/org.eclipse.jst.server.tomcat.runtimeTarget/Apache Tomcat v9.0">
    <attributes>
        <attribute name="owner.project.facets" value="jst.web"/>
    </attributes>
</classpathentry>
```

**문제점**:
- 다른 프로젝트와 톰캣 런타임이 충돌할 수 있음
- 톰캣 서버에서 프로젝트를 제거했다가 다시 추가할 때 경로 문제 발생 가능

---

### 3. Maven 의존성 버전 문제

#### pom.xml 분석
```xml
<java-version>11</java-version>
<org.springframework-version>5.3.6</org.springframework-version>

<!-- 오래된 버전들 -->
<dependency>
    <groupId>commons-fileupload</groupId>
    <artifactId>commons-fileupload</artifactId>
    <version>1.2.1</version> <!-- 매우 오래됨 -->
</dependency>

<dependency>
    <groupId>commons-io</groupId>
    <artifactId>commons-io</artifactId>
    <version>1.4</version> <!-- 매우 오래됨 -->
</dependency>

<!-- Log4j 1.2.15 (2010년대 버전, 보안 취약점 있음) -->
<dependency>
    <groupId>log4j</groupId>
    <artifactId>log4j</artifactId>
    <version>1.2.15</version>
</dependency>
```

**문제점**:
- commons-fileupload 1.2.1은 2006년 버전 (현재 1.5)
- commons-io 1.4는 2008년 버전 (현재 2.11+)
- Log4j 1.x는 보안 취약점이 있고 더 이상 지원되지 않음

---

### 4. 톰캣 배포 디렉토리 문제

#### target 디렉토리 구조
```
SpringMVC_Basic05_Maven_log/
├── target/
│   ├── classes/          # 컴파일된 클래스
│   ├── test-classes/
│   └── m2e-wtp/          # Eclipse WTP 메타데이터
│       └── web-resources/
│           └── META-INF/
```

**잠재적 문제**:
- Eclipse Clean 없이 톰캣 재시작 시 오래된 클래스 파일 사용
- 여러 프로젝트의 target 디렉토리가 톰캣 temp에 혼재될 가능성

---

### 5. web.xml 버전 문제

```xml
<web-app version="2.5" xmlns="http://java.sun.com/xml/ns/javaee"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://java.sun.com/xml/ns/javaee
                        https://java.sun.com/xml/ns/javaee/web-app_2_5.xsd">
```

**문제점**:
- **Servlet 2.5** 스펙 사용 (2005년 버전)
- pom.xml에는 **javax.servlet-api 3.1.0** 의존성 있음
- **버전 불일치**로 인한 예상치 못한 동작 가능

---

## 🛠️ 해결 방안

### 1단계: 프로젝트 클린 & 리빌드 (가장 먼저 시도)

```bash
# 이클립스에서
1. Project > Clean... > Clean all projects
2. 해당 프로젝트 우클릭 > Maven > Update Project (Force Update 체크)
3. 프로젝트 우클릭 > Maven > Clean
4. 프로젝트 우클릭 > Maven > Install
```

### 2단계: Tomcat 완전 초기화

```bash
# 이클립스에서
1. Servers 뷰에서 Tomcat 우클릭 > Clean...
2. Servers 뷰에서 Tomcat 우클릭 > Clean Tomcat Work Directory...
3. 톰캣 서버에서 모든 프로젝트 Remove
4. 해당 프로젝트만 Add
5. 톰캣 재시작
```

### 3단계: DataSource 설정 명확하게 정리

#### 개발 환경용 (SQL 로그 보기)
```xml
<!-- root-context.xml -->

<!-- 개발용: HikariCP + log4jdbc -->
<bean id="hikariConfig" class="com.zaxxer.hikari.HikariConfig">
    <property name="driverClassName" value="net.sf.log4jdbc.sql.jdbcapi.DriverSpy"></property>
    <property name="jdbcUrl" value="jdbc:log4jdbc:oracle:thin:@localhost:1521:XE"></property>
    <property name="username" value="springuser"></property>
    <property name="password" value="1004"></property>
</bean>
<bean id="driverManagerDataSource" class="com.zaxxer.hikari.HikariDataSource"
      destroy-method="close">
    <constructor-arg ref="hikariConfig"></constructor-arg>
</bean>
```

#### 배포 환경용 (성능 최적화)
```xml
<!-- root-context.xml -->

<!-- 배포용: HikariCP만 사용 -->
<bean id="hikariConfig" class="com.zaxxer.hikari.HikariConfig">
    <property name="driverClassName" value="oracle.jdbc.driver.OracleDriver"></property>
    <property name="jdbcUrl" value="jdbc:oracle:thin:@localhost:1521:xe"></property>
    <property name="username" value="springuser"></property>
    <property name="password" value="1004"></property>
</bean>
<bean id="driverManagerDataSource" class="com.zaxxer.hikari.HikariDataSource"
      destroy-method="close">
    <constructor-arg ref="hikariConfig"></constructor-arg>
</bean>
```

**현재는 개발 환경이므로 첫 번째 설정 권장**

### 4단계: web.xml 버전 업그레이드

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app version="3.1"
         xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
                             http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd">

    <!-- 기존 내용 동일 -->
    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>/WEB-INF/spring/root-context.xml</param-value>
    </context-param>

    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>

    <servlet>
        <servlet-name>appServlet</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>/WEB-INF/spring/appServlet/servlet-context.xml</param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>

    <servlet-mapping>
        <servlet-name>appServlet</servlet-name>
        <url-pattern>*.do</url-pattern>
    </servlet-mapping>

    <filter>
        <filter-name>EncodingFilter</filter-name>
        <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
        <init-param>
            <param-name>encoding</param-name>
            <param-value>UTF-8</param-value>
        </init-param>
    </filter>
    <filter-mapping>
        <filter-name>EncodingFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
</web-app>
```

### 5단계: Eclipse 프로젝트 Facet 설정 확인

```
프로젝트 우클릭 > Properties > Project Facets

확인 사항:
☑ Dynamic Web Module: 3.1
☑ Java: 11
☑ JavaScript: 1.0
```

---

## 🚨 긴급 조치 (구동이 안 될 때 즉시 시도)

### A. 톰캣 완전 재설정
```
1. 이클립스 종료
2. 워크스페이스/.metadata/.plugins/org.eclipse.wst.server.core/ 폴더 삭제
3. 톰캣 설치 폴더의 work, temp, logs 폴더 내용 삭제
4. 이클립스 재시작
5. 톰캣 서버 재설정
```

### B. 프로젝트 완전 재빌드
```bash
# 이클립스에서
1. Project > Clean... (모든 프로젝트 클린)
2. 해당 프로젝트 우클릭 > Close Project
3. 프로젝트 우클릭 > Open Project
4. Maven > Update Project (Force Update 체크)
5. 톰캣에 Add 후 재시작
```

### C. target 디렉토리 수동 삭제
```bash
# 프로젝트 루트에서
rm -rf target/*
# 또는 Windows에서
rd /s /q target
```
그 후 Maven Clean & Install 수행

---

## 📊 체크리스트

### 구동 전 확인사항
- [ ] 다른 프로젝트가 톰캣에 배포되어 있지 않은가?
- [ ] 톰캣 포트(8080)가 다른 프로세스에서 사용 중이지 않은가?
- [ ] Oracle DB가 실행 중인가? (localhost:1521)
- [ ] springuser 계정이 존재하는가?
- [ ] target/classes 폴더에 최신 클래스 파일이 있는가?

### 설정 파일 확인
- [ ] root-context.xml의 DataSource 설정이 하나만 활성화되어 있는가?
- [ ] web.xml과 pom.xml의 Servlet 버전이 일치하는가?
- [ ] log4j.xml이 제대로 로드되는가?
- [ ] mapper XML 파일 경로가 올바른가? (classpath*:mapper/*xml)

### Maven 의존성
- [ ] pom.xml의 모든 의존성이 다운로드되었는가?
- [ ] Maven Dependencies가 클래스패스에 포함되어 있는가?
- [ ] .m2/repository에 jar 파일들이 정상적으로 있는가?

---

## 🔧 권장 설정 변경

### 1. pom.xml 개선 (선택사항)

```xml
<!-- 보안 및 안정성 개선 -->
<properties>
    <java-version>11</java-version>
    <org.springframework-version>5.3.30</org.springframework-version> <!-- 최신 5.3.x -->
    <org.aspectj-version>1.9.19</org.aspectj-version>
    <org.slf4j-version>1.7.36</org.slf4j-version>
</properties>

<dependencies>
    <!-- Commons FileUpload 업데이트 -->
    <dependency>
        <groupId>commons-fileupload</groupId>
        <artifactId>commons-fileupload</artifactId>
        <version>1.5</version>
    </dependency>

    <!-- Commons IO 업데이트 -->
    <dependency>
        <groupId>commons-io</groupId>
        <artifactId>commons-io</artifactId>
        <version>2.11.0</version>
    </dependency>
</dependencies>
```

### 2. .settings/org.eclipse.wst.common.component 확인

프로젝트 배포 경로가 올바른지 확인:
```xml
<wb-module deploy-name="SpringMVC_Basic05_Maven_log">
    <wb-resource deploy-path="/" source-path="/src/main/webapp"/>
    <wb-resource deploy-path="/WEB-INF/classes" source-path="/src/main/java"/>
    <wb-resource deploy-path="/WEB-INF/classes" source-path="/src/main/resources"/>
</wb-module>
```

---

## 💡 개발 팁

### 여러 프로젝트 동시 작업 시 주의사항

1. **한 번에 하나의 프로젝트만 톰캣에 배포**
   - 포트 충돌 방지
   - 메모리 부족 방지

2. **프로젝트별 Context Path 명확히 구분**
   - 각 프로젝트마다 고유한 Context Root 설정
   - 예: /mvc05, /mvc04 등

3. **톰캣 Server Locations 설정**
   ```
   Servers 뷰 > Tomcat 더블클릭 > Server Locations

   권장: Use Tomcat installation (takes control of Tomcat installation)
   ```

4. **자동 배포 설정**
   ```
   Servers 뷰 > Tomcat 더블클릭 > Publishing

   - Automatically publish when resources change
   - Publishing interval: 1초
   ```

---

## 🎯 최종 권장 조치 순서

### 문제 발생 시 다음 순서로 시도:

1. **Level 1 - 간단한 재시작**
   ```
   톰캣 Clean → 프로젝트 Clean → 톰캣 재시작
   ```

2. **Level 2 - Maven 갱신**
   ```
   Maven Clean → Maven Update Project (Force) → Maven Install
   ```

3. **Level 3 - Target 삭제**
   ```
   target 폴더 삭제 → Maven Clean → Maven Install
   ```

4. **Level 4 - 톰캣 완전 초기화**
   ```
   톰캣 Remove All → Tomcat Work Directory Clean →
   이클립스 재시작 → 프로젝트만 Add
   ```

5. **Level 5 - 프로젝트 재임포트**
   ```
   프로젝트 Delete (파일 삭제 체크 안 함) →
   Import Existing Maven Project →
   Maven Update Project
   ```

---

## 📝 로그 확인 방법

### 구동 실패 시 확인할 로그

1. **이클립스 Console 탭**
   - Spring ApplicationContext 로딩 에러
   - Bean 생성 실패
   - DataSource 연결 실패

2. **톰캣 로그**
   - `{톰캣설치폴더}/logs/catalina.out`
   - `{톰캣설치폴더}/logs/localhost.{날짜}.log`

3. **주요 에러 키워드**
   - `ClassNotFoundException` → 클래스패스 문제
   - `BeanCreationException` → Bean 설정 문제
   - `SQLException` → DB 연결 문제
   - `FileNotFoundException` → 설정 파일 경로 문제

---

## 🔍 현재 설정 요약

### 활성화된 설정
```
- Spring: 5.3.6
- Java: 11
- Servlet API: 3.1.0 (pom.xml) vs 2.5 (web.xml) ⚠️ 불일치
- Tomcat: 9.0
- DataSource: HikariCP (log4jdbc 비활성화)
- MyBatis: 3.5.14
- Lombok: 1.18.30
```

### 주요 경로
```
Context Root: /kosa (추정)
DispatcherServlet: *.do
View Resolver: /WEB-INF/views/*.jsp
Mapper XML: classpath*:mapper/*xml
```

---

**작성일**: 2025-10-23
**분석 대상**: 실습코드/SpringMVC_Basic05_Maven_log
**환경**: Eclipse + Tomcat 9.0 + Spring 5.3.6
