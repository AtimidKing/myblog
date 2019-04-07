# rebar3
rebar3 是erlang的包管理器,可以通过他来添加需要的库.功能类似Java的maven.
1. rebar3 构建项目
```
rebar3 new app my_project
```
可以构建一个app类型的羡慕
2. 添加依赖  
在rebar.config中添
```
{deps, [
  {cowboy, "2.6.1"}, % package
  {cowboy, {git, "git://github.com/ninenines/cowboy.git", {tag, "2.6.1"}}}
]}.
```
然后,在src下*.app.src文件中添加引用
```
{application, myblog,
 [{description, "An OTP application"},
  {vsn, "0.1.0"},
  {registered, []},
  {mod, {myblog_app, []}},
  {applications,
   [kernel,
    stdlib,
    cowboy
   ]},
  {env,[]},
  {modules, []},

  {licenses, ["Apache 2.0"]},
  {links, []}
 ]}.

```
3. 执行`rebar3 compile`