/**
  new ArrLoader(arr:Array,allLoad:Function,oneLoaded:Function=null) 
  clear();
 */
package 
{
	import flash.events.Event;
	import flash.display.LoaderInfo;
	import flash.display.Bitmap;

	public class ArrLoader 
	{
		public var bmpArr:Array;

		private var arr:Array;
		private var numload:uint = 0;
		private var allLoadFun:Function;
		private var oneLoadFun:Function;
		public function ArrLoader(arr:Array,allLoad:Function,oneLoaded:Function=null) 
		{
			clear();
			allLoadFun = allLoad;
			oneLoadFun = oneLoaded;
			if (arr && arr.length > 0){
				this.arr = arr;
				loads(0);
			}else {
				if(allLoad != null)allLoadFun(null);
			}
		}
		public function clear():void
		{
			for each(var bmp:Bitmap in bmpArr)
			{
				if(bmp){
					if(bmp.parent)bmp.parent.removeChild(bmp);
					bmp.bitmapData.dispose();
				}
				bmp = null;
			}
			if(bmpArr)bmpArr.splice(0,bmpArr.length);
		}

		private function loads(number:int):void 
		{
			numload = number;
			var url:String = String(arr[number]);
			/*logs.adds("==============",url);*/
			if (SwfLoader.matchImgs(url)) {
				if (bmpArr== null) bmpArr= new Array();
				SwfLoader.SwfLoad(url,loaded);
			}else {
				loaded(null);
			}
		}

		private function loaded(e:Event):void 
		{
			if (e && e.type == Event.COMPLETE) {
				bmpArr.push(LoaderInfo(e.target).content);
			}else {
				bmpArr.push(null);
				/*logs.adds("arrloader",e);*/
			}
			if(oneLoadFun != null)oneLoadFun(e);
			++numload;
			if (numload < arr.length) {
				loads(numload);
			}else {
				allLoadFun(e);
			}
		}
	}
}

