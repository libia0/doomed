package 
{
	import flash.text.engine.FontDescription;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextRotation;
	import flash.text.engine.TextLine;
	import flash.display.Sprite;
	import flash.text.engine.TextBlock;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.TextElement;
	/*import flash.text.engine.ContentElement;*/
	/*import flash.text.engine.GraphicElement;*/

	public class VertTxt extends Sprite
	{
		private var textBlock:TextBlock =new TextBlock();
		public var text_length:int = 0;
		private var bg:Shape = new Shape();
		public function showbg(b:Boolean = false):void
		{
			if(b) bg.alpha = 1;
			else bg.alpha = 0;
		}
		public function VertTxt(_text:String=null,_height:int = 160,size:int=20,color:uint=0x000000,linegap:int=5)
		{
			if(_text.length <1)return;
			var linePosition:Number = 0;

			var fd:FontDescription = new FontDescription();
			fd.fontName = "SimHei";
			/*fd.fontWeight = flash.text.engine.FontWeight.BOLD;*/
			var format:ElementFormat = new ElementFormat(fd);
			format.fontSize = size;
			format.color = color;
			format.textRotation = TextRotation.AUTO;
			textBlock.lineRotation = TextRotation.ROTATE_90;
			textBlock.baselineZero = TextBaseline.IDEOGRAPHIC_CENTER;
			textBlock.content = new TextElement(_text,format);
			var previousLine:TextLine = null;
			while (true)
			{
				try{
					var textLine:TextLine = textBlock.createTextLine(previousLine, _height);
				}catch(e:Error){trace(e);}

				if (textLine == null){
					break;
				}else{
					var textIndex:int = textLine.textBlockBeginIndex;
					var textlength:int = textLine.rawTextLength;
					text_length = textIndex + textlength;
					textLine.y = 0;
					textLine.x = linePosition;
					linePosition += (linegap+size);
					addChild(textLine);
					previousLine = textLine;
				}
			}
			addEventListener(Event.REMOVED_FROM_STAGE,clears);
		}

		public function clears(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,clears);
			if(textBlock){
				textBlock.releaseLineCreationData();
				textBlock = null;
			}
			/*ViewSet.removes(this);*/
		}
		/*
		   public function graphicTxt():void
		   {
		   var format:ElementFormat = new ElementFormat();
		   format.fontSize = 14;
		   var redBox:Sprite= new Sprite();
		   redBox.graphics.beginFill(0xCC0000, 1.0);
		   redBox.graphics.drawRect(0,0, 20, 20);
		   redBox.graphics.endFill();   
		   var graphicElement:GraphicElement = new GraphicElement(redBox,redBox.width,redBox.height, format);
		   var textBlock:TextBlock = new TextBlock();
		   textBlock.content = graphicElement;
		   var textLine1:TextLine = textBlock.createTextLine(null,redBox.width);
		   addChild(textLine1);
		   textLine1.x = 5;
		   textLine1.y = 55;
		   var str:String = "Your picture here ...";
		   var textElement:TextElement = new TextElement(str, format);
		   textBlock = new TextBlock();
		   textBlock.content = textElement;
		   var textLine2:TextLine = textBlock.createTextLine(null, 300);
		   addChild(textLine2);
		   textLine2.x = textLine1.x + textLine1.width;
		   textLine2.y += textLine1.y;  
		//textLine2.y += textLine1.y + format.fontSize;  
		}
		 */
	}
}

