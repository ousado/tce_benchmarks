package ddlist;


using ddlist.AList.ALists;

typedef AList<T> = { x:T, xs:AList<T> };

class ALists {
    
    public static function nil<T>():AList<T> return null;
    
    public static function cons<T>(xs:AList<T>,v:T){
        return {x:v,xs:xs};
    }
    
    public static function toAList<T>(arr:Array<T>) return fromArray(arr);
    public static function fromArray<T>(arr:Array<T>){
        var idx = arr.length;
        var list = nil();
        while (idx>0) {
            list = list.cons(arr[--idx]);
        }
        return list;
    }
    
    public static function toArray<T>(xs:AList<T>):Array<T>{
        var arr = [];
        iter(xs,arr.push);
        return arr;
    }
    
    public static function map<T,U>(xs:AList<T>,f:T->U):AList<U>{
        var r = xs.reverse();
        return r.map_reverse(f);
    }
    
    @:analyzer(tce_local)
    public static function map_arr<T,U>(xs:AList<T>,f:T->U):AList<U>{
        var arr:Array<U> = [];
        @:analyzer(tce_strict)
        function loop(xs:AList<T>,f:T->U):Void switch xs {
            case null:
            case {x:x,xs:xs}:
                arr.push(f(x));
                loop(xs,f);
        }
        loop(xs,f);
        return fromArray(arr);
    }
    
    public static function reverse<T>(xs:AList<T>):AList<T>{
        return _reverse(xs,null);
    }
    
    @:analyzer(tce_strict)
    public static function _reverse<T>(xs:AList<T>,acc:AList<T>):AList<T> return switch xs {
        case null: acc;
        case {x:v, xs:xs}: _reverse(xs,acc.cons(v));
    }
    
    public static function iter<T>(xs:AList<T>,f:T->Void) _iter(xs,f);
    
    @:analyzer(tce_strict)
    public static function _iter<T>(xs:AList<T>,f:T->Void):Void switch xs {
        case null:
        case {x:v, xs:xs}:
            f(v);
            _iter(xs,f);
    }
    
    public static function fold<T,ACC>(xs:AList<T>,f:ACC->T->ACC,acc:ACC) return _fold(xs,f,acc);
    
    @:analyzer(tce_strict)
    public static function _fold<T,ACC>(xs:AList<T>,f:ACC->T->ACC,acc):ACC return switch xs {
        case null:acc;
        case {x:v, xs:xs}:_fold(xs,f,f(acc,v));
    }
    
    @:analyzer(tce_local)
    public static function map_reverse<T,U>(xs:AList<T>,f:T->U):AList<U> {
        @:analyzer(tce_strict)
        function loop(xs:AList<T>,f:T->U,acc:AList<U>) return switch xs {
            case null:
                acc;
            case {x:x,xs:xs}:
                loop( xs, f, acc.cons( f(x) ));
        }
        return loop(xs,f,null); 
    }
    /*
    public function map_reverse_<U>(f:T->U):AList<U> return _map_rev(this,f,null);
    
    @:analyzer(tce_strict)
    function _map_rev<U>(xs:AList<T>,f:T->U,acc:AList<U>) return switch xs {
        case null:        acc;
        case {x:x,xs:xs}:
            _map_rev( xs, f, acc.cons( f(x) ));
    }
    */
    
    @:analyzer(tce_local)
    public static function flatten_to_array<T>(xxs:AList<AList<T>>):Array<T> {
        var arr:Array<T> = [];
        @:analyzer(tce_strict)
        function loopxs(xs:AList<T>) return switch xs {
            case null:null;
            case {x:x,xs:xs}:
                arr.push(x);
                loopxs(xs);
        }
        @:analyzer(tce_strict)
        function loopxxs(xxs:AList<AList<T>>):Array<T> return switch xxs {
            case null:arr;
            case {x:xs,xs:xxs}:
                loopxs(xs);
                loopxxs(xxs);
        }
        return loopxxs(xxs);
    }
    
    @:analyzer(tce_local)
    public static function flatten_to_array2<T>(xxs:AList<AList<T>>):Array<T> {
        var arr:Array<T> = [];
        @:analyzer(tce_strict)
        function loop(xxs:AList<AList<T>>,xs:AList<T>):Array<T> return switch [xxs,xs] {
            case [null,null]:arr;
            case [{x:xs,xs:xxs},null]:
                loop(xxs,xs);
            case [xxs,{x:x,xs:xs}]:
                arr.push(x);
                loop(xxs,xs);
        }
        return loop(xxs,null);
    }
    
    public static function flatten_via_array<T>(xxs:AList<AList<T>>):AList<T> {
        return fromArray(flatten_to_array(xxs));
    }
    
    @:analyzer(tce_local)
    public static function flatten<T>(xxs:AList<AList<T>>):AList<T> {
        @:analyzer(tce_strict)
        function loop(xxs:AList<AList<T>>,xs:AList<T>,acc:AList<T>) return switch xs {
            case null: switch xxs {
                case null:
                    acc;
                case {x:xs_rev,xs:xxs}:
                    loop(xxs,xs_rev.reverse(),acc);
                }
            case {x:x,xs:xs}:
                loop(xxs,xs,acc.cons(x));
        }
        var r = xxs.reverse();
        return switch r {
            case null:            null;
            case {x:xs,xs:null}:  xs;
            case {x:xs,xs:xxs}:   loop(xxs,null,xs);
        }
    }
}