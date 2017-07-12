package com.examples
{
	import components.CustomDataGridItemRenderer;
	import feathers.extensions.dataGrid.DataGrid;
	import feathers.controls.LayoutGroup;
	import feathers.extensions.dataGrid.themes.DataGridMetalWorksDesktopTheme;
	import feathers.data.ListCollection;
	
	public class DataGridExample extends LayoutGroup
	{
		public function DataGridExample()
		{
			new DataGridMetalWorksDesktopTheme();
			super();
			
			var dataGrid:DataGrid = new DataGrid();
			dataGrid.columns = new ListCollection(
			[
			{ dataField: "check", headerText: "" },
			{ dataField: "comment", headerText: "comment"  },
			{ dataField: "mail", headerText: "mail"  },
			{ dataField: "adress", headerText: "adress"  }
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
	}
}