package com.jje.mobile.util;

import org.springframework.stereotype.Component;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.util.Map;
import java.util.Vector;

@Component
public class HttpRequester {

    private static String REQUEST_TYPE_GET = "GET";

    private static String REQUEST_TYPE_POST = "POST";

    private String defaultContentEncoding;

    public HttpRequester() {
        this.defaultContentEncoding = "UTF-8";
    }

    /**
     * 发送GET请求
     *
     * @param urlString
     * URL地址
     *
     * @return 响应对象
     * @throws IOException
     */
    public HttpResponser sendGet(String urlString) throws IOException {
        return this.send(urlString, REQUEST_TYPE_GET, null, null);
    }

    /**
     * 发送GET请求
     * @param urlString
     * URL地址
     *
     * @param params
     * 参数集合
     *
     * @return 响应对象
     * @throws IOException
     */
    public HttpResponser sendGet(String urlString, Map<String, String> params) throws IOException {
        return this.send(urlString, REQUEST_TYPE_GET, params, null);
    }

    /**
     * 发送GET请求
     * @param urlString
     * URL地址
     *
     * @param params
     * 参数集合
     *
     * @param propertys
     * 请求属性
     *
     * @return 响应对象
     * @throws IOException
     */
    public HttpResponser sendGet(String urlString, Map<String, String> params, Map<String, String> propertys) throws IOException {
        return this.send(urlString, REQUEST_TYPE_GET, params, propertys);
    }

    /**
     * 发送POST请求
     *
     * @param urlString
     * URL地址
     *
     * @return 响应对象
     * @throws IOException
     */
    public HttpResponser sendPost(String urlString) throws IOException {
        return this.send(urlString, REQUEST_TYPE_POST, null, null);
    }

    /**
     * 发送POST请求
     *
     * @param urlString
     * URL地址
     *
     * @param params
     * 参数集合
     *
     * @return 响应对象
     * @throws IOException
     */
    public HttpResponser sendPost(String urlString, Map<String, String> params) throws IOException {
        return this.send(urlString, REQUEST_TYPE_POST, params, null);
    }

    /**
     * 发送POST请求
     *
     * @param urlString
     * URL地址
     *
     * @param params
     * 参数集合
     * @param propertys
     * 请求属性
     *
     * @return 响应对象
     * @throws IOException
     */
    public HttpResponser sendPost(String urlString, Map<String, String> params,Map<String, String> propertys) throws IOException {
        return this.send(urlString, REQUEST_TYPE_POST, params, propertys);
    }

    /**
     * 发送HTTP请求
     * @param urlString
     *
     * @return 响映对象
     * @throws IOException
     */
    private HttpResponser send(String urlString, String method,Map<String, String> parameters, Map<String, String> propertys) throws IOException {
        HttpURLConnection urlConnection = null;
        if (method.equalsIgnoreCase(REQUEST_TYPE_GET) && parameters != null) {
            StringBuffer param = new StringBuffer();
            int i = 0;
            for (String key : parameters.keySet()) {
                if (i == 0)
                    param.append("?");
                else
                    param.append("&");
                param.append(key).append("=").append(parameters.get(key));
                i++;
            }
            urlString += URLEncoder.encode(param.toString(),defaultContentEncoding);
        }

        URL url = new URL(urlString);
        urlConnection = (HttpURLConnection) url.openConnection();
        urlConnection.setRequestMethod(method);
        urlConnection.setDoOutput(true);
        urlConnection.setDoInput(true);
        urlConnection.setUseCaches(false);
        if (propertys != null) {
            for (String key : propertys.keySet()) {
                urlConnection.addRequestProperty(key, propertys.get(key));
            }
        }

        if (method.equalsIgnoreCase(REQUEST_TYPE_POST) && parameters != null) {
            StringBuffer param = new StringBuffer();
            for (String key : parameters.keySet()) {
                param.append("&");
                param.append(key).append("=").append(parameters.get(key));
            }
            urlConnection.getOutputStream().write(param.toString().getBytes(defaultContentEncoding));
            urlConnection.getOutputStream().flush();
            urlConnection.getOutputStream().close();
        }

        return this.makeContent(urlString, urlConnection);
    }

    /**
     * 得到响应对象
     * @param urlConnection
     *
     * @return 响应对象
     * @throws IOException
     */

    private HttpResponser makeContent(String urlString,HttpURLConnection urlConnection) throws IOException {
        HttpResponser httpResponser = new HttpResponser();
        try {
            httpResponser.setContentCollection(new Vector<String>());

            /*StringBuffer temp = new StringBuffer();
            String line = bufferedReader.readLine();
            while (line != null) {
                httpResponser.getContentCollection().add(line);
                temp.append(line).append("\r\n");
                line = bufferedReader.readLine();
            }
            bufferedReader.close();
            String ecod = urlConnection.getContentEncoding();
            if (ecod == null)
                ecod = this.defaultContentEncoding;*/

            httpResponser.setUrlString(urlString);
            httpResponser.setDefaultPort(urlConnection.getURL().getDefaultPort());
            httpResponser.setFile(urlConnection.getURL().getFile());
            httpResponser.setHost(urlConnection.getURL().getHost());
            httpResponser.setPath(urlConnection.getURL().getPath());
            httpResponser.setPort(urlConnection.getURL().getPort());
            httpResponser.setProtocol(urlConnection.getURL().getProtocol());
            httpResponser.setQuery(urlConnection.getURL().getQuery());
            httpResponser.setRef(urlConnection.getURL().getRef());
            httpResponser.setUserInfo(urlConnection.getURL().getUserInfo());
            httpResponser.setContent(this.convertStreamToString(urlConnection.getInputStream()));
            httpResponser.setContentEncoding(defaultContentEncoding);
            httpResponser.setCode(urlConnection.getResponseCode());
            httpResponser.setMessage(urlConnection.getResponseMessage());
            httpResponser.setContentType(urlConnection.getContentType());
            httpResponser.setMethod(urlConnection.getRequestMethod());
            httpResponser.setConnectTimeout(urlConnection.getConnectTimeout());
            httpResponser.setReadTimeout(urlConnection.getReadTimeout());
            return httpResponser;
        } catch (IOException e) {
            throw e;
        } finally {
            if (urlConnection != null)
                urlConnection.disconnect();
        }
    }

    private String convertStreamToString(InputStream inputStream) throws IOException {
        if (inputStream != null) {
            String line;
            StringBuffer sb = new StringBuffer();
            try {
                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream,defaultContentEncoding));
                while ((line=bufferedReader.readLine()) != null) {
                    sb.append(line).append("\n");
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            } finally {
                inputStream.close();
            }

            return sb.toString();
        } else {
            return "";
        }
    }

    public String getDefaultContentEncoding() {
        return defaultContentEncoding;
    }

    public void setDefaultContentEncoding(String defaultContentEncoding) {
        this.defaultContentEncoding = defaultContentEncoding;
    }

    public static void main(String[] args) {
        try {
            HttpRequester request = new HttpRequester();
            HttpResponser hr = request.sendGet("http://www.csdn.net");
            System.out.println(hr.getUrlString());
            System.out.println(hr.getProtocol());
            System.out.println(hr.getHost());
            System.out.println(hr.getPort());
            System.out.println(hr.getContentEncoding());
            System.out.println(hr.getMethod());
            System.out.println(hr.getContent());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
