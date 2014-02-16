package com.jerry.client;

import org.apache.commons.codec.binary.Hex;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

public class AppClient {

    public static void main(String[] args) {
        Socket socket = null;
        try {
        	//115.29.147.77
            socket = new Socket("192.168.1.104", 8868);
            auth(socket);  //第1条为验证指令
            responseHandler(socket);//读取16进制信息并还原为字符串
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (socket != null) {
                try {
                    socket.close();
                } catch (IOException e) {
                }
            }
        }
    }

    public static void auth(Socket socket) {
        //serverId去本地存储值
        String authInfo="{\"key\":\"\",\"body\":\"{\\\"serverId\\\":\\\"e94beb6e-a3d2-4523-ab40-7ee3b909741f\\\"}\",\"messageType\":\"auth\"}";
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

    private static void responseHandler(Socket socket) throws Exception {
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

    }
}