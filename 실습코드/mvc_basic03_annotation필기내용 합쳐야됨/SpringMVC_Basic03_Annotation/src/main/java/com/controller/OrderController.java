package com.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.model.OrderCommand;
import com.model.OrderItem;

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