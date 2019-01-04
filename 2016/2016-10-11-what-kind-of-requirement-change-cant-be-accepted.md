---
layout: post
author: gelnyang
comments: true
date: 2016-10-11
title: 什么需求变更不可接受
categories:
- 管理
tags:
- Management
- Requirement
---
---

1. 违背系统架构： 对于大多数需求变更来说，尽量不要变更系统架构(包括底层架构及页面功能架构); 如果一定要变更，应该是有共性的功能需求，特殊需要变更架构的需求应不予接受。

2. 影响系统性能： 比如需要将多个表字段关联查询显示，如果这样的关联查询会影响性能，应建议调整页面功能修改为多层级多页签等方式展现。

3. 非系统属性功能： 系统本身不具备或不擅长的功能,不应该添加到系统中; 除非此功能和系统原有功能属性一致，可以使项目产品增加特性亮点。

4. 臃肿庞大的功能： 需求很复杂，会设计大量的修改，让系统臃肿庞大，增加维护难度。

