/*
Copyright 2017 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.extensions.dataGrid.themes
{
    import feathers.themes.MetalWorksDesktopTheme;
	import feathers.controls.ToggleButton;
	import feathers.extensions.dataGrid.DataGridToggleButton;
 
    public class DataGridMetalWorksDesktopTheme extends MetalWorksDesktopTheme
    {
        public function DataGridMetalWorksDesktopTheme()
        {
			super();
        }
		
		/**
		 * @private 
		 */
		override protected function initializeStyleProviders():void
		{
			super.initializeStyleProviders();
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName("toggleButton-arrow", this.setToggleButtonArrowtyles);
		}
		
		/**
		 * @private 
		 */
		protected function setToggleButtonArrowtyles(toggleButton:ToggleButton):void
		{
			this.setTabStyles(toggleButton);
			(toggleButton as DataGridToggleButton).toggleArrowBottom = this.atlas.getTexture("callout-arrow-bottom-skin0000"); 
			(toggleButton as DataGridToggleButton).toggleArrowUp = this.atlas.getTexture("callout-arrow-top-skin0000");
		}
    }
}