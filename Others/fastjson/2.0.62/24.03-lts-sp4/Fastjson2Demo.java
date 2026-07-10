package com.example;

import com.alibaba.fastjson2.JSON;

public class Fastjson2Demo {
    static class User {
        public String name;
        public int age;

        public User() {}
        public User(String name, int age) {
            this.name = name;
            this.age = age;
        }
    }

    public static void main(String[] args) {
        User user = new User("张三", 25);
        String jsonString = JSON.toJSONString(user);
        System.out.println("序列化结果：" + jsonString);

        User parsed = JSON.parseObject(jsonString, User.class);
        System.out.println("反序列化结果：" + parsed.name + ", " + parsed.age);
    }
}
