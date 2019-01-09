# markindex.sh 

`markindex` generate markdown structure files for [docsify.js](https://github.com/docsifyjs/docsify), include `_navbar.md`, `README.md`. 

markdown files MUST contain the following metadata at the begining , eg:
```
<!---
markmeta_author: wongoo
markmeta_date: 2019-01-09
markmeta_title: article title
markmeta_categories: tech,lang
markmeta_tags: golang,performance
-->
```

Currently, `markindex` only supports two level file structure.
