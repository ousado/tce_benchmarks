package ddlist;

using ddlist.RList.RLists;
 
enum RList<T> {
    RNil;
    RCons(v:T,t:RList<T>);
}

class RLists {
    
    public static function reverse<T>(xs:RList<T>) return _rev(xs,RNil);
    
    public static function map_reverse<T,U>(xs:RList<T>,f:T->U):RList<U> return _map_rev(xs,f,RNil);
    
    public static function map<T,U>(xs:RList<T>,f:T->U):RList<U>{
        var xs = _map_rev(xs,f,RNil);
        return _rev(xs,RNil);
    }

    public static function cons<T>(xs:RList<T>,x:T) return RCons(x,xs);
    
    public static function toRList<T>(arr:Array<T>):RList<T> {
        var cur = arr.length - 1;
        var xs  = RNil;
        while (cur > -1) xs = xs.cons(arr[cur--]);
        return xs;
    }
    
    public static function toArray<T>(xs:RList<T>) return _toArray(xs,[]);
    

    public static function _toArray<T>(xs:RList<T>,acc:Array<T>) return switch xs{
        case RNil:acc;
        case RCons(x,xs):
            acc.push(x);
            _toArray(xs,acc);
    }
    
    //@:analyzer(tce_strict)
    public static function fold<T,ACC>(xs:RList<T>,f:ACC->T->ACC,acc:ACC):ACC return switch xs {
        case RNil:        acc;
        case RCons(x,xs): fold(xs,f,f(acc,x));
    }
    
    //@:analyzer(tce_strict)
    static function _rev<T>(xs:RList<T>,acc:RList<T>) return switch xs {
        case RNil:        acc;
        case RCons(x,xs): _rev(xs,RCons(x,acc));
    }
    
    //@:analyzer(tce_strict)
    static function _map_rev<T,U>(xs:RList<T>,f:T->U,acc:RList<U>) return switch xs {
        case RNil:        acc;
        case RCons(x,xs): _map_rev(xs,f,RCons(f(x),acc));
    }

    //@:analyzer(tce_local)
    public static function flatten_arr<T>(xxs:RList<RList<T>>):RList<T> {
        var arr:Array<T> = [];
        //@:analyzer(tce_strict)
        function loopxs(xs:RList<T>) return switch xs {
            case RNil:null;
            case RCons(x,xs):
                arr.push(x);
                loopxs(xs);
        }
        //@:analyzer(tce_strict)
        function loopxxs(xxs:RList<RList<T>>):RList<T> return switch xxs {
            case RNil:arr.toRList();
            case RCons(xs,xxs):
                loopxs(xs);
                loopxxs(xxs);
        }
        return loopxxs(xxs);
    }
    //@:analyzer(tce_local)
    public static function flatten_to_array<T>(xxs:RList<RList<T>>):Array<T> {
        var arr:Array<T> = [];
        //@:analyzer(tce_strict)
        function loopxs(xs:RList<T>) return switch xs {
            case RNil:null;
            case RCons(x,xs):
                arr.push(x);
                loopxs(xs);
        }
        //@:analyzer(tce_strict)
        function loopxxs(xxs:RList<RList<T>>):Array<T> return switch xxs {
            case RNil:arr;
            case RCons(xs,xxs):
                loopxs(xs);
                loopxxs(xxs);
        }
        return loopxxs(xxs);
    }
    //@:analyzer(tce_local)
    public static function flatten_to_array2<T>(xxs:RList<RList<T>>):Array<T> {
        var arr:Array<T> = [];
        //@:analyzer(tce_strict)
        function loop(xxs:RList<RList<T>>,xs:RList<T>):Array<T> return switch [xxs,xs] {
            case [RNil,RNil]:arr;
            case [RCons(xs,xxs),RNil]:
                loop(xxs,xs);
            case [xxs,RCons(x,xs)]:
                arr.push(x);
                loop(xxs,xs);
        }
        return loop(xxs,RNil);
    }
    //@:analyzer(tce_local)
    public static function flatten<T>(xxs:RList<RList<T>>):RList<T> {
        //@:analyzer(tce_strict)
        function loop(xxs:RList<RList<T>>,xs:RList<T>,acc:RList<T>) return switch xs {
            case RNil: switch xxs {
                case RNil:             acc;
                case RCons(xs_rev,xxs):loop(xxs,xs_rev.reverse(),acc);
                }
            case RCons(x,xs):          loop(xxs,xs,acc.cons(x));
        }
        var r = xxs.reverse();
        return switch r {
            case RNil:           RNil;
            case RCons(xs,RNil):  xs;
            case RCons(xs,xxs):  loop(xxs,RNil,xs);
        }
    }
    
    public static function flatten_<T>(xxs:RList<RList<T>>):RList<T> {
        var r = xxs.reverse();
        return switch r {
            case RNil: RNil;
            case RCons(xs,RNil):xs;
            case RCons(xs,xxs): _flatten(xxs,RNil,xs);
        }
    }
    
    //@:analyzer(tce_strict)
    static function _flatten<T>(xxs:RList<RList<T>>,xs:RList<T>,acc:RList<T>) return switch xs {
        case RNil: switch xxs {
            case RNil: 
                acc;
            case RCons(xs_rev,xxs):
                var xs = xs_rev.reverse();  
                _flatten(xxs,xs,acc);
        }
        case RCons(x,xs):
            _flatten(xxs,xs,acc.cons(x));
    }
  
}

/*
class RListTest {
  static function main(){
        trace('testlists');
        
        var l = [for ( x in 0...500) [ for (y in 0...500) y].toList() ].toList();
        trace(l.flatten().toArray().length );
        
        var l = [[1,2,3].toList(),[4,5,6].toList()].toList();
        trace(l.flatten().toArray());
        var l = RNil;
        for(i in 0...500000) l = l.RCons(i);
        var l2 = l.map(function(v) return v*2);
        var l3 = l2.reverse();
        var sum = l3.fold(function(sum:Float,v) return sum+v,0.);
        trace(sum);
    }
} */

