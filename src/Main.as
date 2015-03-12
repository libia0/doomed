package 
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	/**
	 * ...
	 * @author 
	 */
	public class Main extends Sprite 
	{
		private function loaded(e:Event):void
		{
			addChild(new logs());
			if(e && e.type == Event.COMPLETE)
			{
				logs.adds("data:",e.target.data);
			}else{
				logs.adds(e);
			}
		}

		private var textfield:TextField = new TextField;
		private function testweb():void
		{
			textfield.type = "input";
			textfield.border = true;
			textfield.defaultTextFormat = new TextFormat("",30);
			textfield.text = "http://localhost/?f=mean&p1=like";
			textfield.width = stage.stageWidth;
			Security.loadPolicyFile("http://localhost/crossdomain.xml");
			var urlVariables:URLVariables = new URLVariables;
			urlVariables.f = "mean";
			urlVariables.p1 = "likes";
			SwfLoader.loadData("http://localhost/",loaded,null,urlVariables);
			addChild(textfield);
			stage.addEventListener(MouseEvent.CLICK,loadnew);
		}
		private function loadnew(e:Event):void {
			if(mouseX > stage.stageWidth*.9){
				SwfLoader.loadData(textfield.text, loaded);
				logs.adds("========================================");
			}
		}
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// entry point
			testweb();
			
			// new to AIR? please read *carefully* the readme.txt files!
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		
	}
	
}