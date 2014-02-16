package com;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.*;
import java.util.Timer;

import org.apache.commons.codec.binary.Hex;

public class TcpHandler implements Runnable{

	private Socket socket;
    public TcpHandler(Socket socket){
        this.socket=socket;
        Timer timer = new Timer();
      //每隔10秒向客户端发一次数据包
        timer.schedule(new MyTask(), 40000, 8000);
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
        String authInfo="{\"key\":\"\",\"body\":\"{\"id\":\"7c45886b-19b3-4c34-8c0b-be3db24c3114\",\"name\":\"开关\",\"type\":\"SWITCH\",\"groupName\":\"\",\"mac\":\"A18A3A03004B1200\",\"shortAdd\":\"EA86\",\"deviceWayList\":[{\"id\":\"74ca9be9-dbaf-439c-b2e7-b1088f412402\",\"name\":\"1路设备\",\"groupName\":\"\",\"status\":\"OFF\",\"brightness\":5,\"irData\":\"\"}],\"createTime\":\"Feb 15, 2014 6:58:29 AM\"}\",\"messageType\":\"syncStatus\"}";
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
//    	String authInfo="{\"key\":\"\",\"body\":\"{\"serverId\":\"11111\"}\",\"messageType\":\"auth\"}";
    	String authInfo="{\"key\":\"\",\"body\":\"{\"id\":\"7c45886b-19b3-4c34-8c0b-be3db24c3114\",\"name\":\"开关\",\"type\":\"SWITCH\",\"groupName\":\"\",\"mac\":\"A18A3A03004B1200\",\"shortAdd\":\"EA86\",\"deviceWayList\":[{\"id\":\"74ca9be9-dbaf-439c-b2e7-b1088f412402\",\"name\":\"1路设备\",\"groupName\":\"\",\"status\":\"OFF\",\"brightness\":5,\"irData\":\"\"}],\"createTime\":\"Feb 15, 2014 6:58:29 AM\"}\",\"messageType\":\"syncStatus\"}";
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
    
    class MyTask extends java.util.TimerTask{ 
        @Override
        public void run() { 
            System.out.println("____发送数据包到客户端____");
            try {
//				writeMessage(socket);
            	auth(socket);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        }
    }
}
