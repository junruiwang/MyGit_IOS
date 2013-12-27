package com.jerry.server;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.InetAddress;
import java.net.MulticastSocket;
import java.util.concurrent.*;

/**
 * 接收udp广播消息的服务端程序
 *
 * */
public class UDPServer {

	final int DEFAULT_PORT = 5222;
	private static LinkedBlockingQueue<UDPSession> msgQueue;
	private static ThreadPoolExecutor sendExecutor ;
	private static int port = 5225;
	private static MulticastSocket multicastServer;
	final static String multiaddress = "224.0.0.1";
	final static int RECEIVE_LENGTH = 1024;   

	public void start(){
		startUDPServer();
        msgQueue = new LinkedBlockingQueue<UDPSession>();
		sendExecutor = new ThreadPoolExecutor(5, 10, 200, TimeUnit.MILLISECONDS, new ArrayBlockingQueue<Runnable>(200));
		new Dequeue().start();
	}
	
	public void stop(){
		if(multicastServer!=null){
			multicastServer.close();
		}
	}
	
	public void startUDPServer(){
        new Thread(){
        	public void run() {
        		try {
	        		InetAddress receiveAddress = InetAddress.getByName(multiaddress);
	                if(receiveAddress==null||!receiveAddress.isMulticastAddress()){//测试是否为多播地址   
	                	System.out.println("udp需要使用多播地址,udp广播服务启动失败");  
	                	return ;
	                }
	                System.out.println("udp server start--"+receiveAddress+"--port--"+port);
	        		multicastServer = new MulticastSocket(port);
	                multicastServer.joinGroup(receiveAddress);
	            	while(true){
			            DatagramPacket receivePacket = new DatagramPacket(new byte[RECEIVE_LENGTH], RECEIVE_LENGTH);   
			            multicastServer.receive(receivePacket);
			            enqueue(getUDPSession(receivePacket));
	            	}
        		} catch (IOException e) {
        			System.out.println("udpserver start error");
        		}
        	}
        }.start();
	}
	private UDPSession getUDPSession(DatagramPacket receivePacket){
		UDPSession session = new UDPSession();
		session.setData(receivePacket.getData());
		session.setRemoteInetAddress(receivePacket.getAddress());
		session.setRemotePort(receivePacket.getPort());
		return session;
	}
	public void enqueue(UDPSession obj){
		try {
			msgQueue.put(obj);
			System.out.println("enqueue UDPSession successfully! size:"+msgQueue.size());
		} catch (InterruptedException e) {
			System.out.println("enqueue UDPSession error! size:"+msgQueue.size());
		}
	}
	private class Dequeue extends Thread{
		@Override
		public void run() {
			while(true){
				UDPSession session = null;
				try {
					session = (UDPSession)msgQueue.take(); //使用阻塞方法，当队列为空时，将会wait在这里，当队列不为空时，将被唤醒此线程继续执行
				} catch (Exception e) {
                    System.out.println("dequeue error-->"+session+"--size-->"+msgQueue.size());
                    e.printStackTrace();
                    continue;
				}
				if(session==null){
                    System.out.println("dequeue:"+"session-->"+null+"--size-->"+msgQueue.size());
                    continue;
				}

				System.out.println("dequeue:"+"message-->"+session+"--size-->"+msgQueue.size());
				SendMessage pushThread = new SendMessage(session);
				sendExecutor.execute(pushThread);
			}
		}
	}
	private class SendMessage extends Thread{
		private UDPSession session;
		public SendMessage(UDPSession session){
			this.session = session;
		}
		@Override
		public void run() {
			String message = new String(session.getData()).trim();
			String result = "you_find_me";
			DatagramPacket sendPacket = new DatagramPacket(result.getBytes(), result.getBytes().length, session.getRemoteInetAddress(), session.getRemotePort());
			try {
				multicastServer.send(sendPacket);
				System.out.println("handle udp message from remoteaddress--"+session.getRemoteInetAddress()+"--remoteport--"+session.getRemotePort()+"--recievemessage--"+message+"--sendMessage--"+result);
			} catch (IOException e) {
				System.out.println("send udp response error!");
			}
			

		}
	}
	class UDPSession {
		private InetAddress remoteInetAddress ;
		private int remotePort;
		private byte[] data;
		public InetAddress getRemoteInetAddress() {
			return remoteInetAddress;
		}
		public void setRemoteInetAddress(InetAddress remoteInetAddress) {
			this.remoteInetAddress = remoteInetAddress;
		}
		public int getRemotePort() {
			return remotePort;
		}
		public void setRemotePort(int remotePort) {
			this.remotePort = remotePort;
		}
		public byte[] getData() {
			return data;
		}
		public void setData(byte[] data) {
			this.data = data;
		}
		
	}


    public static void main(String[] args) {
        new UDPServer().start();
    }

}
