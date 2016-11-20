/*
Copyright 2016 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.extensions.dataGrid
{
	import feathers.controls.ScrollContainer;
	import feathers.data.ListCollection;
	import feathers.events.CollectionEventType;
	import flash.utils.getDefinitionByName;
	import feathers.extensions.dataGrid.events.DataGridEvent;
	import feathers.controls.LayoutGroup;
	import feathers.layout.VerticalLayout;
	import feathers.layout.HorizontalLayout;
	import feathers.controls.ScrollBar;
	import flash.utils.getQualifiedClassName;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	import starling.display.Quad;
	import flash.geom.Point;
	
	/**
	 * Dispatched when a datagrid row changes.
	 */
	[Event(name="change", type="feathers.extensions.dataGrid.events.DataGridEvent")]
	
	/**
	 * The DataGrid displays a row of column headings above a scrollable grid. The grid is arranged as a collection of individual cells arranged in rows and columns. The DataGrid control is designed to support smooth scrolling through large numbers of rows and columns.
	 *
	 * @see http://pol2095.free.fr/Feathers-Extension-DataGrid/ How to use DataGrid with mxml
	 * @see feathers.extensions.tree.DataGridItemRenderer
	 */	
	public class DataGrid extends LayoutGroup
	{
		private var _lineSize:Number = 2;
		/**
		 * the size of the datagrid lines in pixels.
		 *
		 * @default 2
		 */
		public function get lineSize():Number
		{
			return this._lineSize;
		}
		public function set lineSize(value:Number):void
		{
			this._lineSize = value;
		}
		
		private var _defaultLineColor:uint = 0xCCCCCC;
		/**
		 * The default color of lines when a row is not selected.
		 *
		 * @default 0xCCCCCC
		 */
		public function get defaultLineColor():uint
		{
			return this._defaultLineColor;
		}
		public function set defaultLineColor(value:uint):void
		{
			this._defaultLineColor = value;
		}
		
		private var _selectLineColor:uint = 0xFFA500;
		/**
		 * The color of lines when a row is selected.
		 *
		 * @default 0xCCCCCC
		 */
		public function get selectLineColor():uint
		{
			return this._selectLineColor;
		}
		public function set selectLineColor(value:uint):void
		{
			this._selectLineColor = value;
		}
		
		private var _requestedRowCount:int = -1;
		/**
		 * Requests that the layout set the view port dimensions to display a specific number of rows
		 * <p>This property is ignored if datagrid height is set.</p>
		 *
		 * @default -1
		 */
		public function get requestedRowCount():int
		{
			return this._requestedRowCount;
		}
		public function set requestedRowCount(value:int):void
		{
			this._requestedRowCount = value;
		}
		
		private var headerHeight:Number = 0;
		private var itemRendererHeight:Number;
		
		/**
		 * <p>The list of GridColumn objects displayed by this grid. Each column selects different data provider item properties to display.</p>
		 *
		 * <p>In the columns ListCollection three keys can be used :</p>
		 * <p>- "dataField" : a key of a dataProvider item.</p>
		 * <p>- "headerText" : the name of a column.</p>
		 * <p>- "type" : "string" or "numeric", the default value is "string".</p>
		 *
		 * @default null
		 */
		public var columns:ListCollection;
		
		public function DataGrid()
		{
			super();
			
			if(!this.layout) this.layout = new VerticalLayout();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			header.layout = new HorizontalLayout();
			this.addChild(header);
			this.scrollContainer.layout = new VerticalLayout();
			this.addChild(this.scrollContainer);
		}
		
		private function addedToStageHandler(event:Event):void
		{
			this.scrollContainer.addEventListener(TouchEvent.TOUCH, onTouchEvent);
		}
		
		/**
		 * The header of the datagrid.
		 */		
		public var header:LayoutGroup = new LayoutGroup();
		/**
		 * @private 
		 */	
		public var scrollContainer:ScrollContainer = new ScrollContainer();
			
		private function requestedRowCountDefault():void
		{
			if(headerHeight == 0 && this.header.visible)
			{
				var button:DataGridToggleButton = new DataGridToggleButton();
				button.validate();
				headerHeight = button.height;
				button = null;
			}
			if(!this.header.visible) headerHeight = 0;
			
			var itemRenderer:Object = new ItemRenderer();
			itemRenderer.owner = this;
			itemRenderer.validate();
			itemRendererHeight = itemRenderer.height;
			itemRenderer = null;
		}
		
		/**
		 * Scroll to the specified index.
		 *
		 * @param row index of the cell
		 */
		public function scrollToIndex(index:int):void
		{
			if(this.scrollContainer.viewPort.height > this.scrollContainer.height)
			{
				var item:Object = this.getItemAt(index);
				if(item.height > this.scrollContainer.height) //tab width > scroller width
				{
					this.scrollContainer.verticalScrollPosition = item.parent.y; //tab begin
				}
				else if(item.parent.y < this.scrollContainer.verticalScrollPosition) //tab begin < scroller begin
				{
					this.scrollContainer.verticalScrollPosition = item.parent.y; //tab begin
				}
				else if(item.parent.y + item.height > this.scrollContainer.verticalScrollPosition + this.scrollContainer.height) //tab end > scroller end
				{
					this.scrollContainer.verticalScrollPosition = item.parent.y + item.height - this.scrollContainer.height; //tab end - scroller width
				}
			}
		}
		
		/**
		 * @private 
		 */
		public function rowChange(index:int):void
		{
			dispatchEvent(new DataGridEvent( DataGridEvent.CHANGE, index ));
		}
		
		private var ItemRenderer:Class;
		/**
		 * The class used to instantiate item renderers.
		 */
		public function set itemRenderer(value:Object):void
		{
			if( !(value is Class) ) value = getDefinitionByName(value as String);
			ItemRenderer = value as Class;
		}
		
		private var _allowMultipleSelection:Boolean;
		/**
		 * If true multiple items may be selected at a time. If false, then only a single item may be selected at a time, and if the selection changes, other items are deselected. Has no effect if isSelectable is false.
		 *
		 * @default false
		 */
		public function get allowMultipleSelection():Boolean
		{
			return _allowMultipleSelection;
		}
		public function set allowMultipleSelection(value:Boolean):void
		{
			this._allowMultipleSelection = value;
			if(!this.allowMultipleSelection && this._selectedIndices.length >= 2)
			{
				for(var i:int = this._selectedIndices.length - 2; i >= 0; i--) this._selectedIndices.shift();
				this._selectedIndex = this.selectedIndices[0];
				updateIndices();
			}
		}
		
		private var _sortable:Boolean = true;
		/**
		 * Specifies whether the user can interactively sort columns. If true, the user can sort the data provider by the data field of a column by clicking on the column's header. If true, an individual column can set its sortable property to false to prevent the user from sorting by that column.
		 *
		 * @default true
		 */
		public function get sortable():Boolean
		{
			return _sortable;
		}
		public function set sortable(value:Boolean):void
		{
			this._sortable = value;
			if(header.numChildren > 0)
			{
				for(var i:int = 0; i<header.numChildren; i++) (header.getChildAt(i) as DataGridToggleButton).isEnabled = sortable;
			}
		}
		
		private var _isSelectable:Boolean = true;
		/**
		 * Determines if items in the list may be selected.
		 *
		 * @default true
		 */
		public function get isSelectable():Boolean
		{
			return _isSelectable;
		}
		public function set isSelectable(value:Boolean):void
		{
			if(isSelectable)
			{
				removeAllSelectedIndex();
				this._selectedIndex = -1;
				this._selectedIndices = new <int>[];
			}
			this._isSelectable = value;
		}
		
		/**
		 * @private
		 */
		protected var _dataProvider:ListCollection;
		
		/**
		 * The collection of data displayed by the datagrid. Changing this property
		 * to a new value is considered a drastic change to the datagrid's data, so
		 * the horizontal and vertical scroll positions will be reset, and the
		 * datagrid's selection will be cleared.
		 *
		 * <p><em>Warning:</em> A datagrid's data provider cannot contain duplicate
		 * items. To display the same item in multiple item renderers, you must
		 * create separate objects with the same properties. This limitation
		 * exists because it significantly improves performance.</p>
		 *
		 * <p><em>Warning:</em> If the data provider contains display objects,
		 * concrete textures, or anything that needs to be disposed, those
		 * objects will not be automatically disposed when the datagrid is disposed.
		 * Similar to how <code>starling.display.Image</code> cannot
		 * automatically dispose its texture because the texture may be used
		 * by other display objects, a datagrid cannot dispose its data provider
		 * because the data provider may be used by other datagrids. See the
		 * <code>dispose()</code> function on <code>ListCollection</code> to
		 * see how the data provider can be disposed properly.</p>
		 *
		 * @default null
		 *
		 * @see feathers.data.ListCollection#dispose()
		 */
		public function get dataProvider():ListCollection
		{
			return this._dataProvider;
		}
		
		public function set dataProvider(value:ListCollection):void
		{
			if(this._dataProvider == value)
			{
				return;
			}
			if(this._dataProvider)
			{
				this._dataProvider.removeEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
				this._dataProvider.removeEventListener(Event.CHANGE, dataProvider_changeHandler);
			}
			this._dataProvider = value;
			if(this._dataProvider)
			{
				this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
				this._dataProvider.addEventListener(Event.CHANGE, dataProvider_changeHandler);
			}

			//reset the scroll position because this is a drastic change and
			//the data is probably completely different
			this.scrollContainer.horizontalScrollPosition = 0;
			this.scrollContainer.verticalScrollPosition = 0;

			//clear the selection for the same reason
			this._selectedIndex = -1;
			this._selectedIndices = new <int>[];

			this.scrollContainer.removeChildren();
			for(var i:int = 0; i<this._dataProvider.length; i++) addItem(i);
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}
		
		private var _selectedIndex:int = -1;
		/**
		 * The index of the currently selected item.
		 *
		 * @default -1
		 */ 
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		public function set selectedIndex(value:int):void
		{
			_selectedIndex = value;
			removeAllSelectedIndex();
			if(_selectedIndex == -1) return;
			selectIndex(selectedIndex);
		}
		
		private var _selectedIndices:Vector.<int> = new <int>[];
		/**
		 * The indices of the currently selected items. Returns an empty Vector.&lt;int&gt; if no items are selected. If allowMultipleSelection is false, only one item may be selected at a time.
		 */
		public function get selectedIndices():Vector.<int>
		{
			return _selectedIndices;
		}
		public function set selectedIndices(value:Vector.<int>):void
		{
			_selectedIndices = value;
			if(selectedIndices.length == 0)
			{
				selectedIndex = -1;
			}
			else
			{
				updateIndices();
				_selectedIndex = selectedIndices[ selectedIndices.length - 1];
			}
		}
		private function updateIndices():void
		{
			removeAllSelectedIndex();
			for(var i:int = 0; i<selectedIndices.length; i++) selectIndex( selectedIndices[i] );
		}
		
		/**
		 * @private
		 */
		public function dataProvider_changeHandler(event:Event):void
		{
			//
		}

		/**
		 * @private
		 */
		public function dataProvider_resetHandler(event:Event):void
		{
			this.scrollContainer.removeChildren();
			this.header.removeChildren();
			this.numColons = 0;
			this._selectedIndex = -1;
			this._selectedIndices = new <int>[]; 
		}
		
		private var numColons:int;
		/**
		 * @private
		 */
		public function dataProvider_addItemHandler(event:Event, index:int):void
		{
			addItem(index);
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}
		private function addItem(index:int):void
		{
			var createHeader:Boolean;
			if(index == 0 && numColons == 0)
			{
				var item:Object = this.dataProvider.getItemAt(index);
				for (var key:String in item)
				{
					numColons++;
					if(this.header.visible)
					{
						var button:DataGridToggleButton = new DataGridToggleButton();
						button.isEnabled = sortable;
						button.isToggle = false;
						button.styleNameList.add("toggleButton-arrow");
						button.addEventListener( Event.TRIGGERED, toggleButton_triggeredHandler );
						header.addChild(button);
					}
				}
				if(numColons != 0) createHeader = true;
			}
			
			var layoutGroup:LayoutGroup = new LayoutGroup();
			var itemRenderer:Object = new ItemRenderer();
			itemRenderer.owner = this;
			layoutGroup.addChild( itemRenderer as DisplayObjectContainer );
			
			var dataGridLines:DataGridLines = new DataGridLines(this);
			dataGridLines.itemRenderer = itemRenderer;
			itemRenderer.gridLines = dataGridLines;
			layoutGroup.addChild( dataGridLines );
				
			this.scrollContainer.addChild( layoutGroup );
			dataGridLines.index = itemRenderer.index = this.scrollContainer.numChildren - 1;
			
			itemRenderer.dataGridChangeHandler();
			
			if(createHeader && this.header.visible)
			{
				var id:String;
				for(var i:int = 0; i<itemRenderer._numChildren; i++)
				{
					if(!columns)
					{
						id = this._getChildAt(0).getChildAt(0)._getChildAt(i).id;
						(header.getChildAt(i) as DataGridToggleButton).label = id;
					}
					else if( !columns.getItemAt(0).hasOwnProperty("headerText") )
					{
						id = this._getChildAt(0).getChildAt(0)._getChildAt(i).id;
						(header.getChildAt(i) as DataGridToggleButton).label = id;
					}
					else
					{
						(header.getChildAt(i) as DataGridToggleButton).label = columns.getItemAt(i).headerText;
					}
				}
			}
		}

		/**
		 * @private
		 */
		public function dataProvider_removeItemHandler(event:Event, index:int):void
		{
			var i:int;
			if(this._selectedIndex == index || this.dataProvider.length == 0)
			{
				this._selectedIndex = -1;
			}
			else if(this._selectedIndex > index)
			{
				this._selectedIndex--;
			}
			
			if(this.dataProvider.length == 0)
			{
				this._selectedIndices = new <int>[];
			}
			else
			{
				for(i = 0; i < this._selectedIndices.length; i++)
				{
					if(this._selectedIndices[i] > index)
					{
						this._selectedIndices[i]--;
					}
					else if(index == this._selectedIndices[i])
					{
						this._selectedIndices.splice(i, 1);
					}
				}
			}
			
			for(i = index + 1; i < this.scrollContainer.numChildren; i++)
			{
				this._getChildAt(i).getChildAt(0).index--;
				this._getChildAt(i).getChildAt(1).index--;
			}
			
			this.scrollContainer.removeChildAt( index );
			
			if(this.dataProvider.length == 0)
			{
				for(i = this.header.numChildren - 1; i >= 0; i--)
				{
					this.header.removeChildAt( i );
				}
				this.numColons = 0;
			}
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		public function dataProvider_replaceItemHandler(event:Event, index:int):void
		{
			this._getChildAt( index ).getChildAt(0).dataGridChangeHandler();
		} 
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			super.draw();
			this._autoSizeIfNeeded();
		}
		/**
		 * @private
		 */
		protected function _autoSizeIfNeeded():void
		{
			if( !this.isInvalid(INVALIDATION_FLAG_SIZE) ) autoSizeHeader();
			//this.validate();
			
			for(var i:int = 0; i < this.scrollContainer.numChildren; i++)
			{
				this._getChildAt(i).getChildAt(1).lines();
			}
			updateIndices();
		}
		/**
		 * @private
		 */
		protected function autoSizeHeader():void
		{
			var colons:Vector.<int> = new <int>[];
			for(var i:int = 0; i<this.numColons; i++) colons.push(0);
			for(i = 0; i<this.scrollContainer.numChildren; i++)
			{
				var children:Object = this._getChildAt(i).getChildAt(0);
				for(var j:int = 0; j<children._numChildren; j++)
				{
					if(children._getChildAt(j).width > colons[j]) colons[j] = children._getChildAt(j).width;
				}
			}
			var lineSize:Number;
			for(i = 0; i<this.header.numChildren; i++)
			{
				lineSize = (i == 0 || i == numColons -1) ? this.lineSize * 1.5 : this.lineSize;
				if(this.header.visible) header.getChildAt(i).width = colons[i] + lineSize;
			}
			for(i = 0; i<this.scrollContainer.numChildren; i++)
			{
				for(j = 0; j<this.numColons; j++)
				{
					lineSize = (j == 0 || j == numColons - 1) ? this.lineSize * 1.5 : this.lineSize;
					this._getChildAt(i).getChildAt(0)._getChildAt(j).width = colons[j];
				}
				this._getChildAt(i).getChildAt(0).validate();
			}
			if(this.numColons > 0)
			{
				if( !isNaN(this.height) )
				{
					this.scrollContainer.height = this.height - this.header.height;
				}
				else if(requestedRowCount == -1)
				{
					this.scrollContainer.height = NaN;
				}
				else
				{
					lineSize = (requestedRowCount != 0) ? this.lineSize : 0;
					this.scrollContainer.height = this._getChildAt( this.scrollContainer.numChildren - 1 ).height * requestedRowCount - lineSize * (requestedRowCount - 1);
				}
			}
			else
			{
				if(requestedRowCount == -1)
				{
					this.scrollContainer.height = NaN;
				}
				else
				{
					requestedRowCountDefault();
					lineSize = (requestedRowCount != 0) ? this.lineSize : 0;
					this.scrollContainer.height = this.headerHeight + itemRendererHeight * requestedRowCount - lineSize * (requestedRowCount - 1);
				}
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}
		
		private function onTouchEvent(event:TouchEvent):void {
			if(!isSelectable) return;
			var touch:Touch = event.getTouch(this.scrollContainer);
			if(!touch) return;
			if (touch.phase == TouchPhase.BEGAN) {
				var target:Object = touch.target as Object;
				var _selectIndex:Object = selectTouchIndex(target);
				if(_selectIndex.hasOwnProperty("index"))
				{
					if(_selectIndex is DataGridLines && _selectIndex.index != 0) //correction line top touch
					{
						var lineTop:Quad = _selectIndex.lineTop;
						if(target == lineTop)
						{
							var location:Point = touch.getLocation(_selectIndex as DisplayObjectContainer);
							if(location.y >= lineTop.y && location.y <= lineTop.y + lineTop.height / 2)
							{
								_selectIndex = this._getChildAt( this.scrollContainer.getChildIndex(_selectIndex.parent) - 1 ).getChildAt(1);
							}
						}
					}
					var selectLines:DataGridLines = (_selectIndex is DataGridLines) ? _selectIndex as DataGridLines : _selectIndex.gridLines;
					if(!this.allowMultipleSelection && this.selectedIndex != -1)
					{
						var actualLines:DataGridLines = this._getChildAt( this.selectedIndex ).getChildAt(1) as DataGridLines;
						if(actualLines != selectLines)
						{
							actualLines.isSelected = actualLines.itemRenderer.isSelected = false;
							actualLines.selectedLines();
						}
					}
					selectLines.isSelected = selectLines.itemRenderer.isSelected = !selectLines.isSelected;
					selectLines.selectedLines();
					if(this.allowMultipleSelection)
					{
						if(!selectLines.isSelected)
						{
							this._selectedIndices.splice( this._selectedIndices.indexOf(_selectIndex.index), 1 );
							this._selectedIndex = (this._selectedIndices.length == 0) ? -1 : this._selectedIndices[this._selectedIndices.length-1];
						}
						else
						{
							if(this._selectedIndices.indexOf(_selectIndex.index) != -1) this._selectedIndices.splice( this._selectedIndices.indexOf(_selectIndex.index), 1 );
							this._selectedIndices.push( _selectIndex.index );
							this._selectedIndex = this._selectedIndices[this._selectedIndices.length-1];
						}
					}
					else
					{
						if(!selectLines.isSelected)
						{
							this._selectedIndices.pop();
							this._selectedIndex = -1;
						}
						else
						{
							if(this._selectedIndices.length == 1) this._selectedIndices.pop();
							this._selectedIndices.push( _selectIndex.index );
							this._selectedIndex = this._selectedIndices[this._selectedIndices.length-1];
						}
					}
				}
			}
		}
		private function selectTouchIndex(target:Object):Object
		{
			while (target.parent.parent.parent != this.scrollContainer)
			{
				if(target is ScrollBar && target.parent == this.scrollContainer) break;
				target = target.parent;
			}
			return target;
		}
		private function toggleButton_triggeredHandler( event:Event ):void
		{
			var toogleButton:DataGridToggleButton = event.target as DataGridToggleButton;
			toogleButton.toggle();
			var columnIndex:int = header.getChildIndex( toogleButton );
			var isNumeric:Boolean = isHeaderNumeric( columnIndex );
			var key:String = getKey(columnIndex);
			this.dataProvider = DataGridUtils.sort(this.dataProvider, key, toogleButton.isArrowDown, isNumeric);
		}
		private function removeAllSelectedIndex():void
		{
			for(var i:int = 0; i<this.scrollContainer.numChildren; i++)
			{
				var children:Object = this._getChildAt(i).getChildAt(1);
				children.isSelected = children.itemRenderer.isSelected = false;
				children.selectedLines();
			}
		}
		private function selectIndex(index:int):void
		{
			for(var i:int = 0; i<this.scrollContainer.numChildren; i++)
			{
				var children:Object = this._getChildAt(i).getChildAt(1);
				if(index == children.index)
				{
					children.isSelected = children.itemRenderer.isSelected = true;
					children.selectedLines();
				}
			}
		}
		/**
		 * Get an item renderer at the specified index.
		 *
		 * @param index row index of the cell
		 */
		public function getItemAt(index:int):Object
		{
			for(var i:int = 0; i<this.scrollContainer.numChildren; i++)
			{
				var children:Object = this._getChildAt(i).getChildAt(0);
				if(index == children.index)
				{
					return children;
				}
			}
			return null;
		}
		private function isHeaderNumeric(columnIndex:int):Boolean
		{
			if(!columns) return false;
			var columnHeader:Object = columns.getItemAt( columnIndex )
			if( columnHeader.hasOwnProperty("type") )
			{
				if(columnHeader.type == "numeric") return true;
			}
			return false;
		}
		private function getKey(columnIndex:int):String
		{
			if(!columns)
			{
				return this._getChildAt(0).getChildAt(0)._getChildAt(columnIndex).id;
			}
			else if( !columns.getItemAt(columnIndex).hasOwnProperty("dataField") )
			{
				return this._getChildAt(0).getChildAt(0)._getChildAt(columnIndex).id;
			}
			else
			{
				return columns.getItemAt(columnIndex).dataField;
			}
			return null;
		}
		/**
		 * @private
		 */
		public function _getChildAt(index:int):Object
		{
			return this.scrollContainer.getChildAt(index) as Object;
		}
		
		private var _horizontalScrollStep:Number = NaN;
		/**
		 * The number of pixels the horizontal scroll position can be adjusted
		 * by a "step". Passed to the horizontal scroll bar, if one exists.
		 * Touch scrolling is not affected by the step value.
		 *
		 * <p>In the following example, the horizontal scroll step is customized:</p>
		 *
		 * <listing version="3.0">
		 * dataGrid.horizontalScrollStep = 0;</listing>
		 *
		 * @default NaN
		 */
		public function get horizontalScrollStep():Number
		{
			return _horizontalScrollStep;
		}
		public function set horizontalScrollStep(value:Number):void
		{
			this._horizontalScrollStep = value;
			this.scrollContainer.horizontalScrollStep = horizontalScrollStep;
		}
		
		private var _verticalScrollStep:Number = NaN;
		/**
		 * The number of pixels the vertical scroll position can be adjusted
		 * by a "step". Passed to the vertical scroll bar, if one exists.
		 * Touch scrolling is not affected by the step value.
		 *
		 * <p>In the following example, the vertical scroll step is customized:</p>
		 *
		 * <listing version="3.0">
		 * dataGrid.verticalScrollStep = 0;</listing>
		 *
		 * @default NaN
		 */
		public function get verticalScrollStep():Number
		{
			return _verticalScrollStep;
		}

		/**
		 * @private
		 */
		public function set verticalScrollStep(value:Number):void
		{
			this._verticalScrollStep = value;
			this.scrollContainer.verticalScrollStep = verticalScrollStep;
		}
		
 		/**
		 * Hide the header.
		 *
		 * @default false
		 */
		public function set hideHeader(value:Boolean):void
		{
			this.header.visible = !this.header.visible;
		}
	}
}