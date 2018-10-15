/* 服务器与本地冲突的处理方法 */
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
