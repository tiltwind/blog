<!---
markmeta_title: 低代码 vs AI
markmeta_author: 斜风
markmeta_date: 2024-04-16
markmeta_categories: 思考
markmeta_tags: 低代码,AI
-->

# 低代码 vs AI


## 低代码

最近公司在研究低代码，想把低代码引入技术能力底座，以便支持各种快速发展的业务。

低代码的细分2个等级，一个零代码，面向业务人员，可以不用写任何代码搭建一般应用；另一个低代码，面相开发者，可以写少量代码实现复杂功能业务。

低代码有几个重要的能力，数据建模能力、交互设计能力、功能组件能力、流程设计能力、数据打通能力。 这些能力支撑起了业务快速实现快速变化的能力。

低代码目前也有遇到一些问题，比如建议只是企业内部使用。每当问到解决方案供应商低代码应用是否可以面客时，都会问到是否有大流量，有大流量不建议对客使用，因为低代码本身的架构设计问题，其本身运行效率比代码应用要低。
另外低代码基本上基于账号、权限体系建设，更多是面相企业内部的业务场景。


## AI

人工智能发展迅速，山姆奥特曼、李彦宏都说以后只要会自然语言，就可以编程了，而且可以通过画手稿快速生成页面代码。

但从目前看要使用 AI 完成一个完整的应用，还是挺困难的。 首先得有一定的编码能力；其次要知道一个应用的技术架构，知道要生成哪些代码；最后还要知道代码如何构建如何部署。

目前来开 AI 还是主要是协助编程，提高开发人员的工作效率。


## 低代码 和 AI

**低代码加AI，是快速实现通过自然语言开发应用的重要路径**。低代码提供了编译、部署环境，同时提供了固定的开发模式。低代码虽然可以零代码，但是要配置的内容也是非常多，业务人员要使用低代码也并非那么好上手。AI在低代码固定开发模式下，可以做到轻车熟路，准确性更高。业务人员通过 AI 和低代码平台交互，将变得更加简单和高效。

低代码运行低效的问题，也有一个解决思路。**把低代码看做是一个编程范式，将低代码编译为原生程序直接运行**，而不是运行在低代码运行时框架中，效率必定提高很多。
编译过程也不复杂，首先将低代码应用相关的配置和代码抽取转换为源代码形式（保证源代码的高效），再将源代码编译为原生程序即可。
其中转换为源码部分如果比较复杂，还可以考虑通过 AI 来转换。低代码定义了应用的详细功能细节，再让 AI 来生成源码，生成的源码质量也会很高。
