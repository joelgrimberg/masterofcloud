#!/bin/sh
ENVIRONMENT="test"
echo 'COMPILING...'
./rake_compile.sh
echo ''
echo ''
echo 'UPLOADING...'
./rake_upload.sh
echo ''
echo ''
echo 'APPLYING... and waiting..'
./rake_apply.sh
echo ''
echo ''
