<?php
function add(int $a, int $b): int {
    $result = $a + $b;
    // 检测整数溢出（PHP 8+需要）
    if (PHP_MAJOR_VERSION >= 8 && ($a > 0 && $b > 0 && $result < 0) ||
                                  ($a < 0 && $b < 0 && $result > 0)) {
        throw new OverflowException("Integer overflow detected");
    }

    return $result;
}