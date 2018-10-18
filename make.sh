#!/bin/sh
if [ -f "apps/sdk.cbp" ]; then
cd apps/
/usr/bin/CodeBlocks/codeblocks.exe /na /nd --no-splash-screen --build sdk.cbp --target=Release
cd ..
<<<<<<< HEAD
# ssh-keygen -t rsa -C "1043623557@qq.com"
# pissh -T git@github.com
=======
fi
>>>>>>> bc6a31850a47b8ba0d561e1d2e0350db7c202731

