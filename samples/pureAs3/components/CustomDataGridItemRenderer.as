package components
{
	import feathers.extensions.dataGrid.DataGridItemRenderer;
	import feathers.layout.HorizontalLayout;
	import starling.events.Event;
	import feathers.controls.Check;
	import feathers.controls.TextInput;
	import feathers.controls.Label;
	
	public class CustomDataGridItemRenderer extends DataGridItemRenderer
	{
		private var checkBox:Check;
		private var textInput:TextInput;
		private var label:Label;
		private var label2:Label;
		
		public function CustomDataGridItemRenderer()
		{
			super();
			var horizontalLayout:HorizontalLayout = new HorizontalLayout();
			this.layout = horizontalLayout;
			
			checkBox = new Check();
			checkBox.addEventListener( Event.CHANGE, rowChangeHandler );
			this.addChild( checkBox );
			
			textInput = new TextInput();
			textInput.addEventListener( Event.CHANGE, rowChangeHandler );
			this.addChild( textInput );
			
			label = new Label();
			this.addChild( label );
			
			label2 = new Label();
			this.addChild( label2 );
		}
		
		override public function dataGridChangeHandler():void
		{
			super.dataGridChangeHandler(); //never forget to add this!
			
			checkBox.isSelected = this.data.check == 1 ? true : false;
			textInput.text = this.data.comment;
			label.text = this.data.label;
			label2.text = this.data.label2;
		}
		
		override protected function rowChangeHandler():void
		{
			if(isChanging) return; //never forget to add this!
			
			this.data.check = checkBox.isSelected ? 1 : 0;
			this.data.comment = textInput.text;
			
			super.rowChangeHandler(); //never forget to add this!
		}
	}
}