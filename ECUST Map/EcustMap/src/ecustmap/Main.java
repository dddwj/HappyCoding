/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ecustmap;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.LinkedList;

/**
 *
 * @author dddwj
 */
public class Main {
    public static void main(String[] args){
        Init init = new Init();
        ShortestPath sp = new ShortestPath( init.setGraph() );
                sp.printGraph();
        int startPoint = 0;
        int endPoint = 0;
        
        try{
            String pathname = "/Users/dddwj/NetBeansProjects/EcustMap/src/ecustmap/input.txt";
            File filename = new File(pathname);
            InputStreamReader reader = new InputStreamReader(new FileInputStream(filename)); // 建立一个输入流对象reader  
            BufferedReader br = new BufferedReader(reader); // 建立一个对象，它把文件内容转成计算机能读懂的语言  
            String line = "";  
            startPoint = Integer.parseInt(br.readLine());  
            endPoint = Integer.parseInt(br.readLine()); 
//            System.out.println(startPoint + " " + endPoint);
        }
        catch(Exception e){e.printStackTrace();}
        
        
        

        sp.Dijkstra( startPoint );
        LinkedList<Integer> ll = sp.printPath( endPoint );
        String pathLength = sp.printPathLength( endPoint );
        
        
        
        try {
            PrintWriter pw=new PrintWriter("/Users/dddwj/NetBeansProjects/EcustMap/src/ecustmap/output.txt");
            for(int x : ll)
                pw.write(x + "\n");
            pw.write("\n");
            pw.write(pathLength);
            pw.flush();
            pw.close();
	} catch (FileNotFoundException e) {
            e.printStackTrace();
	}

    }
}