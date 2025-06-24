- 引入Netty依赖:

  Maven：
  ```
  <dependency>
    <groupId>io.netty</groupId>
    <artifactId>netty-all</artifactId>
    <version>4.2.1.Final</version>
  </dependency>
  ```
  Gradle:
  ```
  implementation 'io.netty:netty-all:4.2.1.Final'
  ```
 
- 编写一个简单的服务器
  
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

- 运行服务器

  直接运行 EchoServer 类中的 main 方法即可。
  通过命令行连接测试：
  ```
  telnet localhost 8080
  ```
  输入的任何内容都会被服务器原样返回。