/**
 * @file PhotoLoader.as
 *  
 照片下载
 *  
 addChild(new PhotoLoader(url,ww,hh,defaultbmp,txt_str));

 * @author db0@qq.com
 * @version 1.0.1
 * @date 2014-07-04
 */
package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.text.TextField;
	/*import flash.text.TextFormat;*/

	public class PhotoLoader extends BaseSprite 
	{
		public var obj:Object;//照片对应的人物对象
		private var ww:int;//区域宽
		private var hh:int;//区域高
		private var defaultbmp:Bitmap;//默认的填充图像
		private var str:String;//照片底下的文本
		public function PhotoLoader(url:String,_width:int=30,_height:int=30,_defaultbmp:Bitmap=null,_txt:String=""){
			mouseChildren = false;
			ww = _width;
			hh = _height;
			str = _txt;
			defaultbmp = _defaultbmp;
			if(ww <=2 || hh <=0)return;
			ViewSet.removes(this);
			addChild(new Bitmap(new BitmapData(ww,hh))).alpha=0;//照片的显示区域,下载前占位
			if(str && str.length >0){
				var txt:TextField = new TextField;
				txt.autoSize = "left";
				/*var txtformat:TextFormat  = new TextFormat();*/
				/*txt.defaultTextFormat = txtformat;*/
				addChild(txt);
				txt.text = str;
				txt.x = ww/2 - txt.width/2;
				txt.y = hh;
			}
			if(String(url).match(/http:/) && !Boolean(String(url).match(/null$/im))){
				if(String(url).length>12){
					SwfLoader.SwfLoad(url,loaded);
					return;
				}
			}else if(String(url).length>4 && String(url)!="null"){
				SwfLoader.SwfLoad(url,loaded);
				return;
			}
			loaded();
			addEventListener(Event.REMOVED,clears);
		}
		private function clears(e:Event):void
		{
			/*ViewSet.removes(this);*/
		}
		private function loaded(e:Event=null):void
		{
			visible = true;
			var target:Bitmap;
			if(e && e.type == Event.COMPLETE)
			{
				target = e.target.content as Bitmap;
				ViewSet.fullCenter(target,0,0,ww,hh);
				addChild(target);
			}else if(defaultbmp){
				target = new Bitmap(defaultbmp.bitmapData);
				ViewSet.fullCenter(target,0,0,ww,hh);
				addChild(target);
			}else{
				visible = false;
			}
		}
	}
}

