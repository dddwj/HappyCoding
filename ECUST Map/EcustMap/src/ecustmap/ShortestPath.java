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
            // �ҵ�ǰû�б����ʹ������е㣬�����ǵ�distance��tableȡ��distanceQ�С�
            ArrayList<distanceV> distanceQ = new ArrayList<distanceV>();
            for (int index = 0 ; index < table.length ; index ++ ){     // O(N)���Ӷ�
                Vertex x = table[index];            
                if ( x.known == false ){
                    distanceV m = new distanceV();
                    m.id = x.id;
                    m.distance = x.dist;
                    distanceQ.add(m);
                }
            }
            if(distanceQ.isEmpty())     break;
            
            
            // ��ӡÿ���ڵ������distance
            for(int index = 1 ; index < table.length; index ++ )
                System.out.print(table[index].dist + " ");
            System.out.println();
                    
            // ��distance��������   
            Collections.sort(distanceQ, new distanceComparator()); //MergeSort ���Ӷȣ�O(NlogN).  
            // ��ӡdistance�����Ķ���
            for ( distanceV x : distanceQ )     
                System.out.print(x.distance + " ");
            System.out.println();
            
            // �ҳ���ǰdistance��С�㣬���ʸõ�
            Vertex V = table[distanceQ.get(0).id];
            V.known = true;
            visit(V);
            
            
            // ����table������û�и�С�ľ���
            for ( AdjVertex W : V.adj )
                if( !table[W.id].known )
                    if( V.dist + W.cost < table[W.id].dist){
                        table[W.id].dist = V.dist + W.cost;
                        table[W.id].path = V;
                    }
             
        }while( true );
        
    }
    
    
    
    public static void main(String[] args){
        // ��ʼ��һ��ͼVertex[]���顣�������ϵ�һ�ű�
        // �����Ǵ�Ȩ�ģ�������ҪaddEdge��ʹ��AdjVertex���ڽӱ��洢��Ȩ�ͱߵ��յ㡣
        
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









