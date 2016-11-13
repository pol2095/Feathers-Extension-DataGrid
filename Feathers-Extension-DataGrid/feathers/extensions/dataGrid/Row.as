package feathers.extensions.dataGrid
{
	import feathers.controls.LayoutGroup;
	import starling.events.EnterFrameEvent;
	import 	feathers.layout.HorizontalLayout;
 
    public class Row extends LayoutGroup
    {
		public var gridLines:DataGridLines;
        public var index:int;
		public var isSelected:Boolean;
		protected var isChanging:Boolean;
		
		private var countEnterFrame:int;
		
		public function get data():Object
		{
			return owner.dataProvider.getItemAt(index);
		}
		
		private var _owner:DataGrid;
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
		
		public function Row()
        {
			super();
        }
		
		public function dataGridChangeHandler():void
        {
			isChanging = true;
			if(countEnterFrame == 0)
			{
				this.addEventListener(EnterFrameEvent.ENTER_FRAME, onDataGridChangeHandler);
				countEnterFrame++;
			}
		}
		
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
	}
}