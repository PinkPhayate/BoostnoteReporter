# ストレージ先を引数から取得する。
backup_folder=$1

# ストレージフォルダを作成
sh mkdirs.sh $backup_folder

# boostnoteの記事をmarkdownに変換して保存
sh backup.sh $backup_folder

# gitにpush
sh gitpush.sh $backup_folder
