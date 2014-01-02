package com.jerry.server;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.Socket;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class MultiThreadTcpClient {

	public static void main(String[] args) {
        int numTasks = 2000;
        
        ExecutorService exec = Executors.newCachedThreadPool();

        for (int i = 0; i < numTasks; i++) {
        	try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
            exec.execute(createTask(i));
        }

    }

    // 定义一个简单的任务
    private static Runnable createTask(final int taskID) {
        return new Runnable() {
            private Socket socket = null;
            private int port=8821;

            public void run() {
            	
                System.out.println("Task " + taskID + ":start");
                try {     
                    socket = new Socket("192.168.1.105", port);
                    // 发送关闭命令
                    OutputStream socketOut = socket.getOutputStream();
                    socketOut.write(("shutdown"+ taskID +"\r\n").getBytes());

                    // 接收服务器的反馈
                    BufferedReader br = new BufferedReader(
                            new InputStreamReader(socket.getInputStream()));
                    String msg = null;
                    while ((msg = br.readLine()) != null)
                        System.out.println(msg);
                } catch (Exception e) {                    
                    e.printStackTrace();
                }
            }

        };
    }
	
}
