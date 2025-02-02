#!/bin/bash

# 最大同時実行数
MAX_JOBS=5
# ロックファイルのディレクトリ
LOCK_DIR="/tmp/yzfcu_locks"

# ロックファイルのディレクトリが存在しない場合は作成
mkdir -p "$LOCK_DIR"

# 現在のジョブ数を取得する関数
get_job_count() {
    echo $(ls "$LOCK_DIR" | wc -l)
}

# ロックファイルを作成する関数
create_lock() {
    local lock_file="$LOCK_DIR/$$"
    touch "$lock_file"
}

# ロックファイルを削除する関数
remove_lock() {
    local lock_file="$LOCK_DIR/$$"
    rm -f "$lock_file"
}

# 同時実行数を制限する関数
limit_concurrent_jobs() {
    while [ $(get_job_count) -ge $MAX_JOBS ]; do
        sleep 1
    done
    create_lock
}

# メイン処理
main() {
    # 同時実行数を制限
    limit_concurrent_jobs

    # ここにyzfcuのメイン処理を記述
    echo "Running yzfcu command..."
    sleep 10  # 例として10秒間の処理を実行

    # ロックファイルを削除
    remove_lock
}

# スクリプト終了時にロックファイルを削除するためのトラップを設定
trap remove_lock EXIT

# メイン処理を実行
main
