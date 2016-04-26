package bench;

import thx.benchmark.speed.SuiteReport;
import bench.Report;

interface IBenchmark {
    function run(report:bench.Report,warmup:Bool,min_samples:Int,max_time:Int):Void;
}

@:publicFields
class Run {
    
    static var warmup:Map<TargetName,Bool> = [ js => true ];
    static var WARMUP_MIN_SAMPLES = 1;
    static var WARMUP_MAX_TIME    = 100;
    static var MIN_SAMPLES = 10;
    static var MAX_TIME    = 300;
    function new(){}
    function run(report:bench.Report,b:IBenchmark,min_samples:Int=0,max_time:Int=0):Void{
        var tn = Report.target_name();
        if (warmup.exists(tn) && warmup.get(tn)){
            var ignore = new Report(""); 
            b.run(ignore,true,WARMUP_MIN_SAMPLES,WARMUP_MAX_TIME);
        }
        var min_samples = min_samples == 0 ? MIN_SAMPLES : min_samples;
        var max_time = max_time == 0 ? MAX_TIME : max_time;
        return b.run(report,false,min_samples,max_time);
    }
}