package 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;

	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filesystem.File;
	/**
	 * 素材加载器
	 * ...
	 * @author db0@qq.com
	 */
	public class SwfLoader 
	{
		private var loadedFunction:Function;
		private var curURLLoader:URLLoader;
		private var curLoader:Loader;
		/**
		 * 
		 * @param	url
		 * @param	loaded
		 */
		public function SwfLoader(url:String=null,loaded:Function=null):void
		{
			loadedFunction = loaded;
			if(url){
				curURLLoader = loadData(url,loadcomplete,URLLoaderDataFormat.BINARY);
			}
		}

		public function sandboxLoadSwf(url:String=null,loaded:Function=null):URLLoader
		{
			loadedFunction = loaded;
			if(url){
				return loadData(url,loadcomplete,URLLoaderDataFormat.BINARY);
			}
			return null;
		}

		private function loadcomplete(e:Event):void 
		{
			if (e && e.type == Event.COMPLETE) {
				curLoader = loadBytes(e.target.data,loadedFunction);
			}else {
				logs.adds("load error",e);
			}
		}


		public static function loadBytes(bytes:ByteArray,loaded:Function):Loader
		{
			if(loaded ==null)return null;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaded);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaded);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			context.allowCodeImport = true;
			loader.loadBytes(bytes,context);
			return loader;
		}

		public static function SwfLoad(url:String,loaded:Function):Loader
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaded);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaded);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
			/*
			   var context:LoaderContext = new LoaderContext(false);
			   context.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain) ; 
			   context.allowCodeImport = true;
			   loader.load(new URLRequest(url),context);
			 */
			loader.load(new URLRequest(url));
			logs.adds("url:",url);
			return loader;
		}

		public static function loadData(url:String,loaded:Function,type:String=null,urlVariables:URLVariables=null):URLLoader
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(url);
			logs.adds("url:",url);
			if(urlVariables){
				request.data = urlVariables;
				logs.adds("url:",CodeSet.urldecode(String(urlVariables)));
				/*if(urlVariables) loader.dataFormat = URLLoaderDataFormat.VARIABLES;*/
			}
			if(type)loader.dataFormat = type;

			loader.addEventListener(IOErrorEvent.IO_ERROR, loaded);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaded);
			loader.addEventListener(Event.COMPLETE, loaded);
			loader.load(request);
			return loader;
		}

		public static function closeLoader(loader:Loader):void
		{
			if(loader){
				if(loader.parent)loader.parent.removeChild(loader);
				try{
					loader.close();
				}catch(e:Error){
					logs.adds(e);
				}
				loader.unloadAndStop();
				loader = null;
			}
		}

		public function close():void
		{
			if(curURLLoader){
				try{
					curURLLoader.close();
					curURLLoader = null;
				}catch(e:Error){
					logs.adds(e);
				}
			}
			if(curLoader){
				if(curLoader.parent)curLoader.parent.removeChild(curLoader);
				try{
					curLoader.close();
				}catch(e:Error){
					logs.adds(e);
				}
				try{
					curLoader.unloadAndStop();
				}catch(e:Error){
					logs.adds(e);
				}
				curLoader = null;
			}
		}


		public static function closeURLLoader(loader:URLLoader):void
		{
			if(loader){
				try{
					loader.close();
					loader = null;
				}catch(e:Error){
					logs.adds(e);
				}
			}
		}


		public static const imgReg:String = "(jpg$)|(png$)|(jpeg$)|(gif$)";
		public static const vidReg:String = "\.(flv|f4v|mp4)$";
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
			var num1:Number = Number(file.name.replace(/^([\d]+)[^\d]*.*$/i,"$1"));
			var num2:Number = Number(file1.name.replace(/^([\d]+)[^\d]*.*$/i,"$1"));
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
		   iOS
		   File.applicationStorageDirectory — 每个已安装的 AIR 应用程序独有的存储目录。此目录适用于存储动态应用程序资源和用户首选项。考虑在其他位置存储大量数据。 在 Android 和 iOS 上，当卸载应用程序或用户选择清除应用程序数据时，会删除应用程序存储目录，但这不适用于其他平台。
		   File.applicationDirectory — 安装应用程序的目录（还存储任何安装的资源）。在有些操作系统上，应用程序存储在一个软件包文件中而不是物理目录中。在这种情况下，可能无法使用本机路径访问内容。应用程序目录是只读的。
		   File.desktopDirectory— 用户的桌面目录。如果平台不定义桌面目录，则使用文件系统上的另一个位置。
		   File.documentsDirectory— 用户的文档目录。如果平台不定义文档目录，则使用文件系统上的另一个位置。
		   File.userDirectory — 用户目录。如果平台不定义用户目录，则使用文件系统上的另一个位置。

		   应用程序 /var/mobile/Applications/uid/filename.app 
		   应用程序存储 /var/mobile/Applications/uid/Library/Application Support/applicationID/Local Store 
		   缓存 /var/mobile/Applications/uid/Library/Caches 
		   桌面 不可访问 
		   文档 /var/mobile/Applications/uid/Documents 
		   临时 /private/var/mobile/Applications/uid/tmp/FlashTmpNNN
		   用户 不可访问
		 */
		public static function get rootPath():String
		{
			return "";
			return File.userDirectory.nativePath+"/";
			if(System.isWindowns){
				return File.applicationDirectory.nativePath +"/";
			}else if(System.isAndroid){
				/*return "/sdcard/";*/
				return "";
			}else{//linux userDirectory
				return File.applicationDirectory.nativePath+"/";
			}
			return "/";
		}

		public static function get rootFile():File
		{
			if(rootPath!=null){//
				return getFile(rootPath);
			}
			return File.applicationDirectory;
		}

		public static function getRelativePath(file:File):String
		{
			return rootFile.getRelativePath(file,true);
			/*return (File.applicationDirectory).getRelativePath(file);*/
		}

		public static function getAbspath(file:File):String//获取绝对路径
		{
			if(rootPath!=null){
				return rootPath + getRelativePath(file);
			}
			return File.applicationDirectory.nativePath +"/" + getRelativePath(file);
		}

		public static function toAbsPath(url:String):String//获取绝对路径
		{
			/*if(System.isAndroid)return url;*/
			if(url==null){
				trace("AbsPath: 0");
				return "";
			}
			if (url.match(/^[\\\/].*/) || url.match(/^[a-z]:[\\\/]/i))//是绝对路径
			{
				return url;
			}
			if(rootPath==null){
				var s:String =File.applicationDirectory.resolvePath(url).nativePath; 
				if(s==null || s.length ==0)return url;
				return s;
			}else{
				return rootPath+url;
			}
			return null;
		}
		public static function getFile(url:String):File
		{

			trace("getFile()",url);
			if(System.isAndroid && rootPath.length >0 && !rootPath.match(/^[\\\/]/))
				return File.applicationDirectory.resolvePath(url);
			var _url:String = toAbsPath(url);
			trace("toAbsPath:",_url);
			if (_url.match(/^[\\\/]/) || _url.match(/^[a-z]:[\\\/]/i))//绝对路径
				return new File(_url);
			if(_url.length==0)
				return File.applicationDirectory;
			return File.applicationDirectory.resolvePath(_url);
		}

		public static function readfile(url:String):String
		{
			var file:File = getFile(url);
			if(!file.exists)return null;
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
			logs.adds("dir:",dir);
			var f:File = getFile(dir);
			if(!f.exists)return null;
			var filelist:Array = f.getDirectoryListing().sort(sortFun);
			var reg:RegExp = new RegExp(type, "i");
			var arr:Array;
			for each (var file:File in filelist)
			{
				if (file.name.match(reg))
				{
					if (arr == null) arr = new Array();
					//logs.adds("push RelativePath:",dir+(file.name));
					arr.push((dir+"/"+file.name).replace(/[\\\/]+/g,"/"));
					/*arr.push(getRelativePath(file));*/
				}
			}
			return arr;
		}

		public static function dirsInDir(dir:String, type:String):Array
		{
			logs.adds("dir:",dir);
			var f:File = getFile(dir);
			if(!f.exists)return null;
			var filelist:Array = f.getDirectoryListing().sort(sortFun);

			var reg:RegExp = new RegExp(type, "i");
			var arr:Array;
			for each (var file:File in filelist)
			{
				/*if (file.isDirectory && file.name.match(reg))*/
				if (file.isDirectory)
				{
					if (arr == null) arr = new Array();
					logs.adds("push RelativePath:",dir+file.name);
					/*arr.push(getRelativePath(file));*/
					arr.push((dir+"/"+file.name+"/").replace(/[\\\/]+/g,"/"));
				}
			}
			return arr;
		}
	}
}

