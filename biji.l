/*----------- 服务器与本地冲突的处理方法 -----------*/
git stash
git pull
git stash pop
/* 查看修改 */
git diff -w +文件名 
/* 覆盖本地 */
git reset --hard
git pull
/* 恢复以前版本 */
git checkout HEAD file/to/restore


/*---------- cd进入目录同时ls -----------*/
vi ~/.bashrc
/* 添加代码 */
cd_ll()
{
  # 使用‘\’可以调用原始命令
  \cd $1
  # ls -l
  ll
}
# 设置别名
alias cd='cd_ll'
