/*
Copyright 2016 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.extensions.dataGrid
{
	import feathers.data.ListCollection;
	
	public class DataGridUtils
    {
		public static function sort(listCollection:ListCollection, key:String, descending:Boolean, numeric:Boolean = false):ListCollection
        {
			var column:Array = [];
			for(var i:int = 0; i<listCollection.length; i++) column.push( listCollection.getItemAt(i) );
			var options:Number = !descending ? Array.CASEINSENSITIVE : Array.DESCENDING | Array.CASEINSENSITIVE;
			if(numeric) options = options | Array.NUMERIC;
			column.sortOn(key, options);
			var _listCollection:ListCollection = new ListCollection();
			for(i = 0; i<column.length; i++) _listCollection.addItem(column[i]);
			return _listCollection;
        }
	}
}