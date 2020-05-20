<!---
markmeta_author: wongoo
markmeta_date: 2020-05-20
markmeta_title: 对有依赖关系的元素进行顺序调整
markmeta_categories: algorithm
markmeta_tags: algorithm
-->

# 对有依赖关系的元素进行顺序调整


```js
/**
算法需求: 构建节点顺序，支持节点前后移动，节点之间有依赖关系，移动后不改变依赖关系。
算法实现: 通过链表方式控制节点顺序，前后移动的时候通过找到无依赖关系的节点，将节点移动到指定位置。	
**/

let data=[
	{key:"a", dep:""},  // 确保只有一个无依赖的起始节点
	{key:"b",dep:"a"}, 
	{key:"c",dep:"a"}, 
	{key:"d",dep:"c"}, 
	{key:"e",dep:"d"}, 
	{key:"f",dep:"a"}, 
	{key:"g",dep:"a"}
];

let dataMap = {};
var firstItem ;

function initData(){
	// 初始化map
	for (index in data){
		let item = data[index]
		dataMap[item.key] = item;

		if (item.dep == ""){
			item.order = 1;
			firstItem = item;
		}
	}

	// 构建链表
	for (index in data){
		let item = data[index]
		let previous = dataMap[item.dep];

		while (previous && previous.next){
			previous = previous.next;
		}

		if (previous){
			item.previous = previous;
			previous.next = item;
		}
	}
}

// 将一个节点前移	
function movePrevious(key){
	let item = dataMap[key];

	// 没有前置节点则返回
	if (!item.previous){
		return ;
	}

	let depStart = item;
	let exchange = item.previous;
	let next = item.next;

	let tempDepKeys = {}
	tempDepKeys[item.dep] = item;

	// 向前找到无依赖的节点exchange, exchange.key 不在被依赖链中
	while (exchange && tempDepKeys[exchange.key]){
		tempDepKeys[exchange.dep] = exchange;

		depStart = exchange;
		exchange = exchange.previous;
	}

	// 未找(或找到第一个节点)则返回
	if (!exchange || !exchange.previous){
		return;
	}

	// 将 exchange 移到 item 之后的位置
	depStart.previous = exchange.previous;
	if(depStart.previous){
		depStart.previous.next = depStart ;
	}

	exchange.previous = item;
	item.next = exchange;
	exchange.next = next;
	if (next){
		next.previous = exchange;
	}
}


// 将一个节点后移
function moveBack(key){
	let item = dataMap[key];

	// 没有后置节点(或首节点)则返回
	if (!item.next || !item.previous ){
		return ;
	}

	let depEnd = item;
	let exchange = item.next;
	let previous = item.previous;

	let tempDepKeys = {}
	tempDepKeys[item.key] = item;

	// 向后找到无依赖的节点exchange, exchange.dep 不再依赖链中
	while (exchange && tempDepKeys[exchange.dep]){
		tempDepKeys[exchange.key] = exchange;

		depEnd = exchange;
		exchange = exchange.next;
	}

	// 未找到返回
	if (!exchange){
		return;
	}

	// 将 exchange 移到 item 之前的位置
	depEnd.next = exchange.next;
	if(depEnd.next){
		depEnd.next.previous = depEnd ;
	}

	exchange.next = item;
	item.previous = exchange;
	exchange.previous = previous;
	previous.next = exchange;
}

function printOrder(){
	let orderSteps = [];
	let item = firstItem;
	while(item){
		orderSteps.push(item.key);
		item = item.next;
	}
	console.log(orderSteps);
}

initData(); // 初始化
printOrder();    					 // a,b,c,d,e,f,g
movePrevious("c");printOrder();      // a,c,b,d,e,f,g
moveBack("c");printOrder();      	 // a,b,c,d,e,f,g
moveBack("c");printOrder();     	 // a,b,f,c,d,e,g
moveBack("c");printOrder();     	 // a,b,f,g,c,d,e
movePrevious("c");printOrder();      // a,b,f,c,g,d,e
movePrevious("c");printOrder();      // a,b,c,f,g,d,e
movePrevious("c");printOrder();      // a,c,b,f,g,d,e
```
