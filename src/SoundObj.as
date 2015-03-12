package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	public class SoundObj extends Sprite
	{
		/**
		 * sound.loadCompressedDataFromByteArray + sound.extract 
		 */
		public var url:String;
		private var sound:Sound;
		private var soundChannel:SoundChannel;
		private var vol:Number = 1.0;
		private var loop:Boolean=false;

		function SoundObj()
		{

		}

		public function play(url:String = null, loop:Boolean = true):void
		{
			this.loop = loop;
			if (url)
				this.url = url;
			stop();
			sound = new Sound();
			sound.addEventListener(Event.COMPLETE, toEvent);
			sound.addEventListener(Event.ID3, toEvent);
			sound.addEventListener(ProgressEvent.PROGRESS, toEvent);
			sound.addEventListener(IOErrorEvent.IO_ERROR, toEvent);
			sound.addEventListener(Event.OPEN, toEvent); //开始加载
			var context:SoundLoaderContext = new SoundLoaderContext(10000, false); //10秒缓冲

			if (this.url)
			{
				sound.load(new URLRequest(this.url), context);
				playAt(0 * 1000);
			}

		}

		/**
		 * 抛出的事件
		 * @param	e
		 */
		private function toEvent(e:Event):void
		{
			switch (e.type)
			{
				case Event.SOUND_COMPLETE: 
					stop();
					if (loop)
						play(null, loop);
					else{
						try{
							if(sound)sound.close();
						}catch(error:Error){trace(error);}
						sound = null;
						/*dispatchEvent(new Event(Event.COMPLETE));*/
					}
					trace(e.type, "播放完成");
					break;
				case Event.COMPLETE: 
					trace(e.type, "下载完成");
					break;
				case Event.ID3: 
					trace(sound.id3.songName); 
					trace(sound.id3.artist); 
					trace(sound.id3.album); 
					trace(sound.id3.year); 
					trace(sound.id3.time); 
					break;
				case ProgressEvent.PROGRESS: 
					/*trace(totleTime);*/
					break;

				default: 
					trace(e);
					/*logs.adds(e);*/
			}
			//trace(e.type,totleTime);
			dispatchEvent(e);
		}

		/**
		 * 停止
		 */
		public function stop():void
		{
			if (sound)
			{
				try
				{
					sound.close();
				}
				catch (e:Error)
				{
					trace(e);
				}
				sound = null;
			}
			if (soundChannel)
			{
				soundChannel.stop();
				soundChannel = null;
			}
		}

		/**
		 * 播放与暂停
		 */
		public function set pause(b:Boolean):void
		{
			if (b)
			{
				trace(curTime); //不能注释，否则不能从暂停点开始
				if(sound)
					if (soundChannel)
						soundChannel.stop();
			}
			else
			{
				if(sound) playAt(curTime);
				else play(null,loop);
				//trace();
			}
		}

		/**
		 * 从num毫秒开始播放
		 * @param	num
		 */
		public function playAt(num:Number):Number
		{
			if (sound)
			{
				if(soundChannel)soundChannel.stop();
				soundChannel = sound.play(num);
				volume = vol;
				soundChannel.addEventListener(Event.SOUND_COMPLETE, toEvent); //播放完成
				return curTime;
			}
			else
			{
				play(null, loop);
				return 0;
			}

		}

		/**
		 * 调整音量
		 */
		public function set volume(vol:Number):void
		{
			this.vol = vol;
			var soundTransform:SoundTransform = soundChannel.soundTransform;
			soundTransform.volume = vol;
			soundChannel.soundTransform = soundTransform;
		}

		/**
		 * 获取音量
		 */
		public function get volume():Number
		{
			return vol;
		}

		/**
		 * 返回总时长
		 * @return
		 */
		public function get totleTime():Number
		{
			if (sound.bytesLoaded < sound.bytesTotal)
			{
				//下载时计算总时长
				return Math.round(Math.round(sound.length / (sound.bytesLoaded / sound.bytesTotal)));
			}
			else
			{
				return Math.round(sound.length);
			}
		}

		/**
		 * 返回当前播放的时间（毫秒）
		 * @return
		 */
		public function get curTime():Number
		{
			if (soundChannel)
			{
				return soundChannel.position;
			}
			else
				return 0;
		}

	}
}
