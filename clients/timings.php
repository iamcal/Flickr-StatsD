<?php
	for ($i=0; $i<5; $i++){
		$n = rand(100,300);
		log_value('localhost', 8765, "db-query:$n");
	}

	function log_value($server, $port, $value){

		$fp = fsockopen("udp://$server", $port, $errno, $errstr);
		if ($fp){
			fwrite($fp, "$value\n");
			fclose($fp);
		}
	}
?>
