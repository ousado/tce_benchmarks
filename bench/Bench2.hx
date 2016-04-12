package bench;


import thx.benchmark.speed.*;
import ddlist.List;

#if python
import python.lib.Sys as PySys;
#end

using ddlist.List.Lists;

import ddlist.RList;
using ddlist.RList.RLists;

import ddlist.AList;
using ddlist.AList.ALists;

import ddlist.CList;
using ddlist.CList;

class Bench2 {
    
    static function main(){
        _main(false);
        _main(true);
    }
    
    static function _main(p:Bool){
        
        #if python untyped PySys.setrecursionlimit(50000); #end
        
        var MAX_T = 200;
        var MIN_SAMPLES = 50;
        
        var suite = new Suite(MIN_SAMPLES, MAX_T);
        
        var mapsuite = new Suite(MIN_SAMPLES, MAX_T);
        var mapsuite = new Suite(MIN_SAMPLES, MAX_T);
        
        
        var stacksuite = new Suite(MIN_SAMPLES, MAX_T);
        var flattensuite = new Suite(MIN_SAMPLES, MAX_T);
        
        var N = 5000;
        
        var l = Nil;
        var cl = CList.nil();
        var rl = RNil;
        var al = ALists.nil();
        
        for (i in 0...N) {
             l = l.cons(i);
             rl = rl.cons(i);
             cl = cl.cons(i);
             al = al.cons(i);
        }
        var RLIST = false;
        
        var N_NESTED = 100;
        var N_OUTER = 50;
        
        var nested_arr = [for ( x in 0...N_OUTER) [ for (y in 0...N_NESTED) y]];
        
        var nested  = nested_arr.map(function(x) return Lists.toList(x)).toList();  
        var rnested = if (!RLIST) null else nested_arr.map(function(x) return RLists.toRList(x)).toRList();
        var cnested = nested_arr.map(function(x) return CList.toCList(x)).toCList();
        var anested = nested_arr.map(function(x) return ALists.toAList(x)).toAList();
        //var nested = [for ( x in 0...50) [ for (y in 0...50) y].toList() ].toList();
        //var rnested = [for ( x in 0...50) [ for (y in 0...50) y].toRList() ].toRList();
        
        /*var lstack = Nil;
        var rlstack = RNil;
        var N = 500;
        for (i in 0...N) lstack = lstack.cons(i);
        for (i in 0...N) rlstack = rlstack.cons(i);*/
        
        var itersuite = new Suite(MIN_SAMPLES, MAX_T);
        itersuite.add("list iter", function(){
            var sum = 0;
            function f(v) sum += v;
            @:measure { sum = 0; l.iter(f); };
            //var r = Std.int( Std.int(N/2) * (N-1) );
            //if (sum != r) throw('unexpected result $r $sum');
        });
        if (RLIST) itersuite.add("rlist iter", function(){
            function f(v) 2*v;
            @:measure { rl.iter(f); };
        });
        itersuite.add("clist iter", function(){
            var sum = 0;
            function f(v) sum += v;
            @:measure { sum = 0; cl.iter(f); };
            //var r = Std.int( Std.int(N/2) * (N-1) );
            //if (sum != r) throw('unexpected result $r $sum');
        });
        itersuite.add("alist iter", function(){
            var sum = 0;
            function f(v) sum += v;
            @:measure { sum = 0; al.iter(f); };
            //var r = Std.int( Std.int(N/2) * (N-1) );
            //if (sum != r) throw('unexpected result $r $sum');
        });
        var foldsuite = new Suite(MIN_SAMPLES, MAX_T);
        foldsuite.add("list fold", function(){
            var sum = 0;
            function f(v,acc) return v+acc;
            @:measure { sum = l.fold(f,0); };
            //var r = Std.int( Std.int(N/2) * (N-1) );
            //if (sum != r) throw('unexpected result $r $sum');
        });
        if (RLIST)foldsuite.add("rlist fold", function(){
            function f(v,acc) return 2+v+acc;
            @:measure { rl.fold(f,0); };
        });
        foldsuite.add("clist fold", function(){
            function f(v,acc) return 2+v+acc;
            @:measure { cl.fold(f,0); };
        });
        foldsuite.add("alist fold", function(){
            function f(v,acc) return 2+v+acc;
            @:measure { al.fold(f,0); };
        });
        
        var mapsuite = new Suite(MIN_SAMPLES, MAX_T);
        mapsuite.add("list map", function(){
            function f(v) return 2*v;
            @:measure { l.map(f); };
        });
        if (RLIST)mapsuite.add("rlist map", function(){
            function f(v) return 2*v;
            @:measure { rl.map(f); };
        });
        mapsuite.add("clist map", function(){
            function f(v) return 2*v;
            @:measure { cl.map(f); };
        });
        mapsuite.add("alist map", function(){
            function f(v) return 2*v;
            @:measure { al.map(f); };
        });
        
        var maparrsuite = new Suite(MIN_SAMPLES, MAX_T);
        maparrsuite.add("list map arr", function(){
            function f(v) return 2*v;
            @:measure { l.map_arr(f); };
        });
        if (RLIST)maparrsuite.add("rlist map arr", function(){
            function f(v) return 2*v;
            @:measure { rl.map_arr(f); };
        });
        maparrsuite.add("clist map arr", function(){
            function f(v) return 2*v;
            @:measure { cl.map_arr(f); };
        });
        maparrsuite.add("alist map arr", function(){
            function f(v) return 2*v;
            @:measure { al.map_arr(f); };
        });
        
        var maprevsuite = new Suite(MIN_SAMPLES, MAX_T);
        maprevsuite.add("list map_reverse", function(){
            function f(v) return 2*v;
            @:measure { l.map_reverse(f); };
        });
        if (RLIST) maprevsuite.add("rlist map_reverse", function(){
            function f(v) return 2*v;
            @:measure { rl.map_reverse(f); };
        });
        maprevsuite.add("clist map_reverse", function(){
            function f(v) return 2*v;
            @:measure { cl.map_reverse(f); };
        });
        maprevsuite.add("alist map_reverse", function(){
            function f(v) return 2*v;
            @:measure { al.map_reverse(f); };
        });
        
        var flat1 = new Suite(MIN_SAMPLES, MAX_T);
        flat1.add("list flatten_to_array",function(){
            @:measure{ nested.flatten_to_array(); }
        });
        if (RLIST)flat1.add("rlist flatten_to_array",function(){
            @:measure{ rnested.flatten_to_array(); }
        });
        flat1.add("clist flatten_to_array",function(){
            @:measure{ cnested.flatten_to_array(); }
        });
        flat1.add("alist flatten_to_array",function(){
            @:measure{ anested.flatten_to_array(); }
        });
        
        var flat3 = new Suite(MIN_SAMPLES, MAX_T);
        flat3.add("list flatten_to_array2",function(){
            #if js untyped global.gc(); #end
            @:measure{ nested.flatten_to_array2(); }
        });
        if (RLIST)flat3.add("rlist flatten_to_array2",function(){
            #if js untyped global.gc(); #end
            @:measure{ rnested.flatten_to_array2(); }
        });
        flat3.add("clist flatten_to_array2",function(){
            #if js untyped global.gc(); #end
            @:measure{ cnested.flatten_to_array2(); }
        });
        flat3.add("alist flatten_to_array2",function(){
            #if js untyped global.gc(); #end
            @:measure{ anested.flatten_to_array2(); }
        });
        
        var flat2 = new Suite(MIN_SAMPLES, MAX_T);
        flat2.add("list flatten_arr",function(){
            @:measure{ nested.flatten_arr(); }
        });
        if (RLIST)flat2.add("rlist flatten_arr",function(){
            @:measure{ rnested.flatten_arr(); }
        });
        flat2.add("clist flatten_arr",function(){
            @:measure{ cnested.flatten_via_array(); }
        });
        flat2.add("alist flatten_arr",function(){
            @:measure{ anested.flatten_via_array(); }
        });
        
        flat2.add("list flatten local",function(){
            @:measure{ nested.flatten(); }
        });
        if (RLIST)flat2.add("rlist flatten local",function(){
            @:measure{ rnested.flatten(); }
        });
        flat2.add("clist flatten local",function(){
            @:measure{ cnested.flatten(); }
        });
        flat2.add("alist flatten local",function(){
            @:measure{ anested.flatten(); }
        });
        
        
        flat2.add("list flatten sep",function(){
            @:measure{ nested.flatten_(); }
        });
        if (RLIST)flat2.add("rlist flatten sep",function(){
            @:measure{ rnested.flatten_(); }
        });
        
        // #######################################
        
        var revsuite = new Suite(MIN_SAMPLES, MAX_T);
        revsuite.add("list reverse", function(){
            @:measure { l.reverse(); };
        });
        if (RLIST)revsuite.add("rlist reverse", function(){
            @:measure { rl.reverse(); };
        });
        revsuite.add("clist reverse", function(){
            @:measure { cl.reverse(); };
        });
        revsuite.add("alist reverse", function(){
            @:measure { al.reverse(); };
        });
        
        /*suite.add("flatten", function(){
            @:measure { nested.flatten(); };
        });*/
        /*
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
        */
        
        var results = [];
        
        for (s in [
            itersuite,
            foldsuite,
            mapsuite,
            maparrsuite,
            maprevsuite,
            flat2,
            flat1,
            flat3
        ]){
            var r = s.run();
            //trace(r);
            for (k in r.tests.keys()){
                var v = r.tests.get(k);
                var ops = v.cycles,
                    ops_low = v.cycles - (v.cycles * v.relativeMarginOfError / 2),
                    ops_high = v.cycles + (v.cycles * v.relativeMarginOfError / 2),
                    ops_err = (v.cycles * v.relativeMarginOfError),
                    merr = v.relativeMarginOfError,
                    size = v.size,
                    name = k,
                    ms = v.ms;
                var res = '{ "name": "$name",  "data" : { "ops":$ops, "ops_err":$ops_err, "ops_low":$ops_low, "ops_high":$ops_high, "merr":$merr, "size":$size, "ms":$ms }}';
                results.push(res);
                if (false) trace({ 
                    ops : v.cycles, 
                    merr : v.relativeMarginOfError,
                    size : v.size 
                });
            }
            
        }
        var rr = results.join(',\n');
        if(p)trace('\n { "target" : "", "results" : [ $rr ] }');
    }
}