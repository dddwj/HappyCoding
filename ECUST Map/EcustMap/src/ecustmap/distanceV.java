/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ecustmap;

import java.util.Comparator;

/**
 *
 * @author dddwj
 */
public class distanceV{     
// 在distanceQ中使用，用于给Comparator排序。
//这样不仅可以排序distance，也可以排序distance对应的点的id。
        private final float INFINITY = 99;
        boolean known = false;
        float distance = INFINITY;
        int id;
}

class distanceComparator implements Comparator {
    public int compare(Object a, Object b){

        // Return nagative if a < b, postive if a > b
        if (((distanceV)a).distance < ((distanceV)b).distance)
            return -1;
        else if (((distanceV)a).distance > ((distanceV)b).distance)
            return 1;
        else
            return 0;
    }
}