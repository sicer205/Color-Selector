package com.xiao.color;

public class Hex {
    
    public static String numToHex(int n){
        String r="";//空字符串
        while (n>16){
            int yushu=n%16;
            int shang=n/16;
            if(yushu>9){//特殊处理
                char c=(char) ((yushu-10)+'A');
                r+=c;//连接字符c
            }else {
                r+=yushu;
            }
            n=shang;
        }
        if(n>9){
            char c=(char)((n-10)+'A');
            r+=c;
        }else {
            r+=n;
        }
        return r;
    }
    
}
