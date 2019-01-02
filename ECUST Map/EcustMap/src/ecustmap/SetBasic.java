/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ecustmap;
import static java.lang.Math.*;
import java.sql.*;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Stack;

/**
 *
 * @author dddwj
 */
public class SetBasic {
    Connection con;
    String driver = "com.mysql.jdbc.Driver";
    String url = "jdbc:mysql://101.132.154.2:3306/atmsys";
    String user = "atmsys";
    String password = "atmsys";
     
    
    public float[] findPoint( int Vid ){
        float[] xy = new float[2];
        try{
            float x,y;        
            PreparedStatement ps = con.prepareStatement("select x,y from points where Vid = " + Vid );
            ResultSet rs = ps.executeQuery();       
            
            while(rs.next()){
//                Vid = rs.getInt("Vid");
                x = rs.getFloat("x");  xy[0] = x;
                y = rs.getFloat("y");  xy[1] = y;
//                System.out.println(Vid + " [" + x + ", " + y + "]");
            }
            
            rs.close();
        }
        catch( Exception e ){
            e.printStackTrace();
        }
        finally{
//            System.out.println("End of visiting DB!");
        }
        return xy;
    }
    
    public void findDistance( int Vid ){
        float[] Vxy = findPoint( Vid );
        LinkedList<Integer> q = new LinkedList<>();
        
        try{
            int adj1,adj2,adj3,adj4;
            PreparedStatement ps = con.prepareCall("select * from adjList where Vid = " + Vid );
            ResultSet rs = ps.executeQuery();
            while ( rs.next() ){
                adj1 = rs.getInt("adj1");   if ( adj1 != 99 ) { q.add(adj1); }
                adj2 = rs.getInt("adj2");   if ( adj2 != 99 ) { q.add(adj2);}
                adj3 = rs.getInt("adj3");   if ( adj3 != 99 ) { q.add(adj3);}
                adj4 = rs.getInt("adj4");   if ( adj4 != 99 ) { q.add(adj4);}
            }

            while ( !q.isEmpty() ){
                int W = q.removeFirst();
                float[] Wxy = findPoint( W );
                float distance = (float) sqrt( pow((Vxy[0] - Wxy[0]),2) + pow((Vxy[1] - Wxy[1]),2) ); 
                System.out.println(Vid + "->" + W + ": " + distance );

            }
            System.out.println();
        }
        catch(Exception e){e.printStackTrace();}
        finally{
//            System.out.println("End of visiting DB!");
        }
        return;
    }
    
    public void findDistance(){
        try{
            Class.forName(driver);
            con = DriverManager.getConnection(url,user,password);
            if(!con.isClosed())
                System.out.println("Succeeded connecting to the DB!");
        }
        catch(Exception e){
            e.printStackTrace();
        }
        for ( int i = 0 ; i < 40 ; i ++ ){
            findDistance(i);
            System.out.println();
        }
        
    }
    
    public static void main(String[] args){
        SetBasic sb = new SetBasic();
        sb.findDistance();
    }
    
    
}
