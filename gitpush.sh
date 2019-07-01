# バックアップを保存するディレクトリ。ここに変換したmarkdownを保存する
backup_folder=$1

# gitディレクトリであることを確認する
is_git_dir=0
for file in $(ls -a $backup_folder); do
    if [ $file = .git ]; then
        is_git_dir=1
    fi
done
echo $is_git_dir

# gitディレクトリじゃない場合は終了
if [ $is_git_dir = 0 ]; then
    exit
fi

# コミットメッセージを作成
msg=backup-`date "+%Y%m%d"`
# gitのmasterブランチにpushする
cd $backup_folder && git add . && git commit -m "$(echo $msg)" && git push origin master
