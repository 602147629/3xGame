package framework.model
{
	public class ResourcePackageConfig
	{
		private var groups:Vector.<PackageGroup> = new Vector.<PackageGroup>();
		
		private var packageWaitingDownload:int;
		private var callback:Function;
		
		public function ResourcePackageConfig(xml:XML)
		{
			var list:XMLList = xml.child("package");
			for each(var node:XML in list)
			{
				var group:PackageGroup = new PackageGroup(node);
				groups.push(group);
			}
		}
		
		public function load(callback:Function):void
		{
			this.callback = callback;
			
			CONFIG::debug
			{
				ASSERT(packageWaitingDownload == 0, "ASSERT");
			}
			
			packageWaitingDownload = groups.length;

			for each(var group:PackageGroup in groups)
			{
				group.load(onComplete);
			}
		}
		
		private function onComplete():void
		{
			CONFIG::debug
			{
				ASSERT(packageWaitingDownload > 0, "ASSERT");
			}
			
			--packageWaitingDownload;
			if(packageWaitingDownload == 0)
			{
				callback();
			}
		}
		
	}
}


import framework.model.BackgroundLoadProxy;
import framework.resource.ResourceFactory;
import framework.util.rsv.Rsv;
import framework.util.rsv.RsvEvent;
import framework.util.rsv.RsvFile;
import framework.util.rsv.RsvObject;

import flash.utils.ByteArray;

class PackageGroup
{
	public var id:String;
	public var files:Vector.<PackageFile> = new Vector.<PackageFile>();
	
	private var callback:Function;
	private var filePosition:int;
	private var stream:ByteArray;
	private var bytesRead:int;
	
	private static const BASE_FOLDER:String = "./package/";
	
	public function PackageGroup(xml:XML)
	{
		id = xml.@id;
		
		var list:XMLList = xml.file;
		for each(var node:XML in list)
		{
			var file:PackageFile = new PackageFile(node);
			files.push(file);
		}
	}
	
	public function load(callback:Function):void
	{
		this.callback = callback;
		
		var rsvFile:RsvFile = new RsvFile(id, BASE_FOLDER + id);
		rsvFile.load(onCompleteGroupPackage);
	}
	
	private function onCompleteGroupPackage(ev:RsvEvent):void
	{
		if(ev.type == "" + RsvEvent.CONTENTREADY)
		{
			var sourceRsvFile:RsvFile = ev.from as RsvFile;
			stream = sourceRsvFile.rawdata as ByteArray;
			
			filePosition = 0;
			bytesRead = 0;
			
			loadNext();
			
		}

	}
	
	private function loadNext():void
	{
		var file:PackageFile = files[filePosition];
		filePosition++;

		var bytes:ByteArray = new ByteArray();
		stream.readBytes(bytes, 0, file.length);
		bytesRead += file.length;

		var rsvFile:RsvFile;
		if(file.classId == "")
		{
			rsvFile = Rsv.getFile_s(file.id);
		}
		else
		{
			rsvFile = ResourceFactory.createRsvFileForSplitGroup(file.id, file.classId);
		}
		
		rsvFile.loadFromBytes(bytes, onCompleteOneFile);
		

	}
	
	private function onCompleteOneFile(ev:RsvEvent):void
	{
		if(ev.type == "" + RsvEvent.CONTENTREADY)
		{
			if(filePosition >= files.length)
			{
				CONFIG::debug
				{
					ASSERT(bytesRead == stream.length, "why there still are bytes in stream ?");
				}
				
				stream = null;
				
				callback();
				
			}
			else
			{
				loadNext();
			}
			
		}
		else if(ev.type != "" + RsvEvent.LOADCOMPLETE)
		{
			CONFIG::debug
			{
				ASSERT(false, "id = " + (ev.from as RsvObject).id + ", get event = " + ev.type);
			}
		}
	}

}

class PackageFile
{
	public var id:String;
	public var classId:String;
	public var length:int;
	
	public function PackageFile(xml:XML)
	{
		id = xml.@id;
		classId = xml.@classId;
		length = xml.@length;
	}
}

