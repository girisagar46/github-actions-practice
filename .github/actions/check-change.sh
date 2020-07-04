#!/bin/bash
set -eu

AUTO_MERGE_DIR_REGEX='check-change/.*/auto-merge/.*.yaml'
git fetch origin master
NON_AUTOMERGE_FILE_NUM=$(git diff --name-only origin/master HEAD | grep -vE "$AUTO_MERGE_DIR_REGEX")
PR_COMMENT_CONTENT_TMP_FILE=comment
if [ "$NON_AUTOMERGE_FILE_NUM" == 0 ];then
    echo "auto-approve" >> $PR_COMMENT_CONTENT_TMP_FILE
else
    echo "auto-approve is skipped as the following files are changed:" >> $PR_COMMENT_CONTENT_TMP_FILE
    { echo "\`\`\`"; git diff --name-only origin/master HEAD | grep -vE "$AUTO_MERGE_DIR_REGEX"; echo "\`\`\`"; } >> $PR_COMMENT_CONTENT_TMP_FILE
fi
echo "auto-approve condition is: \`$AUTO_MERGE_DIR_REGEX\` defined in [](/.github/actions/check-change.sh)" >> $PR_COMMENT_CONTENT_TMP_FILE
sed -i -z 's/\n/\\n/g' $PR_COMMENT_CONTENT_TMP_FILE

export NON_AUTOMERGE_FILE_NUM=$NON_AUTOMERGE_FILE_NUM
echo "Done"