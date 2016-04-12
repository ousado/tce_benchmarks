package ddlist;


using ddlist.CList;

class CList<T> {
    
    var x:T;
    var xs:CList<T>;
    
    public function new(x:T,xs:CList<T>){
        this.x = x;
        this.xs = xs;
    }
    
    public static function nil<T>():CList<T> return null;
    
    public static function cons<T>(xs:CList<T>,v:T){
        return new CList(v,xs);
    }
    
    public static function toCList<T>(arr:Array<T>) return fromArray(arr);
    public static function fromArray<T>(arr:Array<T>){
        var idx = arr.length;
        var list = nil();
        while (idx>0) {
            list = list.cons(arr[--idx]);
        }
        return list;
    }
    
    public function toArray():Array<T>{
        var arr = [];
        iter(arr.push);
        return arr;
    }
    
    public function map<U>(f:T->U):CList<U>{
        var r = reverse();
        return r.map_reverse(f);
    }
    
    @:analyzer(tce_local)
    public function map_arr<U>(f:T->U):CList<U>{
        var arr:Array<U> = [];
        @:analyzer(tce_strict)
        function loop(xs:CList<T>,f:T->U):Void switch xs {
            case null:
            case {x:x,xs:xs}:
                arr.push(f(x));
                loop(xs,f);
        }
        loop(xs,f);
        return fromArray(arr);
    }
    
    public function reverse():CList<T>{
        return _reverse(this,null);
    }
    
    @:analyzer(tce_strict)
    public function _reverse(xs:CList<T>,acc:CList<T>):CList<T> return switch xs {
        case null: acc;
        case {x:v, xs:xs}: _reverse(xs,acc.cons(v));
    }
    
    public function iter(f:T->Void) _iter(this,f);
    
    @:analyzer(tce_strict)
    public function _iter(xs:CList<T>,f:T->Void):Void switch xs {
        case null:
        case {x:v, xs:xs}:
            f(v);
            _iter(xs,f);
    }
    
    public function fold<ACC>(f:ACC->T->ACC,acc:ACC) return _fold(this,f,acc);
    
    @:analyzer(tce_strict)
    public function _fold<ACC>(xs:CList<T>,f:ACC->T->ACC,acc):ACC return switch xs {
        case null:acc;
        case {x:v, xs:xs}:_fold(xs,f,f(acc,v));
    }
    
    @:analyzer(tce_local)
    public function map_reverse<U>(f:T->U):CList<U> {
        @:analyzer(tce_strict)
        function loop(xs:CList<T>,f:T->U,acc:CList<U>) return switch xs {
            case null:        acc;
            case {x:x,xs:xs}:
                loop( xs, f, acc.cons( f(x) ));
        }
        return loop(this,f,null); 
    }
    /*
    public function map_reverse_<U>(f:T->U):CList<U> return _map_rev(this,f,null);
    
    @:analyzer(tce_strict)
    function _map_rev<U>(xs:CList<T>,f:T->U,acc:CList<U>) return switch xs {
        case null:        acc;
        case {x:x,xs:xs}:
            _map_rev( xs, f, acc.cons( f(x) ));
    }
    */
    
    @:analyzer(tce_local)
    public static function flatten_to_array<T>(xxs:CList<CList<T>>):Array<T> {
        var arr:Array<T> = [];
        @:analyzer(tce_strict)
        function loopxs(xs:CList<T>) return switch xs {
            case null:null;
            case {x:x,xs:xs}:
                arr.push(x);
                loopxs(xs);
        }
        @:analyzer(tce_strict)
        function loopxxs(xxs:CList<CList<T>>):Array<T> return switch xxs {
            case null:arr;
            case {x:xs,xs:xxs}:
                loopxs(xs);
                loopxxs(xxs);
        }
        return loopxxs(xxs);
    }
    
    @:analyzer(tce_local)
    public static function flatten_to_array2<T>(xxs:CList<CList<T>>):Array<T> {
        var arr:Array<T> = [];
        @:analyzer(tce_strict)
        function loop(xxs:CList<CList<T>>,xs:CList<T>):Array<T> return switch [xxs,xs] {
            case [null,null]:arr;
            case [{x:xs,xs:xxs},null]:
                loop(xxs,xs);
            case [xxs,{x:x,xs:xs}]:
                arr.push(x);
                loop(xxs,xs);
        }
        return loop(xxs,null);
    }
    
    public static function flatten_via_array<T>(xxs:CList<CList<T>>):CList<T> {
        return fromArray(flatten_to_array(xxs));
    }
    
    @:analyzer(tce_local)
    public static function flatten<T>(xxs:CList<CList<T>>):CList<T> {
        @:analyzer(tce_strict)
        function loop(xxs:CList<CList<T>>,xs:CList<T>,acc:CList<T>) return switch xs {
            case null: switch xxs {
                case null:                acc;
                case {x:xs_rev,xs:xxs}:   loop(xxs,xs_rev.reverse(),acc);
                }
            case {x:x,xs:xs}:             loop(xxs,xs,acc.cons(x));
        }
        var r = xxs.reverse();
        return switch r {
            case null:            null;
            case {x:xs,xs:null}:  xs;
            case {x:xs,xs:xxs}:   loop(xxs,null,xs);
        }
    }
    
    
    
    
}