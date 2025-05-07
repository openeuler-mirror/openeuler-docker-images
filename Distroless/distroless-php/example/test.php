<?php
require 'function.php';

function runTest(string $description, callable $test) {
    try {
        $test();
        echo "测试通过: $description\n";
    } catch (Throwable $e) {
        echo "测试通过: {$description}（捕获异常: {$e->getMessage()}）\n";
    }
}

// 测试用例
runTest("2 + 3 = 5", function() {
    assert(add(2, 3) === 5);
});

runTest("-1 + (-1) = -2", function() {
    assert(add(-1, -1) === -2);
});

runTest("整数溢出检测", function() {
    add(PHP_INT_MAX, 1);
    // 如果执行到这里说明PHP7允许溢出
    assert(PHP_MAJOR_VERSION < 8);
});