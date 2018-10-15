#!/bin/sh
if [ -f "apps/sdk.cbp" ]; then
cd apps/
/usr/bin/CodeBlocks/codeblocks.exe /na /nd --no-splash-screen --build sdk.cbp --target=Release
cd ..
fi

