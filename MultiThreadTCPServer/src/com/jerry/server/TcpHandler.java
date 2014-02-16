package com.jerry.server;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.*;
import org.apache.commons.codec.binary.Hex;

public class TcpHandler implements Runnable{

	private Socket socket;
    public TcpHandler(Socket socket){
        this.socket=socket;
    }
    private PrintWriter getWriter(Socket socket) throws IOException{
        OutputStream socketOut=socket.getOutputStream();
        return new PrintWriter(socketOut,true);
    }
    private BufferedReader getReader(Socket socket) throws IOException{
        InputStream socketIn=socket.getInputStream();
        return new BufferedReader(new InputStreamReader(socketIn));
    }
    public String echo(String msg){
        return "echo:"+msg;
    }
    public void run(){
        try {
            System.out.println("New connection accepted "+socket.getInetAddress()+":"+socket.getPort());
            
//            responseHandler(socket);
//            auth(socket);
            
            readMessage(socket);
            
//            BufferedReader br=getReader(socket);
//            PrintWriter pw=getWriter(socket);
//            String msg=null;
//            while((msg=br.readLine())!=null){
//                System.out.println(msg);
//                pw.println("{\"status\":\"200\",\"description\":\"\",\"js_method\":\"refresh_clicked\"}");
//            }
        } catch (Exception e) {
            e.printStackTrace();
        }finally{
            try {
                if(socket!=null)
                    socket.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
    
    public static void auth(Socket socket) {
        //serverId去本地存储值
        String authInfo="{\"key\":\"\",\"body\":\"{\"serverId\":\"11111\"}\",\"messageType\":\"auth\"}";
        try{
            OutputStream outputStream = socket.getOutputStream();
            String msg = new String(new Hex().encodeHex((authInfo.getBytes("UTF-8")))); //转16进制
            msg=msg+"\n";//加回车符
            outputStream.write(msg.getBytes());
            outputStream.flush();
        }catch (Exception e){
            throw new RuntimeException(e);
        }
    }
    
    public void readMessage(Socket socket) throws Exception{
    	BufferedReader br=getReader(socket);       
        StringBuffer messageBuffer = new StringBuffer();
		int c=-1;
        while ((c=br.read())!=-1){
            if(c=='\n'){
                String msg = messageBuffer.toString();
                messageBuffer=new StringBuffer();
                System.out.println(new String(new Hex().decode(msg.getBytes()),"UTF-8"));
                writeMessage(socket);
            }else{
                messageBuffer.append((char)c);
            }
        }
        
    }
    
    public void writeMessage(Socket socket) throws Exception{
    	String authInfo="{\"key\":\"\",\"body\":\"{\"serverId\":\"11111\"}\",\"messageType\":\"auth\"}";
    	String msg = new String(new Hex().encodeHex((authInfo.getBytes("UTF-8")))); //转16进制
    	System.out.println("返回信息：-->"+msg);
    	PrintWriter pw=getWriter(socket);
    	pw.println(msg);
    }

    private static void responseHandler(Socket socket){
    	try {
    		InputStream inputStream = socket.getInputStream();
    		StringBuffer messageBuffer = new StringBuffer();
    		int c=-1;
            while ((c=inputStream.read())!=-1){
                if(c=='\n'){
                    String msg = messageBuffer.toString();
                    messageBuffer=new StringBuffer();
                    System.out.println(new String(new Hex().decode(msg.getBytes()),"UTF-8"));
                }else{
                    messageBuffer.append((char)c);
                }
            }
            inputStream.close(); 
    	} catch (Exception ex) {
    		ex.printStackTrace();
    	}finally{
    		
    	}
    }
    
}
