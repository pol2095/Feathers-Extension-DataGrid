/*
Copyright 2016 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.extensions.dataGrid.events {
	import starling.events.Event;
	
	/**
	 * A event dispatched when a datagrid row changes
	 *
	 * @see http://pol2095.free.fr/Feathers-Extension-DataGrid/ How to use DataGrid with mxml
	 * @see feathers.extensions.dataGrid.DataGrid
	 */
	public class RowChangeEvent extends Event {
		
		/**
		 * Dispatched when a datagrid row changes.
		 */
		public static var CHANGE:String = "change";
		
		private var _index:int;

		public function RowChangeEvent(type:String, index:int, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_index = index;
		}
		
		/**
		 * The datagrid row that has changed.
		 */
		public function get index():int { return _index; }
	}
}