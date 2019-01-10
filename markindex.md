<!---
markmeta_author: wongoo
markmeta_date: 2019-01-09
markmeta_title: markindex.sh specification
markmeta_categories: 工具
markmeta_tags: markdown,shell
-->

# markindex.sh 

`markindex` generate markdown structure files for [docsify.js](https://github.com/docsifyjs/docsify), include `_navbar.md`, `README.md`. 

markdown files MUST contain the following metadata at the begining , eg:
```
<!---
markmeta_author: wongoo
markmeta_date: 2019-01-09
markmeta_title: markindex.sh specification
markmeta_categories: tools
markmeta_tags: markdown,shell
-->
```

Currently, `markindex` only supports two level file structure.
