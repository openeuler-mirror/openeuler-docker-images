# Quick reference

- The official Netty docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Netty | openEuler
Current Netty docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Netty is an asynchronous event-driven network application framework for rapid development of maintainable high performance protocol servers & clients.

Learn more about Netty on [Netty Website](http://netty.io/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `netty` docker image is consist of the version of `netty` and the version of basic image. The details are as follows

| Tag                                                                                                                            | Currently                              | Architectures |
|--------------------------------------------------------------------------------------------------------------------------------|----------------------------------------|---------------|
| [4.2.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/netty/4.2.1/24.03-lts-sp1/Dockerfile) | Netty 4.2.1 on openEuler 24.03-LTS-SP1 | amd64, arm64  |
| [4.2.4-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/netty/4.2.4/24.03-lts-sp2/Dockerfile) | Netty 4.2.4 on openEuler 24.03-LTS-SP2 | amd64, arm64  |
| [4.2.5-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/netty/4.2.5/24.03-lts-sp2/Dockerfile) | Netty 4.2.5 on openEuler 24.03-LTS-SP2 | amd64, arm64  |5
# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/netty` image from docker

	```bash
	docker pull openeuler/netty:{Tag}
	```
    
- Add the Netty dependency:

    **Maven：
    ```
    <dependency>
      <groupId>io.netty</groupId>
      <artifactId>netty-all</artifactId>
      <version>${NETTY_VERSION}</version>
    </dependency>
    ```
    Gradle:**
    ```
    implementation 'io.netty:netty-all:${NETTY_VERSION}'
    ```
 
- Write a simple server
  
    **EchoServer.java**：
    ```
    public class EchoServer {
        private final int port;
      
        public EchoServer(int port) {
            this.port = port;
        }
      
        public void start() throws Exception {
            EventLoopGroup bossGroup = new NioEventLoopGroup();
            EventLoopGroup workerGroup = new NioEventLoopGroup();
      
            try {
                ServerBootstrap b = new ServerBootstrap();
                b.group(bossGroup, workerGroup)
                 .channel(NioServerSocketChannel.class)
                 .childHandler(new ChannelInitializer<SocketChannel>() {
                     @Override
                     public void initChannel(SocketChannel ch) {
                         ch.pipeline().addLast(new EchoServerHandler());
                     }
                 });
      
                ChannelFuture f = b.bind(port).sync();
                f.channel().closeFuture().sync();
            } finally {
                bossGroup.shutdownGracefully();
                workerGroup.shutdownGracefully();
            }
        }
      
        public static void main(String[] args) throws Exception {
            new EchoServer(8080).start(); 
        }
    }
    ```
      
    **EchoServerHandler.java**
    ```
    public class EchoServerHandler extends ChannelInboundHandlerAdapter {
        @Override
        public void channelRead(ChannelHandlerContext ctx, Object msg) {
            ctx.write(msg);
        }
      
        @Override
        public void channelReadComplete(ChannelHandlerContext ctx) {
            ctx.flush();
        }
      
        @Override
        public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) {
            cause.printStackTrace();
            ctx.close();
        }
    }
    ```

- Run the server

    Directly run the main method in the EchoServer class.
    Test via command line:
    ```
    telnet localhost 8080
    ```
    Any input will be echoed back by the server.
 
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
