package
{
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapTexture;
	//import data.Config;
	//import shine.ui.Button;
	//import ui.events.WindowEvent;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.net.URLRequest;

	[SWF(width='2048',height='1536',frameRate='60')]

		public class S360 extends Sprite
		{
			private var _startX:Number;
			private var _startY:Number;
			private var _mouseX:Number;
			private var _mouseY:Number;
			private var _view:View3D;
			private var _hover:HoverController;
			private var _mesh:Mesh;
			private var _sphere:SphereGeometry;
			private var _material:TextureMaterial;
			private var _bitmap:BitmapTexture;
			private var _delta:int;
			//按钮
			//private var _btnBack:Button;
			public var backIndex:int; //返回界面Id
			public var closeType:String;

			private var url:String;

			public function S360(_url:String = null)
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
				url = _url;
			}

			private function init(e:Event):void
			{
				//removeEventListener(Event.ADDED_TO_STAGE, init);

				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderEnd);
				if (url)
				{
					trace(url);
					loader.load(new URLRequest(url));
				}
			}

			private function loaderEnd(e:Event):void
			{
				_view = new View3D();
				addChild(_view);
				_view.camera.lens.far = 2000; // 设置照相机的渲染上限（不能低于球半径） 
				var _panoMp:Bitmap = e.target.content as Bitmap;
				_panoMp.smoothing = true;
				_bitmap = new BitmapTexture(_panoMp.bitmapData);

				_sphere = new SphereGeometry(1000, 62, 62);
				_material = new TextureMaterial(_bitmap);
				_material.bothSides = true;
				_mesh = new Mesh(_sphere, _material);
				_hover = new HoverController(_view.camera, null, 90, 0, 300);
				_view.scene.addChild(_mesh);
				if (stage)
				{
					stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownFunction);
					stage.addEventListener(MouseEvent.MOUSE_UP, onUpHandler);
					stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheelHandler);
				}
				addEventListener(Event.ENTER_FRAME, onLoopHandler);

				/*
				   [Embed(source = "../../lib/content/back.png")]
				   var bkc:Class;
				   _btnBack = Button.CreateButtonStyle1(new bkc);
				   _btnBack.scaleX = _btnBack.scaleY = 2;
				   _btnBack.x = stage.stageWidth - _btnBack.width - 20;
				   _btnBack.y = stage.stageHeight - _btnBack.height - 20;
				   stage.addChild(_btnBack);

				   _btnBack.addEventListener(MouseEvent.CLICK, clickHandler);
				 */
			}

			private function clickHandler(e:MouseEvent):void
			{
				_view.dispose();
				_view = null;
				if (stage)
				{
					stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownFunction);
					stage.removeEventListener(MouseEvent.MOUSE_UP, onUpHandler);
					stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheelHandler);
				}
				removeEventListener(Event.ENTER_FRAME, onLoopHandler);
				//removeEventListener(Event.ENTER_FRAME, onLoopHandler);  
				//removeChildren();

				/*
				   if (_btnBack.parent) _btnBack.parent.removeChild(_btnBack);
				   backIndex = Config.prevModule;
				   var window2Event:WindowEvent = new WindowEvent(WindowEvent.BackPrevEvent);
				   window2Event.currentObj = this;
				   stage.dispatchEvent(window2Event);
				 */
			}

			protected function onWheelHandler(event:MouseEvent):void
			{
				_delta += event.delta;
				_hover.distance = _delta;
				//trace(del);  
			}

			protected function onUpHandler(event:MouseEvent):void
			{
				if(stage)
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveFunction);
			}

			private function mouseDownFunction(event:MouseEvent):void
			{
				_startX = _hover.panAngle;
				_startY = _hover.tiltAngle;
				_mouseX = mouseX;
				_mouseY = mouseY;
				if (stage)
				{
					stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveFunction);
					//stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpFunction);  
				}
			}

			private function mouseMoveFunction(event:MouseEvent):void
			{
				_view.camera.x = _delta;
				_hover.panAngle = (mouseX - _mouseX) * .3 + _startX;
				_hover.tiltAngle = (mouseY - _mouseY) * .3 + _startY;
			}

			protected function onLoopHandler(event:Event):void
			{
				_view.render();
			}
		}
}
