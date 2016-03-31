package bench;


import thx.benchmark.speed.*;
import ddlist.List;
using ddlist.List.Lists;

import ddlist.RList;
using ddlist.RList.RLists;

class Bench2 {
    static function main(){
        var suite = new Suite(10, 2500);
        
        var mapsuite = new Suite(10, 2500);
        var mapsuite = new Suite(10, 2500);
        
        
        var stacksuite = new Suite(10, 2500);
        var flattensuite = new Suite(10, 2500);
        
        var l = Nil;
        var N = 5000;
        for (i in 0...N) l = l.cons(i);
        var rl = RNil;
        for (i in 0...N) rl = rl.cons(i);
        
        var nested = [for ( x in 0...50) [ for (y in 0...50) y].toList() ].toList();
        var rnested = [for ( x in 0...50) [ for (y in 0...50) y].toRList() ].toRList();
        
        var lstack = Nil;
        var rlstack = RNil;
        var N = 500;
        for (i in 0...N) lstack = lstack.cons(i);
        for (i in 0...N) rlstack = rlstack.cons(i);
        
        var mapsuite = new Suite(10, 2500);
        mapsuite.add("list map", function(){
            function f(v) return 2*v;
            @:measure { l.map(f); };
        });
        mapsuite.add("rlist map", function(){
            function f(v) return 2*v;
            @:measure { rl.map(f); };
        });
        
        var maprevsuite = new Suite(10, 2500);
        maprevsuite.add("list map_reverse", function(){
            function f(v) return 2*v;
            @:measure { l.map_reverse(f); };
        });
        var maprevsuit = new Suite(10, 2500);
        maprevsuite.add("rlist map_reverse", function(){
            function f(v) return 2*v;
            @:measure { rl.map_reverse(f); };
        });
        
        var flat1 = new Suite(10, 2500);
        flat1.add("list flatten_to_array",function(){
            @:measure{ nested.flatten_to_array(); }
        });
        flat1.add("rlist flatten_to_array",function(){
            @:measure{ rnested.flatten_to_array(); }
        });
        flat1.add("list flatten_to_array2",function(){
            @:measure{ nested.flatten_to_array2(); }
        });
        flat1.add("rlist flatten_to_array2",function(){
            @:measure{ rnested.flatten_to_array2(); }
        });
        
        var flat2 = new Suite(10, 2500);
        
        flat2.add("list flatten_arr",function(){
            @:measure{ nested.flatten_arr(); }
        });
        flat2.add("rlist flatten_arr",function(){
            @:measure{ rnested.flatten_arr(); }
        });
        
        flat2.add("list flatten local",function(){
            @:measure{ nested.flatten(); }
        });
        flat2.add("rlist flatten local",function(){
            @:measure{ rnested.flatten(); }
        });
        flat2.add("list flatten sep",function(){
            @:measure{ nested.flatten_(); }
        });
        flat2.add("rlist flatten sep",function(){
            @:measure{ rnested.flatten_(); }
        });
        
        var revsuite = new Suite(10, 2500);
        revsuite.add("list reverse", function(){
            @:measure { l.reverse(); };
        });
        revsuite.add("rlist reverse", function(){
            @:measure { rl.reverse(); };
        });
        
        
        /*suite.add("flatten", function(){
            @:measure { nested.flatten(); };
        });*/
        trace(" ------- map --------- ");
        trace(mapsuite.run().toString());
        trace(" ------- map_reverse --------- ");
        trace(maprevsuite.run().toString());
        trace(" ------- flatten to array --------- ");
        trace(flat1.run().toString());
        trace(" ------- flatten --------- ");
        trace(flat2.run().toString());
        trace('--------- reverse ----------');
        trace(revsuite.run().toString());
    }
}