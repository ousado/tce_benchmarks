package ddlist;

using ddlist.List.Lists;

enum List<T> {
    Nil;
    Cons(v:T,t:List<T>);
}

class Lists {
    
    public static function reverse<T>(xs:List<T>) return _rev(xs,Nil);
    
    public static function map_reverse<T,U>(xs:List<T>,f:T->U):List<U> return _map_rev(xs,f,Nil);
    
    public static function map<T,U>(xs:List<T>,f:T->U):List<U>{
        var xs = _map_rev(xs,f,Nil);
        return _rev(xs,Nil);
    }

    public static function cons<T>(xs:List<T>,x:T) return Cons(x,xs);
    
    public static function toList<T>(arr:Array<T>):List<T> {
        var cur = arr.length - 1;
        var xs  = Nil;
        while (cur > -1) xs = xs.cons(arr[cur--]);
        return xs;
    }
    
    public static function toArray<T>(xs:List<T>) return _toArray(xs,[]);
    
    @:analyzer(tce_strict)
    public static function _toArray<T>(xs:List<T>,acc:Array<T>) return switch xs{
        case Nil:acc;
        case Cons(x,xs):
            acc.push(x);
            _toArray(xs,acc);
    }
    
    @:analyzer(tce_strict)
    public static function fold<T,ACC>(xs:List<T>,f:ACC->T->ACC,acc:ACC):ACC return switch xs {
        case Nil:        acc;
        case Cons(x,xs): fold(xs,f,f(acc,x));
    }
    
    @:analyzer(tce_strict)
    static function _rev<T>(xs:List<T>,acc:List<T>) return switch xs {
        case Nil:        acc;
        case Cons(x,xs): _rev(xs,Cons(x,acc));
    }
    
    @:analyzer(tce_strict)
    static function _map_rev<T,U>(xs:List<T>,f:T->U,acc:List<U>) return switch xs {
        case Nil:        acc;
        case Cons(x,xs): _map_rev(xs,f,Cons(f(x),acc));
    }

    @:analyzer(tce_local)
    public static function flatten_arr<T>(xxs:List<List<T>>):List<T> {
        var arr:Array<T> = [];
        @:analyzer(tce_strict)
        function loopxs(xs:List<T>) return switch xs {
            case Nil:null;
            case Cons(x,xs):
                arr.push(x);
                loopxs(xs);
        }
        @:analyzer(tce_strict)
        function loopxxs(xxs:List<List<T>>):List<T> return switch xxs {
            case Nil:arr.toList();
            case Cons(xs,xxs):
                loopxs(xs);
                loopxxs(xxs);
        }
        return loopxxs(xxs);
    }
    @:analyzer(tce_local)
    public static function flatten_to_array<T>(xxs:List<List<T>>):Array<T> {
        var arr:Array<T> = [];
        @:analyzer(tce_strict)
        function loopxs(xs:List<T>) return switch xs {
            case Nil:null;
            case Cons(x,xs):
                arr.push(x);
                loopxs(xs);
        }
        @:analyzer(tce_strict)
        function loopxxs(xxs:List<List<T>>):Array<T> return switch xxs {
            case Nil:arr;
            case Cons(xs,xxs):
                loopxs(xs);
                loopxxs(xxs);
        }
        return loopxxs(xxs);
    }
    @:analyzer(tce_local)
    public static function flatten_to_array2<T>(xxs:List<List<T>>):Array<T> {
        var arr:Array<T> = [];
        @:analyzer(tce_strict)
        function loop(xxs:List<List<T>>,xs:List<T>):Array<T> return switch [xxs,xs] {
            case [Nil,Nil]:arr;
            case [Cons(xs,xxs),Nil]:
                loop(xxs,xs);
            case [xxs,Cons(x,xs)]:
                arr.push(x);
                loop(xxs,xs);
        }
        return loop(xxs,Nil);
    }
    @:analyzer(tce_local)
    public static function flatten<T>(xxs:List<List<T>>):List<T> {
        @:analyzer(tce_strict)
        function loop(xxs:List<List<T>>,xs:List<T>,acc:List<T>) return switch xs {
            case Nil: switch xxs {
                case Nil:             acc;
                case Cons(xs_rev,xxs):loop(xxs,xs_rev.reverse(),acc);
                }
            case Cons(x,xs):          loop(xxs,xs,acc.cons(x));
        }
        var r = xxs.reverse();
        return switch r {
            case Nil:           Nil;
            case Cons(xs,Nil):  xs;
            case Cons(xs,xxs):  loop(xxs,Nil,xs);
        }
    }
    
    public static function flatten_<T>(xxs:List<List<T>>):List<T> {
        var r = xxs.reverse();
        return switch r {
            case Nil: Nil;
            case Cons(xs,Nil):xs;
            case Cons(xs,xxs): _flatten(xxs,Nil,xs);
        }
    }
    
    @:analyzer(tce_strict)
    static function _flatten<T>(xxs:List<List<T>>,xs:List<T>,acc:List<T>) return switch xs {
        case Nil: switch xxs {
            case Nil: 
                acc;
            case Cons(xs_rev,xxs):
                var xs = xs_rev.reverse();  
                _flatten(xxs,xs,acc);
        }
        case Cons(x,xs):
            _flatten(xxs,xs,acc.cons(x));
    }
  
}

class ListTest {
  static function main(){
        trace('testlists');
        
        var l = [for ( x in 0...500) [ for (y in 0...500) y].toList() ].toList();
        trace(l.flatten().toArray().length );
        
        var l = [[1,2,3].toList(),[4,5,6].toList()].toList();
        trace(l.flatten().toArray());
        var l = Nil;
        for(i in 0...500000) l = l.cons(i);
        var l2 = l.map(function(v) return v*2);
        var l3 = l2.reverse();
        var sum = l3.fold(function(sum:Float,v) return sum+v,0.);
        trace(sum);
    }
}

