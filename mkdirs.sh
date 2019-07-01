#!/bin/bash
# フォルダのキーと名前を一時的にファイル保存する

# boostnote.jsonから、Boostnote上に存在しているフォルダと同じものをバックアップ先に作る

# バックアップを記録するフォルダ
backup_folder=$1
if [ ! -e $backup_folder ]; then
  echo no such directory
  exit
fi


json=$(cat ~/Boostnote/boostnote.json | jq .folders)
len=$(echo $json | jq length)
str=''
# もし前回の時のマッピングファイルが存在していら消す
if [ -e .tmp ]; then
rm .tmp
fi

for i in  $( seq 0 $(($len - 1)) ); do
  key=$(cat ~/Boostnote/boostnote.json | jq .folders[$i] | jq -r .key)
  color=$(cat ~/Boostnote/boostnote.json | jq .folders[$i] | jq -r .color)
  name=$(cat ~/Boostnote/boostnote.json | jq .folders[$i] | jq -r .name)
  if [ -ne $backup_folder/$name ]; then
      mkdir "$backup_folder/$name"
      echo "$backup_folder/$name"  was created
  fi
  # キーとフォルダ名のマップを作っておく
  echo $key:$name  >> .tmp
done
