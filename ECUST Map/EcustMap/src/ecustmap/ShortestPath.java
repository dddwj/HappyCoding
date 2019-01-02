/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ecustmap;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

/**
 *
 * @author dddwj
 */
public class ShortestPath {
    private static final int MAX_VERTEX_COUNT = 40;
    Vertex[] table;
    LinkedList l_path = new LinkedList();
    ShortestPath( Vertex[] table ){
        this.table = table;
    }
    
    public void printGraph(){
        for ( Vertex v : table )
            for ( AdjVertex x : v.adj )
                System.out.println( v + "->" + "v" + x.id + ": " + x.cost );
        System.out.println();
    }    
    
    public LinkedList printPath(int index){
        Vertex v = table[index];        
        if (v.path != null){
            printPath( v.path.id );
            System.out.print(" to ");
        }
        System.out.print(v);
        l_path.add(index);
        return l_path;
    }
    
    public String printPathLength(int index){
        System.out.println();
        System.out.println("Path Length: " + table[index].dist );
        return String.valueOf((float)(Math.round( table[index].dist * 100))/100);
    }
    
    public void visit(Vertex V){
        System.out.println("Visited: " + V + "\n");
    }
    
    public void Dijkstra( int startPoint ){
        table[startPoint].dist = 0;
        do{
            // 找当前没有被访问过的所有点，将他们的distance从table取到distanceQ中。
            ArrayList<distanceV> distanceQ = new ArrayList<distanceV>();
            for (int index = 0 ; index < table.length ; index ++ ){     // O(N)复杂度
                Vertex x = table[index];            
                if ( x.known == false ){
                    distanceV m = new distanceV();
                    m.id = x.id;
                    m.distance = x.dist;
                    distanceQ.add(m);
                }
            }
            if(distanceQ.isEmpty())     break;
            
            
            // 打印每个节点的最新distance
            for(int index = 1 ; index < table.length; index ++ )
                System.out.print(table[index].dist + " ");
            System.out.println();
                    
            // 对distance进行排序   
            Collections.sort(distanceQ, new distanceComparator()); //MergeSort 复杂度：O(NlogN).  
            // 打印distance排序后的队列
            for ( distanceV x : distanceQ )     
                System.out.print(x.distance + " ");
            System.out.println();
            
            // 找出当前distance最小点，访问该点
            Vertex V = table[distanceQ.get(0).id];
            V.known = true;
            visit(V);
            
            
            // 更新table，看有没有更小的距离
            for ( AdjVertex W : V.adj )
                if( !table[W.id].known )
                    if( V.dist + W.cost < table[W.id].dist){
                        table[W.id].dist = V.dist + W.cost;
                        table[W.id].path = V;
                    }
             
        }while( true );
        
    }
    
    
    
    public static void main(String[] args){
        // 初始化一张图Vertex[]数组。类似书上的一张表。
        // 由于是带权的，所以需要addEdge，使用AdjVertex（邻接表）存储边权和边的终点。
        
//        Vertex[] table = new Vertex[MAX_VERTEX_COUNT];
//        for(int i = 0 ; i < MAX_VERTEX_COUNT ; i++ ){
//            table[i] = new Vertex(i);
//        }
//        table[1].addEdge(2, 2);  table[1].addEdge(4, 1);
//        table[2].addEdge(4, 3); table[2].addEdge(5, 10);
//        table[3].addEdge(1, 4); table[3].addEdge(6, 5);
//        table[4].addEdge(3, 2); table[4].addEdge(5, 2);
//        table[4].addEdge(6, 8); table[4].addEdge(7, 4);
//        table[5].addEdge(7, 6); table[7].addEdge(6, 1);
//        ShortestPath sp = new ShortestPath( table );
     
        Init init = new Init();
        ShortestPath sp = new ShortestPath( init.setGraph() );
        int startPoint = 0;
        int endPoint = 1;
//        sp.printGraph();
        sp.Dijkstra( startPoint );
        LinkedList<Integer> ll = sp.printPath( endPoint );
        sp.printPathLength( endPoint );
        for(int x : ll){
            System.out.print(x + " ");
        }
    }
}









