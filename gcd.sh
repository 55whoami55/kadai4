#!/bin/bash
# gcd.sh - 最大公約数を計算するスクリプト

# 1. 引数の個数チェック（2つ以外はエラー）
if [ $# -ne 2 ]; then
    echo "Error: 2 arguments are required. (Usage: $0 num1 num2)" >&2
    exit 1
fi

# 2. 自然数チェック（1以上の正の整数か、正規表現で判定）
if ! [[ "$1" =~ ^[1-9][0-9]*$ ]] || ! [[ "$2" =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: Arguments must be natural numbers (positive integers)." >&2
    exit 1
fi

# 3. ユークリッドの互除法による数値演算
a=$1
b=$2

while [ $b -ne 0 ]; do
    remainder=$((a % b))
    a=$b
    b=$remainder
done

# 結果を出力して正常終了
echo $a
exit 0
