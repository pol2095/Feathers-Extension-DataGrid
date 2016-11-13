package feathers.extensions.dataGrid
{
	import starling.textures.Texture;
	import feathers.controls.ToggleButton;
	import feathers.layout.RelativePosition;
	import starling.display.Image;
	
    public class DataGridToggleButton extends ToggleButton
    {
        public var owner:DataGrid;
		public var isArrowDown:Boolean;
		public var isFirst:Boolean = true;
		public var toggleArrowBottom:Texture;
		public var toggleArrowUp:Texture;
		
		public function DataGridToggleButton()
        {
			super();
        }
		
		public function toggle():void
        {
			isArrowDown = !isArrowDown;
			this.defaultIcon = isArrowDown ? new Image( toggleArrowBottom ) : new Image( toggleArrowUp ); 
			if(isFirst)
			{
				isFirst = false;
				if(this.label != "") this.iconPosition = RelativePosition.RIGHT;
			}
        }
    }
}