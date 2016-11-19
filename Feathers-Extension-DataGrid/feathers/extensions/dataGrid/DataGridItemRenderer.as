/*
Copyright 2016 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.extensions.dataGrid
{
	import feathers.controls.LayoutGroup;
	import starling.events.EnterFrameEvent;
	import feathers.layout.HorizontalLayout;
	import starling.display.Quad;
 
    /**
	 * The row of a datagrid control.
	 *
	 * @see http://pol2095.free.fr/Feathers-Extension-DataGrid/ How to use DataGrid with mxml
	 */
	public class DataGridItemRenderer extends LayoutGroup
    {
		/**
		 * @private
		 */
		public var gridLines:DataGridLines;
		/**
		 * The index position in the datagrid.
		 */
        public var index:int;
		/**
		 * Indicates whether the item is selected.
		 */
		public var isSelected:Boolean;
		/**
		 * Indicates whether the datagrid dataProvider item corresponding to this item renderer is being changing.
		 */
		protected var isChanging:Boolean;
		
		private var countEnterFrame:int;
		
		/**
		 * The datagrid dataProvider item corresponding to this item renderer.
		 */
		public function get data():Object
		{
			return owner.dataProvider.getItemAt(index);
		}
		
		private var _owner:DataGrid;
		/**
		 * The datagrid that contains this item renderer.
		 */
		public function get owner():DataGrid
		{
			return _owner;
		}
		public function set owner(value:DataGrid):void
		{
			_owner = value;
			var layout:HorizontalLayout = this.layout as HorizontalLayout;
			layout.gap = layout.paddingLeft = layout.paddingRight = layout.paddingTop = layout.paddingBottom = owner.lineSize;
		}
		
		private var backGround:Quad;
		
		public function DataGridItemRenderer()
        {
			super();
			var layoutGroup:LayoutGroup = new LayoutGroup();
			layoutGroup.includeInLayout = false;
			backGround = new Quad(1, 1);
			backGround.alpha = 0;
			layoutGroup.addChild( backGround );
			this.addChild( layoutGroup );
        }
		
		override protected function draw():void
        {
			super.draw();
			
			backGround.width = this.width;
			backGround.height = this.height;
        }
		
		/**
		 * Dispatched after the datagrid dataProvider item corresponding to this item renderer has changed.
		 *
		 * <listing version="3.0">
		 * override public function dataGridChangeHandler():void
		 * {
		 *   super.dataGridChangeHandler(); //never forget to add this!
		 *   
		 *   yourControl = this.data.key; //your code here
		 * }</listing>
		 */
		public function dataGridChangeHandler():void
        {
			isChanging = true;
			if(countEnterFrame == 0)
			{
				this.addEventListener(EnterFrameEvent.ENTER_FRAME, onDataGridChangeHandler);
				countEnterFrame++;
			}
		}
		/**
		 * Allows to change the item datagrid dataProvider corresponding to this item renderer and dispatch a <code>DataGridEvent</code> on the datagrid corresponding to this item renderer.
		 *
		 * <listing version="3.0">
		 * override protected function rowChangeHandler():void
		 * {
		 *   if(isChanging) return; //never forget to add this!
		 *   
		 *   this.data.key = yourControl; //your code here
		 * 
		 *   super.rowChangeHandler(); //never forget to add this!
		 * }</listing>
		 *
		 * @see feathers.extensions.dataGrid.events.DataGridEvent
		 */
		protected function rowChangeHandler():void
        {
			owner.rowChange(index);
		}
		private function onDataGridChangeHandler(event:EnterFrameEvent):void
        {
			isChanging = false;
			this.removeEventListener(EnterFrameEvent.ENTER_FRAME, onDataGridChangeHandler);
			countEnterFrame--;
		}
		/**
		 * @private
		 */
		public function get _numChildren():int
		{
			return this.numChildren - 1;
		}
		/**
		 * @private
		 */
		public function _getChildAt(index:int):Object
		{
			return this.getChildAt(index + 1);
		}
	}
}