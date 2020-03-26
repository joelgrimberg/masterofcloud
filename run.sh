if [[ -z "$ENVIRONMENT" ]] && [ "$ENVIRONMENT" != "development" ] && [ "$ENVIRONMENT" != "acceptance" ] && [ "$ENVIRONMENT" != "production" ]
then  ENVIRONMENT="test"
fi

echo ENVIRONMENT is set to $ENVIRONMENT
echo ''

echo 'COMPILING...'
ENVIRONMENT=$ENVIRONMENT ./rake_compile.sh
echo ''
echo ''
echo 'UPLOADING...'
ENVIRONMENT=$ENVIRONMENT ./rake_upload.sh
echo ''
echo ''
echo 'APPLYING... and waiting..'
ENVIRONMENT=$ENVIRONMENT ./rake_apply.sh
echo ''
echo ''
