package com.model;

import java.util.List;

/*
주문서 클래스
하나의 주문은 여러개의 상품을 가질수 있다(OrderItem)을 가질 수 있다.

Board / reply(댓글)
하나의 게시글은 여러개의 댓글을 가질 수 있다.

Board클래스 ...
private List<Reply> replyList;

하나의 은행은 여러개의 계좌를 가질수 있다.
*/

public class OrderCommand { //주문 (주문 1건은 여러개의 주문 상세(상품)를 가질 수 있다)
	// KEY POINT
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
1, 10, 파손주의
2, 2 , 리모콘별도주문

OrderCommand command = new OrderCommand();

List<OrderItem> itemList = new ArrayList();
itemList.add(new OrderItem(1,10,"파손주의"));
itemList.add(new OrderItem(2,2,"리모콘별도주문"));

command.setOrderItem(itemList);
주문 하나에 상세가 두 건


*/