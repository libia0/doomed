package
{
	import flash.system.Capabilities;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.filesystem.File;

	public class CallSys
	{

		public function CallSys()
		{

		}

		public static function run(s:String,... args):void
		{
			var file:File = new File(File.applicationDirectory.resolvePath(s).nativePath);
			logs.adds(file.exists);
			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo(); //AIR2.0的新类, 创建进程信息对象
			nativeProcessStartupInfo.executable = file; // 将file指定为可执行文件

			var process:NativeProcess = new NativeProcess(); // 创建一个本地进程

			var processArgs:Vector.<String> = new Vector.<String>();

			for each (var item:* in args)
			{
				processArgs.push(item);
			}
			if (processArgs.length > 0)
				nativeProcessStartupInfo.arguments = processArgs;
			logs.adds(s,args);

			process.start(nativeProcessStartupInfo); // 运行本地进程
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
			process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData);
			process.addEventListener(NativeProcessExitEvent.EXIT, onExit);
			process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
			process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
		}

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
				/*logs.adds(">", process.standardOutput.readMultiByte(process.standardOutput.bytesAvailable,"GB2312"));*/
				logs.adds(">", process.standardOutput.readMultiByte(process.standardOutput.bytesAvailable,"utf-8"));
			}else{
				logs.adds(">", process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable));
			}
				/*logs.adds(">", process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable));*/
		}

		private static function onErrorData(e:ProgressEvent):void
		{
			var process:NativeProcess = e.target as NativeProcess;
			if(isWindowns){
				logs.adds(">: ", process.standardError.readMultiByte(process.standardError.bytesAvailable,"GB2312"));
			}else{
				logs.adds(">:", process.standardError.readUTFBytes(process.standardError.bytesAvailable));
			}
		}

		private static function onExit(e:NativeProcessExitEvent):void
		{
			if(e.exitCode == 0){
				logs.adds(">exit success");
			}else{
				logs.adds(">#Error: ", e.exitCode);
			}
			var process:NativeProcess = e.target as NativeProcess;
			if (process.running) process.exit(true);
		}

		private static function onIOError(event:IOErrorEvent):void
		{
			logs.adds("IO错误:",event.toString());
		}	
	}
}
