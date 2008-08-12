<?php
	log_value('localhost', 8765, "hello");
	log_value('localhost', 8765, "world");

	function log_value($server, $port, $value){

		$fp = fsockopen("udp://$server", $port, $errno, $errstr);
		if ($fp){
			fwrite($fp, "$value\n");
			fclose($fp);
		}
	}
?>
