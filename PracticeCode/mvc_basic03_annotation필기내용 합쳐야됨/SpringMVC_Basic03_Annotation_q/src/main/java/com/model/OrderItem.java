package com.model;

import lombok.Data;

//DB 상품테이블
//Order > orderItem

@Data
public class OrderItem {
	private int itemid;
	private int number;
	private String remark;
	
}
