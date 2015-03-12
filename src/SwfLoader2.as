package
{
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filesystem.File;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.net.FileReference;

	/**
	 * 素材加载器
	 * ...
	 * @author db0@qq.com
	 */

	public class SwfLoader
	{
		public static var rootPath:String;
		private var loadedFunction:Function;

		/**
		 *
		 * @param	url
		 * @param	loaded
		 */
		public function SwfLoader(url:String = null, loaded:Function = null):void
		{
			loadedFunction = loaded;
			if (url)
				loadDatas(url, loadcomplete, URLLoaderDataFormat.BINARY);
		}

		private function loadcomplete(e:Event):void
		{
			if (e && e.type == Event.COMPLETE)
			{
				loadBytes(URLLoader(e.target).data, loadedFunction);
			}
			else
			{
				/*logs.adds("load error", e);*/
			}
		}

		public static function loadBytes(bytes:ByteArray, loaded:Function):Loader
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaded);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaded);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			context.allowCodeImport = true;
			loader.loadBytes(bytes, context);
			return loader;
		}

		public static function SwfLoad(url:String, loaded:Function):Loader
		{
			/*url = getAbspath(url);*/
			/*logs.adds("file", url);*/
			var file:File = new File(toAbsPath(url));
			var filestream:FileStream = new FileStream();
			filestream.open(file, FileMode.READ);
			var bytes:ByteArray = new ByteArray();
			filestream.readBytes(bytes);
			filestream.close();
			bytes.position = 0;
			return loadBytes(bytes, loaded);

			/*
			   var loader:Loader = new Loader();
			   loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaded);
			   loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaded);
			   loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);

			   var context:LoaderContext = new LoaderContext(false);
			   context.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain) ;
			   context.allowCodeImport = true;
			   logs.adds("SwfLoader url",url);
			   loader.load(new URLRequest(String(url)),context);
			   return loader;*/
		}

		public static function loadDatas(url:String, loaded:Function, type:String = null):URLLoader
		{
			/*url = getAbspath(url);*/
			//if(url.match(/home/))// 
			/*url = (new File(url)).getRelativePath(File.applicationDirectory);*/ /*url = File.applicationDirectory.getRelativePath(new File(url));*/
			/*logs.adds("file", url);*/
			/*
			 */
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(String(url));

			if (type)
				loader.dataFormat = type;
			loader.addEventListener(IOErrorEvent.IO_ERROR, loaded);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaded);
			loader.addEventListener(Event.COMPLETE, loaded);
			loader.load(request);
			return loader;
		}

		public static function getRelativePath(file:File):String
		{
			var rootFile:File;
			if(rootPath){
				rootFile = new File(rootPath);
			}else{
				rootFile = File.applicationDirectory;
			}
			return rootFile.getRelativePath(file,true);
			/*return (File.applicationDirectory).getRelativePath(file);*/
		}

		public static function getAbspath(file:File):String
		{
			if(rootPath){
				return rootPath +"/" + getRelativePath(file);
			}
			return File.applicationDirectory.nativePath +"/" + getRelativePath(file);

			/*return (File.applicationDirectory).getRelativePath(file);*/
			/*if (path.match(/^\//) == null || path.match(/^[a-z]:/i) == null) return (File.applicationDirectory).getRelativePath(File.applicationDirectory.resolvePath(path));*/
			/*return File.applicationDirectory.resolvePath(path).nativePath;*/
			return path;
		}

		public static function toAbsPath(url:String):String
		{
			if (url.match(/^\//) == null || url.match(/^[a-z]:/i) == null)
			{
				if(rootPath){
					return rootPath+"/"+url;
				}else{
					/*return File.applicationDirectory.nativePath + "/" + url;*/
					return File.applicationDirectory.resolvePath(url).nativePath;
					/*_url = url;*/
				}
			}
			return url;
		}
		public static function readfile(url:String):String
		{
			/*if (url.match(/^\//) == null || url.match(/^[a-z]:/i) == null)*/
			/*url = File.applicationDirectory.resolvePath(url).nativePath;*/
			/*logs.adds("file", url);*/
			/*if(url.match(/home/)==null)url = File.applicationDirectory.resolvePath(url).nativePath;*/
			var _url:String = toAbsPath(url) ;
			var file:File = new File(_url);
			var filestream:FileStream = new FileStream();
			filestream.open(file, FileMode.READ);
			var bytes:ByteArray = new ByteArray();
			filestream.readBytes(bytes);
			filestream.close();
			/*file.close();*/

			bytes.position = 0;
			var str:String = bytes.readMultiByte(bytes.length, "utf-8");
			/*logs.adds(str);*/
			return str;
		}

		public static function filesInDir(dir:String, type:String):Array
		{
			var filelist:Array = (new File(toAbsPath(dir))).getDirectoryListing().sort(sortFun);
			logs.adds(toAbsPath(dir));
			var reg:RegExp = new RegExp(type, "i");
			var arr:Array;
			for each (var file:File in filelist)
			{
				if (file.name.match(reg))
				{
					if (arr == null) arr = new Array();
					arr.push(getRelativePath(file));
				}
			}
			return arr;
		}

		public static function dirsInDir(dir:String, type:String):Array
		{
			var filelist:Array = (new File(toAbsPath(dir))).getDirectoryListing().sort(sortFun);

			var reg:RegExp = new RegExp(type, "i");
			var arr:Array;
			for each (var file:File in filelist)
			{
				if (file.isDirectory && file.name.match(reg))
				{
					if (arr == null) arr = new Array();
					logs.adds(getRelativePath(file));
					arr.push(getRelativePath(file));
				}
			}
			return arr;
		}

		public static const imgReg:String = "(jpg$)|(png$)|(jpeg$)|(gif$)";
		public static const mp3Reg:String = "mp3$";
		public static const swfReg:String = "swf$";
		public static const txtReg:String = "txt$";

		public static function matchImgs(url:String):Boolean
		{
			if (url)
				return Boolean(url.match(new RegExp(imgReg, "i")));
			return false;
		}

		public static function matchTxts(url:String):Boolean
		{
			if (url)
				return Boolean(url.match(new RegExp(txtReg, "i")));
			return false;
		}

		public static function matchmp3(url:String):Boolean
		{
			if (url)
				return Boolean(url.match(new RegExp(mp3Reg, "i")));
			return false;
		}
		public static function matchSwf(url:String):Boolean
		{
			if (url)
				return Boolean(url.match(new RegExp(swfReg, "i")));
			return false;
		}
		public static function sortFun(file1:File,file:File):int{
			var num1:Number =Number(file.name.replace(/^([\d]+)[^\d].*$/i,"$1"));
			var num2:Number =Number(file1.name.replace(/^([\d]+)[^\d].*$/i,"$1"));
			if(file.name.match(/^[\d]+$/))num1 = Number(file.name);
			if(file1.name.match(/^[\d]+$/))num2 = Number(file1.name);
			var num :Number = num2 - num1;

			if(num > 0)return 1;
			if(num < 0)return -1;

			num1 = Number(file.name.replace(/^.*[^\d]([\d]+)[^\d]*$/i,"$1"));
			num2 = Number(file1.name.replace(/^.*[^\d]([\d]+)[^\d]*$/i,"$1"));
			num = num2 - num1;

			if(num > 0)return 1;
			if(num < 0)return -1;
			return 0;
		}

		/*
	public static function sortFun(file1:File,file:File):int{

			var num1:Number = Number(file.name.replace(/^([\d]+)[^\d].*$/i,"$1"));
			var num2:Number = Number(file1.name.replace(/^([\d]+)[^\d].*$/i,"$1"));

			if(file.name.match(/^[\d]*$/))num1 = Number(file.name);
			if(file2.name.match(/^[\d]*$/))num2 = Number(file1.name);

			var num :Number = num2 - num1;
			if(num > 0)return 1;
			if(num < 0)return -1;

			num1 = Number(file.name.replace(/^.*\(([\d]+)\).*$/i,"$1"));
			num2 = Number(file1.name.replace(/^.*\(([\d]+)\).*$/i,"$1"));
			num = num2 - num1;
			if(num > 0)return 1;
			if(num < 0)return -1;

			num1 = Number(file.name.replace(/^.*[^\d]([\d]+)[^\d]*$/i,"$1"));
			num2 = Number(file1.name.replace(/^.*[^\d]([\d]+)[^\d]*$/i,"$1"));
			num = num2 - num1;
			if(num > 0)return 1;
			if(num < 0)return -1;

			return 0;
		}
	*/
	}
}

