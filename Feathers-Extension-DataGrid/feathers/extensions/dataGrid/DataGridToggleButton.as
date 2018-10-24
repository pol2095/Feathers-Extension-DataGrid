/*
Copyright 2017 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.extensions.dataGrid
{
	import starling.textures.Texture;
	import feathers.controls.ToggleButton;
	import feathers.layout.RelativePosition;
	import feathers.skins.IStyleProvider;
	import starling.display.Image;
	
    public class DataGridToggleButton extends ToggleButton
    {
        /**
		 * The default <code>IStyleProvider</code> for all <code>BorderContainer</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;
		
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
		
		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return DataGridToggleButton.globalStyleProvider;
		}
    }
}