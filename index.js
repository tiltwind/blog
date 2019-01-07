 function GenPageId() {
     var gid = document.location.href;
     gid = gid.replace("http://", "");
     gid = gid.replace("https://", "");
     gid = gid.replace("sisopipo.com", "");
     gid = gid.replace(".html", "");

     if (gid[gid.length - 1] == '/') {
         gid = gid.substr(0, gid.length - 1);
     }
     var len = gid.lastIndexOf("/");
     if (gid.length - len > 25) {
         gid = gid.substr(len + 1);
     } else {
         len = gid.lastIndexOf("/", len - 1);
         if (gid.length - len > 25) {
             gid = gid.substr(len + 1);
         }
     }
     if (gid.length > 50) {
         gid = gid.replace(/[\W]/g, "");
     }
     if (gid.length > 50) {
         gid = gid.substr(gid.length - 50);
     }
     return gid;
 }

 var gitalk_first_loaded = false;
 var gitalk_reload_timer;

 window.$docsify = {
     name: '望哥的博客',
     repo: '',
     themeColor: '#19BE6B',
     loadSidebar: false,
     subMaxLevel: 4,
     loadNavbar: true,
     notFoundPage: true,
     search: 'auto',
     basePath: "https://raw.githubusercontent.com/wongoo/blog/master/",
     plugins: [
         function(hook, vm) {
             hook.doneEach(function() {
                 if (!gitalk_first_loaded) {
                     gitalk_first_loaded = true;
                     return
                 }
                 var c = document.getElementById(
                     'gitalk-container')
                 if (c) {
                     c.innerHTML = "";
                     if (gitalk_reload_timer) {
                         clearTimeout(
                             gitalk_reload_timer)
                     }
                     gitalk_reload_timer = setTimeout(
                         function() {
                             NewGitalk().render(
                                 'gitalk-container'
                             );
                         }, 20 * 1000);
                 }

             });
         }
     ]
 }

 function NewGitalk() {
     return new Gitalk({
         clientID: '2d9d63331c0adf11342f',
         clientSecret: '1aef93fd1152f53fd4fe261a133c3c779043c99d',
         repo: 'wongoo.github.io',
         owner: 'wongoo',
         admin: ['wongoo'],
         id: GenPageId(),
         language: 'zh-CN',
         distractionFreeMode: true
     });
 }
 const gitalk = NewGitalk();
