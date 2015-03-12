/*
d:\flex_sdk_4.5\bin\amxmlc Videos.as --source-path=. 
d:\flex_sdk_4.5\bin\FlashPlayerDebugger.exe Videos.swf
java -Duser.language=en -Duser.country=US -jar d:/flex_sdk_4.5/lib/mxmlc.jar +flexlib d:/flex_sdk_4.5/frameworks +configname=air Videos.as
 */
package 
{
	import dc.data;
	import flash.system.Capabilities;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	//import flash.filesystem.File;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	/**
	 * 无按键视频播放
	 */
	public class Videos extends Sprite
	{
		/**
		 * bg
		 */
		//private static var bg:Bitmap = new Bitmap(new BitmapData(2,2,false,0));

		private var url:String;
		private static var video:Video;
		private var ns:NetStream;
		private var nc:NetConnection;
		private var client:Object;
		public var isPause:Boolean;

		//---------------视频总时间
		private var countTime:Number;

		private static var soundVolume:Number;

		private function get xx():int{
		   	return 0;
		}
		private function get yy():int{
		   	return 0;
		}
		private function get ww():int {
			return data.stageW;
			return Capabilities.screenResolutionX;
		}
		private function get hh():int{
			return data.stageH;
			return Capabilities.screenResolutionY;
		}

		/**
		 * 设定视频的大小
		 * @param	_x
		 * @param	_y
		 * @param	_width
		 * @param	_height
		 */
		public function setSize(_x:int = 0, _y:int = 0, _width:int = 320, _height:int = 240):void
		{
			//bg.visible = true;
			//bg.width = _width;
			//bg.height = _height;
			//bg.x =  - bg.width/2;
			//bg.y =  - bg.height/2;

			changeSize();

			addEventListener(Event.REMOVED_FROM_STAGE, clears);
			addEventListener(Event.ADDED_TO_STAGE, added);
		}

		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			/*setSize(0,0,stage.stageWidth,stage.stageHeight);*/
			setSize();
		}

		private function clears(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, clears);
			while (numChildren > 0)
			{
				var obj:DisplayObject = getChildAt(numChildren - 1);
				if (contains(obj))
					removeChild(obj);
				obj = null;
			}
		}

		/**
		 * url,宽度，高度，是否自动重播
		 * @param	obj
		 * @param	auto
		 * @param	vol
		 */
		/*public function Videos(obj:Object="http://218.77.91.136/11/d/r/v/e/drveyhuivvhkppqtxddzpxdomrfyej/DC490145052547CF303EB862C766D6A8.flv", vol:Number = 1.0)*/
		public function Videos(obj:Object="data/start.flv", vol:Number = 1.0)
		{
			//addChildAt(bg, 0);
			//bg.visible = true;

			setSize();

			url = String(obj).replace(/[\\\/]+/g, "/");

			//音量
			soundVolume = vol;
			//logs.adds("---------------------------", soundVolume);
			start(vol);

		}

		public function play():void
		{
			//bg.visible = true;
			if (ns)
			{
				if (isPause)
				{
					ns.resume();
					isPause = false;
				}
				else
				{
					ns.seek(1);
				}
			}
			else
			{
				start(soundVolume);
			}

		}

		public function playTo(n:Number):void
		{
			if (ns)
			{
				if (n > 0)
					ns.seek(n);
				//ns.time
			}
		}

		public function forwards():void
		{
			if (ns)
			{
				var i:Number = ns.time;
				i += 5;
				playTo(i);
			}
		}

		public function rewards():void
		{
			if (ns)
			{
				var i:Number = ns.time;
				i -= 5;
				playTo(i);
			}
		}

		/**
		 * 音量
		 */
		public function volume(n:Number):void
		{
			try
			{
				soundVolume = n;
				var ts:SoundTransform = ns.soundTransform;
				ts.volume = n;
				ns.soundTransform = ts;
			}
			catch (e:Error)
			{
				//logs.adds(e);
			}
		}

		public function resume():void
		{
			if (isPause)
			{
				ns.resume();
				isPause = false;
			}
			else
			{
				ns.seek(1);
			}
		}

		public function pause(e:Event=null):void
		{
			if (ns)
			{
				ns.pause();
				isPause = true;
			}
		}

		public function stop():void
		{
			if (video)
			{
				video.clear();
				if (contains(video))
					removeChild(video);
				video = null;
			}
			if (ns)
			{
				ns.close();
				ns = null;
			}
			if (nc)
				nc = null;
			//bg.visible = false;
		}

		/**
		 * --------------------------------------------开始加载视频
		 * @param	vol
		 */
		private function start(vol:Number):void
		{
			//bg.visible = true;
			video = new Video();
			video.smoothing = true;
			addChild(video);
			nc = new NetConnection();
			nc.connect(null);
			ns = new NetStream(nc);
			ns.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
			video.attachNetStream(ns);

			ns.play(url);

			client = new Object();
			client.onMetaData = onMetaData;
			ns.client = client;
			/*stage.addEventListener(MouseEvent.CLICK,pause);*/
			/*addEventListener(Event.ENTER_FRAME,showPost);*/
		}

		private function showPost(e:Event):void
		{
			logs.adds(ns.bytesTotal,ns.bytesLoaded,ns.time);//,metadataEvent.info.duration);
		}

		private function onMetaData(datas:Object):void
		{
			if (video)
			{
				logs.adds("duration:",datas.duration);
				//logs.adds(video.width, video.height, video.videoWidth, video.videoHeight);
			}
			countTime = datas.duration;
			changeSize();

		}

		private function changeSize():void
		{
			if (video){
				/*
				if ((video.videoWidth > ww || video.videoHeight > hh))
				{
					video.width = video.videoWidth;
					video.height = video.videoHeight;

					video.x = -video.width / 2;
					video.y = -video.height / 2;
					var scalex:Number = ww / video.videoWidth;
					var scaley:Number = hh / video.videoHeight;
					scaleX = scaleY = Math.min(scalex, scaley);
					x = xx;
					y = yy;
				}
				else
				*/
				{
					//var wrate:Number = 4/3;
					var wrate:Number = 1.0;
					video.width = video.videoWidth;
					video.height = video.videoHeight;
					video.x = -video.width/2;
					video.y = -video.height/2;
					width = ww*wrate;
					height = hh;
					x = xx+width/2-ww*(wrate-1)/2;
					y = yy+height/2;
				}
			}
		}

		private function onStatus(e:NetStatusEvent):void
		{
			if (video)
			{
				volume(soundVolume);
			}
			switch (e.info.code)
			{
				case "NetStream.Play.Stop": 
					stop();
					dispatchEvent(new Event(Event.COMPLETE));
					break;

				case "NetStream.Buffer.Full": 
					if (video)
					{
						if (video.videoWidth > 0 && video.width != video.videoWidth)
						{
							var stf:SoundTransform = new SoundTransform();
							stf.volume = soundVolume;
							ns.soundTransform = stf;
						}
					}
					break;
			}
			setSize();
		}
	}
}

