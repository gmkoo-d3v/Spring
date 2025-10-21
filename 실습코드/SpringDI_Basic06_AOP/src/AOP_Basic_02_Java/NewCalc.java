package AOP_Basic_02_Java;

public class NewCalc implements Calc{

	@Override
	public int ADD(int x, int y) {
		//보조업무(공통업무) : 횡단관심
		
		//주관심
		int sum = x + y;
		
		//보조업무(공통업무) : 횡단관심
		return sum;
	}

	@Override
	public int MUL(int x, int y) {
		//보조업무(공통업무) : 횡단관심
		
		//주관심
		int mul = x * y;
				
		//보조업무(공통업무) : 횡단관심
		return mul;
	}

	@Override
	public int SUB(int x, int y) {
		//보조업무(공통업무) : 횡단관심
		
		//주관심
		int sub = x - y;
				
		//보조업무(공통업무) : 횡단관심
		return sub;
	}

}
