# Quick reference

- The official distroless-ruby docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# distroless-static | openEuler
This image contains a minimal Linux, ruby runtime.

**What is Ruby?**

Ruby is a dynamic, reflective, object-oriented, general-purpose, open-source programming language. It supports multiple programming paradigms, including functional, object-oriented, and imperative. It also has a dynamic type system and automatic memory management.

# Supported tags and respective Dockerfile links
The tag details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[3.2.2-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-ruby/3.2.2/24.03-lts/Distrofile)| Ruby 3.2.2 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
**Create a Dockerfile in your Ruby app project**

```
FROM openeuler/distroless-ruby:3.2.2-oe2403lts

RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["./your-daemon-or-script.rb"]
```
Put this file in the root of your app, next to the Gemfile.

You can then build and run the Ruby image:
```
$ docker build -t my-ruby-app .
$ docker run -it --name my-running-script my-ruby-app
```

**Generate a Gemfile.lock**

The above example Dockerfile expects a Gemfile.lock in your app directory. This docker run will help you generate one. Run it in the root of your app, next to the Gemfile:
```
$ docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app openeuler/distroless-ruby:3.2.2-oe2403lts bundle install
```

**Run a single Ruby script**

For many simple, single file projects, you may find it inconvenient to write a complete Dockerfile. In such cases, you can run a Ruby script by using the Ruby Docker image directly, for [example](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-ruby/):
```
$ docker run -it --rm $PWD/example:/usr/src/myapp -w /usr/src/myapp openeuler/distroless-ruby:3.2.2-oe2403lts ruby example.rb
```	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).