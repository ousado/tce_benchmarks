package bench;
#if js
import js.node.Fs;
#end
import thx.benchmark.speed.*;

@:enum abstract TargetName(String) to String {
    var cpp = "cpp";
    var cppia = "cppia";
    var cs = "cs";
    var java = "java";
    var js = "js";
    var lua = "lua";
    var neko = "neko";
    var php = "php";
    var python = "python";
    var __other__ = "unknown target";
}

typedef BenchmarkInfo = {
    tags : Array<String>,
    desc : String
};

typedef SuiteReportIn = {
    name : String,
    desc : String,
    info : Map<String,BenchmarkInfo>,
    result : SuiteReport
}

typedef Benchmark = {
    var name:String;
    var desc:String;
    var tags:Array<String>;
    var ops:Float;
    var ops_err:Float;
    var ops_low:Float;
    var ops_high:Float;
    var margin_of_error:Float;
    var size:Int;
    var ms:Float;
}

typedef SuiteReportObject = {
    var name:String;
    var desc:String;
    var report_table:String;
    var results:Array<Benchmark>;
}

typedef SuiteReportGroup = {
    var name : String;
    var desc : String;
    var suites : Array<SuiteReportObject>;
}

typedef ReportObject = {
    var name:String;
    var target:TargetName;
    var target_desc:String;
    var runtime:String;
    var runtime_desc:String;
    var suites : Array<SuiteReportObject>;
    var groups : Array<SuiteReportGroup>;
}

@:publicFields
class Report {
    
    static function target_name():TargetName{
        return #if (cpp && cppia) cppia
            #elseif cpp cpp
            #elseif cs cs
            #elseif java java
            #elseif js js
            #elseif neko neko
            #elseif php php
            #elseif python python
            #elseif lua lua
            #else #error "forgot a target.."
            #end;
    }

    static function add_report_info(v:ReportObject){
        v.name = target_name();
        v.target_desc = "";
        v.runtime = Sys.getEnv("RUNTIME") != null ? Sys.getEnv("RUNTIME") : "runtime info missing (set RUNTIME env var)";
        v.runtime_desc =  Sys.getEnv("RUNTIME_DESC") != null ? Sys.getEnv("RUNTIME_DESC") : "runtime info missing (set RUNTIME_DESC env var)";
    }
    
    static function writeToFile(path:String,content:String){
        #if sys
            sys.io.File.saveContent(path,content);
        #elseif js
            Fs.writeFileSync(path,content);
            //sys.io.File.saveContent(path,content);
        #else
            #error "which target might this be"
        #end
    }
    
    var reportname:String;
    var suites:Array<SuiteReportObject> = [];
    var groups:Array<SuiteReportGroup> = [];
    
    function new(name:String){
        reportname = name;
    }
    
    function addSuiteReportGroup(name:String,desc:String,suites:Array<SuiteReportIn>){
        var suites = [for (s in suites) suite_report(s.name,s.desc,s.result,s.info)];
        groups.push({
            name : name,
            desc : desc,
            suites : suites
        });
    }
    
    function addSuiteReport(r:SuiteReportIn){
        suites.push(suite_report(r.name,r.desc,r.result,r.info != null ? r.info : new Map()));
    }
    
    function report(name:String,desc:String){
        var r = {
            name : name,
            desc : desc,
            target : cast "",
            target_desc : "",
            runtime : "",
            runtime_desc : "",
            suites : suites,
            groups : groups
        }
        add_report_info(r);
        return r;
    }
    
    static function suite_report(name:String,desc:String,r:SuiteReport,info:Map<String,BenchmarkInfo>):SuiteReportObject {
        var results = [];
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
            var res = {
                name : name,
                desc : if (info.exists(k)) info.get(k).desc else "",
                tags : if (info.exists(k)) info.get(k).tags else [],
                ops  : ops,
                ops_low : ops_low,
                ops_high : ops_high,
                ops_err : ops_err,
                margin_of_error : merr,
                size : size,
                ms : ms
            };
            //var res = '{ "name": "$name",  "data" : { "ops":$ops, "ops_err":$ops_err, "ops_low":$ops_low, "ops_high":$ops_high, "merr":$merr, "size":$size, "ms":$ms }}';
            results.push(res);
        }
        
        return {
            name:name,
            desc:desc,
            results:results,
            report_table : r.toString()
        };
    }
    
}