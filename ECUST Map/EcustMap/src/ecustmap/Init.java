/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ecustmap;

import java.sql.*;

/**
 *
 * @author dddwj
 */
public class Init {
    Connection con;
    String driver = "com.mysql.jdbc.Driver";
    String url = "jdbc:mysql://101.132.154.2:3306/atmsys";
    String user = "atmsys";
    String password = "atmsys";
    
    private static final int MAX_VERTEX_COUNT = 40;
    Vertex[] table = new Vertex[MAX_VERTEX_COUNT];
    
    
    public void setGraph(int Vid){
        int adj1,adj2,adj3,adj4;
        float dist1,dist2,dist3,dist4;
        table[Vid].id = Vid;
        try{
            PreparedStatement ps = con.prepareStatement("select adj1,dist1,adj2,dist2,adj3,dist3,adj4,dist4"
                + " from adjList where Vid = " + Vid );
            ResultSet rs = ps.executeQuery();   
            while(rs.next()){
                adj1 = rs.getInt("adj1");  
                if ( adj1 != 99 ){ dist1 = rs.getFloat("dist1"); table[Vid].addEdge(adj1, dist1);}
                adj2 = rs.getInt("adj2");  
                if ( adj2 != 99 ){ dist2 = rs.getFloat("dist2"); table[Vid].addEdge(adj2, dist2);}
                adj3 = rs.getInt("adj3");  
                if ( adj3 != 99 ){ dist3 = rs.getFloat("dist3"); table[Vid].addEdge(adj3, dist3);}
                adj4 = rs.getInt("adj4");  
                if ( adj4 != 99 ){ dist4 = rs.getFloat("dist4"); table[Vid].addEdge(adj4, dist4);}
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
    }
    
    public Vertex[] setGraph(){
        try{
            Class.forName(driver);
            con = DriverManager.getConnection(url,user,password);
            if(!con.isClosed())
                System.out.println("Succeeded connecting to the DB!");
            }
        catch(Exception e){e.printStackTrace();}
        
        for(int i = 0 ; i < MAX_VERTEX_COUNT ; i++ ){
            table[i] = new Vertex(i);
        }
        
        for ( int i = 0 ; i < 40 ; i ++){
            setGraph(i);
        }
        return table;
    }
}
