#!/bin/bash
# test_gcd.sh - gcd.shの動作を自動検証するスクリプト

TARGET="./gcd.sh"
errors=0

# 【正常系用テスト関数】
test_success() {
    local arg1=$1
    local arg2=$2
    local expected=$3
    
    output=$($TARGET "$arg1" "$arg2" 2>/dev/null)
    status=$?
    
    if [ $status -ne 0 ]; then
        echo "❌ [Failed] Input: $arg1 $arg2 | Expected success, but exited with status $status" >&2
        errors=$((errors + 1))
    elif [ "$output" != "$expected" ]; then
        echo "❌ [Failed] Input: $arg1 $arg2 | Expected output: $expected, but got: $output" >&2
        errors=$((errors + 1))
    else
        echo "✅ [Passed] Input: $arg1 $arg2 -> Output: $output"
    fi
}

# 【異常系用テスト関数】
test_error() {
    local args=("$@")
    
    output=$($TARGET "${args[@]}" 2>&1)
    status=$?
    
    if [ $status -eq 0 ]; then
        echo "❌ [Failed] Input: [${args[*]}] | Expected error, but script returned exit 0 (success)" >&2
        errors=$((errors + 1))
    elif [ -z "$output" ]; then
        echo "❌ [Failed] Input: [${args[*]}] | Script failed, but error message was empty" >&2
        errors=$((errors + 1))
    else
        echo "✅ [Passed] Input: [${args[*]}] | Correctly blocked. Message: $output"
    fi
}

echo "=== Starting GCD Script Validation ==="

# --- 1. 正常系テスト ---
test_success 2 4 2
test_success 12 18 6
test_success 7 13 1    # 互いに素
test_success 100 10 10

# --- 2. 異常系テスト ---
test_error 3          # 引数が1つ（不足）
test_error 2 4 6      # 引数が3つ（過剰）
test_error a b        # 文字列の入力
test_error -2 4       # 負の数の入力
test_error 2.5 4      # 小数の入力
test_error 0 5        # 0の入力（自然数ではない）
test_error "" 5       # 空文字の入力

# --- 総括 ---
echo "====================================="
if [ $errors -ne 0 ]; then
    echo "🚨 Test Result: $errors errors detected." >&2
    exit 1
else
    echo "🎉 Test Result: All test cases passed safely!"
    exit 0
fi
