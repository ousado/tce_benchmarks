package bench;

import bench.Run.IBenchmark;

import thx.benchmark.speed.*;
import thx.Arrays;

interface ICall {
    function f1(v:Int):Int;
    function f2(v1:Int,v2:Int):Int;
    function f3(v1:Int,v2:Int,v3:Int):Int;
    function f5(v1:Int,v2:Int,v3:Int,v4:Int,v5:Int):Int;
    function f8(v1:Int,v2:Int,v3:Int,v4:Int,v5:Int,v6:Int,v7:Int,v8:Int):Int;
}

@:publicFields
class CCall1 implements ICall {
    function new(){}
    function f1(v1:Int):Int
        return v1;
    function f2(v1:Int,v2:Int):Int
        return v1+v2;
    function f3(v1:Int,v2:Int,v3:Int):Int
        return v1+v2+v3;
    function f5(v1:Int,v2:Int,v3:Int,v4:Int,v5:Int):Int
        return v1+v2+v3+v4+v5;
    function f8(v1:Int,v2:Int,v3:Int,v4:Int,v5:Int,v6:Int,v7:Int,v8:Int):Int
        return v1+v2+v3+v4+v5+v6+v7+v8;
}

@:publicFields
class CCall2 implements ICall  {
    function new(){}
    function f1(v1:Int):Int
        return v1;
    function f2(v1:Int,v2:Int):Int
        return v1+v2;
    function f3(v1:Int,v2:Int,v3:Int):Int
        return v1+v2+v3;
    function f5(v1:Int,v2:Int,v3:Int,v4:Int,v5:Int):Int
        return v1+v2+v3+v4+v5;
    function f8(v1:Int,v2:Int,v3:Int,v4:Int,v5:Int,v6:Int,v7:Int,v8:Int):Int
        return v1+v2+v3+v4+v5+v6+v7+v8;
}
@:publicFields
class CCall3 implements ICall {
    function new(){}
    function f1(v1:Int):Int
        return v1;
    function f2(v1:Int,v2:Int):Int
        return v1+v2;
    function f3(v1:Int,v2:Int,v3:Int):Int
        return v1+v2+v3;
    function f5(v1:Int,v2:Int,v3:Int,v4:Int,v5:Int):Int
        return v1+v2+v3+v4+v5;
    function f8(v1:Int,v2:Int,v3:Int,v4:Int,v5:Int,v6:Int,v7:Int,v8:Int):Int
        return v1+v2+v3+v4+v5+v6+v7+v8;
}
@:publicFields
class CCall4 implements ICall {
    function new(){}
    function f1(v1:Int):Int
        return v1;
    function f2(v1:Int,v2:Int):Int
        return v1+v2;
    function f3(v1:Int,v2:Int,v3:Int):Int
        return v1+v2+v3;
    function f5(v1:Int,v2:Int,v3:Int,v4:Int,v5:Int):Int
        return v1+v2+v3+v4+v5;
    function f8(v1:Int,v2:Int,v3:Int,v4:Int,v5:Int,v6:Int,v7:Int,v8:Int):Int
        return v1+v2+v3+v4+v5+v6+v7+v8;
}
@:publicFields
class CCall5 implements ICall {
    function new(){}
    function f1(v1:Int):Int
        return v1;
    function f2(v1:Int,v2:Int):Int
        return v1+v2;
    function f3(v1:Int,v2:Int,v3:Int):Int
        return v1+v2+v3;
    function f5(v1:Int,v2:Int,v3:Int,v4:Int,v5:Int):Int
        return v1+v2+v3+v4+v5;
    function f8(v1:Int,v2:Int,v3:Int,v4:Int,v5:Int,v6:Int,v7:Int,v8:Int):Int
        return v1+v2+v3+v4+v5+v6+v7+v8;
}


@:publicFields
class BICall implements IBenchmark {
    
    function new(){}
    
    function run(report:Report,warmup:Bool,MIN_SAMPLES:Int,MAX_TIME:Int){
        
        var N  = 5;
        var NL = 5000;
        
        function mix(i):ICall return switch i % 5 {
            case 0:new CCall1();
            case 1:new CCall2();
            case 2:new CCall3();
            case 3:new CCall4();
            case 4:new CCall5();
            case _: throw "nope";
        }
        
        var sameN  = [for(i in 0...N) (new CCall1() : ICall )];
        var sameNL = [for(i in 0...NL) (new CCall1() : ICall )];
        var mixedN = [for(i in 0...N) mix(i)];
        var mixedNL = [for(i in 0...NL) mix(i)];
        
        var snames = ["short","long"];
        var suites = [
            { var s = new Suite(MIN_SAMPLES, MAX_TIME);
              s.add("sameN 1",function(){
                  @:measure{ sum1(sameN); }
              });
              s.add("sameN 2",function(){
                  @:measure{ sum2(sameN); }
              });
              s.add("sameN 3",function(){
                  @:measure{ sum3(sameN); }
              });
              s.add("sameN 5",function(){
                  @:measure{ sum5(sameN); }
              });
              s.add("sameN 8",function(){
                  @:measure{ sum8(sameN); }
              });
              s.add("mixedN 1",function(){
                  @:measure{ sum1(mixedN); }
              });
              s.add("mixedN 2",function(){
                  @:measure{ sum2(mixedN); }
              });
              s.add("mixedN 3",function(){
                  @:measure{ sum3(mixedN); }
              });
              s.add("mixedN 5",function(){
                  @:measure{ sum5(mixedN); }
              });
              s.add("mixedN 8",function(){
                  @:measure{ sum8(mixedN); }
              });
              s;
            },
            { var s = new Suite(MIN_SAMPLES, MAX_TIME);
              s.add("sameNL 1",function(){
                  @:measure{ sum1(sameNL); }
              });
              s.add("sameNL 2",function(){
                  @:measure{ sum2(sameNL); }
              });
              s.add("sameNL 3",function(){
                  @:measure{ sum3(sameNL); }
              });
              s.add("sameNL 5",function(){
                  @:measure{ sum5(sameNL); }
              });
              s.add("sameNL 8",function(){
                  @:measure{ sum8(sameNL); }
              });
              s.add("mixedNL 1",function(){
                  @:measure{ sum1(mixedNL); }
              });
              s.add("mixedNL 2",function(){
                  @:measure{ sum2(mixedNL); }
              });
              s.add("mixedNL 3",function(){
                  @:measure{ sum3(mixedNL); }
              });
              s.add("mixedNL 5",function(){
                  @:measure{ sum5(mixedNL); }
              });
              s.add("mixedNL 8",function(){
                  @:measure{ sum8(mixedNL); }
              });
              s;
            }
        ];
        
        var results = [for (s in suites) s.run()];
        if (!warmup) for (r in results) trace(r);
        //var json = results.map(Micro.tojson);
    }
    
    function sum1(xs:Array<ICall>){
        var s = 0;
        for (i in 0...xs.length) s += xs[i].f1(i);
        return s;
    }
    function sum2(xs:Array<ICall>){
        var s = 0;
        for (i in 0...xs.length) s += xs[i].f2(i,i);
        return s;
    }
    function sum3(xs:Array<ICall>){
        var s = 0;
        for (i in 0...xs.length) s += xs[i].f3(i,i,i);
        return s;
    }
    function sum5(xs:Array<ICall>){
        var s = 0;
        for (i in 0...xs.length) s += xs[i].f5(i,i,i,i,i);
        return s;
    }
    function sum8(xs:Array<ICall>){
        var s = 0;
        for (i in 0...xs.length) s += xs[i].f8(i,i,i,i,i,i,i,i);
        return s;
    }
}

@:publicFields
class BClosureCall implements IBenchmark {
    
    function new(){}
    
    function run(report:Report,warmup,MIN_SAMPLES:Int,MAX_TIME:Int){
        
        function f1(v1:Int):Int
            return (v1 ^ 0x1f1f1f1f) >> 1;
        function f2(v1:Int,v2:Int):Int
            return (v1 ^ v2) >> 1;
        function f3(v1:Int,v2:Int,v3:Int):Int
            return (v1 ^ v3) >> 1;
        function f5(v1:Int,v2:Int,v3:Int,v4:Int,v5:Int):Int
            return (v1 ^ v4) >> 1;
        function f8(v1:Int,v2:Int,v3:Int,v4:Int,v5:Int,v6:Int,v7:Int,v8:Int):Int
            return (v1 ^ v8) >> 1;
        
        var N = 5000;
        var ARG = 123;
        
        
        
        var rr = Std.int(thx.Timer.time());
        var s = new Suite(MIN_SAMPLES, MAX_TIME);
              s.add("call 1",function(){
                  var r = rr;
                  @:measure{ r = call1(N,r,f1); }
                  rr += r;
              });
              s.add("call 2",function(){
                  var r = rr;
                  @:measure{ r = call2(N,r,f2); }
                  rr += r;
              });
              s.add("call 3",function(){
                  var r = rr;
                  @:measure{ r = call3(N,r,f3); }
                  rr += r;
              });
              s.add("call 5",function(){
                  var r = rr;
                  @:measure{ r = call5(N,r,f5); }
                  rr += r;
              });
              s.add("call 8",function(){
                  var r = rr;
                  @:measure{ r = call8(N,r,f8); }
                  rr += r;
              });
              s.add("callG 1",function(){
                  var r = rr;
                  @:measure{ r = callG1(N,ARG,f1); }
                  rr += r;
              });
              s.add("callG 2",function(){
                  var r = rr;
                  @:measure{ r = callG2(N,ARG,f2); }
                  rr += r;
              });
              s.add("callG 3",function(){
                  var r = rr;
                  @:measure{ r = callG3(N,ARG,f3); }
                  rr += r;
              });
              s.add("callG 5",function(){
                  var r = rr;
                  @:measure{ r = callG5(N,ARG,f5); }
                  rr += r;
              });
              s.add("callG 8",function(){
                  var r = rr;
                  @:measure{ r = callG8(N,ARG,f8); }
                  rr += r;
              });
        var suites = [s];
        trace(rr);
        var results = [for (s in suites) s.run()];
        trace(rr);
        if (!warmup) for (r in results) trace(r);
        //var json = results.map(Micro.tojson);
    }
    
    function call1(N:Int,arg:Int,f:Int->Int){
        var s = arg;
        for (i in 0...N) s = f(s);
        return s;
    }
    function call2(N:Int,arg:Int,f:Int->Int->Int){
        var s = arg;
        for (i in 0...N) s = f(s,i);
        return s;
    }
    function call3(N:Int,arg:Int,f:Int->Int->Int->Int){
        var s = arg;
        for (i in 0...N) s = f(s,i,i);
        return s;
    }
    function call5(N:Int,arg:Int,f:Int->Int->Int->Int->Int->Int){
        var s = arg;
        for (i in 0...N) s = f(s,i,i,i,i);
        return s;
    }
    function call8(N:Int,arg:Int,f:Int->Int->Int->Int->Int->Int->Int->Int->Int){
        var s = arg;
        for (i in 0...N) s = f(s,i,i,i,i,i,i,i);
        return s;
    }
    
    function callG1<T>(N:Int,arg:T,f:T->T){
        var s = arg;
        for (i in 0...N) s = f(s);
        return s;
    }
    function callG2<T>(N:Int,arg:T,f:T->T->T){
        var s = arg;
        for (i in 0...N) s = f(s,arg);
        return s;
    }
    function callG3<T>(N:Int,arg:T,f:T->T->T->T){
        var s = arg;
        for (i in 0...N) s = f(s,arg,arg);
        return s;
    }
    function callG5<T>(N:Int,arg:T,f:T->T->T->T->T->T){
        var s = arg;
        for (i in 0...N) s = f(s,arg,arg,arg,arg);
        return s;
    }
    function callG8<T>(N:Int,arg:T,f:T->T->T->T->T->T->T->T->T){
        var s = arg;
        for (i in 0...N) s = f(s,arg,arg,arg,arg,arg,arg,arg);
        return s;
    }
}


enum TwoFlat {
    TwoFlat1;
    TwoFlat2;
}

enum TwoArgs {
    TwoArgs1(v:Int);
    TwoArgs2(v:Int);
}
enum TwoArgsG<T> {
    TwoArgsG1(v:T);
    TwoArgsG2(v:T);
}

enum FewFlat {
    FewFlat1;
    FewFlat2;
    FewFlat3;
    FewFlat4;
    FewFlat5;
}
enum FewArgs {
    FewArgs1(v:Int);
    FewArgs2(v:Int);
    FewArgs3(v:Int);
    FewArgs4(v:Int);
    FewArgs5(v:Int);
}
enum FewArgsG<T> {
    FewArgsG1(v:T);
    FewArgsG2(v:T);
    FewArgsG3(v:T);
    FewArgsG4(v:T);
    FewArgsG5(v:T);
}

enum ManyFlat {
    ManyFlat1;
    ManyFlat2;
    ManyFlat3;
    ManyFlat4;
    ManyFlat5;
    ManyFlat6;
    ManyFlat7;
    ManyFlat8;
    ManyFlat9;
    ManyFlat10;
    ManyFlat11;
    ManyFlat12;
    ManyFlat13;
    ManyFlat14;
    ManyFlat15;
    ManyFlat16;
    ManyFlat17;
}

enum ManyArgs {
    ManyArgs1(v:Int);
    ManyArgs2(v:Int);
    ManyArgs3(v:Int);
    ManyArgs4(v:Int);
    ManyArgs5(v:Int);
    ManyArgs6(v:Int);
    ManyArgs7(v:Int);
    ManyArgs8(v:Int);
    ManyArgs9(v:Int);
    ManyArgs10(v:Int);
    ManyArgs11(v:Int);
    ManyArgs12(v:Int);
    ManyArgs13(v:Int);
    ManyArgs14(v:Int);
    ManyArgs15(v:Int);
    ManyArgs16(v:Int);
    ManyArgs17(v:Int);
}

enum ManyArgsG<T> {
    ManyArgsG1(v:T);
    ManyArgsG2(v:T);
    ManyArgsG3(v:T);
    ManyArgsG4(v:T);
    ManyArgsG5(v:T);
    ManyArgsG6(v:T);
    ManyArgsG7(v:T);
    ManyArgsG8(v:T);
    ManyArgsG9(v:T);
    ManyArgsG10(v:T);
    ManyArgsG11(v:T);
    ManyArgsG12(v:T);
    ManyArgsG13(v:T);
    ManyArgsG14(v:T);
    ManyArgsG15(v:T);
    ManyArgsG16(v:T);
    ManyArgsG17(v:T);
}

@:publicFields
class EC {
    var i:Int;
    function new(i:Int) this.i = i;
}

@:publicFields
class BEnums implements IBenchmark {
    
    function run(report:Report,warmup:Bool,MIN_SAMPLES:Int,MAX_TIME:Int){
        
        var N  = 5;
        var NL = 5000;
        
        function mix2F(i) return switch i % 2 {
            case 0:TwoFlat1;
            case 1:TwoFlat2;
            case _:throw "nope";
        }
        
        function mix2(i) return switch i % 2 {
            case 0:TwoArgs1(i);
            case 1:TwoArgs2(i);
            case _:throw "nope";
        }
        
        function mix2G(i) return switch i % 2 {
            case 0:TwoArgsG1(i);
            case 1:TwoArgsG2(i);
            case _:throw "nope";
        }
        function mix2GI(i) return switch i % 2 {
            case 0:TwoArgsG1(new EC(i));
            case 1:TwoArgsG2(new EC(i));
            case _:throw "nope";
        }
        function mix5F(i) return switch i % 5 {
            case 0:FewFlat1;
            case 1:FewFlat2;
            case 2:FewFlat3;
            case 3:FewFlat4;
            case 4:FewFlat5;
            case _:throw "nope";
        }
        function mix5(i) return switch i % 5 {
            case 0:FewArgs1(i);
            case 1:FewArgs2(i);
            case 2:FewArgs3(i);
            case 3:FewArgs4(i);
            case 4:FewArgs5(i);
            case _:throw "nope";
        }
        
        function mix5G(i) return switch i % 5 {
            case 0:FewArgsG1(i);
            case 1:FewArgsG2(i);
            case 2:FewArgsG3(i);
            case 3:FewArgsG4(i);
            case 4:FewArgsG5(i);
            case _:throw "nope";
        }
        function mix5GI(i) return switch i % 5 {
            case 0:FewArgsG1(new EC(i));
            case 1:FewArgsG2(new EC(i));
            case 2:FewArgsG3(new EC(i));
            case 3:FewArgsG4(new EC(i));
            case 4:FewArgsG5(new EC(i));
            case _:throw "nope";
        }
        
        /*
        function desc(n:Int,numcons:Int,same:Bool) {
            'matching each out of an array of $n enum instances, where ' +
            'the enum has $numcons constructors, ' +
            ( same ? " all constructors are the same"
                  :  " the constructors are mixed " ) +
            ''
                 
        }*/
        
        
        
        var same2FN   = [for(i in 0...N) TwoFlat2];
        var same2FNL  = [for(i in 0...NL) TwoFlat2];
        
        var same2AN  = [for(i in 0...N) TwoArgs2(i)];
        var same2ANL  = [for(i in 0...NL) TwoArgs2(i)];
        
        var same2AGN  = [for(i in 0...N) TwoArgsG2(i)];
        var same2AGNL  = [for(i in 0...NL) TwoArgsG2(i)];
        
        var same2IGN  = [for(i in 0...N) TwoArgsG2(new EC(i))];
        var same2IGNL  = [for(i in 0...NL) TwoArgsG2(new EC(i))];
        
        
        var mixed2FN  = [for(i in 0...N) mix2F(i)];
        var mixed2AN = [for(i in 0...N) mix2(i)];
        var mixed2AGN = [for(i in 0...N) mix2G(i)];
        var mixed2IGN = [for(i in 0...N) mix2GI(i)];
        
        var mixed2FNL = [for(i in 0...NL) mix2F(i)];
        var mixed2ANL = [for(i in 0...NL) mix2(i)];
        var mixed2AGNL = [for(i in 0...NL) mix2G(i)];
        var mixed2IGNL = [for(i in 0...NL) mix2GI(i)];
        
        var same5FN   = [for(i in 0...N) FewFlat5];
        var same5FNL  = [for(i in 0...NL) FewFlat5];
        
        var same5AN  = [for(i in 0...N) FewArgs5(i)];
        var same5ANL  = [for(i in 0...NL) FewArgs5(i)];
        
        var same5AGN  = [for(i in 0...N) FewArgsG5(i)];
        var same5IGN  = [for(i in 0...N) FewArgsG5(new EC(i))];
        var same5AGNL  = [for(i in 0...NL) FewArgsG5(i)];
        var same5IGNL  = [for(i in 0...NL) FewArgsG5(new EC(i))];
        
        var mixed5FN  = [for(i in 0...N) mix5F(i)];
        var mixed5AN  = [for(i in 0...N) mix5(i)];
        var mixed5AGN  = [for(i in 0...N) mix5G(i)];
        var mixed5IGN = [for(i in 0...N) mix5GI(i)];
        
        var mixed5FNL = [for(i in 0...NL) mix5F(i)];
        var mixed5ANL = [for(i in 0...NL) mix5(i)];
        var mixed5AGNL = [for(i in 0...NL) mix5G(i)];
        var mixed5IGNL = [for(i in 0...NL) mix5GI(i)];
        
        var snames = ["short","long"];
        var suites = [
            { var s = new Suite(MIN_SAMPLES, MAX_TIME);
              s.add("same2FN",function(){
                  var r = 0;
                  @:measure{ r = sum2F(same2FN); }
                  if (r == 0) throw("wrong");
              });
              s.add("same2AN",function(){
                  @:measure{ sum2A(same2AN); }
              });
              s.add("same2AGN",function(){
                  @:measure{ sum2AG(same2AGN); }
              });
              s.add("same2IGN",function(){
                  @:measure{ sum2IG(same2IGN); }
              });
              
              s.add("same5FN",function(){
                  var r = 0;
                  @:measure{ r = sum5F(same5FN); }
                  if (r == 0) throw("wrong");
              });
              s.add("same5AN",function(){
                  @:measure{ sum5A(same5AN); }
              });
              s.add("same5AGN",function(){
                  @:measure{ sum5AG(same5AGN); }
              });
              s.add("same5IGN",function(){
                  @:measure{ sum5IG(same5IGN); }
              });
              s.add("mixed2FN",function(){
                  var r = 0;
                  @:measure{ r = sum2F(mixed2FN); }
                  if (r == 0) throw("wrong");
              });
              s.add("mixed2AN",function(){
                  @:measure{ sum2A(mixed2AN); }
              });
              s.add("mixed2AGN",function(){
                  @:measure{ sum2AG(mixed2AGN); }
              });
              s.add("mixed2IGN",function(){
                  @:measure{ sum2IG(mixed2IGN); }
              });
              
              s.add("mixed5FN",function(){
                  var r = 0;
                  @:measure{ r = sum5F(mixed5FN); }
                  if (r == 0) throw("wrong");
              });
              s.add("mixed5AN",function(){
                  @:measure{ sum5A(mixed5AN); }
              });
              s.add("mixed5AGN",function(){
                  @:measure{ sum5AG(mixed5AGN); }
              });
              s.add("mixed5IGN",function(){
                  @:measure{ sum5IG(mixed5IGN); }
              });
              s;
            },{ 
              var s = new Suite(MIN_SAMPLES, MAX_TIME);
              s.add("same2FNL",function(){
                  var r = 0;
                  @:measure{ r = sum2F(same2FNL); }
                  if (r == 0) throw("wrong");
              });
              s.add("same2ANL",function(){
                  @:measure{ sum2A(same2ANL); }
              });
              s.add("same2AGNL",function(){
                  @:measure{ sum2AG(same2AGNL); }
              });
              s.add("same2IGNL",function(){
                  @:measure{ sum2IG(same2IGNL); }
              });
              
              s.add("same5FNL",function(){
                  var r = 0;
                  @:measure{ r = sum5F(same5FNL); }
                  if (r == 0) throw("wrong");
              });
              s.add("same5ANL",function(){
                  @:measure{ sum5A(same5ANL); }
              });
              s.add("same5AGNL",function(){
                  @:measure{ sum5AG(same5AGNL); }
              });
              s.add("same5IGNL",function(){
                  @:measure{ sum5IG(same5IGNL); }
              });
              
              s.add("mixed2FNL",function(){
                  var r = 0;
                  @:measure{ r = sum2F(mixed2FNL); }
                  if (r == 0) throw("wrong");
              });
              s.add("mixed2ANL",function(){
                  @:measure{ sum2A(mixed2ANL); }
              });
              s.add("mixed2AGNL",function(){
                  @:measure{ sum2AG(mixed2AGNL); }
              });
              s.add("mixed2IGNL",function(){
                  @:measure{ sum5IG(mixed5IGNL); }
              });
              
              s.add("mixed5FNL",function(){
                  var r = 0;
                  @:measure{ r = sum5F(mixed5FNL); }
                  if (r == 0) throw("wrong");
              });
              s.add("mixed5ANL",function(){
                  @:measure{ sum5A(mixed5ANL); }
              });
              s.add("mixed5AGNL",function(){
                  @:measure{ sum5AG(mixed5AGNL); }
              });
              s.add("mixed5IGNL",function(){
                  @:measure{ sum5IG(mixed5IGNL); }
              });
              s;
        }];
        
        var results = [for (s in suites) s.run()];
        if (!warmup) for (r in results) trace(r);
        //var json = results.map(Micro.tojson);
        
    }
    
    function sum2F(xs:Array<TwoFlat>) {
        var s = 0;
        for (x in xs) switch x {
            case TwoFlat1: s+=1;
            case TwoFlat2: s+=2;
        }
        return s;
    }
    
    function sum2A(xs:Array<TwoArgs>) {
        var s = 0;
        for (x in xs) switch x {
            case TwoArgs1(v): s+=v;
            case TwoArgs2(v): s+=v;
        }
        return s;
    }
    function sum2AG(xs:Array<TwoArgsG<Int>>) {
        var s = 0;
        for (x in xs) switch x {
            case TwoArgsG1(v): s+=v;
            case TwoArgsG2(v): s+=v;
        }
        return s;
    }
    function sum2IG(xs:Array<TwoArgsG<EC>>) {
        var s = 0;
        for (x in xs) switch x {
            case TwoArgsG1(v): s+=v.i;
            case TwoArgsG2(v): s+=v.i;
        }
        return s;
    }
    function sum5F(xs:Array<FewFlat>) {
        var s = 0;
        for (x in xs) switch x {
            case FewFlat1: s+=1;
            case FewFlat2: s+=2;
            case FewFlat3: s+=3;
            case FewFlat4: s+=4;
            case FewFlat5: s+=5;
        }
        return s;
    }
    function sum5A(xs:Array<FewArgs>) {
        var s = 0;
        for (x in xs) switch x {
            case FewArgs1(v): s+=v;
            case FewArgs2(v): s+=v;
            case FewArgs3(v): s+=v;
            case FewArgs4(v): s+=v;
            case FewArgs5(v): s+=v;
        }
        return s;
    }
    function sum5AG(xs:Array<FewArgsG<Int>>) {
        var s = 0;
        for (x in xs) switch x {
            case FewArgsG1(v): s+=v;
            case FewArgsG2(v): s+=v;
            case FewArgsG3(v): s+=v;
            case FewArgsG4(v): s+=v;
            case FewArgsG5(v): s+=v;
        }
        return s;
    }
    function sum5IG(xs:Array<FewArgsG<EC>>) {
        var s = 0;
        for (x in xs) switch x {
            case FewArgsG1(v): s+=v.i;
            case FewArgsG2(v): s+=v.i;
            case FewArgsG3(v): s+=v.i;
            case FewArgsG4(v): s+=v.i;
            case FewArgsG5(v): s+=v.i;
        }
        return s;
    }
    function new(){}
}

@:publicFields
class Micro {
    
    static function main(){
        
        
        var runner = new bench.Run();
        var report = new bench.Report("Haxe micro benchmarks");
        //bench.Macro.run(report);
        var bcc = new BClosureCall();
        var benums = new BEnums();
        var bicall = new BICall();
        for (x in ([bcc,benums,bicall]:Array<IBenchmark>)){
            runner.run(report,x);
        }
        //new BICall().run();
    }
}