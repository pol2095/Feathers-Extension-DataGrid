package com.examples
{
	import components.CustomDataGridItemRenderer;
	import feathers.extensions.dataGrid.DataGrid;
	import feathers.controls.LayoutGroup;
	import feathers.extensions.themes.MetalWorksDesktopTheme;
	import feathers.data.ListCollection;
	import feathers.extensions.dataGrid.events.DataGridEvent;
	import starling.events.Event;
	
	public class DataGridExample extends LayoutGroup
	{
		public function DataGridExample()
		{
			new DataGridMetalWorksDesktopTheme();
			super();
			
			var dataGrid:DataGrid = new DataGrid();
			dataGrid.addEventListener( Event.CHANGE, rowChangeHandler );
			dataGrid.columns = new ListCollection(
			[
			{ dataField: "check", headerText: "", type:"numeric" },
			{ dataField: "comment", headerText: "Comment"  },
			{ dataField: "label", headerText: "Mail"  },
			{ dataField: "label2", headerText: "Adress"  }
			]);
			dataGrid.itemRenderer = components.CustomDataGridItemRenderer;
			dataGrid.dataProvider = new ListCollection(
			[
			{ check: 1, comment: "comment", label: "mail1", label2: "adress1"  },
			{ check: 0, comment: "comment2", label: "mail2", label2: "adress3"  },
			{ check: 1, comment: "comment", label: "mail4", label2: "adress2"  },
			{ check: 0, comment: "comment2", label: "mail3", label2: "adress4"  }
			]);
			dataGrid.requestedRowCount = 3;
			this.addChild(dataGrid);
		}
		
		private function rowChangeHandler(event:DataGridEvent):void
		{
			trace(event.index);
		}
	}
}