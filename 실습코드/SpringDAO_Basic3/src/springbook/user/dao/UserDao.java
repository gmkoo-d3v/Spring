package springbook.user.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import springbook.user.domain.User;

public class UserDao {
	//DB연결을 가지고 있는  SimpleConnectionMaker 클래스 사용
	//UserDao 각 SimpleConnectionMaker 를 <<<<  복합연관   >>>>>(객체의 LifeCycle 동일) **********
	//dependency 의존관계와 혼동하지 말자 ....,.
	// 근데 가지고있는게 NULL 그러니 new
	private SimpleConnectionMaker simpleconnectionmaker;
	public UserDao(){ // 생성자
		this.simpleconnectionmaker = new SimpleConnectionMaker(); //나는 너의 주소가 필요해 의존성 주입
	}
	// 자동차를 만들면 엔진도 new한것 고로 라이프 사이클이 같다.
	/*
	  
	  
	 
	 public UserDao(SimpleConnectionMaker s){ // 생성자
		this.simpleconnectionmaker = s; 이러면 심플커넥션 메이커 s 파라메터만 받는 생성자이기때문에 라이프사이클이 다르다.
	} 
	좀더 해설 이런거임
	  main(){
	  	SimpleConnectionMaker s = new SimpleConnectionMaker();
	  	UserDao dao = new UserDao(s);
	  }
	  -------------------------------------------------------
	  main(){
	  	UserDao dao = new UserDao();
	  	
	  }
	  이러니 라이프사이클이 같다.	  
	 
	 */
	
	
	
	//Data Add
	public void add(User user) throws ClassNotFoundException , SQLException {
		//Class.forName("oracle.jdbc.driver.OracleDriver");
		//Connection c = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","spring","1004");
		//Connection c = getConnection();
		Connection c = simpleconnectionmaker.getConnection();
		PreparedStatement ps = c.prepareStatement("insert into users(id,name,password) values(?,?,?)");
		ps.setString(1, user.getId());
		ps.setString(2, user.getName());
		ps.setString(3, user.getPassword());
		
		ps.executeUpdate();
		
		ps.close();
		c.close();
		
	}
	
	//Data Get
	public User get(String id) throws ClassNotFoundException , SQLException {
		//Class.forName("oracle.jdbc.driver.OracleDriver");
		//Connection c = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","spring","1004");
		Connection c = simpleconnectionmaker.getConnection();
		PreparedStatement ps = c.prepareStatement("select * from users where id =?");
		ps.setString(1, id);
		ResultSet rs = ps.executeQuery();
		rs.next();
		User user = new User();
		user.setId(rs.getString("id"));
		user.setName(rs.getString("name"));
		user.setPassword(rs.getString("password"));
		return user;
	}
	
	//Oracle -> MySql
	//중복관심에 대한 하나의 관심사로 모았다(DB연결)
	/*private Connection getConnection() throws ClassNotFoundException,SQLException{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		Connection c = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","spring","1004");
		return c;
	}*/
	
	//2차 요구사항
	//벤더 마다 다른 연결을 가지고 싶다
	//벤더가 자기 회사의 연결을 강제 구현
	
	//3차 요구사항()
	//abstract protected Connection getConnection() throws ClassNotFoundException ,SQLException;

	
	
}
