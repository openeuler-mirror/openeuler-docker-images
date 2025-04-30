# test_ruby_environment.rb
# 输出 Ruby 版本
puts "Ruby version: #{RUBY_VERSION}"

# 定义一个简单的加法函数
def add(a, b)
  a + b
end

# 测试加法函数
result = add(5, 3)
puts "5 + 3 = #{result}"

# 检查是否支持某个特性
if defined?(String)
  puts "String class is defined"
else
  puts "String class is not defined"
end