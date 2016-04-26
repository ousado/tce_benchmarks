package bench;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
using haxe.macro.ExprTools;
using haxe.macro.TypeTools;
using haxe.macro.TypedExprTools;
using haxe.macro.Tools;
#end

class TT<T> {
    var t:T;
}

@:publicFields
class EClass {
    var i:Int;
    function new(i:Int) this.i = i;
}

enum EEnum {  
    EConstructor(v:Int); 
}

enum ArgKind {
    AInt;
    AClass;
    AEnum;
    ATP(a:ArgKind);
}

enum EKind {
    Abstract;
    Flat;
    P1(a:ArgKind);
    //P2(a:ArgKind,b:ArgKind);
}

enum Mix {
    First;
    Last;
    //Sparse;
    All;
}

typedef EnumConf = {
    c : Int,
    k : EKind
}

typedef TestGenConf = {
    c : Int,
    k : EKind,
    mix : Mix
}

typedef TestConf = {
    c : Int,
    k : EKind,
    sz : Int,
    mix : Mix
}

class Macro {
    
    static function main(){
        var report = new bench.Report("");
        run(report);
        //run();
    }
    
    
    
    static var SZ = [5,50,500];
    static var MIX = [All,First,Last];
    
    static function enums(){
        var C   = [2,5,250],
            K   = [ Abstract,
                    Flat,
                    P1(AInt),
                    P1(AClass),
                    P1(AEnum),
                    P1(ATP(AInt)),
                    P1(ATP(AClass)),
                    P1(ATP(AEnum))];
        return [ for (c in C) for (k in K) {c:c,k:k} ];
    }
    
    static function tests(){
        return [for (mix in MIX) for (e in enums()) 
            { mix:mix, k:e.k, c:e.c } 
        ];
    }
    
    static function s_akind(v:ArgKind) return switch v {
        case AInt:'Int';
        case AClass:'Class';
        case AEnum:'Enum';
        case ATP(a):'TP_${s_akind(a)}';
    }
    
    static function s_ekind(v:EKind) return switch v {
        case Abstract:'Abstract';
        case Flat:'Flat';
        case P1(k):'P1_${s_akind(k)}';
    }
    
    static function s_mix(v:Mix) return switch v {
        case First:'FirstCon';
        //case Sparse:'SparseCons';
        case All:'AllCons';
        case Last:'LastCon';
    }
    
    static function mk_enum_name(v:EnumConf){
        var c = v.c,
            k = s_ekind(v.k);
        return 'E_N${c}_K${k}'; 
    }
    
    static function test_name(test:TestConf) return 
        mk_enum_name(test)+'_SZ${test.sz}_MIX${s_mix(test.mix)}';
    
    public static function run(report:bench.Report){
        build(report);
    }
    
    macro static function build(e_report:Expr) {
    //macro static function build() {
        
        build_enums();
        build_tests();
        return macro {
            
            var r = $e_report;
            //var r = new bench.Report();
            
            var runner = new bench.Run();
            var eb = new bench.EnumBenchmarks();
            run.run(r,eb);
        };
    }
    
    #if macro
    static var pos = Context.makePosition({min:0,max:0,file:"bench/Macro.hx"});
    
    static function mk_type(name:String,params,fields:Array<Field>,kind:TypeDefKind,enumabs=false) return {
        pos : (macro null).pos,
        params : params,
        pack : ["bench"],
        name : name,
        meta : enumabs ? [{name:':enum',pos:pos,params:[]}] : null,
        kind : kind,
        isExtern : false,
        fields : fields
    }
    
    static function mk_field(name:String,ft:FieldType) return {
        pos : (macro null).pos,
        name : name,
        meta : null,
        doc : null,
        kind : ft,
        access : [APublic]
    }
    
    static function mk_con(name:String,con:Function) return mk_field(name,FFun(con));
    
    static function mk_function_field(e:Expr) switch e.expr {
        case EFunction(name,f):
            return mk_con(name,f);
        case _: throw("nope");
    }
    
    static function mk_var(e:Expr) switch e.expr {
        case EFunction(name,f):
            return mk_con(name,f);
        case _: throw("nope");
    }
    
    static function con_name(i:Int) return 'C$i'; 
    
    static function mk_cons(n:Int,args:Array<ComplexType>){
        return [for (i in 0...n) mk_con(con_name(i),
            {
                ret : null,
                params : [],
                expr : null,
                args : [for (i in 0...args.length) {
                    value : null,
                    type : args[i],
                    name : 'a$i',
                    opt  : false
                }]
            }
        )];
    }
    
    static function mk_abstract_cons(n:Int) return
        [for (i in 0...n) mk_field(con_name(i), FVar(macro : Int, macro $v{i}))];
    
    
    static var P = new haxe.macro.Printer();
    
    static function mk_case(match:Expr,expr:Expr)
            return {values:[match],guard:null,expr:expr};
    
    static function mk_switch(expr:Expr,cases:Array<{match:Expr,expr:Expr}>):Expr{
        var pos = (macro null).pos;
        var cases = [for (c in cases) mk_case(c.match,c.expr)];
        return {expr:ESwitch(expr,cases,macro throw "nope"),pos:pos};
    }
        
    static function mk_test_switch(eexpr:Expr,inval:Expr,econf:EnumConf):Expr{
       
        //var en = macro $i{mk_enum_name(econf)};
        var en = mk_enum_name(econf);
        var cases = switch econf.k {
            case Flat | Abstract: 
                [for (i in 0...econf.c) { 
                    match : {
                        var con_name = con_name(i);
                        macro bench.$en.$con_name; },
                    expr : macro $inval += $v{i} 
                }];
            case P1(a):
                [for (i in 0...econf.c){
                    var con_name = con_name(i);
                    var _case = {
                        match : switch a {
                                case AEnum | ATP(AEnum):
                                    macro bench.$en.$con_name(EConstructor(v));
                                case _:
                                    macro bench.$en.$con_name(v);
                            },
                        expr : switch a {
                            case AInt | ATP(AInt): macro $inval += v;
                            case AClass | ATP(AClass): macro $inval += v.i;
                            case AEnum | ATP(AEnum): macro $inval += v;
                            case xxx: throw('$xxx not allowed, currently');
                            }
                    };
                    _case;
                }];
        }
        return mk_switch(eexpr,cases);
    }
    
    static function build_tests(){
        
        var tests = tests();
        
        var enums = enums();
        var eexpr = macro enumvalue;
        var inval = macro inval;
        
        function etype_path(econf:EnumConf){
            var params = switch econf.k {
                case Abstract
                    | Flat 
                    | P1(AClass)
                    | P1(AEnum)
                    | P1(AInt) : [];
                case P1(ATP(AClass)): [TPType(macro : bench.Macro.EClass)];
                case P1(ATP(AEnum)):  [TPType(macro : bench.Macro.EEnum)];
                case P1(ATP(AInt)):   [TPType(macro : Int)];
                case _:throw "nope";
            }
            return TPath({ pack : ["bench"], name : mk_enum_name(econf), params : params });
        }
        
        function mk_enum_value_case(i:Int,econf:EnumConf){
            //var en = macro $i{mk_enum_name(econf)};
            //var EEE = bench.Macro.EEnum.EConstructor(123);
            var en = mk_enum_name(econf);
            var con_name = con_name(i);
            var expr = switch econf.k {
                case Abstract: macro bench.$en.$con_name; 
                case Flat: macro bench.$en.$con_name;
                case P1(AClass) | P1(ATP(AClass)) : macro bench.$en.$con_name(new bench.Macro.EClass(vin));
                case P1(AEnum) | P1(ATP(AEnum)): macro bench.$en.$con_name(bench.Macro.EEnum.EConstructor(vin));
                case P1(AInt) | P1(ATP(AInt)): macro bench.$en.$con_name(vin);
                case _:throw "nope";
            }
            return {match:macro $v{i}, expr: expr };
        }
        function mk_value_func(fname:String,econf:EnumConf){
            var cases = [for (i in 0...econf.c) mk_enum_value_case(i,econf)];
            var eswitch = mk_switch(macro vin % $v{econf.c}, cases);
            var f = macro function $fname(vin:Int) return $eswitch;
            //trace(P.printExpr(f));
            return f;
        }
        
        function mk_test_run(test:TestConf,valfunc:Expr,tfunc:Expr,e_suite:Expr){
            
            var test_name = test_name(test);
            
            var arr_expr = switch test.mix {
                case All: macro [for (vin in 0...N) $valfunc(vin)];
                case First: macro [for (vin in 0...N) $valfunc(0)];
                case Last: macro [for (vin in 0...N) $valfunc($v{test.c-1})];
            }
            var arr_expr = macro var $test_name = $arr_expr; 
            var arr_name = test_name;
            var run_block = macro {
                var N = $v{test.sz};
                $arr_expr;
                $e_suite.add($v{test_name},function(){
                    var r = 0;
                    @:measure { r = $tfunc($i{arr_name},r); }
                    if (r == -1) throw "bad result "+$v{test_name};
                });
            };
            //trace(P.printExpr(run_block));
            return run_block;
        }
        
        var cls = macro class EnumBenchmarks implements bench.Run.IBenchmark {
            public function new(){}
            public function run(report:bench.Report,warmup:Bool,min_samples:Int,max_time:Int){
                _run(report,warmup,min_samples,max_time);
            }
        }
        
        var funcs = [];
        var main = [];
        var suites = [for (sz in SZ){
            var suite = 'suite_N$sz';
            var e_suite = macro $i{suite};
            var thing = macro var $suite = new thx.benchmark.speed.Suite(min_samples,max_time);
            main.push( thing );
            e_suite;
        }];
        
        for (ee in enums){
            var fname = mk_enum_name(ee)+'_test';
            var e_tfunc = macro $i{fname};
            var e = mk_test_switch(eexpr,inval,ee);
            var ETPATH = etype_path(ee);
            var tfunc = macro function $fname(arr:Array<$ETPATH>,inval){
                for (enumvalue in arr) $e;
                return inval;
            }
            funcs.push(tfunc);
            //trace(P.printExpr(f));
            var valfname = mk_enum_name(ee)+'_value';
            var e_valfunc = macro $i{valfname};
            var valfunc = mk_value_func(valfname,ee);
            funcs.push(valfunc);
            var tests = [for (mix in MIX) for (sz in SZ) {
                var suite = 'suite_N$sz';
                var e_suite = macro $i{suite};
                var test = {sz:sz,mix:mix,k:ee.k,c:ee.c};
                var t = mk_test_run(test,e_valfunc,e_tfunc,e_suite);
                main.push(t);
            }];
        }
        for (s in suites) main.push( macro if(!warmup)trace($s.run()) );
        var run = macro function _run(report:bench.Report,warmup,min_samples,max_time){
            $b{main};
        }
        funcs.push(run);
        cls.fields = cls.fields.concat(funcs.map(mk_function_field));
        Context.defineType(cls);
        
        //trace(P.printTypeDefinition(cls));
        
    }
    
    static function build_enums(){
        
        var tInt   = Context.getType('Int'),
            tClass = Context.getType('bench.Macro.EClass'),
            tEnum  = Context.getType('bench.Macro.EEnum');
            
        var ctInt = tInt.toComplexType(),
            ctClass = tClass.toComplexType(),
            ctEnum = tEnum.toComplexType(),
            ctTP = TPath({name:'T',pack:[],params:[]});
        
        function _mk_args(v:ArgKind) return switch v {
            case AClass:[ctClass];
            case AEnum:[ctEnum];
            case AInt:[ctInt];
            case ATP(_):[ctTP];
        }
        
        function mk_args(v:EKind) return switch v {
            case Abstract:[];
            case Flat:[];
            case P1(a):_mk_args(a);
        }
        
        for (t in enums()) {
            var n    = mk_enum_name(t);
            
            var tps  = switch t.k {
                case P1(ATP(_)):[{name:'T',params:[],constraints:[]}];
                case _:[];
            }
            
            var te = switch t.k {
                case Abstract:
                    var cons = mk_abstract_cons(t.c);
                    var tdk = TDAbstract(macro : Int,[macro : Int],[]);
                    mk_type(n,tps,cons,tdk,true);
                case _:
                    var cons = mk_cons(t.c,mk_args(t.k));
                    mk_type(n,tps,cons,TDEnum);
            }
            Context.defineType(te);
            //var s = P.printTypeDefinition(te);
            trace('defined $n');
        }
        
        return macro null;
    }
    #end
    
}