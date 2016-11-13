package feathers.extensions.dataGrid
{
	import feathers.core.FeathersControl;
	import starling.display.Quad;
	import starling.events.TouchEvent;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	import starling.display.DisplayObjectContainer;
	
	public class DataGridLines extends FeathersControl
	{
		public var lineRight:Quad;
		public var lineLeft:Quad;
		public var lineTop:Quad;
		public var lineBottom:Quad;
		
		private var lineInters:Vector.<Quad>;
		
		public var itemRenderer:Object;
		public var index:int;
		public var isSelected:Boolean;
		
		protected var owner:Object;	
		
		private function get lineSize():Number
		{
			return owner.lineSize;
		}
		
		private function get defaultLineColor():uint
		{
			return owner.defaultLineColor;
		}
		
		private function get selectLineColor():uint
		{
			return owner.selectLineColor;
		}
		
		public function DataGridLines(owner:Object)
		{
			super();
			
			this.owner = owner;
			
			lineRight = new Quad(lineSize, lineSize, defaultLineColor);
			lineRight.name = "border";
			//quad.addEventListener(TouchEvent.TOUCH, onTouchEventMenuBG);
			this.addChild( lineRight );
			
			lineLeft = new Quad(lineSize, lineSize, defaultLineColor);
			lineLeft.name = "border";
			this.addChild( lineLeft );
			
			lineTop = new Quad(lineSize, lineSize, defaultLineColor);
			lineTop.name = "border";
			this.addChild( lineTop );
			
			lineBottom = new Quad(lineSize, lineSize, defaultLineColor);
			lineBottom.name = "border";
			this.addChild( lineBottom );
		}
		
		/*private function onTouchEventMenuBG(event:TouchEvent):void {
			var touch:Touch = event.getTouch(stage);
			if (touch.phase == TouchPhase.BEGAN) {
				var target:Quad = touch.target as Quad;
				if(target.name == "menuBG") menu.visible = false;
			}
		}*/
		public function lines():void
		{
			this.lineLeft.y = this.itemRenderer.y;
			this.lineLeft.height = this.itemRenderer.height;
				
			this.lineRight.y = this.itemRenderer.y;
			this.lineRight.x = this.itemRenderer.width - lineSize;
			this.lineRight.height = this.itemRenderer.height;
				
			this.lineTop.y = this.itemRenderer.y;
			this.lineTop.width = this.itemRenderer.width;
				
			this.lineBottom.y = this.itemRenderer.y + this.itemRenderer.height - lineSize;
			this.lineBottom.width = this.itemRenderer.width;
			for(var i:int = this.numChildren - 1; i >= 0; i--)
			{
				if(this.getChildAt(i).name != "border") this.removeChild( this.getChildAt(i) );
			}
			lineInters = new Vector.<Quad>();
			
			for(i = 0; i < this.itemRenderer.numChildren - 1; i++)
			{
				var _height:Number = (index == owner.numChildren - 2) ? lineSize * 2 : lineSize;
				lineInters.push( new Quad(lineSize, this.itemRenderer.height - _height, defaultLineColor) );
				lineInters[i].x = this.itemRenderer.getChildAt(i).x + this.itemRenderer.getChildAt(i).width;
				lineInters[i].y = this.itemRenderer.y + lineSize;
				this.addChild( lineInters[i] );
			}
			
			if(index == owner.numChildren - 2)
			{
				lineBottom.visible = true;
				this.itemRenderer.layout.paddingBottom = this.itemRenderer.layout.paddingTop;
			}
			else
			{
				lineBottom.visible = false;
				this.itemRenderer.layout.paddingBottom = this.itemRenderer.layout.paddingTop - lineSize;
			}
		}
		public function selectedLines():void
		{
			var color:uint = isSelected ? selectLineColor : defaultLineColor;
			lineLeft.color = lineRight.color = lineTop.color = lineBottom.color = color;
			if(index != owner.dataProvider.length - 1)
			{
				var _nextIndex:DataGridLines = nextIndex;
				color = (isSelected || _nextIndex.isSelected) ? selectLineColor : defaultLineColor;
				_nextIndex.lineTop.color = color;
			}
			if(index != 0)
			{
				var _prevIndex:DataGridLines = prevIndex;
				color = (isSelected || _prevIndex.isSelected) ? selectLineColor : defaultLineColor;
				lineTop.color = color;
			}
		}
		private function get nextIndex():DataGridLines
		{
			return owner._getChildAt( index + 2 ).getChildAt(1) as DataGridLines;
		}
		private function get prevIndex():DataGridLines
		{
			return owner._getChildAt( index ).getChildAt(1) as DataGridLines;
		}
	}
}