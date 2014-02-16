package com.jerry.server;

import java.net.*;
import java.util.concurrent.*;
import java.io.IOException;

public class MultiThreadServer {
	private int port=8868;
    private ServerSocket serverSocket;
    private ExecutorService executorService;//线程池
    private final int POOL_SIZE=500;//单个CPU线程池大小
    
    public MultiThreadServer() throws IOException{
        serverSocket=new ServerSocket(port);
        //Runtime的availableProcessor()方法返回当前系统的CPU数目.
        executorService=Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors()*POOL_SIZE);
        System.out.println("服务器启动");
    }
    
    public void service(){
        while(true){
            Socket socket=null;
            try {
                //接收客户连接,只要客户进行了连接,就会触发accept();从而建立连接
                socket=serverSocket.accept();
                executorService.execute(new TcpHandler(socket));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

	public static void main(String[] args) {
		try {
			new MultiThreadServer().service();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	
	
}
