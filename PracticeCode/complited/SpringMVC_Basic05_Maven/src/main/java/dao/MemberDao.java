package dao;

import java.sql.SQLException;

import vo.Member;

public interface MemberDao {
	public Member getMember(String userid) throws ClassNotFoundException, SQLException;
	public int insert(Member member) throws ClassNotFoundException, SQLException;
	
}
