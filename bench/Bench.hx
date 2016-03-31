package bench;


import thx.benchmark.speed.*;
import ddlist.List;
using ddlist.List.Lists;


class Bench {
    static function main(){
        var suite = new Suite(10, 2500);
        
        var mapsuite = new Suite(10, 2500);
        var revsuite = new Suite(10, 2500);
        
        var stacksuite = new Suite(10, 2500);
        var flattensuite = new Suite(10, 2500);
        var l = Nil;
        var nested = [for ( x in 0...500) [ for (y in 0...500) y].toList() ].toList();
        var lstack = Nil;
        var N = 500;
        for (i in 0...N) lstack = lstack.cons(i);
        var arrstack = [for (i in  0...N) i];
        for (i in 0...50000) l = l.cons(i);
        var arr = [for (i in 0...50000) i];
        
        flattensuite.add("flatten_to_array",function(){
            @:measure{ nested.flatten_to_array(); }
        });
        flattensuite.add("flatten_to_array2",function(){
            @:measure{ nested.flatten_to_array2(); }
        });
        flattensuite.add("flatten_arr",function(){
            @:measure{ nested.flatten_arr(); }
        });
        flattensuite.add("flatten local",function(){
            @:measure{ nested.flatten(); }
        });
        flattensuite.add("flatten sep",function(){
            @:measure{ nested.flatten_(); }
        });
        stacksuite.add("lstack pop immutable",function(){
            @:measure { 
                var c = 0;
                var cur = lstack;
                while(true) switch cur {
                    case Nil:break;
                    case Cons(v,xs):cur = xs;
                }
            }
        });
        stacksuite.add("arrstack stack pop immutable",function(){
            @:measure { 
                var c = 0;
                var cur = arrstack;
                while (cur.length>0){
                    cur = cur.copy();
                    var v = cur.pop();
                }
            }
        });
        stacksuite.add("arrstack stack pop mutable",function(){
            @:measure { 
                var c = 0;
                var cur = arrstack.copy();
                while (cur.length>0){
                    var v = cur.pop();
                }
            }
        });
        
        revsuite.add("list reverse", function(){
            @:measure { l.reverse(); };
        });
        revsuite.add("arr reverse", function(){
            var arr2=null;
            @:measure { arr2 = arr.copy(); arr2.reverse(); arr2[5] = 5; };
            if (arr2[0] != 49999 && arr2[5] == 5)
                throw 'unexpected result';
        });
        mapsuite.add("list map", function(){
            function f(v) return 2*v;
            @:measure { l.map(f); };
        });
        mapsuite.add("arr map", function(){
            function f(v) return 2*v;
            @:measure { var arr2 = arr.map(f); };
        });
        mapsuite.add("list map_reverse", function(){
            function f(v) return 2*v;
            @:measure { l.map_reverse(f); };
        });
        mapsuite.add("arr map_reverse", function(){
            function f(v) return 2*v;
            @:measure { var arr2 = arr.map(f); arr2.reverse(); };
        });
        
        /*suite.add("flatten", function(){
            @:measure { nested.flatten(); };
        });*/
        trace(flattensuite.run().toString());
        trace('--------- STACK ----------');
        trace(stacksuite.run().toString());
        trace('--------- MAP ----------');
        trace(mapsuite.run().toString());
        trace('--------- REV ----------');
        trace(revsuite.run().toString());
    }
}