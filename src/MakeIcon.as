package
{
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.events.Event;
	public class MakeIcon
	{
		private const dir:String = "iconf/";
		public function MakeIcon(url:String = "end/Default.jpg")
		{
			SwfLoader.SwfLoad(url,loaded);
		}

		private var bmp:Bitmap;
		private function loaded(e:Event):void
		{
			bmp = e.target.content as Bitmap;
			if(bmp == null){
				trace("no pic");
				return;
			}else{
				trace("pic loaded");
			}
			bmp.smoothing = true;

			make_ios_default();

			logs.adds("loaded");
			/**
			  <image732x412></image732x412>
			 */
			make_icon(128);
			make_icon(16);
			make_icon(29);
			make_icon(50);
			make_icon(58);
			make_icon(76);
			make_icon(80);
			make_icon(96);
			make_icon(100);
			make_icon(120);

			make_icon(144);
			make_icon(152);
			make_icon(512);
			make_icon(1024);
			make_icon(32);
			make_icon(36);
			make_icon(48);
			make_icon(57);
			make_icon(72);
			make_icon(114);
			return;
		}

		private function make_icon(i:int):void
		{
			var bmp2:BitmapData = new BitmapData(i,i,true,0x00ffffff);
			var matrix:Matrix = new Matrix();
			matrix.scale(i/bmp.width, i/bmp.height);
			bmp2.draw(bmp,matrix);
			write_bytes(dir+i+".png",PNGEncoder.encode(bmp2));
			logs.adds(i,"ok");
		}

		private function make_ios_default():void
		{
			make_pic(320,480,"Default.png");
			make_pic(640,960,"Default@2x.png");
			make_pic(640,1136,"Default-568h@2x.png");
			make_pic(768,1024,"Default-Portrait.png");
		}
		/**
		  Default-568h@2x.png 640*1136
		  Default-Portrait.png 768*1024
		  Default.png 320*480
		  Default@2x.png 640*960
		 */
		private function make_pic(w:int,h:int,_name:String=null):void
		{
			var bmp2:BitmapData = new BitmapData(w,h,true,0x00ffffff);
			var matrix:Matrix = new Matrix();
			matrix.scale(w/bmp.width, h/bmp.height);
			bmp2.draw(bmp,matrix);
			if(_name==null)_name=dir+w+"x"+h+".png";
			write_bytes(_name,PNGEncoder.encode(bmp2));
			logs.adds(w,h,"ok");
		}
		public static function write_bytes(filename:String,data:ByteArray):void
		{
			/*var target:File = File.applicationStorageDirectory.resolvePath(filename);*/
			var target:File = File.desktopDirectory.resolvePath(filename);
			/*if(target.exists)return;*/
			var targetParent:File = target.parent;
			if(targetParent.exists){
				logs.adds("exists:",targetParent.nativePath);
			}else{
				logs.adds("not exists:",targetParent.nativePath);
				targetParent.createDirectory();
			}
			logs.adds(target.nativePath);
			var fileStream:FileStream = new FileStream();
			fileStream.open(target,FileMode.WRITE);
			data.position = 0;
			fileStream.writeBytes(data);
			fileStream.truncate();
			fileStream.close();
			/*source.moveTo(target, true);*/
		}
	}

}
