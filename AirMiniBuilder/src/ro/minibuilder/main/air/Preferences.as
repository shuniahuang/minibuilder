package ro.minibuilder.main.air
{
	import ro.mbaswing.FButton;
	import org.aswing.JTextField;
	import flash.net.SharedObject;
	import flash.utils.clearTimeout;
	import flash.events.Event;
	import ro.minibuilder.main.Frame;
	import ro.minibuilder.data.fileBased.SDKCompiler;
	import flash.utils.setTimeout;
	import org.aswing.JLabel;
	import ro.mbaswing.TablePane;
	
	public class Preferences extends Frame
	{
		private var lbl1:JLabel;
		private var lbl2:JLabel;
		private var txt1:JTextField;
		private var okBtn:FButton;
		private var cancelBtn:FButton;
		
		
		private static var so:SharedObject;
		static public function get config():SharedObject
		{
			if (!so) 
				so = SharedObject.getLocal('configuration');
			return so;
		}
		
		public function Preferences()
		{
			setTitle('Preferences');
			var pane:TablePane = new TablePane(1);
			setContentPane(pane);
			
			pane.addLabel('Compilation Server:');
			lbl1 = pane.addLabel('detecting...');
			pane.newRow();
			pane.addLabel('Flex SDK location:');
			lbl2 = pane.addLabel('');
			
			pane.addSeparatorRow();
			
			pane.newRow();
			
			pane.addLabel('In order to work with AIR projects you need the Adobe AIR SDK', 
				TablePane.ALIGN_LEFT, 2);
			pane.newRow();
			pane.addLabel('AIR SDK path:');
			pane.addCell(txt1 = new JTextField(String(config.data.airsdk)));
			
			pane.addSeparatorRow();
			pane.newRow(true);
			pane.addCell(null);
			
			pane.addSeparatorRow();
			pane.addCell(
				TablePane.hBox(5, okBtn=new FButton('OK'), 
				cancelBtn=new FButton('Cancel')), TablePane.ALIGN_RIGHT, 2);
			
			okBtn.addActionListener(function(e:Event):void {
				save();
				dispose();
			});
			cancelBtn.addActionListener(function(e:Event):void {
				dispose();
			});
			
			
			checkServer();
			var TID:int = setTimeout(checkServer, 500);
			
			addEventListener(Event.REMOVED_FROM_STAGE, function():void {
				clearTimeout(TID);
			});
			
			setSizeAndCenter(600, 400);
		}
		
		private function save():void
		{
			config.data.airsdk = txt1.getText();
			config.flush();
		}
		
		private function checkServer():void
		{
			SDKCompiler.pingCompiler(function(path:String):void {
				lbl1.setText(path ? 'running ok' : 'not running!');
				lbl2.setText(path ? path : '?');
			});
		}
	}
}