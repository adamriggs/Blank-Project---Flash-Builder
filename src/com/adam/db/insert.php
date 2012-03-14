<?php

//mysql connection info
include 'connString.php';


//get table name and remove it from $_POST
$table=$_POST[table];
unset($_POST[table]);


//get the array of keys from $_POST and build a string of comma seperated column names 
$keys=array_keys($_POST);
$keystring="";
$keysep="";
foreach($keys as $i => $value){
	$keystring.=$keysep;
	$keystring.=$value;
	$keysep=", ";
}


//build a string of csv from the $_POST values
$valuestring="";
$valuesep="";
foreach($_POST as $i => $value){
	$valuestring.=$valuesep;
        $valuestring.="'";
	$valuestring.=$value;
        $valuestring.="'";
	$valuesep=", ";
}



//build the sql query string
$sql="INSERT INTO $table ($keystring) VALUES ($valuestring)";


//execute the query and report back status in xml form
echo "<?xml version=\"1.0\"?>";
echo "<insert>";
echo "<sql>" . $sql . "</sql>";
if (!mysql_query($sql,$conn)){
	die('<result>' . mysql_error() . "</result>");
} else {
	echo "<result>success</result>";
}
echo "</insert>";

mysql_close($conn)


?>