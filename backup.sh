#!/bin/bash

# バックアップを保存するディレクトリ。ここに変換したmarkdownを保存する
backup_folder=$1

# Boostnoteのデータが記録されているディレクトリ。通常ホームディレクトリ下にあります
boostnote_repo=~/Boostnote



# タイトルを取得する
get_file_title () {
  grep title: $1 > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    filename=$(cat $file | awk '/title:/' | cut -d: -f2 | tr -d \" | sed "s/\//./g")
  else
  filename='no title'
  fi
  echo $filename
}


# ファイルのフォルダキーを抽出する
get_folder_key () {
  file=$1
  foldername=$(cat $file | awk '/folder:/' | cut -d: -f2 | tr -d \")
  echo $foldername
}

# ファイルのコンテンツだけ抽出する
extract_contents () {
  origin_file_name=$1

  # 関数の引数にスペースを含められないので、中で生成する
  title=`get_file_title $file`.md
  new_file_name=$backup_folder/$folder_name/$title

  from=$(grep -n "'''" $origin_file_name | cut -d: -f1 | head -1)
  end=$(grep -n "'''" $origin_file_name | cut -d: -f1 | tail -1)

  if [ -z $from ];  then
    # 空のファイル
    echo 1
    exit
  fi
  contents=$(head -$(($end-1)) $origin_file_name | tail -$(($end-$from-1)))
  content_length=$(($end-$from-1))
  head -$(($end-1)) $origin_file_name | tail -$content_length  > $new_file_name && echo 0
}
# file=/Users/hatanaka/Boostnote/notes/60153f39-49c1-43f2-ab4f-83e98af98137.cson
# ret=$(extract_contents $file)


note配下にあるcsonで、markdownのものだけ取得する
for file in `ls -1 $boostnote_repo/notes/*.cson`
do
  grep MARKDOWN_NOTE $file > /dev/null 2>&1
  if [ $? -eq 0 ] ; then
    echo $file
    # フォルダキーの取得
    folder_key=`get_folder_key $file`
    # echo $folder_key
    # フォルダ名を取得
    folder_name=$(grep $folder_key .tmp| cut -d: -f2)

    # 内容を抽出して指定したファイル名で保存
    content=`extract_contents $file`
    if [ $content -eq 1 ]; then
      echo "not success"
    fi


  fi
done
