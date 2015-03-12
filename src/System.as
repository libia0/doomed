/*
 */
package
{
	import flash.system.Capabilities;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.filesystem.File;

	public class System
	{


		public function System()
		{

		}
/**
		public static function callane(s:String):String
		{
			if(NativeApi.mains == null)new NativeApi();
			return (NativeApi.mains.call_system(s));
		}
**/
		private var endfun:Function;
		/*
		public function run(s:String,args:Vector.<String>=null,existfun:Function=null):void
		{
			endfun = existfun;
			var file:File = new File(File.applicationDirectory.resolvePath(s).nativePath);

			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo(); //AIR2.0的新类, 创建进程信息对象
			nativeProcessStartupInfo.executable = file; // 将file指定为可执行文件

			var process:NativeProcess = new NativeProcess(); // 创建一个本地进程


			if (args && args.length > 0)
				nativeProcessStartupInfo.arguments = args;
			trace(s,args);
			process.start(nativeProcessStartupInfo); // 运行本地进程
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
			process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData);
			process.addEventListener(NativeProcessExitEvent.EXIT, onExit);
			process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
			process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
		}
*/
		public static function get isWindowns():Boolean {
			return Boolean(Capabilities.serverString.match(/windows/i));
		}
		public static function get isAndroid():Boolean {
			return Boolean(Capabilities.serverString.match(/arm/i));
		}
		public static function get isLinux():Boolean {
			return Boolean(Capabilities.serverString.match(/linux/i));
		}
		public static function get isMac():Boolean {
			return Boolean(Capabilities.serverString.match(/mac/i));
		}
		public static function get isIphone():Boolean {
			return Boolean(Capabilities.serverString.match(/iphone/i));
		}
		private static function onOutputData(e:ProgressEvent):void
		{
			var process:NativeProcess = e.target as NativeProcess;
			if(isWindowns){
				trace(">", process.standardOutput.readMultiByte(process.standardOutput.bytesAvailable,"utf-8"));
			}else{
				trace(">", process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable));
			}
		}

		private static function onErrorData(e:ProgressEvent):void
		{
			var process:NativeProcess = e.target as NativeProcess;
			if(isWindowns){
				trace(">: ", process.standardError.readMultiByte(process.standardError.bytesAvailable,"GB2312"));
			}else{
				trace(">:", process.standardError.readUTFBytes(process.standardError.bytesAvailable));
			}
		}

		private function onExit(e:NativeProcessExitEvent):void
		{
			if(e.exitCode == 0){
				trace(">exit success");
			}else{
				trace(">#$$$$$$$$$$$$$Error: ", e.exitCode);
			}
			var process:NativeProcess = e.target as NativeProcess;
			if (process.running) process.exit(true);

			if(endfun==null){}else{
				endfun();
			}
		}

		private static function onIOError(event:IOErrorEvent):void
		{
			trace("IO错误:",event.toString());
		}	
	}
}
