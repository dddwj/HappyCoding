/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ecustmap;

import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author dddwj
 */
class Vertex{
    private static final float INFINITY = 99;
    public int id;
    public boolean known;
    public float dist;
    public Vertex path;
    public String toString(){ return "v" + id + " "; }

    Vertex(int id){
        this.id = id;
        this.known = false;
        this.dist = INFINITY;
        this.path = null;
    }

    public List<AdjVertex> adj = new LinkedList<>();
    
    public void addEdge(int id, float cost){
        adj.add(new AdjVertex(id, cost));
    } 

}
    
class AdjVertex{        // ´æ´¢±ßµÄÈ¨ÖØ¡£
        public int id;
        public float cost;
        AdjVertex(int id, float cost){
            this.cost = cost;
            this.id = id;
        }
}