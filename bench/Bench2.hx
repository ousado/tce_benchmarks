package bench;


import thx.benchmark.speed.*;
import ddlist.List;

#if python
import python.lib.Sys as PySys;
#end

using ddlist.List.Lists;

import ddlist.RList;
using ddlist.RList.RLists;

import ddlist.CList;
using ddlist.CList;

class Bench2 {
    static function main(){
        
        #if python untyped PySys.setrecursionlimit(50000); #end
        
        var MAX_T = 10000;
        var MIN_SAMPLES = 100;
        
        var suite = new Suite(MIN_SAMPLES, MAX_T);
        
        var mapsuite = new Suite(MIN_SAMPLES, MAX_T);
        var mapsuite = new Suite(MIN_SAMPLES, MAX_T);
        
        
        var stacksuite = new Suite(MIN_SAMPLES, MAX_T);
        var flattensuite = new Suite(MIN_SAMPLES, MAX_T);
        
        var N = 5000;
        
        var l = Nil;
        var cl = CList.nil();
        var rl = RNil;
        
        for (i in 0...N) {
             l = l.cons(i);
             rl = rl.cons(i);
             cl = cl.cons(i);
        }
        
        var N_NESTED = 50;
        var N_OUTER = 50;
        
        var nested_arr = [for ( x in 0...N_OUTER) [ for (y in 0...N_NESTED) y]];
        
        var nested  = nested_arr.map(Lists.toList).toList();  
        var rnested = nested_arr.map(RLists.toRList).toRList();
        var cnested = nested_arr.map(CList.toCList).toCList();
        
        var nested = [for ( x in 0...50) [ for (y in 0...50) y].toList() ].toList();
        var rnested = [for ( x in 0...50) [ for (y in 0...50) y].toRList() ].toRList();
        
        var lstack = Nil;
        var rlstack = RNil;
        var N = 500;
        for (i in 0...N) lstack = lstack.cons(i);
        for (i in 0...N) rlstack = rlstack.cons(i);
        
        var itersuite = new Suite(MIN_SAMPLES, MAX_T);
        itersuite.add("list iter", function(){
            function f(v) 2*v;
            @:measure { l.iter(f); };
        });
        itersuite.add("rlist iter", function(){
            function f(v) 2*v;
            @:measure { rl.iter(f); };
        });
        itersuite.add("clist iter", function(){
            function f(v) 2*v;
            @:measure { cl.iter(f); };
        });
        
        var foldsuite = new Suite(MIN_SAMPLES, MAX_T);
        foldsuite.add("list fold", function(){
            function f(v,acc) return 2+v+acc;
            @:measure { l.fold(f,0); };
        });
        foldsuite.add("rlist fold", function(){
            function f(v,acc) return 2+v+acc;
            @:measure { rl.fold(f,0); };
        });
        foldsuite.add("clist fold", function(){
            function f(v,acc) return 2+v+acc;
            @:measure { cl.fold(f,0); };
        });
        
        var mapsuite = new Suite(MIN_SAMPLES, MAX_T);
        mapsuite.add("list map", function(){
            function f(v) return 2*v;
            @:measure { l.map(f); };
        });
        mapsuite.add("rlist map", function(){
            function f(v) return 2*v;
            @:measure { rl.map(f); };
        });
        mapsuite.add("clist map", function(){
            function f(v) return 2*v;
            @:measure { cl.map(f); };
        });
        
        var maprevsuite = new Suite(MIN_SAMPLES, MAX_T);
        maprevsuite.add("list map_reverse", function(){
            function f(v) return 2*v;
            @:measure { l.map_reverse(f); };
        });
        maprevsuite.add("rlist map_reverse", function(){
            function f(v) return 2*v;
            @:measure { rl.map_reverse(f); };
        });
        maprevsuite.add("clist map_reverse", function(){
            function f(v) return 2*v;
            @:measure { cl.map_reverse(f); };
        });
        
        
        var flat1 = new Suite(MIN_SAMPLES, MAX_T);
        flat1.add("list flatten_to_array",function(){
            @:measure{ nested.flatten_to_array(); }
        });
        flat1.add("rlist flatten_to_array",function(){
            @:measure{ rnested.flatten_to_array(); }
        });
        flat1.add("clist flatten_to_array",function(){
            @:measure{ cnested.flatten_to_array(); }
        });
        
        var flat3 = new Suite(MIN_SAMPLES, MAX_T);
        flat3.add("list flatten_to_array2",function(){
            #if js untyped global.gc(); #end
            @:measure{ nested.flatten_to_array2(); }
        });
        flat3.add("rlist flatten_to_array2",function(){
            #if js untyped global.gc(); #end
            @:measure{ rnested.flatten_to_array2(); }
        });
        flat3.add("clist flatten_to_array2",function(){
            #if js untyped global.gc(); #end
            @:measure{ cnested.flatten_to_array2(); }
        });
        
        var flat2 = new Suite(MIN_SAMPLES, MAX_T);
        flat2.add("list flatten_arr",function(){
            @:measure{ nested.flatten_arr(); }
        });
        flat2.add("rlist flatten_arr",function(){
            @:measure{ rnested.flatten_arr(); }
        });
        flat2.add("clist flatten_arr",function(){
            @:measure{ cnested.flatten_via_array(); }
        });
        
        flat2.add("list flatten local",function(){
            @:measure{ nested.flatten(); }
        });
        flat2.add("rlist flatten local",function(){
            @:measure{ rnested.flatten(); }
        });
        flat2.add("clist flatten local",function(){
            @:measure{ cnested.flatten(); }
        });
        
        
        flat2.add("list flatten sep",function(){
            @:measure{ nested.flatten_(); }
        });
        flat2.add("rlist flatten sep",function(){
            @:measure{ rnested.flatten_(); }
        });
        
        // #######################################
        
        var revsuite = new Suite(MIN_SAMPLES, MAX_T);
        revsuite.add("list reverse", function(){
            @:measure { l.reverse(); };
        });
        revsuite.add("rlist reverse", function(){
            @:measure { rl.reverse(); };
        });
        revsuite.add("clist reverse", function(){
            @:measure { cl.reverse(); };
        });
        
        /*suite.add("flatten", function(){
            @:measure { nested.flatten(); };
        });*/
        trace(" ------- iter --------- ");
        trace(itersuite.run().toString());
        trace(" ------- fold --------- ");
        trace(foldsuite.run().toString());
        trace(" ------- map --------- ");
        trace(mapsuite.run().toString());
        #if js untyped global.gc(); #end
        trace(" ------- map_reverse --------- ");
        trace(maprevsuite.run().toString());
        #if js untyped global.gc(); #end
        
        trace(" ------- flatten --------- ");
        #if js untyped global.gc(); #end
        trace(flat2.run().toString());
        #if js untyped global.gc(); #end
        trace('--------- reverse ----------');
        trace(revsuite.run().toString());
        
        trace(" ------- flatten to array --------- ");
        #if js untyped global.gc(); #end
        trace(flat1.run().toString());
        trace(flat3.run().toString());
    }
}